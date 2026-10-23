import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/csv_export.dart';
import 'package:christmas_ideas_nz_test/registered_users.dart';
void main(){
 test('CSV protects formulas and exports eligible accounts only',(){
 final csv=accountCsv([{'name':'=HYPERLINK("bad")','email':'x@example.invalid','entry_number':1},{'name':'Admin','email':'admin@example.invalid'}],entriesOnly:true);
 expect(csv,contains("'=HYPERLINK"));expect(csv,contains('""bad""'));expect(csv,contains('x@example.invalid'));expect(csv, isNot(contains('admin@example.invalid')));
 });
 testWidgets('Hidden draw leaves permanent account names, email and export available',(tester)async{
 await tester.pumpWidget(MaterialApp(home:RegisteredUsersPage(loader:()async=>{'accounts':[{'id':'1','name':'Example member','email':'test@example.invalid','role':'member','created_at':'2026-10-01T00:00:00Z','entry_number':1}],'draw':{'enabled':false,'count':1}})));
 await tester.pumpAndSettle();expect(find.text('Example member'),findsOneWidget);expect(find.text('test@example.invalid'),findsOneWidget);expect(find.text('Export all accounts (CSV)'),findsOneWidget);expect(find.text('Draw winner'),findsNothing);
 await tester.pumpWidget(const SizedBox());
 });
}
