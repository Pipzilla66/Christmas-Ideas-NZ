import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const santaMailboxKey = 'family_santa_letters_v2';

class SantaLetterPage extends StatefulWidget {
  const SantaLetterPage({super.key});
  @override
  State<SantaLetterPage> createState() => _SantaLetterPageState();
}

class _SantaLetterPageState extends State<SantaLetterPage> {
  final name = TextEditingController(), letter = TextEditingController();
  final editorKey = GlobalKey();
  List<Map<String, dynamic>> letters = [];
  String? currentId, error;
  String originalName = '', originalLetter = '';
  bool loading = true, saving = false, loadFailed = false;
  bool get dirty => name.text != originalName || letter.text != originalLetter;

  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(santaMailboxKey);
      var restored = <Map<String, dynamic>>[];
      if (raw != null) {
        restored = (jsonDecode(raw) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } else {
        final old = prefs.getString('family_santa_letter');
        if (old != null) {
          final data = Map<String, dynamic>.from(jsonDecode(old) as Map);
          if ((data['letter'] as String? ?? '').trim().isNotEmpty) {
            restored = [
              {
                ...data,
                'id': 'legacy',
                'savedAt': DateTime.now().toIso8601String(),
              },
            ];
            if (!await prefs.setString(santaMailboxKey, jsonEncode(restored)))
              throw Exception();
            await prefs.remove('family_santa_letter');
          }
        }
      }
      if (mounted)
        setState(() {
          letters = restored;
          loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          loading = false;
          loadFailed = true;
          error =
              'Your saved letters could not load. Please reopen the mailbox.';
        });
    }
  }

  @override
  void dispose() {
    name.dispose();
    letter.dispose();
    super.dispose();
  }

  Future<bool> canLeaveDraft() async {
    if (!dirty) return true;
    return await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Leave this unsaved letter?'),
            content: const Text(
              'Save your letter first to keep it in the mailbox.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Keep writing'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Discard changes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void edit(Map<String, dynamic>? entry) {
    setState(() {
      currentId = entry?['id'] as String?;
      name.text = entry?['name'] as String? ?? '';
      letter.text = entry?['letter'] as String? ?? '';
      originalName = name.text;
      originalLetter = letter.text;
      error = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && editorKey.currentContext != null) {
        Scrollable.ensureVisible(
          editorKey.currentContext!,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  Future<void> save({bool copy = false}) async {
    if (loadFailed) return;
    if (letter.text.trim().isEmpty) {
      setState(() => error = 'Write a little note to Santa first.');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final now = DateTime.now();
      final id = copy || currentId == null
          ? now.microsecondsSinceEpoch.toString()
          : currentId!;
      final entry = <String, dynamic>{
        'id': id,
        'name': name.text.trim(),
        'letter': letter.text.trim(),
        'savedAt': now.toIso8601String(),
      };
      final next = [entry, ...letters.where((e) => e['id'] != id)];
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(santaMailboxKey, jsonEncode(next)))
        throw Exception();
      if (mounted) {
        setState(() {
          letters = next;
          currentId = id;
          originalName = name.text;
          originalLetter = letter.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              copy
                  ? 'A separate copy is saved in your mailbox.'
                  : 'Your letter is saved in your mailbox.',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted)
        setState(() => error = 'The letter could not save. Please try again.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> remove(Map<String, dynamic> entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this saved letter?'),
        content: Text(
          'Delete ${entry['name'] == '' ? 'this letter' : '${entry['name']}’s letter'} from this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => saving = true);
    try {
      final next = letters.where((e) => e['id'] != entry['id']).toList();
      if (!await (await SharedPreferences.getInstance()).setString(
        santaMailboxKey,
        jsonEncode(next),
      ))
        throw Exception();
      if (mounted) {
        setState(() => letters = next);
        if (currentId == entry['id']) edit(null);
      }
    } catch (_) {
      if (mounted)
        setState(
          () => error = 'The letter could not delete. Please try again.',
        );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  String savedDate(Map<String, dynamic> entry) {
    final date = DateTime.tryParse(entry['savedAt'] as String? ?? '')
        ?.toLocal();
    return date == null ? '' : '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !dirty,
    onPopInvokedWithResult: (didPop, result) async {
      if (!didPop && await canLeaveDraft() && mounted) {
        setState(() {
          originalName = name.text;
          originalLetter = letter.text;
        });
        if (context.mounted) Navigator.pop(context);
      }
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Santa mailbox')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Keep a separate letter for every child, or save different copies. Letters stay private on this device and browser; they are not sent to Santa or shared online.',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Saved letters (${letters.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (letters.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Your family’s saved letters will appear here.',
                          ),
                        ),
                      for (final entry in letters)
                        Card(
                          child: ListTile(
                            selected: currentId == entry['id'],
                            title: Text(
                              (entry['name'] as String? ?? '').isEmpty
                                  ? 'Letter to Santa'
                                  : '${entry['name']}’s letter',
                            ),
                            subtitle: Text(
                              '${savedDate(entry)} · ${entry['letter']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: saving
                                ? null
                                : () async {
                                    if (await canLeaveDraft() && mounted)
                                      edit(entry);
                                  },
                            trailing: IconButton(
                              tooltip: 'Delete saved letter',
                              onPressed: saving ? null : () => remove(entry),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: saving
                            ? null
                            : () async {
                                if (await canLeaveDraft() && mounted)
                                  edit(null);
                              },
                        icon: const Icon(Icons.add),
                        label: const Text('New letter for another child'),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        currentId == null
                            ? 'Write a new letter'
                            : 'Edit your saved letter',
                        key: editorKey,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: name,
                        enabled: !saving && !loadFailed,
                        maxLength: 40,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'First name (optional)',
                        ),
                      ),
                      TextField(
                        controller: letter,
                        enabled: !saving && !loadFailed,
                        maxLength: 2000,
                        minLines: 5,
                        maxLines: 10,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Dear Santa…',
                        ),
                      ),
                      if (error != null)
                        Text(
                          error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      FilledButton.icon(
                        onPressed: saving || loadFailed ? null : () => save(),
                        icon: const Icon(Icons.save_outlined),
                        label: Text(
                          saving
                              ? 'Saving…'
                              : currentId == null
                              ? 'Save my letter'
                              : 'Save changes',
                        ),
                      ),
                      if (currentId != null)
                        OutlinedButton.icon(
                          onPressed: saving ? null : () => save(copy: true),
                          icon: const Icon(Icons.copy_outlined),
                          label: const Text('Save a separate copy'),
                        ),
                      OutlinedButton.icon(
                        onPressed: saving || letter.text.trim().isEmpty
                            ? null
                            : () => launchUrl(
                                Uri.parse(
                                  'https://christmasideasnz.co.nz/santa-letter.html',
                                ).replace(
                                  fragment: Uri.encodeComponent(
                                    jsonEncode({
                                      'name': name.text.trim(),
                                      'letter': letter.text.trim(),
                                    }),
                                  ),
                                ),
                                mode: LaunchMode.externalApplication,
                              ),
                        icon: const Icon(Icons.print_outlined),
                        label: const Text('Print this letter'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Use the same device and browser to return to your mailbox. Clearing browser data removes saved letters.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ),
  );
}
