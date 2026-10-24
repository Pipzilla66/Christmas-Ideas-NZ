import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:christmas_ideas_nz_test/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  bool pendingFixture = false;
  bool failProfiles = false;
  setUp(() { pendingFixture = false; failProfiles = false; });
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(url: 'https://example.supabase.co', anonKey: 'test-only',
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
      httpClient: MockClient((request) async {
        dynamic data = [];
        if (pendingFixture && request.url.path.endsWith('/submissions') &&
            (request.url.queryParameters['select'] ?? '').contains('user_id')) {
          data = [{'id': 'fixture-submission', 'user_id': 'fixture-user',
            'title': 'Fixture craft', 'submission_type': 'idea',
            'description': 'Test only', 'payload': {}, 'status': 'pending'}];
        }
        if (request.url.path.endsWith('/profiles')) {
          if (failProfiles) return http.Response('{"message":"Test denied"}',403,request:request);
          data = [{'id': 'fixture-user', 'display_name': 'Test Contributor',
            'email': 'contributor@example.com'}];
        }
        return http.Response(jsonEncode(data), 200, request: request,
          headers: {'content-type': 'application/json'});
      }));
  });
  testWidgets('Admin header overrides pale title and Back colours on cream', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(appBarTheme: const AppBarTheme(foregroundColor: Colors.white)),
      home: Builder(builder: (context) => Scaffold(body: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
        child: const Text('Open Admin'))))));
    await tester.tap(find.text('Open Admin'));
    await tester.pumpAndSettle();
    final bar = tester.widget<AppBar>(find.byType(AppBar));
    expect(bar.foregroundColor, const Color(0xFF0F4C45));
    expect(bar.backgroundColor, const Color(0xFFF7F2E8));
    expect(find.text('Admin'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Open Admin'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Submission form overrides white header and Back colours', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(appBarTheme: const AppBarTheme(foregroundColor: Colors.white)),
      home: Builder(builder: (context) => Scaffold(body: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmissionPage(initialSection: 'Elf Ideas'))),
        child: const Text('Share an idea'))))));
    await tester.tap(find.text('Share an idea'));
    await tester.pumpAndSettle();
    final bar = tester.widget<AppBar>(find.byType(AppBar));
    expect(bar.foregroundColor, const Color(0xFF0F4C45));
    expect(bar.backgroundColor, const Color(0xFFF7F2E8));
    expect(find.byType(BackButton), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Share an idea'), findsOneWidget);
  });
  testWidgets('Moderation sender details show both name and email', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body:
      SubmissionSenderDetails(item: {'user_id': 'fixture-user',
        'submitter_name': 'Test Contributor', 'submitter_email': 'contributor@example.com'}))));
    expect(find.text('Submitted by: Test Contributor'), findsOneWidget);
    expect(find.text('contributor@example.com'), findsOneWidget);
  });
  testWidgets('Missing profile does not invent a sender', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body:
      SubmissionSenderDetails(item: {'user_id': 'fixture-user'}))));
    expect(find.text('Submitted by: Submitting account details unavailable.'), findsOneWidget);
    expect(find.textContaining('Anonymous'), findsNothing);
  });
  testWidgets('Profile lookup failure is explicit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body:
      SubmissionSenderDetails(item: {'user_id': 'fixture-user', 'submitter_lookup_failed': true}))));
    expect(find.textContaining('could not be loaded'), findsOneWidget);
  });
  testWidgets('Pending moderation resolves sender from existing profile', (tester) async {
    pendingFixture = true;
    await tester.pumpWidget(const MaterialApp(home: AdminDashboardPage()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Submitted by: Test Contributor'),350,maxScrolls:35);
    expect(find.text('contributor@example.com'),findsOneWidget);
    expect(find.text('Fixture craft'),findsOneWidget);
    expect(tester.takeException(),isNull);
  });
  testWidgets('A profile error keeps the pending submission available', (tester) async {
    pendingFixture = true;
    failProfiles = true;
    await tester.pumpWidget(const MaterialApp(home: AdminDashboardPage()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Fixture craft'),350,maxScrolls:35);
    expect(find.textContaining('Submitter details could not be loaded'),findsOneWidget);
    expect(tester.takeException(),isNull);
  });
}
