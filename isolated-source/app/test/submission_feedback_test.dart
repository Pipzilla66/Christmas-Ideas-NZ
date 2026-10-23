import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/submission_feedback.dart';

void main() {
  Future<void> open(WidgetTester tester, void Function(String?) result) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result(
                await requestRejectionFeedback(context, 'My Christmas idea'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('rejection returns trimmed feedback for the submitter', (
    tester,
  ) async {
    String? result;
    await open(tester, (value) => result = value);
    expect(find.text('Feedback (optional)'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      '  Please include the event date.  ',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Reject submission'));
    await tester.pumpAndSettle();
    expect(result, 'Please include the event date.');
  });

  testWidgets('blank feedback still allows rejection', (tester) async {
    String? result;
    await open(tester, (value) => result = value);
    await tester.tap(find.widgetWithText(FilledButton, 'Reject submission'));
    await tester.pumpAndSettle();
    expect(result, '');
  });

  testWidgets('cancel abandons the decision and feedback', (tester) async {
    String? result = 'not cancelled';
    await open(tester, (value) => result = value);
    await tester.enterText(find.byType(TextField), 'Draft reason');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });
}
