import 'package:flutter/material.dart';

/// Keeps a newly created board available if saving fails, so retrying cannot
/// create another board with the same name.
class BoardSaveSheet extends StatefulWidget {
  final List<Map<String, dynamic>> boards;
  final Future<String> Function(String name) createBoard;
  final Future<void> Function(String boardId) saveItem;
  const BoardSaveSheet({
    super.key,
    required this.boards,
    required this.createBoard,
    required this.saveItem,
  });

  @override
  State<BoardSaveSheet> createState() => _BoardSaveSheetState();
}

class _BoardSaveSheetState extends State<BoardSaveSheet> {
  final name = TextEditingController();
  late final boards = List<Map<String, dynamic>>.from(widget.boards);
  bool creating = false;
  bool busy = false;
  String? error;
  String? createdId;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> save(String? boardId) async {
    if (busy) return;
    if (boardId == null && createdId == null && name.text.trim().isEmpty) {
      setState(() => error = 'Enter a name for your board.');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      var target = boardId ?? createdId;
      if (target == null) {
        target = await widget.createBoard(name.text.trim());
        createdId = target;
        boards.add({'id': target, 'name': name.text.trim()});
      }
      await widget.saveItem(target);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted)
        setState(
          () => error = createdId != null
              ? 'Your board was created, but the item could not be saved. Try again.'
              : 'Could not save this item. Check your connection and try again.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Save to board',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            ...boards.map(
              (board) => ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: Text((board['name'] ?? 'Board').toString()),
                enabled: !busy,
                onTap: () => save(board['id'].toString()),
              ),
            ),
            if (!creating)
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Create a new board'),
                enabled: !busy,
                onTap: () => setState(() => creating = true),
              ),
            if (creating) ...[
              const SizedBox(height: 12),
              TextField(
                controller: name,
                autofocus: true,
                enabled: !busy && createdId == null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Board name',
                  hintText: 'e.g. Christmas decorations',
                ),
                onSubmitted: (_) => save(null),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: busy ? null : () => save(null),
                icon: const Icon(Icons.add),
                label: Text(
                  createdId == null
                      ? 'Create board and save'
                      : 'Retry saving item',
                ),
              ),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            if (busy)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            TextButton(
              onPressed: busy ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}
