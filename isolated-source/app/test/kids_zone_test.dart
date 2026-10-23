import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';
import 'package:christmas_ideas_nz_test/kids_colouring.dart';
import 'package:christmas_ideas_nz_test/santa_mailbox.dart';

Future<void> press(WidgetTester t,String label) async {
 final f=find.text(label);
 await t.scrollUntilVisible(f,150,scrollable:find.byType(Scrollable).first);
 await t.ensureVisible(f);await t.pumpAndSettle();await t.tap(f);await t.pumpAndSettle();
}
Future<void> write(WidgetTester t,String name,String note) async {
 await t.enterText(find.byType(TextField).first,name);
 await t.enterText(find.byType(TextField).last,note);
}
Future<void> restart(WidgetTester t,Widget page) async {
 await t.pumpWidget(const SizedBox());await t.pumpWidget(MaterialApp(home:page));await t.pumpAndSettle();
}
void main(){
 testWidgets('Separate children, copies and edits survive reopening without overwriting siblings',(t)async{
  SharedPreferences.setMockInitialValues({});await restart(t,const SantaLetterPage());
  await press(t,'Save my letter');expect(find.text('Write a little note to Santa first.'),findsOneWidget);
  await write(t,'Macey','I wish for a book.');await press(t,'Save my letter');
  await press(t,'Save a separate copy');
  await press(t,'New letter for another child');
  await write(t,'Ronan','I wish for a train.');await press(t,'Save my letter');
  final prefs=await SharedPreferences.getInstance();
  var data=(jsonDecode(prefs.getString(santaMailboxKey)!) as List);
  expect(data.length,3);expect(data.where((e)=>e['name']=='Macey').length,2);expect(data.map((e)=>e['id']).toSet().length,3);
  await restart(t,const SantaLetterPage());expect(find.text('Saved letters (3)'),findsOneWidget);
  await t.tap(find.text('Ronan’s letter'));await t.pumpAndSettle();expect(find.byType(TextField).evaluate().map((e)=>(e.widget as TextField).controller!.text),['Ronan','I wish for a train.']);
  await t.enterText(find.byType(TextField).last,'A train and a happy Christmas.');await press(t,'Save changes');
  data=jsonDecode(prefs.getString(santaMailboxKey)!) as List;
  expect(data.length,3);expect(data.where((e)=>e['name']=='Macey').every((e)=>e['letter']=='I wish for a book.'),isTrue);
  await restart(t,const SantaLetterPage());await t.tap(find.text('Ronan’s letter'));await t.pumpAndSettle();expect(find.text('A train and a happy Christmas.'),findsOneWidget);
  expect(t.takeException(),isNull);
 });
 testWidgets('Existing single letter migrates into mailbox; deleting it needs confirmation',(t)async{
  SharedPreferences.setMockInitialValues({'family_santa_letter':jsonEncode({'name':'Pip','letter':'Merry Christmas!'})});await restart(t,const SantaLetterPage());
  final prefs=await SharedPreferences.getInstance();expect(prefs.getString('family_santa_letter'),isNull);expect(find.text('Pip’s letter'),findsOneWidget);
  await t.tap(find.byTooltip('Delete saved letter'));await t.pumpAndSettle();await t.tap(find.text('Cancel'));await t.pumpAndSettle();expect((jsonDecode(prefs.getString(santaMailboxKey)!) as List).length,1);
  await t.tap(find.byTooltip('Delete saved letter'));await t.pumpAndSettle();await t.tap(find.text('Delete'));await t.pumpAndSettle();expect((jsonDecode(prefs.getString(santaMailboxKey)!) as List),isEmpty);
 });
 testWidgets('New letter keeps unsaved draft unless discard is confirmed',(t)async{
  SharedPreferences.setMockInitialValues({});await restart(t,const SantaLetterPage());await write(t,'Ronan','Keep this draft.');await press(t,'New letter for another child');
  await t.tap(find.text('Keep writing'));await t.pumpAndSettle();expect(find.text('Keep this draft.'),findsOneWidget);
 });
 for(final width in [320.0,1100.0]){
  testWidgets('Santa stays square and bounded at $width',(t)async{
   t.view.physicalSize=Size(width,800);t.view.devicePixelRatio=1;addTearDown(t.view.resetPhysicalSize);addTearDown(t.view.resetDevicePixelRatio);
   await t.pumpWidget(const MaterialApp(home:KidsSantaPage()));await t.pumpAndSettle();
   final painted=find.descendant(of:find.byType(SantaPicture),matching:find.byType(CustomPaint));expect(t.getSize(painted),const Size(180,180));expect(t.takeException(),isNull);
   await press(t,'Santa');expect(find.text('Colour Santa'),findsOneWidget);expect(t.takeException(),isNull);
  });
  testWidgets('Colour by tapping, undo and save persist on phone/desktop $width',(t)async{
   SharedPreferences.setMockInitialValues({});t.view.physicalSize=Size(width,900);t.view.devicePixelRatio=1;addTearDown(t.view.resetPhysicalSize);addTearDown(t.view.resetDevicePixelRatio);
   await restart(t,const KidsColouringPage(picture:'Christmas tree'));
   await t.tap(find.byKey(const ValueKey('colour-Green')));await t.pumpAndSettle();
   final canvas=find.byKey(const ValueKey('colour-canvas'));await t.ensureVisible(canvas);await t.pumpAndSettle();
   final size=t.getSize(canvas),origin=t.getTopLeft(canvas);
   // Tree interior away from ornaments and outlines.
   await t.tapAt(origin+Offset(size.width*.5,size.height*200/660));await t.pumpAndSettle();
   await press(t,'Save picture');final prefs=await SharedPreferences.getInstance();var values=(jsonDecode(prefs.getString('kids_colouring_v1_Christmas tree')!) as List);expect(values,contains(0xFF32834A));
   await press(t,'Undo');await press(t,'Save picture');values=jsonDecode(prefs.getString('kids_colouring_v1_Christmas tree')!) as List;expect(values.every((v)=>v==0xFFFFFFFF),isTrue);
   await restart(t,const KidsColouringPage(picture:'Christmas tree'));expect(t.takeException(),isNull);
  });
 }
 testWidgets('Saved colours reopen and unsaved Back offers keep or discard',(t)async{
  final regions=colouringRegions('Santa');final values=List.filled(regions.length,0xFFFFFFFF);values[0]=0xFF3476D1;
  SharedPreferences.setMockInitialValues({'kids_colouring_v1_Santa':jsonEncode(values)});
  await restart(t,const KidsSantaPage());await press(t,'Santa');
  final painted=find.byWidgetPredicate((w)=>w is CustomPaint&&w.painter is ColouringPainter);
  expect((t.widget<CustomPaint>(painted).painter as ColouringPainter).colours[0],0xFF3476D1);
  final canvas=find.byKey(const ValueKey('colour-canvas'));await t.ensureVisible(canvas);await t.pumpAndSettle();
  final size=t.getSize(canvas),origin=t.getTopLeft(canvas);await t.tapAt(origin+Offset(size.width*.5,size.height*550/660));await t.pumpAndSettle();
  await t.tap(find.byTooltip('Back'));await t.pumpAndSettle();expect(find.text('Leave your unsaved picture?'),findsOneWidget);
  await t.tap(find.text('Keep colouring'));await t.pumpAndSettle();expect(find.text('Colour Santa'),findsOneWidget);
  await t.tap(find.byTooltip('Back'));await t.pumpAndSettle();await t.tap(find.text('Leave without saving'));await t.pumpAndSettle();expect(find.text('Kids Zone'),findsOneWidget);expect(t.takeException(),isNull);
 });
 testWidgets('Gingerbread house opens from Kids Zone and saves colours separately',(t)async{
  SharedPreferences.setMockInitialValues({});await restart(t,const KidsSantaPage());await press(t,'Gingerbread house');expect(find.text('Colour Gingerbread house'),findsOneWidget);
  final canvas=find.byKey(const ValueKey('colour-canvas'));await t.ensureVisible(canvas);await t.pumpAndSettle();
  final size=t.getSize(canvas),origin=t.getTopLeft(canvas);await t.tapAt(origin+Offset(size.width*300/600,size.height*360/660));await t.pumpAndSettle();await press(t,'Save picture');
  final prefs=await SharedPreferences.getInstance();final colours=jsonDecode(prefs.getString('kids_colouring_v1_Gingerbread house')!) as List;expect(colours,contains(0xFFE63946));expect(prefs.getString('kids_colouring_v1_Santa'),isNull);
  expect(t.takeException(),isNull);
 });
 test('All five colouring pictures have closed fillable shapes',(){for(final name in ['Santa','Christmas tree','Snowman','Reindeer','Gingerbread house']){final shapes=colouringRegions(name);expect(shapes.where((r)=>r.fillable).length,greaterThan(5));expect(shapes.every((r)=>r.path.getBounds().left>=0&&r.path.getBounds().right<=600&&r.path.getBounds().top>=0&&r.path.getBounds().bottom<=660),isTrue);}});
}
