import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/admin_delete.dart';
void main() {
  testWidgets('Removal requires explicit confirmation and Cancel preserves content', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: TextButton(
      onPressed: () async => result = await confirmContentRemoval(context, 'Gift example'), child: const Text('Remove'))))));
    await tester.tap(find.text('Remove')); await tester.pumpAndSettle();
    expect(result, isNull); expect(find.textContaining('Gift example'), findsOneWidget);
    await tester.tap(find.text('Cancel')); await tester.pumpAndSettle(); expect(result, false);
    await tester.tap(find.text('Remove')); await tester.pumpAndSettle();
    await tester.tap(find.text('Delete')); await tester.pumpAndSettle(); expect(result, true);
  });
}
