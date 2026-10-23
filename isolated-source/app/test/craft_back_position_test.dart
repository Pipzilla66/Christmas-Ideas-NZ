import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/christmas_inspiration.dart';
void main(){
 testWidgets('Back restores selection position after a background focus scroll',(tester)async{
 tester.view.physicalSize=const Size(390,800);tester.view.devicePixelRatio=1;
 addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
 await tester.pumpWidget(MaterialApp(home:ChristmasInspirationPage(loader:()async=>[],onIdea:(_){})));await tester.pumpAndSettle();
 final target=find.text('Christmas colour hunt');
 await tester.scrollUntilVisible(target,200,scrollable:find.byType(Scrollable).first);await tester.pumpAndSettle();
 final list=tester.widget<ListView>(find.byKey(const PageStorageKey('craft-activity-list')));final controller=list.controller!;final selected=controller.offset;
 await tester.tap(target);await tester.pumpAndSettle();
 expect(find.byType(BuiltInActivityDetailPage),findsOneWidget);
 // Focus/visibility updates can move a retained background list on Flutter Web.
 controller.jumpTo((selected+150).clamp(0,controller.position.maxScrollExtent));await tester.pumpAndSettle();
 expect(controller.offset,isNot(closeTo(selected,0.1)));
 await tester.pageBack();await tester.pumpAndSettle();
 expect(controller.offset,closeTo(selected,0.1));expect(tester.takeException(),isNull);
 });
}
