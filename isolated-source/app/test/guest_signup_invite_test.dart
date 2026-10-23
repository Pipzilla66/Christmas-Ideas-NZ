import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:christmas_ideas_nz_test/guest_signup_invite.dart';
void main() {
 setUp(() => SharedPreferences.setMockInitialValues({}));
 Widget app({bool signedIn=false, Future<void> Function()? signUp}) => MaterialApp(home:GuestSignupInvite(isSignedIn:()=>signedIn,onSignUp:signUp??()async{},child:const Scaffold(body:Text('Browse Christmas ideas'))));
 testWidgets('Guest can browse first and dismiss the delayed invitation', (tester)async{
   await tester.pumpWidget(app());await tester.pump(const Duration(seconds:29));
   expect(find.byType(AlertDialog),findsNothing);expect(find.text('Browse Christmas ideas'),findsOneWidget);
   await tester.pump(const Duration(seconds:1));await tester.pumpAndSettle();
   expect(find.text('Sign up free'),findsOneWidget);
   await tester.tap(find.text('Keep browsing'));await tester.pumpAndSettle();
   expect(find.byType(AlertDialog),findsNothing);
   await tester.pump(const Duration(minutes:2));expect(find.byType(AlertDialog),findsNothing);
   await tester.pumpWidget(const SizedBox());
 });
 testWidgets('Signed-in members are not interrupted', (tester)async{
   await tester.pumpWidget(app(signedIn:true));await tester.pump(const Duration(seconds:35));await tester.pumpAndSettle();
   expect(find.byType(AlertDialog),findsNothing);await tester.pumpWidget(const SizedBox());
 });
 testWidgets('Invitation opens signup only when requested', (tester)async{
   var calls=0;
   await tester.pumpWidget(app(signUp:()async{calls++;}));await tester.pump(const Duration(seconds:30));await tester.pumpAndSettle();
   expect(calls,0);await tester.tap(find.text('Sign up free'));await tester.pumpAndSettle();expect(calls,1);
   await tester.pumpWidget(const SizedBox());
 });
 testWidgets('Recent invitation is not repeated after reopening', (tester)async{
   SharedPreferences.setMockInitialValues({'guest_signup_invite_at':DateTime.now().millisecondsSinceEpoch});
   await tester.pumpWidget(app());await tester.pump(const Duration(seconds:35));await tester.pumpAndSettle();
   expect(find.byType(AlertDialog),findsNothing);await tester.pumpWidget(const SizedBox());
 });
 testWidgets('Opening an item defers invitation until back in the list', (tester)async{
   await tester.pumpWidget(app());
   final context=tester.element(find.text('Browse Christmas ideas'));
   Navigator.of(context).push(MaterialPageRoute<void>(builder:(_)=>const Scaffold(body:Text('Item details'))));await tester.pumpAndSettle();
   await tester.pump(const Duration(seconds:35));expect(find.byType(AlertDialog),findsNothing);
   Navigator.of(tester.element(find.text('Item details'))).pop();await tester.pumpAndSettle();
   await tester.pump(const Duration(seconds:5));await tester.pumpAndSettle();expect(find.byType(AlertDialog),findsOneWidget);
   await tester.tap(find.text('Keep browsing'));await tester.pumpAndSettle();await tester.pumpWidget(const SizedBox());
 });
}
