import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/secret_santa.dart';
import 'package:christmas_ideas_nz_test/secret_santa_data.dart';

void main() {
  test(
    'December plan has 31 complete, linked messages and valid calendar dates',
    () {
      expect(decemberIdeas.length, 31);
      for (var i = 0; i < 31; i++) {
        expect(decemberIdeas[i].title, isNotEmpty);
        expect(
          decemberMessage(i),
          contains('https://christmasideasnz.co.nz/?secret-santa='),
        );
        expect([...santaSections, 'submit'], contains(decemberIdeas[i].link));
      }
      final ics = decemberIcs(2026);
      expect('BEGIN:VEVENT'.allMatches(ics).length, 31);
      expect('END:VEVENT'.allMatches(ics).length, 31);
      expect(ics, contains('DTSTART;VALUE=DATE:20261201'));
      expect(ics, contains('DTSTART;VALUE=DATE:20261231'));
      expect(ics, contains('DTEND;VALUE=DATE:20270101'));
      expect(
        decemberTemplate(),
        contains('[paste your private draw invitation here]'),
      );
      expect(decemberTemplate(), contains('DECEMBER 31'));
    },
  );
  test('Elf names are stable and all combinations produce a name', () {
    expect(elfNameFor(0, 0, 0), elfNameFor(0, 0, 0));
    final names = <String>{};
    for (var t = 0; t < 4; t++)
      for (var m = 0; m < 4; m++)
        for (var s = 0; s < 12; s++) {
          final name = elfNameFor(t, m, s);
          expect(name.split(' ').length, 2);
          names.add(name);
        }
    expect(names.length, greaterThan(30));
  });
  test('Quiz scores all personalities and resolves ties consistently', () {
    for (var i = 0; i < 4; i++) expect(reindeerResult([i, i, i, i]), i);
    expect(reindeerResult([3, 3, 1, 2]), 3);
    expect(reindeerResult([3, 2, 1, 0]), 0);
  });
  for (final section in santaSections) {
    testWidgets('$section works at narrow width with enlarged text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 850);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 850),
              textScaler: TextScaler.linear(1.6),
            ),
            child: SecretSantaPage(
              initialSection: section,
              onSubmit: () {},
              onBrowseGifts: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Secret Santa'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Hub routes to rules and sustainable invitation', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecretSantaPage()));
    await tester.tap(find.text('Choose how to play'));
    await tester.pumpAndSettle();
    expect(find.text('Classic Secret Santa'), findsOneWidget);
    await tester.tap(find.text('Classic Secret Santa'));
    await tester.pumpAndSettle();
    expect(find.text('Copy rules'), findsOneWidget);
  });
  testWidgets('Gift budget opens directory with selected cap', (tester) async {
    double? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: SecretSantaPage(
          initialSection: 'gifts',
          onBrowseGifts: (value) => selected = value,
        ),
      ),
    );
    await tester.tap(find.text('Up to \$10'));
    await tester.pumpAndSettle();
    expect(find.text('A garden beginning'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Browse listed gifts up to \$10'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Browse listed gifts up to \$10'));
    expect(selected, 10);
  });
  testWidgets('Elf generator produces and can copy a result', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ElfNameGenerator())),
      ),
    );
    await tester.tap(find.text('Make my elf name'));
    await tester.pumpAndSettle();
    expect(find.text(elfNameFor(0, 0, 0)), findsOneWidget);
    expect(find.text('Copy my elf name'), findsOneWidget);
  });
  testWidgets('Quiz requires answers, shows result and resets', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ReindeerQuiz())),
      ),
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Meet my reindeer'),
          )
          .onPressed,
      isNull,
    );
    for (var q = 0; q < 4; q++) {
      final option = find.text(reindeerOptions[q][2]);
      await tester.ensureVisible(option);
      await tester.pumpAndSettle();
      await tester.tap(option);
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.text('Meet my reindeer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Meet my reindeer'));
    await tester.pumpAndSettle();
    expect(find.text('You’re Cupid!'), findsOneWidget);
    await tester.ensureVisible(find.text('Try again'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('You’re Cupid!'), findsNothing);
  });
}
