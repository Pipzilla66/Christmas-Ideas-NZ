import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:christmas_ideas_nz_test/main.dart';
import 'package:christmas_ideas_nz_test/review_features.dart';
void main() {
 var homeWrites = 0;
 final area = <String,dynamic>{'home_region':'Canterbury','home_city':'Christchurch'};
 final user = {'id':'ab334941-1dc2-4084-8e36-5a6d39212261', 'aud':'authenticated', 'email':'tester@example.com', 'created_at':'2026-10-09T00:00:00Z','app_metadata':{},'user_metadata':{}};
 setUpAll(() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  SharedPreferences.setMockInitialValues({});
  await Supabase.initialize(url:'https://example.supabase.co', anonKey:'test-key',
   authOptions: const FlutterAuthClientOptions(autoRefreshToken:false, detectSessionInUri:false),
   httpClient:MockClient((request) async {
    Object response = [];
    if (request.url.path == '/auth/v1/token' || request.url.path == '/auth/v1/signup') {
     response = {'access_token':'test-token','refresh_token':'test-refresh','token_type':'bearer','expires_in':3600,'user':user};
    } else if(request.url.path == '/rest/v1/profiles') {
     if (request.method == 'PATCH') { homeWrites++; area.addAll(jsonDecode(request.body) as Map<String,dynamic>); }
     final row = {'id':user['id'],'display_name':'Tester','role':'member',...area};
     response = request.method == 'PATCH' ? row : [row];
    }
    return http.Response(jsonEncode(response),200,request:request,headers:{'content-type':'application/json'});
   }));
 });
 setUp(() async {await Supabase.instance.client.auth.signOut();});
 Widget app(bool create) => MaterialApp(home:Builder(builder:(context) => Scaffold(
  body:Column(children:[const Text('Browsing home'),TextButton(onPressed:()=>openAccount(context,create:create),child:const Text('Open account'))]))));
 testWidgets('Signed-in home area saves on one tap and reloads the selected town', (tester) async {
  await Supabase.instance.client.auth.signInWithPassword(email:'tester@example.com',password:'test-password');
  await tester.pumpWidget(const MaterialApp(home:Scaffold(body:HomeAreaSettings())));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField),'Bishopdale');
  final before = homeWrites;
  await tester.runAsync(() async {
   await tester.tap(find.text('Save home area'));
   await Future<void>.delayed(const Duration(milliseconds:50));
  });
  await tester.pumpAndSettle();
  expect(homeWrites,before+1);
  expect(find.text('Home area saved ✓'),findsOneWidget);
  expect((await loadHomeArea())['city'],'Bishopdale');
  expect(tester.takeException(),isNull);
 });
 for(final create in [false,true]) {
  testWidgets('${create ? 'Signup' : 'Sign-in'} Explore now returns to browsing', (tester) async {
   await tester.pumpWidget(app(create));
   await tester.tap(find.text('Open account'));await tester.pumpAndSettle();
   if(create) {
    await tester.enterText(find.byType(TextField).at(0),'Tester');
    await tester.enterText(find.byType(TextField).at(1),'tester@example.com');
    await tester.enterText(find.byType(TextField).at(2),'test-password');
    await tester.enterText(find.byType(TextField).at(3),'test-password');
   } else {
    await tester.enterText(find.byType(TextField).at(0),'tester@example.com');
    await tester.enterText(find.byType(TextField).at(1),'test-password');
   }
   await tester.runAsync(() async {
    await tester.tap(find.widgetWithText(FilledButton,create?'Create account':'Sign in'));
    await Future<void>.delayed(const Duration(milliseconds:100));
   });
   await tester.pumpAndSettle();
   expect(find.text('Your account'),findsOneWidget);
   expect(find.text('Admin Dashboard'),findsNothing);
   final explore = create ? find.descendant(of:find.byType(AlertDialog),matching:find.text('Explore now')) : find.text('Explore now');
   await tester.runAsync(() async {
    await tester.tap(explore);
    await Future<void>.delayed(const Duration(milliseconds: 50));
   });
   await tester.pumpAndSettle();
   expect(find.text('Browsing home'),findsOneWidget);
   expect(find.text('Your account'),findsNothing);
   expect(tester.takeException(),isNull);
  });
 }
}
