import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/member_insights.dart';
void main() {
 testWidgets('Admin statistics labels explain coverage and do not imply historical tracking', (tester) async {
   await tester.pumpWidget(MaterialApp(home:MemberStatisticsPage(loader:() async => {'Accounts':5,'Members':3,'Daily activity':[]})));
   await tester.pumpAndSettle();
   expect(find.text('Accounts'),findsOneWidget);
   expect(find.text('5'),findsOneWidget);
   await tester.scrollUntilVisible(find.text('No visits recorded yet. Tracking starts with this update.'),300);
   expect(find.textContaining('who allow analytics'),findsOneWidget);
   expect(find.textContaining('Earlier visits are unavailable.'),findsNothing);
 });
 testWidgets('Statistics failure shows retry rather than invented zero totals', (tester) async {
   await tester.pumpWidget(MaterialApp(home:MemberStatisticsPage(loader:() async => throw StateError('Denied'))));
   await tester.pumpAndSettle();
   expect(find.textContaining('Admin access is required.'),findsOneWidget);
   expect(find.text('Accounts'),findsNothing);
 });
 test('Notifications tolerate missing dates',(){expect(notificationDate(null),'');});
}
