import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/catch_presents.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';

void main() {
  testWidgets('Catch scores once, pause preserves time, round ends and replay resets', (t) async {
    await t.pumpWidget(const MaterialApp(home: CatchPresentsPage(randomSeed: 2)));
    expect(find.byTooltip('Catch present'), findsNothing);
    await t.tap(find.text('Start game')); await t.pump();
    expect(find.byTooltip('Catch present'), findsOneWidget);
    await t.tap(find.byTooltip('Catch present')); await t.pump();
    expect(find.text('Presents caught: 1'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 800));
    expect(find.byTooltip('Catch present'), findsOneWidget);
    await t.ensureVisible(find.text('Pause game')); await t.tap(find.text('Pause game')); await t.pump();
    expect(find.text('Game paused'), findsOneWidget); expect(find.byTooltip('Catch present'), findsNothing);
    final before = t.widget<Text>(find.byKey(const ValueKey('catch-time'))).data;
    await t.pump(const Duration(seconds: 10));
    expect(t.widget<Text>(find.byKey(const ValueKey('catch-time'))).data,before);
    await t.tap(find.text('Keep playing')); await t.pump();
    await t.pump(const Duration(seconds: 30));
    expect(find.text('You caught 1 present! 🎉'), findsOneWidget);expect(find.byTooltip('Catch present'), findsNothing);
    await t.tap(find.text('Play again')); await t.pump();
    expect(find.text('Presents caught: 0'), findsOneWidget);expect(find.text('Time left: 30 s'), findsOneWidget);
    await t.pumpWidget(const SizedBox());await t.pump();expect(t.takeException(),isNull);
  });
  testWidgets('Backgrounding pauses a round until the child resumes', (t) async {
    await t.pumpWidget(const MaterialApp(home: CatchPresentsPage(randomSeed: 1)));
    await t.tap(find.text('Start game')); await t.pump();
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);await t.pump();
    expect(find.text('Game paused'), findsOneWidget);
    await t.pump(const Duration(seconds: 5));expect(find.text('Time left: 30 s'), findsOneWidget);
    t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);await t.pump();expect(find.text('Game paused'), findsOneWidget);
    await t.pumpWidget(const SizedBox());await t.pump();
  });
  for (final width in [320.0,1100.0]) testWidgets('Kids Zone opens second game alongside matching at $width', (t) async {
    t.view.physicalSize=Size(width,700);t.view.devicePixelRatio=1;addTearDown(t.view.resetPhysicalSize);addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(const MaterialApp(home:KidsSantaPage()));
    await t.scrollUntilVisible(find.text('Catch the presents'),100,scrollable:find.byType(Scrollable).first);
    await t.ensureVisible(find.text('Catch the presents')); await t.pumpAndSettle();
    expect(find.text('Catch the presents').hitTestable(),findsOneWidget);
    await t.tap(find.text('Catch the presents'));await t.pumpAndSettle();
    expect(find.text('Start game'),findsOneWidget);
    await t.ensureVisible(find.text('Start game'));await t.pumpAndSettle();await t.tap(find.text('Start game'));await t.pump();
    final gift=find.byTooltip('Catch present').first;
    expect(t.getSize(gift),const Size(64,64));await t.ensureVisible(gift);await t.pump();await t.tap(gift);await t.pump();
    expect(find.text('Presents caught: 1'),findsOneWidget);expect(t.takeException(),isNull);
    await t.pageBack();await t.pumpAndSettle();
    expect(find.text('Kids Zone'),findsOneWidget);
    await t.scrollUntilVisible(find.text('Christmas matching game'),-100,scrollable:find.byType(Scrollable).first);
    expect(find.text('Christmas matching game'),findsOneWidget);
  });
}
