import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_delete.dart';

// A single role lookup is shared by the controls on a page.
String? _roleUser;
Future<bool>? _role;
Future<bool> canEditItems() {
  final client = Supabase.instance.client;
  final id = client.auth.currentUser?.id;
  if (id == null) {
    _roleUser = null;
    _role = null;
    return Future.value(false);
  }
  if (_roleUser != id || _role == null) {
    _roleUser = id;
    _role = client
        .from('profiles')
        .select('role')
        .eq('id', id)
        .maybeSingle()
        .then((row) => ['admin', 'editor'].contains(row?['role']))
        .catchError((_) => false);
  }
  return _role!;
}

Future<Map<String, dynamic>?> editAdminItem(
  BuildContext context,
  String table,
  dynamic id,
) async {
  if (!manageableContent.containsKey(table) || !await canEditItems())
    return null;
  try {
    final row = await Supabase.instance.client
        .from(table)
        .select()
        .eq('id', id)
        .single();
    if (!context.mounted) return null;
    return await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminItemEditor(table: table, item: row),
      ),
    );
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open this item. Check your admin sign-in and try again.',
          ),
        ),
      );
    return null;
  }
}

class AdminItemActions extends StatelessWidget {
  final String table;
  final Map<String, dynamic> item;
  final VoidCallback onChanged;
  const AdminItemActions({
    super.key,
    required this.table,
    required this.item,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: canEditItems(),
    builder: (context, snap) {
      if (snap.data != true) return const SizedBox.shrink();
      return Wrap(
        spacing: 8,
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Admin: Edit'),
            onPressed: () async {
              final updated = await editAdminItem(context, table, item['id']);
              if (updated == null || !context.mounted) return;
              item.addAll(updated);
              onChanged();
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete'),
            onPressed: () async {
              if (await removeAdminContent(context, table, item) &&
                  context.mounted) {
                item['status'] = 'archived';
                onChanged();
              }
            },
          ),
        ],
      );
    },
  );
}

class AdminItemEditor extends StatefulWidget {
  final String table;
  final Map<String, dynamic> item;
  const AdminItemEditor({super.key, required this.table, required this.item});
  @override
  State<AdminItemEditor> createState() => _AdminItemEditorState();
}

class _AdminItemEditorState extends State<AdminItemEditor> {
  final form = GlobalKey<FormState>();
  final fields = <String, TextEditingController>{};
  final flags = <String, bool>{};
  bool busy = false;
  late String status;
  String get titleKey =>
      ['gift_ideas', 'content_items'].contains(widget.table) ? 'title' : 'name';
  Map<String, String> get labels => {
    titleKey: 'Name',
    if (widget.table == 'content_items') ...{
      'summary': 'Short description',
      'body': 'Full details',
      'content_type': 'Category',
      'external_url': 'Website',
    },
    if (widget.table != 'content_items') 'description': 'Description',
    'image_url': 'Photo URL',
    if (widget.table == 'gift_ideas') ...{
      'recipient_group': 'Gift recipient',
      'price_min': 'Price from (NZ\$)',
      'price_max': 'Price to (NZ\$)',
      'product_url': 'Product website',
      'affiliate_url': 'Affiliate link',
    },
    if (['gift_ideas', 'content_items'].contains(widget.table)) ...{
      'image_source_url': 'Photo source website',
      'image_credit': 'Photo credit',
    },
    if (!['gift_ideas', 'content_items'].contains(widget.table)) ...{
      'website_url': 'Website',
      'region': 'Region',
      'city': 'City / town',
      'address': 'Address',
    },
    if (widget.table == 'events') ...{
      'event_type': 'Event category',
      'start_at': 'Starts',
      'end_at': 'Ends',
      'cost_text': 'Entry cost',
    },
    if (widget.table == 'light_displays') ...{
      'start_date': 'First date',
      'end_date': 'Last date',
      'cost_text': 'Entry cost',
    },
    if (widget.table == 'businesses') 'business_type': 'Listing category',
  };
  @override
  void initState() {
    super.initState();
    status = widget.item['status']?.toString() ?? 'draft';
    for (final key in labels.keys) {
      var value = widget.item[key]?.toString() ?? '';
      if (key.endsWith('_at') && value.isNotEmpty)
        value = DateTime.parse(value)
            .toLocal()
            .toIso8601String()
            .substring(0, 16);
      fields[key] = TextEditingController(text: value);
    }
    for (final key in ['featured', 'sponsored', 'nz_made']) {
      if (widget.item.containsKey(key)) flags[key] = widget.item[key] == true;
    }
  }

  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  void message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> upload() async {
    setState(() => busy = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1800,
      );
      if (picked == null) return;
      final extension = picked.name.split('.').last.toLowerCase();
      final path =
          'admin/${widget.table}/${widget.item['id']}_${DateTime.now().microsecondsSinceEpoch}.$extension';
      final storage = Supabase.instance.client.storage.from('content-images');
      await storage.uploadBinary(path, await picked.readAsBytes());
      if (mounted)
        setState(() => fields['image_url']!.text = storage.getPublicUrl(path));
    } catch (_) {
      if (mounted)
        message(
          'Could not upload the photo. Try a JPG or PNG and check your admin sign-in.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String? validate(String key, String? value) {
    final text = (value ?? '').trim();
    if (key == titleKey && text.isEmpty) return 'Enter a name';
    if (text.isEmpty) return null;
    if (key.endsWith('_url')) {
      final url = Uri.tryParse(text);
      if (url == null ||
          !['http', 'https'].contains(url.scheme) ||
          url.host.isEmpty)
        return 'Enter a full https:// address';
    }
    if (key.startsWith('price_') &&
        (num.tryParse(text) == null || num.parse(text) < 0))
      return 'Enter a valid price';
    if ((key.endsWith('_at') || key.endsWith('_date')) &&
        DateTime.tryParse(text) == null)
      return 'Use YYYY-MM-DD${key.endsWith('_at') ? ' HH:MM' : ''}';
    return null;
  }

  Future<void> save() async {
    if (form.currentState?.validate() != true) return;
    setState(() => busy = true);
    try {
      final values = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        ...flags,
      };
      for (final entry in fields.entries) {
        final text = entry.value.text.trim();
        values[entry.key] = text.isEmpty
            ? null
            : entry.key.startsWith('price_')
            ? num.parse(text)
            : entry.key.endsWith('_at')
            ? DateTime.parse(text).toUtc().toIso8601String()
            : text;
      }
      if (widget.table == 'content_items' &&
          status == 'published' &&
          widget.item['published_at'] == null)
        values['published_at'] = DateTime.now().toUtc().toIso8601String();
      final row = await Supabase.instance.client
          .from(widget.table)
          .update(values)
          .eq('id', widget.item['id'])
          .select()
          .single();
      if (mounted) {
        message('Changes saved');
        Navigator.pop(context, row);
      }
    } catch (_) {
      if (mounted)
        message(
          'Could not save changes. Check the fields and your admin sign-in, then try again.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Map<String, String>? choices(String key) {
    if (key == 'content_type')
      return {
        'idea': 'Idea',
        'recipe': 'Recipe',
        'elf': 'Elf idea',
        'wallpaper': 'Wallpaper',
        'movie': 'Movie',
        'music': 'Music',
        'activity': 'Activity',
        'decoration': 'Decorations',
        'budget': 'Budget idea',
        'tradition': 'Tradition',
        'work_christmas': 'Work Christmas',
      };
    if (key == 'business_type')
      return {
        'charity': 'Christmas Charity',
        'christmas_tree': 'Real Christmas Trees',
        'chain_retailer': 'Chain store',
        'specialty_christmas': 'Christmas shop',
      };
    if (key == 'event_type')
      return {
        'christmas': 'Christmas event',
        'santa': 'Santa visit',
        'market': 'Christmas market',
        'workshop': 'Christmas workshop',
        'santa_visit': 'Santa visit',
        'community': 'Community event',
      };
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit item')),
    body: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          const Text(
            'Photo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (fields['image_url']!.text.isNotEmpty)
            SizedBox(
              height: 180,
              child: Image.network(
                fields['image_url']!.text,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Text('Photo preview unavailable')),
              ),
            ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.icon(
                onPressed: busy ? null : upload,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(busy ? 'Please wait…' : 'Choose photo'),
              ),
              TextButton(
                onPressed: busy
                    ? null
                    : () => setState(() => fields['image_url']!.clear()),
                child: const Text('Remove photo'),
              ),
            ],
          ),
          const Text(
            'Choose a photo, then tap Save changes.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 18),
          for (final entry in labels.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: choices(entry.key) != null
                  ? DropdownButtonFormField<String>(
                      initialValue: fields[entry.key]!.text.isEmpty
                          ? null
                          : fields[entry.key]!.text,
                      decoration: InputDecoration(labelText: entry.value),
                      items:
                          {
                                ...choices(entry.key)!,
                                if (fields[entry.key]!.text.isNotEmpty)
                                  fields[entry.key]!.text:
                                      choices(
                                        entry.key,
                                      )![fields[entry.key]!.text] ??
                                      fields[entry.key]!.text,
                              }.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ),
                              )
                              .toList(),
                      onChanged: busy
                          ? null
                          : (v) => fields[entry.key]!.text = v ?? '',
                    )
                  : TextFormField(
                      controller: fields[entry.key],
                      enabled: !busy,
                      validator: (v) => validate(entry.key, v),
                      onChanged: entry.key == 'image_url'
                          ? (_) => setState(() {})
                          : null,
                      minLines:
                          ['description', 'summary', 'body'].contains(entry.key)
                          ? 3
                          : 1,
                      maxLines:
                          ['description', 'summary', 'body'].contains(entry.key)
                          ? 8
                          : 1,
                      decoration: InputDecoration(
                        labelText: entry.value,
                        helperText: entry.key.endsWith('_at')
                            ? 'NZ local time: YYYY-MM-DD HH:MM'
                            : entry.key.endsWith('_date')
                            ? 'YYYY-MM-DD'
                            : null,
                      ),
                    ),
            ),
          DropdownButtonFormField<String>(
            initialValue: status,
            decoration: const InputDecoration(labelText: 'Visibility'),
            items: {status, 'draft', 'published', 'archived'}
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(
                      s == 'published'
                          ? 'Published'
                          : s == 'draft'
                          ? 'Draft'
                          : s == 'archived'
                          ? 'Removed'
                          : s,
                    ),
                  ),
                )
                .toList(),
            onChanged: busy ? null : (v) => setState(() => status = v!),
          ),
          for (final key in flags.keys)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                {
                  'featured': 'Featured',
                  'sponsored': 'Sponsored',
                  'nz_made': 'NZ made',
                }[key]!,
              ),
              value: flags[key]!,
              onChanged: busy ? null : (v) => setState(() => flags[key] = v),
            ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: busy ? null : save,
            child: Text(busy ? 'Please wait…' : 'Save changes'),
          ),
        ],
      ),
    ),
  );
}
