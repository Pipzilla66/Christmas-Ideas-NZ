import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:christmas_ideas_nz_test/home_navigation.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';
void main() {
 setUpAll(() async {
  SharedPreferences.setMockInitialValues({});
  await Supabase.initialize(url:'https://example.supabase.co',anonKey:'test-key',
   authOptions:const FlutterAuthClientOptions(autoRefreshToken:false,detectSessionInUri:false),
   httpClient:MockClient((request)async=>http.Response(jsonEncode({
    'access_token':'test-token','refresh_token':'refresh','token_type':'bearer','expires_in':3600,
    'user':{'id':'test-member','aud':'authenticated','email':'test@example.com','created_at':'2026-10-11T00:00:00Z',
     'app_metadata':{},'user_metadata':{'display_name':'Tristan Bailey'}}}),200,request:request,headers:{'content-type':'application/json'})));
 });
 for(final width in [320.0,412.0,1100.0]) {
  testWidgets('Home shortcuts open the selected category at width $width', (tester)async{
   tester.view.physicalSize=Size(width,900);tester.view.devicePixelRatio=1;
   addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
   HomeCategory? chosen;
   await tester.pumpWidget(MaterialApp(home:Scaffold(body:HomeCategoryShortcuts(onSelected:(value)=>chosen=value))));
   for(final category in homeCategories){
    await tester.tap(find.text(category.label));
    expect(chosen,category);
   }
   expect(tester.takeException(),isNull);
  });
 }
 for(final width in [320.0,412.0,1100.0]) {
  testWidgets('Combined Explore tiles match size and Movies opens at $width',(tester)async{
   tester.view.physicalSize=Size(width,1000);tester.view.devicePixelRatio=1;
   addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
   await tester.pumpWidget(MaterialApp(home:Scaffold(body:Builder(builder:(context)=>
    HomeCategoryShortcuts(onSelected:(_){},additionalShortcuts:CommunityLinks.shortcuts(context,(_){}))))));
   expect(find.text('Real Christmas Trees'),findsNothing);
   expect(find.text('Kids Zone'),findsOneWidget);
   expect(find.text('Activities & Traditions'),findsOneWidget);
   expect(find.text('Family traditions'),findsNothing);
   expect(find.text('🎅'),findsNothing);
   final buttons=find.byType(OutlinedButton);expect(buttons,findsNWidgets(12));
   final expected=tester.getSize(buttons.first);
   for(var i=0;i<12;i++){expect(tester.getSize(buttons.at(i)),expected);}
   final columns=width>=700?4:2;
   expect(tester.getTopLeft(buttons.at(12-columns)).dy, tester.getTopLeft(buttons.last).dy);
   expect(tester.takeException(),isNull);
   await tester.tap(find.text('Movies & Music'));await tester.pumpAndSettle();
   expect(find.byType(MoviesHubPage),findsOneWidget);expect(find.text('Movie voting'),findsOneWidget);
   Navigator.of(tester.element(find.byType(MoviesHubPage))).pop();
   await tester.pumpAndSettle();
   await tester.tap(find.text('Activities & Traditions'));await tester.pumpAndSettle();
   expect(find.byType(ActivitiesTraditionsPage),findsOneWidget);
   expect(find.text('Crafts & activities'),findsOneWidget);
   expect(find.text('Family traditions'),findsOneWidget);
   expect(tester.takeException(),isNull);
  });
 }
 testWidgets('First member visit welcomes by name; reopening welcomes back', (tester)async{
  await Supabase.instance.client.auth.signInWithPassword(email:'test@example.com',password:'test-password');
  await tester.pumpWidget(const MaterialApp(home:Scaffold(body:MemberGreeting())));
  await tester.pumpAndSettle();
  expect(find.text('Welcome, Tristan!'),findsOneWidget);
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(const MaterialApp(home:Scaffold(body:MemberGreeting())));
  await tester.pumpAndSettle();
  expect(find.text('Welcome back, Tristan!'),findsOneWidget);
  expect(tester.takeException(),isNull);
 });
}
