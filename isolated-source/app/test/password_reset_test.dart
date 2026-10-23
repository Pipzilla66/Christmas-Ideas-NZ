import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/password_reset.dart';
void main() {
  testWidgets('Reset validates email, prevents duplicate requests and explains inbox result', (tester) async {
    final done = Completer<void>();
    String? address;
    await tester.pumpWidget(MaterialApp(home: ForgotPasswordPage(sendReset: (value) {address = value; return done.future;})));
    await tester.tap(find.text('Send reset link')); await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), ' member@example.com ');
    await tester.tap(find.text('Send reset link')); await tester.pump();
    expect(address, 'member@example.com');
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
    done.complete(); await tester.pumpAndSettle();
    expect(find.textContaining('If an account uses this address'), findsOneWidget);
  });
  testWidgets('Prefilled email and retry after service error', (tester) async {
    await tester.pumpWidget(MaterialApp(home: ForgotPasswordPage(initialEmail: 'member@example.com', sendReset: (_) async {throw Exception('network');})));
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'member@example.com');
    await tester.tap(find.text('Send reset link')); await tester.pumpAndSettle();
    expect(find.textContaining('Could not request'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNotNull);
  });
}
