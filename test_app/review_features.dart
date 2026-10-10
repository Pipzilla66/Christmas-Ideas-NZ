import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final homeAreaRevision = ValueNotifier<int>(0);

/// Keep the original attribution intact, with a compact display and linked
/// source/licence. Unknown attribution formats remain available in full.
class PhotoCredit extends StatelessWidget {
  const PhotoCredit({super.key, required this.credit, this.source = ''});
  final String credit;
  final String source;

  String get caption {
    final creator = credit.split(' — ').first.trim();
    if (creator.startsWith('Photo and idea:')) {
      return creator.replaceFirst('Photo and idea:', 'Photo & idea:');
    }
    return 'Photo: ${creator.replaceAll(RegExp(r'https?://\S+'), '').trim()}';
  }

  String? get licenceName =>
      RegExp(r'CC (?:BY(?:-SA|-NC(?:-SA|-ND)?|-ND)? [0-9.]+|0 [0-9.]+)').firstMatch(credit)?.group(0) ??
      RegExp(r'CC0 [0-9.]+').firstMatch(credit)?.group(0);

  String get licenceUrl {
    final supplied = RegExp(r'https://creativecommons\.org/[^\s]+').firstMatch(credit)?.group(0);
    if (supplied != null) return supplied;
    final name = licenceName;
    if (name == null) return '';
    if (name.startsWith('CC0')) return 'https://creativecommons.org/publicdomain/zero/1.0/';
    final parts = name.split(' ');
    return 'https://creativecommons.org/licenses/${parts[1].toLowerCase()}/${parts[2]}/';
  }

  String get sourceUrl => source.trim().isNotEmpty ? source.trim() :
      RegExp(r'Source:\s*(https?://\S+)').firstMatch(credit)?.group(1) ?? '';

  Widget link(BuildContext context, String label, VoidCallback action) =>
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF655E55),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: const TextStyle(fontSize: 12, decoration: TextDecoration.underline),
        ),
        onPressed: action,
        child: Text(label),
      );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(caption, style: const TextStyle(fontSize: 12, color: Color(0xFF655E55))),
      Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (sourceUrl.isNotEmpty)
            link(context, 'Source', () => openExternalLink(context, sourceUrl)),
          if (licenceName != null)
            link(context, licenceName!, () => openExternalLink(context, licenceUrl)),
          if (credit.toLowerCase().contains('crop'))
            const Text('Cropped', style: TextStyle(fontSize: 12, color: Color(0xFF655E55))),
          if (credit.contains(' — ') || credit.contains('http') || credit.length > 80)
            link(context, 'Credit details', () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Photo credit'),
                content: SingleChildScrollView(child: SelectableText(credit)),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
              ),
            )),
        ],
      ),
    ],
  );
}

Uri? websiteUri(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;
  final uri = Uri.tryParse(text.contains('://') ? text : 'https://$text');
  if (uri == null || !['http', 'https'].contains(uri.scheme) ||
      uri.host.isEmpty || !uri.host.contains('.') || uri.userInfo.isNotEmpty) return null;
  return uri;
}

Future<void> openExternalLink(BuildContext context, String value) async {
  final uri = websiteUri(value);
  if (uri == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This website address is unavailable.')));
    return;
  }
  try {
    // Launch immediately from the tap to retain the browser's user activation.
    if (await launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank')) return;
  } catch (_) {}
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text('Could not open the website. Copy the link to open it in your browser.'),
    action: SnackBarAction(label: 'Copy link', onPressed: () => Clipboard.setData(ClipboardData(text: uri.toString()))),
  ));
}

Future<Map<String, String>> loadHomeArea() async {
  final client = Supabase.instance.client;
  if (client.auth.currentUser != null) {
    final row = await client.from('profiles').select('home_region,home_city').eq('id', client.auth.currentUser!.id).maybeSingle();
    return {'region': (row?['home_region'] ?? '').toString(), 'city': (row?['home_city'] ?? '').toString()};
  }
  final prefs = await SharedPreferences.getInstance();
  return {'region': prefs.getString('home_region') ?? '', 'city': prefs.getString('home_city') ?? ''};
}

double distanceKm(double lat, double lon, double otherLat, double otherLon) {
  double rad(double d) => d * math.pi / 180;
  final a = math.pow(math.sin(rad(otherLat - lat) / 2), 2) +
      math.cos(rad(lat)) * math.cos(rad(otherLat)) * math.pow(math.sin(rad(otherLon - lon) / 2), 2);
  return 6371 * 2 * math.atan2(math.sqrt(a.clamp(0, 1)), math.sqrt((1 - a).clamp(0, 1)));
}

List<Map<String, dynamic>> sortRecommended(List<Map<String, dynamic>> items) {
  final result = [...items];
  result.sort((a, b) {
    final count = ((b['recommendation_count'] ?? 0) as num).compareTo((a['recommendation_count'] ?? 0) as num);
    return count != 0 ? count : (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString());
  });
  return result;
}

class HomeAreaSettings extends StatefulWidget {
  const HomeAreaSettings({super.key});
  @override
  State<HomeAreaSettings> createState() => _HomeAreaSettingsState();
}

class _HomeAreaSettingsState extends State<HomeAreaSettings> {
  final city = TextEditingController();
  String? region;
  String? message;
  bool busy = false;
  static const regions = ['Northland','Auckland','Waikato','Bay of Plenty','Gisborne','Hawke’s Bay','Taranaki','Manawatū-Whanganui','Wellington','Tasman','Nelson','Marlborough','West Coast','Canterbury','Otago','Southland','Chatham Islands'];
  @override
  void initState() { super.initState(); restore(); }
  Future<void> restore() async {
    try {
      final area = await loadHomeArea();
      if (!mounted) return;
      setState(() {region = regions.contains(area['region']) ? area['region'] : null; city.text = area['city'] ?? '';});
    } catch (_) {}
  }
  @override
  void dispose() { city.dispose(); super.dispose(); }
  Future<void> save() async {
    setState(() { busy = true; message = null; });
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user != null) {
        await client.from('profiles').update({'home_region': region, 'home_city': city.text.trim()}).eq('id', user.id).select('id').single();
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('home_region', region ?? '');
        await prefs.setString('home_city', city.text.trim());
      }
      homeAreaRevision.value++;
      message = 'Home area saved. Near Me will use it automatically.';
    } catch (_) { message = 'Could not save your home area. Please try again.'; }
    finally { if (mounted) setState(() => busy = false); }
  }
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Your home area', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      const SizedBox(height: 8),
      const Text('Optional. Use your town or region to start Near Me with local finds.'),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(key: ValueKey(region), initialValue: region, isExpanded: true,
        decoration: const InputDecoration(labelText: 'Home region'),
        items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        onChanged: busy ? null : (v) => setState(() => region = v)),
      const SizedBox(height: 12),
      TextField(controller: city, enabled: !busy, decoration: const InputDecoration(labelText: 'Home city or town (optional)')),
      const SizedBox(height: 10),
      FilledButton.tonal(onPressed: busy ? null : save, child: Text(busy ? 'Saving…' : 'Save home area')),
      if (message != null) Text(message!),
    ],
  )));
}

class RecommendationButton extends StatefulWidget {
  final String displayId;
  final int count;
  final VoidCallback onChanged;
  const RecommendationButton({super.key, required this.displayId, required this.count, required this.onChanged});
  @override
  State<RecommendationButton> createState() => _RecommendationButtonState();
}

class _RecommendationButtonState extends State<RecommendationButton> {
  bool selected = false;
  bool busy = true;
  @override
  void initState() { super.initState(); restore(); }
  Future<void> restore() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final row = await Supabase.instance.client.from('display_recommendations').select('display_id').eq('user_id', user.id).eq('display_id', widget.displayId).maybeSingle();
        selected = row != null;
      }
    } catch (_) {}
    finally {if (mounted) setState(() => busy = false);}
  }
  Future<void> toggle() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create an account or sign in from Me to recommend this display.')));
      return;
    }
    setState(() => busy = true);
    try {
      final table = Supabase.instance.client.from('display_recommendations');
      if (selected) {
        await table.delete().eq('user_id', user.id).eq('display_id', widget.displayId);
      } else {
        await table.insert({'user_id': user.id, 'display_id': widget.displayId});
      }
      selected = !selected;
      widget.onChanged();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not update your recommendation. Please try again.')));
    } finally {if (mounted) setState(() => busy = false);}
  }
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: busy ? null : toggle,
    icon: Icon(selected ? Icons.thumb_up : Icons.thumb_up_outlined, size: 18),
    label: Text('${selected ? 'Recommended' : 'Recommend'} · ${widget.count}'));
}

class SubmissionPhotoPreview extends StatefulWidget {
  final Map<String, dynamic> payload;
  const SubmissionPhotoPreview({super.key, required this.payload});
  @override
  State<SubmissionPhotoPreview> createState() => _SubmissionPhotoPreviewState();
}
class _SubmissionPhotoPreviewState extends State<SubmissionPhotoPreview> {
  late Future<String?> image;
  @override
  void initState() {super.initState(); image = load();}
  Future<String?> load() async {
    final path = (widget.payload['image_path'] ?? '').toString();
    if (path.isNotEmpty) return Supabase.instance.client.storage.from('submission-images').createSignedUrl(path, 600);
    return null;
  }
  @override
  Widget build(BuildContext context) => FutureBuilder<String?>(future: image, builder: (context, snap) {
    if (snap.hasError) return const Text('Photo could not load. Reopen Admin to retry before approving.');
    if (snap.data == null) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Image.network(snap.data!, height: 180, fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Text('Photo could not load. Please retry before approving.')));
  });
}
