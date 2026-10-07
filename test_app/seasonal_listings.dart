import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const seasonalListingTypes = {
  'charity': 'Christmas Charities',
  'christmas_tree': 'Real Christmas Trees',
};

class AdminSeasonalListingsPage extends StatefulWidget {
  const AdminSeasonalListingsPage({super.key});
  @override
  State<AdminSeasonalListingsPage> createState() => _AdminSeasonalListingsPageState();
}

class _AdminSeasonalListingsPageState extends State<AdminSeasonalListingsPage> {
  String type = 'charity';
  late Future<List<Map<String, dynamic>>> items;
  @override
  void initState() { super.initState(); items = load(); }
  Future<List<Map<String, dynamic>>> load() async => List<Map<String, dynamic>>.from(
    await Supabase.instance.client.from('businesses').select().eq('business_type', type).order('name'),
  );
  Future<void> edit([Map<String, dynamic>? item]) async {
    final saved = await Navigator.push<bool>(context, MaterialPageRoute(
      builder: (_) => SeasonalListingEditor(type: type, item: item),
    ));
    if (saved == true && mounted) setState(() => items = load());
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Charities & Real Trees')),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => edit(), icon: const Icon(Icons.add), label: const Text('Add listing'),
    ),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(20), child: DropdownButtonFormField<String>(
        initialValue: type, decoration: const InputDecoration(labelText: 'Section'),
        items: seasonalListingTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
        onChanged: (v) { if(v != null) setState(() { type = v; items = load(); }); },
      )),
      Expanded(child: FutureBuilder<List<Map<String, dynamic>>>(
        future: items, builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Could not load listings.'), TextButton(onPressed: () => setState(() => items = load()), child: const Text('Retry')),
          ]));
          final rows = snap.data ?? [];
          if (rows.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Add your first listing. Save it as a draft or publish it for everyone to see.', textAlign: TextAlign.center)));
          return ListView(padding: const EdgeInsets.fromLTRB(20,0,20,100), children: rows.map((e) => Card(child: ListTile(
            leading: Icon(type == 'charity' ? Icons.favorite_outline : Icons.forest_outlined),
            title: Text(e['name'].toString()), subtitle: Text('${e['region'] ?? ''} · ${e['status']}'),
            trailing: const Icon(Icons.edit_outlined), onTap: () => edit(e),
          ))).toList());
        },
      )),
    ]),
  );
}

class SeasonalListingEditor extends StatefulWidget {
  final String type;
  final Map<String, dynamic>? item;
  const SeasonalListingEditor({super.key, required this.type, this.item});
  @override
  State<SeasonalListingEditor> createState() => _SeasonalListingEditorState();
}

class _SeasonalListingEditorState extends State<SeasonalListingEditor> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), description = TextEditingController(), url = TextEditingController();
  final region = TextEditingController(), city = TextEditingController(), address = TextEditingController(), image = TextEditingController();
  String status = 'draft';
  bool busy = false;
  bool get charity => widget.type == 'charity';
  @override
  void initState() {
    super.initState(); final row = widget.item ?? {};
    name.text = (row['name'] ?? '').toString(); description.text = (row['description'] ?? '').toString();
    url.text = (row['website_url'] ?? '').toString(); image.text = (row['image_url'] ?? '').toString();
    region.text = (row['region'] ?? (charity ? 'Nationwide' : '')).toString();
    city.text = (row['city'] ?? '').toString(); address.text = (row['address'] ?? '').toString();
    status = (row['status'] ?? 'draft').toString();
  }
  @override
  void dispose() { for (final c in [name,description,url,region,city,address,image]) { c.dispose(); } super.dispose(); }
  String? validUrl(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return status == 'published' ? 'Add a website before publishing' : null;
    final uri = Uri.tryParse(text);
    return uri == null || !['http','https'].contains(uri.scheme) || uri.host.isEmpty ? 'Enter a full https:// website address' : null;
  }
  Future<void> upload() async {
    setState(() => busy = true);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, imageQuality: 88);
      if(picked == null) return;
      final ext = picked.name.contains('.') ? picked.name.split('.').last.toLowerCase() : 'jpg';
      final path = 'admin/businesses/${widget.item?['id'] ?? 'new'}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final storage = Supabase.instance.client.storage.from('content-images');
      await storage.uploadBinary(path, await picked.readAsBytes());
      if(mounted) setState(() => image.text = storage.getPublicUrl(path));
    } catch (_) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not upload the photo. Please try again.'))); }
    finally { if(mounted) setState(() => busy = false); }
  }
  Future<void> save() async {
    if(form.currentState?.validate() != true) return;
    setState(() => busy = true);
    try {
      final row = <String,dynamic>{
        'name':name.text.trim(), 'description':description.text.trim(), 'website_url':url.text.trim(),
        'region':region.text.trim(), 'city':city.text.trim(), 'address':address.text.trim(),
        'image_url':image.text.trim(), 'business_type':widget.type, 'status':status,
        'updated_at':DateTime.now().toUtc().toIso8601String(),
      };
      final table = Supabase.instance.client.from('businesses');
      if(widget.item == null) { await table.insert(row).select('id').single(); }
      else { await table.update(row).eq('id', widget.item!['id']).select('id').single(); }
      if(mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status == 'published' ? 'Listing published' : 'Listing saved as $status'))); Navigator.pop(context,true); }
    } catch (_) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save the listing. Check your admin sign-in and try again.'))); }
    finally { if(mounted) setState(() => busy = false); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(charity ? 'Christmas charity' : 'Real Christmas tree seller')),
    body: Form(key: form, child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(charity ? 'Link directly to the charity’s own donation page. Include what donations support and any drop-off details.' : 'Include tree prices, sizes, opening dates and hours, collection or delivery details in the description.'),
      const SizedBox(height:16),
      TextFormField(controller:name, decoration: const InputDecoration(labelText:'Name'), validator:(v) => (v??'').trim().isEmpty ? 'Enter a name' : null),
      const SizedBox(height:12),
      TextFormField(controller:description, minLines:4,maxLines:8, decoration:const InputDecoration(labelText:'Description / seasonal details')),
      const SizedBox(height:12),
      TextFormField(controller:url, keyboardType:TextInputType.url, decoration:InputDecoration(labelText:charity ? 'Official donation / charity website' : 'Tree seller website'), validator:validUrl),
      const SizedBox(height:12),
      TextFormField(controller:region, decoration:const InputDecoration(labelText:'Region (or Nationwide)'),validator:(v) => (v??'').trim().isEmpty ? 'Enter a region' : null),
      const SizedBox(height:12),
      TextFormField(controller:city, decoration:const InputDecoration(labelText:'City / town (optional)')),
      const SizedBox(height:12),
      TextFormField(controller:address, decoration:InputDecoration(labelText:charity ? 'Drop-off address (optional)' : 'Collection address (optional)')),
      const SizedBox(height:12),
      TextFormField(controller:image, decoration:const InputDecoration(labelText:'Photo / logo URL (optional)')),
      OutlinedButton.icon(onPressed:busy ? null : upload, icon:const Icon(Icons.add_photo_alternate_outlined), label:const Text('Upload photo / logo')),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(initialValue:status, decoration:const InputDecoration(labelText:'Visibility'),
        items:const [DropdownMenuItem(value:'draft',child:Text('Draft')),DropdownMenuItem(value:'published',child:Text('Published')),DropdownMenuItem(value:'archived',child:Text('Archived'))],
        onChanged:busy ? null : (v) => setState(() => status = v ?? 'draft')),
      const SizedBox(height:20),
      FilledButton(onPressed:busy ? null : save, child:Text(busy ? 'Please wait…' : 'Save listing')),
    ]))),
  );
}
