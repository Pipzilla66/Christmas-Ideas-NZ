import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/hallmark_checklist.dart';
void main(){testWidgets('Checklist persists ticks and contains no voting controls',(tester)async{
 final saved=<String>[];
 await tester.pumpWidget(MaterialApp(home:HallmarkChecklistPage(loader:()async=>[{'id':'1','title':'Christmas Under Wraps'}],watchedLoader:()async=>{},saver:(id,selected)async{saved.add('$id:$selected');})));
 await tester.pumpAndSettle();expect(find.byIcon(Icons.favorite_border),findsNothing);expect(find.text('1 / 1 watched'),findsNothing);
 await tester.scrollUntilVisible(find.byType(Checkbox),200,scrollable:find.byType(Scrollable).first);await tester.pumpAndSettle();await tester.tap(find.byType(Checkbox));await tester.pumpAndSettle();expect(saved,['1:true']);expect(find.text('1 / 1 watched'),findsOneWidget);
 });
 testWidgets('All films and Hallmark filter share the same watched records',(tester)async{
  tester.view.physicalSize=const Size(900,1600);tester.view.devicePixelRatio=1;
  addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(home:HallmarkChecklistPage(loader:()async=>[
   {'id':'1','title':'Christmas Under Wraps','cosy':true},
   {'id':'2','title':'Fatman','cosy':false}],watchedLoader:()async=>{'2'})));
  await tester.pumpAndSettle();
  expect(find.text('Fatman'),findsOneWidget);expect(find.text('1 / 2 watched'),findsOneWidget);
  await tester.tap(find.text('Hallmark'));await tester.pumpAndSettle();
  expect(find.text('Fatman'),findsNothing);expect(find.text('Christmas Under Wraps'),findsOneWidget);
  await tester.tap(find.text('All Christmas movies'));await tester.pumpAndSettle();
  expect(find.text('Fatman'),findsOneWidget);
  expect(tester.widget<CheckboxListTile>(find.widgetWithText(CheckboxListTile,'Fatman')).value,isTrue);
 });}
