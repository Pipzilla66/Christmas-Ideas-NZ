import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/advent_calendar.dart';
import '../lib/advent_facts.dart';
import '../lib/calendar_time.dart';
import '../lib/home_hero.dart';
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('24 distinct sourced facts and activities', () {
    expect(adventFacts.map((f) => f.day), orderedEquals(List.generate(24, (i) => i+1)));
    expect(adventFacts.map((f) => f.fact).toSet().length, 24);
    expect(adventFacts.every((f) => f.activity.isNotEmpty && f.sourceUrl.startsWith('https://')), isTrue);
  });
  test('Doors unlock at NZ midnight and reset next year', () {
    expect(adventDoorAvailable(1, nzCalendarToday(DateTime.utc(2026,11,30,10,59))), isFalse);
    final first = nzCalendarToday(DateTime.utc(2026,11,30,11));
    expect(adventDoorAvailable(1, first), isTrue); expect(adventDoorAvailable(2,first), isFalse);
    expect(adventDoorAvailable(2,nzCalendarToday(DateTime.utc(2026,12,1,11))), isTrue);
    expect(adventDoorAvailable(24,nzCalendarToday(DateTime.utc(2026,12,24,11))), isTrue);
    final next = nzCalendarToday(DateTime.utc(2026,12,31,11));
    expect(next.year,2027); expect(adventDoorAvailable(1,next),isFalse);
    expect(adventOpenedKey(2026),isNot(adventOpenedKey(2027)));
    expect(adventDoorAvailable(0,first),isFalse); expect(adventDoorAvailable(25,first),isFalse);
  });
  testWidgets('Sample does not unlock or save a future door', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AdventCalendarPage(clock: () => DateTime.utc(2026,10,13))));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See a sample fact')); await tester.pumpAndSettle();
    expect(find.text(adventFacts.first.fact),findsOneWidget);
    await tester.tap(find.text('Close')); await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('advent-door-1')));
    await tester.tap(find.byKey(const ValueKey('advent-door-1'))); await tester.pumpAndSettle();
    expect(find.byType(AlertDialog),findsNothing);
    expect((await SharedPreferences.getInstance()).getStringList(adventOpenedKey(2026)),isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Open today, persist, block tomorrow and reset year', (tester) async {
    var clock = DateTime.utc(2026,12,1,11);
    await tester.pumpWidget(MaterialApp(home: AdventCalendarPage(clock: () => clock)));
    await tester.pumpAndSettle(); await tester.ensureVisible(find.text('Open today’s door')); await tester.pumpAndSettle(); await tester.tap(find.text('Open today’s door')); await tester.pumpAndSettle();
    expect(find.text(adventFacts[1].fact),findsOneWidget);
    expect((await SharedPreferences.getInstance()).getStringList(adventOpenedKey(2026)),contains('2'));
    await tester.tap(find.text('Close')); await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('advent-door-3')));
    await tester.tap(find.byKey(const ValueKey('advent-door-3'))); await tester.pumpAndSettle();
    expect(find.byType(AlertDialog),findsNothing);
    clock=DateTime.utc(2026,12,31,11); await tester.pump(const Duration(minutes:1)); await tester.pumpAndSettle();
    expect(find.text('The first door opens on 1 December 2027.'),findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Countdown link opens calendar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SingleChildScrollView(child: ChristmasHomeHero(days:73)))));
    await tester.ensureVisible(find.byKey(const ValueKey('advent-home-link')));
    await tester.tap(find.byKey(const ValueKey('advent-home-link'))); await tester.pumpAndSettle();
    expect(find.byType(AdventCalendarPage),findsOneWidget); expect(tester.takeException(),isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Narrow screen with enlarged text fits last fact', (tester) async {
    tester.view.physicalSize=const Size(320,900); tester.view.devicePixelRatio=1;
    addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: MediaQuery(data: const MediaQueryData(size:Size(320,900),textScaler:TextScaler.linear(1.6)),child:AdventCalendarPage(clock:()=>DateTime.utc(2026,12,23,11)))));
    await tester.pumpAndSettle(); await tester.ensureVisible(find.text('Open today’s door')); await tester.pumpAndSettle(); await tester.tap(find.text('Open today’s door')); await tester.pumpAndSettle();
    expect(find.text(adventFacts[23].fact),findsOneWidget); expect(tester.takeException(),isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
