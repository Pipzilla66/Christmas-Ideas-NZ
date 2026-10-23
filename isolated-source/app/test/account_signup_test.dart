import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:christmas_ideas_nz_test/main.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  Map<String, dynamic>? signupRequest;
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'test-publishable-key',
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false, detectSessionInUri: false),
      httpClient: MockClient((request) async {
        expect(request.url.path, '/auth/v1/signup');
        signupRequest = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({
          'id': 'ab334941-1dc2-4084-8e36-5a6d39212261',
          'aud': 'authenticated',
          'email': 'member@example.com',
          'created_at': '2026-10-09T00:00:00Z',
          'app_metadata': {'provider': 'email'},
          'user_metadata': {},
        }), 200, headers: {'content-type': 'application/json'});
      }),
    );
  });

  testWidgets('Visitors can open signup without seeing admin tools', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: MePage(theme: XmasTheme.kiwi, onThemeChanged: (_) {}),
    )));
    expect(find.text('Forgot password?'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'member@example.com');
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.text('Reset password'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField).last).controller!.text, 'member@example.com');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.text('New here? Create an account'));
    await tester.pump();
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsNothing);
    expect(find.text('Admin Dashboard'), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'member@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'short');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    expect(find.text('Use a password with at least 8 characters.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(2), 'long-password');
    await tester.enterText(find.byType(TextField).at(3), 'different-password');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    expect(find.text('Your passwords do not match.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(3), 'long-password');
    await tester.runAsync(() async {
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    expect(signupRequest?['email'], 'member@example.com');
    expect((signupRequest?['data'] as Map?)?.containsKey('role') ?? false, isFalse);
    expect(find.textContaining('Check your email'), findsOneWidget);
    expect(find.text('Confirm password'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });
}
