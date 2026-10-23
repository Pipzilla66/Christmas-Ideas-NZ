import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/christmas_inspiration.dart';
import 'package:christmas_ideas_nz_test/app_viewport.dart';
void main(){
 test('All twelve original entries remain distinct with original photo coverage',(){
 expect(festiveActivities.length,12);
 expect(festiveActivities.map((e)=>e.title).toSet().length,12);
 expect(craftPhotos.length,8);
 });
 for(final width in [320.0,412.0,1100.0]){
 testWidgets('Every built-in opens complete detail and restores list at width $width',(tester)async{
 tester.view.physicalSize=Size(width,900);tester.view.devicePixelRatio=1;
 addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
 await tester.pumpWidget(MaterialApp(home:ChristmasInspirationPage(loader:()async=>[],onIdea:(_){})));
 await tester.pumpAndSettle();
 for(final activity in festiveActivities){
 final title=find.text(activity.title);
 await tester.ensureVisible(title);await tester.pumpAndSettle();
 final list=tester.widget<ListView>(find.byKey(const PageStorageKey('craft-activity-list')));
 final before=list.controller!.offset;
 await tester.tap(title);await tester.pumpAndSettle();
 expect(find.byType(BuiltInActivityDetailPage),findsOneWidget);
 expect(find.text(activity.materials),findsOneWidget);
 for(var i=0;i<activity.steps.length;i++){final step=find.text('${i+1}. ${activity.steps[i]}');await tester.scrollUntilVisible(step,180,scrollable:find.byType(Scrollable).last);await tester.pumpAndSettle();expect(step,findsOneWidget);}
 await tester.scrollUntilVisible(find.text('Share Your Own Idea'),180,scrollable:find.byType(Scrollable).last);await tester.pumpAndSettle();
 expect(find.text('Share Your Own Idea'),findsOneWidget);
 final bar=tester.widget<AppBar>(find.byType(AppBar).last);expect(bar.foregroundColor,const Color(0xFF0F4C45));
 expect(tester.takeException(),isNull);
 await tester.pageBack();await tester.pumpAndSettle();
 expect(list.controller!.offset,closeTo(before,0.1));
 }
 });
 }
 testWidgets('Detail uses existing submission callback without inventing ratings',(tester)async{
 var shared=false;
 await tester.pumpWidget(MaterialApp(home:BuiltInActivityDetailPage(activity:festiveActivities[2],onShare:(_)=>shared=true)));
 await tester.pumpAndSettle();
 await tester.ensureVisible(find.text('Share Your Own Idea'));await tester.pumpAndSettle();
 await tester.tap(find.text('Share Your Own Idea'));await tester.pump();expect(shared,isTrue);
 expect(find.byIcon(Icons.star),findsNothing);
 });
 testWidgets('Standalone phone layout preserves safe areas, detail navigation and Back',(tester)async{
 tester.view.physicalSize=const Size(980,1900);tester.view.devicePixelRatio=1;
 tester.view.padding=const FakeViewPadding(top:60,bottom:30);
 addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);addTearDown(tester.view.resetPadding);
 await tester.pumpWidget(MaterialApp(builder:(context,child)=>AppViewport(phoneWidth:412,child:child!),home:ChristmasInspirationPage(loader:()async=>[],onIdea:(_){})));
 await tester.pumpAndSettle();await tester.ensureVisible(find.text(festiveActivities.first.title));await tester.pumpAndSettle();
 await tester.tap(find.text(festiveActivities.first.title));await tester.pumpAndSettle();
 expect(find.byType(BuiltInActivityDetailPage),findsOneWidget);
 await tester.pageBack();await tester.pumpAndSettle();expect(find.byType(BuiltInActivityDetailPage),findsNothing);expect(tester.takeException(),isNull);
 });

}
