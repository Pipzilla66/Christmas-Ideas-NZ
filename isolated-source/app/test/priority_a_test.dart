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
import 'package:christmas_ideas_nz_test/idea_presentation.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';
import 'package:christmas_ideas_nz_test/christmas_inspiration.dart';

void main() {
  final submitted = <Map<String, dynamic>>[];
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'test-key',
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: false,
        detectSessionInUri: false,
      ),
      httpClient: MockClient((r) async {
        dynamic data = [];
        if (r.url.path.contains('/auth/'))
          data = {
            'access_token': 'token',
            'refresh_token': 'refresh',
            'token_type': 'bearer',
            'expires_in': 3600,
            'user': {
              'id': 'preview-member',
              'aud': 'authenticated',
              'email': 'fixture@example.com',
              'created_at': '2026-10-10T00:00:00Z',
              'app_metadata': {},
              'user_metadata': {},
            },
          };
        if (r.url.path.endsWith('/submissions') && r.method == 'POST')
          submitted.add(Map<String, dynamic>.from(jsonDecode(r.body)));

        if (r.url.path.endsWith('/profiles')) data = {'role': 'member'};
        if (r.url.path.endsWith('/content_items') &&
            r.url.queryParameters['select']?.contains('rating_count') == true &&
            r.url.queryParameters.containsKey('id'))
          data = {'rating_count': 2, 'rating_average': 4};
        if (r.url.path.endsWith('/get_daily_idea'))
          data = [
            {
              'id': 'daily',
              'title': 'Today’s elf',
              'summary': 'Existing daily inspiration',
              'content_type': 'elf',
            },
          ];
        return http.Response(
          jsonEncode(data),
          200,
          request: r,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });
  test('Duplicate credit cleanup is conservative and leaves source untouched', () {
    const body =
        'Arrange your elf.\n\nPhoto and idea courtesy of Laura Gilmour.\n\nPermission granted by contributor.';
    expect(
      ideaBodyWithoutDuplicateAcknowledgement(
        body,
        'Photo and idea courtesy of Laura Gilmour',
      ),
      'Arrange your elf.\n\nPermission granted by contributor.',
    );
    expect(body, contains('Laura Gilmour.'));
    expect(ideaBodyWithoutDuplicateAcknowledgement(body, ''), body);
    expect(
      ideaBodyWithoutDuplicateAcknowledgement(body, 'Another contributor'),
      body,
    );
    expect(
      ideaBodyWithoutDuplicateAcknowledgement(
        'Laura Gilmour shared this idea.',
        'Laura Gilmour',
      ),
      'Laura Gilmour shared this idea.',
    );
  });
  for (final width in [320.0, 412.0, 1100.0]) {
    testWidgets('Share CTA fits and activates at $width', (t) async {
      t.view.physicalSize = Size(width, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      bool clicked = false;
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18),
              child: HomeShareIdeaButton(onPressed: () => clicked = true),
            ),
          ),
        ),
      );
      final button = find.widgetWithText(
        FilledButton,
        'Share Your Christmas Idea',
      );
      final expected = width < 736 ? width - 36 : (width - 46) / 2;
      expect(t.getSize(button).width, closeTo(expected, 0.1));
      await t.tap(button);
      expect(clicked, isTrue);
      expect(t.takeException(), isNull);
    });
    for (final gift in [false, true])
      testWidgets(
        'Cream detail header is readable and Back works: $gift / $width',
        (t) async {
          t.view.physicalSize = Size(width, 800);
          t.view.devicePixelRatio = 1;
          addTearDown(t.view.resetPhysicalSize);
          addTearDown(t.view.resetDevicePixelRatio);
          final item = {
            'id': 'fixture',
            'title': 'Existing idea',
            'body': 'Instructions',
            'content_type': 'elf',
          };
          await t.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
              ),
              home: Builder(
                builder: (c) => Scaffold(
                  body: TextButton(
                    onPressed: () => Navigator.push(
                      c,
                      MaterialPageRoute(
                        builder: (_) => gift
                            ? GiftDetailPage(gift: item)
                            : ContentDetailPage(item: item),
                      ),
                    ),
                    child: const Text('Open'),
                  ),
                ),
              ),
            ),
          );
          await t.tap(find.text('Open'));
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)),
          );
          await t.pumpAndSettle();
          final bar = t.widget<AppBar>(find.byType(AppBar));
          expect(bar.foregroundColor, const Color(0xFF0F4C45));
          expect(bar.backgroundColor, const Color(0xFFF7F2E8));
          await t.pageBack();
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)),
          );
          await t.pumpAndSettle();
          expect(find.text('Open'), findsOneWidget);
          expect(t.takeException(), isNull);
        },
      );
  }
  testWidgets(
    'Rating stars follow the make/share action and retain aggregate',
    (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: IdeaCommunitySection(contentId: 'fixture'),
            ),
          ),
        ),
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pumpAndSettle();
      expect(
        t.getTopLeft(find.byTooltip('Rate 1 out of 5')).dy,
        greaterThan(t.getBottomLeft(find.text('Add a comment or my photo')).dy),
      );
      expect(find.text('4.0 / 5 • 2 ratings'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
  for (final kind in ['elf', 'craft', 'activity'])
    testWidgets('$kind detail offers existing own-idea flow', (t) async {
      await t.pumpWidget(
        MaterialApp(
          home: ContentDetailPage(
            item: {
              'id': 'fixture',
              'title': 'An idea',
              'body': 'Steps',
              'content_type': kind,
            },
          ),
        ),
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pumpAndSettle();
      await t.scrollUntilVisible(
        find.text('Share Your Own Idea'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await t.pumpAndSettle();
      await t.tap(find.text('Share Your Own Idea'));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pumpAndSettle();
      expect(find.text('Confirm password'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  testWidgets(
    'Built-in craft exposes own-idea action alongside unchanged credit',
    (t) async {
      await t.pumpWidget(
        MaterialApp(
          home: ChristmasInspirationPage(
            loader: () async => [],
            onIdea: (_) {},
          ),
        ),
      );
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Little handprint Christmas cards'));
      await t.pumpAndSettle();
      await t.tap(find.text('Little handprint Christmas cards'));
      await t.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await t.pumpAndSettle();
      expect(find.text('Share Your Own Idea'), findsOneWidget);
      expect(find.text('Photo: cottonbro studio / Pexels'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'Elf submission uses the existing pending-review process with mocked writes',
    (t) async {
      await t.runAsync(
        () => Supabase.instance.client.auth.signInWithPassword(
          email: 'fixture@example.com',
          password: 'test-password',
        ),
      );
      await t.pumpWidget(
        const MaterialApp(home: SubmissionPage(initialSection: 'Elf Ideas')),
      );
      await t.pumpAndSettle();
      await t.enterText(
        find.widgetWithText(TextField, 'Title / Name'),
        'Test elf idea',
      );
      await t.enterText(
        find.widgetWithText(TextField, 'Description'),
        'Original idea instructions for testing.',
      );
      await t.scrollUntilVisible(
        find.text('Send for approval'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await t.pumpAndSettle();
      await t.runAsync(() async {
        await t.tap(find.text('Send for approval'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await t.pumpAndSettle();
      expect(submitted.last['status'], 'pending');
      expect(submitted.last['submission_type'], 'idea');
      expect(submitted.last['payload']['source_section'], 'Elf Ideas');
      expect(find.textContaining('now waiting for approval'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
  testWidgets(
    'Built-in own-idea action submits through the existing craft dialog with mocked writes',
    (t) async {
      await t.pumpWidget(
        MaterialApp(
          home: ChristmasInspirationPage(
            loader: () async => [],
            onIdea: (_) {},
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Little handprint Christmas cards'));
      await t.pumpAndSettle();
      await t.tap(find.text('Little handprint Christmas cards'));
      await t.pumpAndSettle();
      await t.scrollUntilVisible(
        find.text('Share Your Own Idea'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await t.pumpAndSettle();
      await t.tap(find.text('Share Your Own Idea'));
      await t.pumpAndSettle();
      expect(find.text('Share a craft or activity'), findsWidgets);
      await t.enterText(
        find.widgetWithText(TextField, 'Give it a name'),
        'Test handmade decoration',
      );
      await t.enterText(
        find.widgetWithText(TextField, 'Materials, suitable ages and steps'),
        'Paper, glue and ribbon. Cut and join the shapes.',
      );
      await t.runAsync(() async {
        await t.tap(find.text('Submit for review'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await t.pumpAndSettle();
      expect(submitted.last['status'], 'pending');
      expect(submitted.last['payload']['content_type'], 'activity');
      expect(find.textContaining('waiting for admin review'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
}
