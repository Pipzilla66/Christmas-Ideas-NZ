import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';
void main(){
 test('Movie ranking uses votes then title without modifying input',(){final input=[{'title':'Z','votes':2},{'title':'B','votes':9},{'title':'A','votes':9}];expect(rankedMovies(input).map((m)=>m['title']),['A','B','Z']);expect(input.first['title'],'Z');});
 test('Calendar excludes future picks; NZ midnight and winter time',(){expect(nzCalendarToday(DateTime.utc(2026,10,10,12)),DateTime(2026,10,11));expect(nzCalendarToday(DateTime.utc(2026,6,10,11,30)),DateTime(2026,6,10));expect(nzCalendarToday(DateTime.utc(2026,4,5,11,30)),DateTime(2026,4,5));expect(pastCalendarIdeas([{'idea_of_day_date':'2026-10-09'},{'idea_of_day_date':'2026-10-11'},{'idea_of_day_date':null}],DateTime(2026,10,10)).length,1);});
 testWidgets('Game finds pairs and resets',(t)async{
  await t.pumpWidget(const MaterialApp(home:ChristmasMatchGame(initialCards:['🎅','🎅','🎄','🎄','⭐','⭐'])));
  for(var i=0;i<6;i++){await t.tap(find.byKey(ValueKey('match-$i')));await t.pump();}
  expect(find.text('You found every pair! 🎉'),findsOneWidget);await t.scrollUntilVisible(find.text('Play again'),200,scrollable:find.byType(Scrollable).first);await t.tap(find.text('Play again'));await t.pump();t.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);await t.pumpAndSettle();expect(find.text('0 / 3 pairs • 0 turns'),findsOneWidget);expect(t.takeException(),isNull);
 });
 testWidgets('Calendar opens past ideas and hides future picks',(t)async{
  Map<String,dynamic>? opened;final date=nzCalendarToday().toIso8601String().substring(0,10);await t.pumpWidget(MaterialApp(home:IdeaCalendarPage(initialIdeas:[{'id':'past','title':'Today’s idea','idea_of_day_date':date},{'id':'future','title':'Future pick','idea_of_day_date':'2099-01-01'}],onIdea:(idea)=>opened=idea)));await t.pumpAndSettle();await t.scrollUntilVisible(find.text('Today’s idea'),200,scrollable:find.byType(Scrollable).first);await t.tap(find.text('Today’s idea'));expect(opened?['id'],'past');expect(find.text('Future pick'),findsNothing);expect(t.takeException(),isNull);
 });
 for(final width in [320.0,1100.0])testWidgets('Kids section opens game at $width',(t)async{t.view.physicalSize=Size(width,700);t.view.devicePixelRatio=1;addTearDown(t.view.resetPhysicalSize);addTearDown(t.view.resetDevicePixelRatio);await t.pumpWidget(const MaterialApp(home:KidsSantaPage()));await t.scrollUntilVisible(find.text('Christmas matching game'),200,scrollable:find.byType(Scrollable).first);await t.tap(find.text('Christmas matching game'));await t.pumpAndSettle();expect(find.text('Christmas matching'),findsOneWidget);expect(t.takeException(),isNull);});
}
