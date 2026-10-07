import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const manageableContent = {
  'gift_ideas': 'Gifts',
  'content_items': 'Ideas, decorations & recipes',
  'events': 'Events & Santa visits',
  'light_displays': 'Light Displays',
  'businesses': 'Shops, charities & real trees',
};

Future<bool> confirmContentRemoval(BuildContext context, String title) async =>
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this listing?'),
        content: Text(
          '“$title” will be removed from the app. You can restore it from Removed content in admin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
    false;

Future<bool> removeAdminContent(
  BuildContext context,
  String table,
  Map<String, dynamic> item,
) async {
  if (!manageableContent.containsKey(table) || item['id'] == null) return false;
  if (!await confirmContentRemoval(
    context,
    (item['title'] ?? item['name'] ?? 'this listing').toString(),
  ))
    return false;
  try {
    final result = await Supabase.instance.client
        .from(table)
        .update({
          'status': 'archived',
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', item['id'])
        .select('id')
        .single();
    if (result['id'] == null) return false;
    if (context.mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Listing removed')));
    return true;
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not delete this listing. Check your admin sign-in and try again.',
          ),
        ),
      );
    return false;
  }
}

class AdminDeleteButton extends StatefulWidget {
  final String table;
  final Map<String, dynamic> item;
  final VoidCallback onDeleted;
  const AdminDeleteButton({
    super.key,
    required this.table,
    required this.item,
    required this.onDeleted,
  });
  @override
  State<AdminDeleteButton> createState() => _AdminDeleteButtonState();
}

class _AdminDeleteButtonState extends State<AdminDeleteButton> {
  bool busy = false;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Delete listing',
    icon: const Icon(Icons.delete_outline),
    onPressed: busy
        ? null
        : () async {
            setState(() => busy = true);
            final removed = await removeAdminContent(
              context,
              widget.table,
              widget.item,
            );
            if (!mounted) return;
            setState(() => busy = false);
            if (removed) widget.onDeleted();
          },
  );
}

class AdminManageContentPage extends StatefulWidget {
  const AdminManageContentPage({super.key});
  @override
  State<AdminManageContentPage> createState() => _AdminManageContentPageState();
}

class _AdminManageContentPageState extends State<AdminManageContentPage> {
  String table = 'gift_ideas';
  bool removed = false;
  String query = '';
  late Future<List<Map<String, dynamic>>> rows;
  @override
  void initState() {
    super.initState();
    rows = load();
  }

  Future<List<Map<String, dynamic>>> load() async {
    final result = await Supabase.instance.client
        .from(table)
        .select()
        .order(
          table == 'gift_ideas' || table == 'content_items' ? 'title' : 'name',
        );
    return List<Map<String, dynamic>>.from(result);
  }

  void reload() => setState(() => rows = load());
  Future<void> restore(Map<String, dynamic> item) async {
    try {
      await Supabase.instance.client
          .from(table)
          .update({
            'status': 'draft',
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', item['id'])
          .select('id')
          .single();
      if (mounted) {
        reload();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Restored as a draft')));
      }
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not restore this listing.')),
        );
    }
  }

  Future<void> publish(Map<String, dynamic> item) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Publish this listing?'),
        content: const Text('This listing will become visible to everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Publish'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await Supabase.instance.client
          .from(table)
          .update({
            'status': 'published',
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', item['id'])
          .select('id')
          .single();
      if (mounted) reload();
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not publish this listing.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Manage & delete content')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: table,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Section'),
                items: manageableContent.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null)
                    setState(() {
                      table = v;
                      rows = load();
                    });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search listings',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) =>
                    setState(() => query = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Current content')),
                  ButtonSegment(value: true, label: Text('Removed content')),
                ],
                selected: {removed},
                onSelectionChanged: (v) => setState(() => removed = v.first),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: rows,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (snap.hasError)
                return Center(
                  child: TextButton(
                    onPressed: reload,
                    child: const Text('Could not load. Retry'),
                  ),
                );
              final items = (snap.data ?? [])
                  .where(
                    (e) =>
                        (e['status'] == 'archived') == removed &&
                        '${e['title'] ?? e['name'] ?? ''} ${e['city'] ?? ''}'
                            .toLowerCase()
                            .contains(query),
                  )
                  .toList();
              if (items.isEmpty)
                return const Center(child: Text('No matching listings.'));
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return ListTile(
                    title: Text(
                      (item['title'] ?? item['name'] ?? 'Listing').toString(),
                    ),
                    subtitle: Text('${item['status']}'),
                    trailing: removed
                        ? IconButton(
                            tooltip: 'Restore as draft',
                            icon: const Icon(Icons.restore),
                            onPressed: () => restore(item),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item['status'] == 'draft')
                                IconButton(
                                  tooltip: 'Publish',
                                  icon: const Icon(Icons.publish),
                                  onPressed: () => publish(item),
                                ),
                              AdminDeleteButton(
                                table: table,
                                item: item,
                                onDeleted: reload,
                              ),
                            ],
                          ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
