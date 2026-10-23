import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:christmas_ideas_nz_test/review_features.dart';
void main() {
 setUpAll(() async {
  SharedPreferences.setMockInitialValues({});
  await Supabase.initialize(url: 'https://example.supabase.co', anonKey: 'test-key',
   authOptions: const FlutterAuthClientOptions(autoRefreshToken: false));
 });
 testWidgets('Restore completes before editing; one save confirms and stays saved', (tester) async {
  final restored = Completer<Map<String,String>>();
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: HomeAreaSettings(loadArea: () => restored.future))));
  expect(tester.widget<TextField>(find.byType(TextField)).enabled, false);
  expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  restored.complete({'region': 'Canterbury', 'city': 'Christchurch'});
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'Bishopdale');
  final before = homeAreaRevision.value;
  await tester.tap(find.text('Save home area'));
  await tester.pumpAndSettle();
  expect(homeAreaRevision.value, before + 1);
  expect(find.text('Home area saved ✓'), findsOneWidget);
  expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  final prefs = await SharedPreferences.getInstance();
  expect(prefs.getString('home_region'), 'Canterbury');
  expect(prefs.getString('home_city'), 'Bishopdale');
  expect((await loadHomeArea())['city'], 'Bishopdale');
  await tester.enterText(find.byType(TextField), 'Christchurch');
  await tester.pump();
  expect(find.text('Save home area'), findsOneWidget);
  expect(tester.takeException(), isNull);
 });
}
