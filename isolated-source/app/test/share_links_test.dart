import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:christmas_ideas_nz_test/main.dart';
import 'package:christmas_ideas_nz_test/share_links.dart';

void main() {
  Map<String, dynamic>? submitted;
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(url: 'https://example.supabase.co', anonKey: 'test-key',
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false, detectSessionInUri: false),
      httpClient: MockClient((request) async {
        if (request.url.path == '/auth/v1/token') {
          return http.Response(jsonEncode({'access_token': 'test-token', 'refresh_token': 'refresh', 'token_type': 'bearer', 'expires_in': 3600,
            'user': {'id': 'test-member', 'aud': 'authenticated', 'email': 'tester@example.com', 'created_at': '2026-10-16T00:00:00Z', 'app_metadata': {}, 'user_metadata': {}}}), 200,
            headers: {'content-type': 'application/json'});
        }
        if (request.url.path == '/rest/v1/submissions' && request.method == 'POST') {
          submitted = Map<String, dynamic>.from(jsonDecode(request.body));
        }
        return http.Response('[]', 200, headers: {'content-type': 'application/json'});
      }));
  });

  for (final section in ['Events', 'Light Displays', 'Stores', 'Recipes', 'Elf Ideas', 'Gifts', 'Christmas Charities', 'Real Christmas Trees']) {
    testWidgets('$section link opens the existing form with the contextual category', (tester) async {
      await Supabase.instance.client.auth.signInWithPassword(email: 'tester@example.com', password: 'test-password');
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body:
        ShareIdeaLink(section: section, onPressed: () => openCommunitySubmission(context, section: section))))));
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SubmissionPage), findsOneWidget);
      expect(find.text('Sharing to: $section'), findsOneWidget);
      expect(tester.widget<DropdownButtonFormField<String>>(find.byType(DropdownButtonFormField<String>).first).initialValue, submissionTypeForSection(section));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Guest link opens signup and cancelling does not open a submission', (tester) async {
    await tester.runAsync(() => Supabase.instance.client.auth.signOut());
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body:
      ShareIdeaLink(section: 'Recipes', onPressed: () => openCommunitySubmission(context, section: 'Recipes'))))));
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.text('Create a free account'), findsWidgets);
    expect(find.byType(SubmissionPage), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SubmissionPage), findsNothing);
    expect(find.text('+ Share your own'), findsOneWidget);
  });

  testWidgets('Recipe submission retains its category and awaits approval', (tester) async {
    await tester.runAsync(() => Supabase.instance.client.auth.signInWithPassword(email: 'tester@example.com', password: 'test-password'));
    await tester.pumpWidget(const MaterialApp(home: SubmissionPage(initialSection: 'Recipes')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Our family recipe');
    await tester.scrollUntilVisible(find.text('Send for approval'), 250, scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Send for approval'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send for approval'));
    await tester.pumpAndSettle();
    expect(submitted?['submission_type'], 'idea');
    expect(submitted?['payload']['content_type'], 'recipe');
    expect(submitted?['status'], 'pending');
  });

  for (final width in [320.0, 412.0, 1100.0]) {
    testWidgets('Subtle heading fits $width with larger text', (tester) async {
      tester.view.physicalSize = Size(width, 900); tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(home: MediaQuery(data: MediaQueryData(size: Size(width, 900), textScaler: const TextScaler.linear(1.6)), child:
        Scaffold(body: Padding(padding: const EdgeInsets.all(20), child: ShareSectionHeading(title: const Text('Christmas Near You', style: TextStyle(fontSize: 32)), section: 'Light Displays', onShare: () {}))))));
      await tester.pumpAndSettle();
      expect(find.text('+ Add a listing'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
