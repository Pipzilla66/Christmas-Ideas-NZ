import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:christmas_ideas_nz_test/main.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';
void main(){
 final movies=[{'id':'a','title':'Elf','votes':0,'year':2003,'status':'published'},{'id':'b','title':'Home Alone','votes':0,'year':1990,'status':'published'}];
 bool voted=false;String boardName='Old board';int rating=0;
 setUpAll(()async{
  GoogleFonts.config.allowRuntimeFetching=false;SharedPreferences.setMockInitialValues({});
  await Supabase.initialize(url:'https://example.supabase.co',anonKey:'test-key',authOptions:const FlutterAuthClientOptions(autoRefreshToken:false,detectSessionInUri:false),httpClient:MockClient((r)async{
   dynamic data=[];
   if(r.url.path.contains('/auth/'))data={'access_token':'token','refresh_token':'refresh','token_type':'bearer','expires_in':3600,'user':{'id':'member','aud':'authenticated','email':'test@example.com','created_at':'2026-10-10T00:00:00Z','app_metadata':{},'user_metadata':{'display_name':'Pip Jones'}}};
   else if(r.url.path.endsWith('/profiles'))data={'role':'member'};
   else if(r.url.path.endsWith('/christmas_movies'))data=movies;
   else if(r.url.path.endsWith('/movie_votes')){if(r.method=='POST'){voted=true;movies[1]['votes']=1;}if(r.method=='DELETE'){voted=false;movies[1]['votes']=0;}data=voted?[{'movie_id':'b'}]:[];}
   else if(r.url.path.endsWith('/boards')){boardName=jsonDecode(r.body)['name'];data={'name':boardName};}
   else if(r.url.path.endsWith('/content_items'))data={'rating_count':rating==0?0:1,'rating_average':rating};
   else if(r.url.path.endsWith('/idea_ratings')){if(r.method=='POST')rating=jsonDecode(r.body)['rating'];data=rating==0?null:{'rating':rating};}
   return http.Response(jsonEncode(data),200,request:r,headers:{'content-type':'application/json'});
  }));
  await Supabase.instance.client.auth.signInWithPassword(email:'test@example.com',password:'test-password');
 });
 testWidgets('Voting reorders leaderboard and toggling removes vote',(t)async{
  await t.pumpWidget(const MaterialApp(home:ChristmasMoviesPage()));await t.pumpAndSettle();await t.tap(find.byTooltip('Vote for this movie').last);await t.pumpAndSettle();expect(voted,isTrue);expect(t.getTopLeft(find.text('Home Alone')).dy,lessThan(t.getTopLeft(find.text('Elf')).dy));await t.tap(find.byTooltip('Remove my vote'));await t.pumpAndSettle();expect(voted,isFalse);expect(t.takeException(),isNull);
 });
 testWidgets('Board rename trims and saves once',(t)async{
  final board={'id':'board','name':'Old board'};await t.pumpWidget(MaterialApp(home:BoardDetailPage(board:board)));await t.pumpAndSettle();await t.tap(find.byTooltip('Rename board'));await t.pumpAndSettle();await t.enterText(find.byType(TextField),'  Family gifts  ');await t.tap(find.text('Save name'));await t.pumpAndSettle();expect(boardName,'Family gifts');expect(board['name'],'Family gifts');expect(find.text('Family gifts'),findsOneWidget);expect(t.takeException(),isNull);
 });
 testWidgets('Member can rate and revise an idea',(t)async{
  await t.pumpWidget(const MaterialApp(home:Scaffold(body:SingleChildScrollView(child:IdeaCommunitySection(contentId:'idea')))));await t.pumpAndSettle();await t.tap(find.byTooltip('Rate 4 out of 5'));await t.pumpAndSettle();expect(find.text('4.0 / 5 • 1 rating'),findsOneWidget);await t.tap(find.byTooltip('Rate 5 out of 5'));await t.pumpAndSettle();expect(find.text('5.0 / 5 • 1 rating'),findsOneWidget);expect(t.takeException(),isNull);
 });
}
