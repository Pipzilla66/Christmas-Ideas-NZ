import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/board_save.dart';

void main() {
  Future<void> open(WidgetTester tester, BoardSaveSheet sheet) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                builder: (_) => sheet,
              ),
              child: const Text('Save'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('create from empty collection, trim name, and save item', (
    tester,
  ) async {
    String? name;
    String? saved;
    await open(
      tester,
      BoardSaveSheet(
        boards: [],
        createBoard: (n) async {
          name = n;
          return 'new-board';
        },
        saveItem: (id) async {
          saved = id;
        },
      ),
    );
    await tester.tap(find.text('Create a new board'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create board and save'));
    await tester.pump();
    expect(find.text('Enter a name for your board.'), findsOneWidget);
    expect(name, isNull);
    await tester.enterText(find.byType(TextField), '  Decorations  ');
    await tester.tap(find.text('Create board and save'));
    await tester.pumpAndSettle();
    expect(name, 'Decorations');
    expect(saved, 'new-board');
    expect(find.text('Save to board'), findsNothing);
  });

  testWidgets('existing boards remain selectable and create stays available', (
    tester,
  ) async {
    String? saved;
    await open(
      tester,
      BoardSaveSheet(
        boards: [
          {'id': 'old', 'name': 'Gifts for Macey'},
        ],
        createBoard: (_) async => throw StateError('Must not create'),
        saveItem: (id) async {
          saved = id;
        },
      ),
    );
    expect(find.text('Create a new board'), findsOneWidget);
    await tester.tap(find.text('Gifts for Macey'));
    await tester.pumpAndSettle();
    expect(saved, 'old');
  });

  testWidgets(
    'retry failed save reuses new board and blocks repeated submits',
    (tester) async {
      int creates = 0;
      int saves = 0;
      final pending = Completer<String>();
      await open(
        tester,
        BoardSaveSheet(
          boards: [],
          createBoard: (_) {
            creates++;
            return pending.future;
          },
          saveItem: (_) async {
            if (++saves == 1) throw StateError('Offline');
          },
        ),
      );
      await tester.tap(find.text('Create a new board'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Trees');
      await tester.tap(find.text('Create board and save'));
      await tester.pump();
      await tester.tap(find.text('Create board and save'));
      expect(creates, 1);
      pending.complete('created');
      await tester.pumpAndSettle();
      expect(find.text('Retry saving item'), findsOneWidget);
      await tester.tap(find.text('Retry saving item'));
      await tester.pumpAndSettle();
      expect(creates, 1);
      expect(saves, 2);
    },
  );
}
