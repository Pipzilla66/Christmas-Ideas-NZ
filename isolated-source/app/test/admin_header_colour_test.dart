import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:christmas_ideas_nz_test/main.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(url: 'https://example.supabase.co', anonKey: 'test-only',
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
      httpClient: MockClient((_) async => http.Response('[]', 200,
        headers: {'content-type': 'application/json'})));
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
}
