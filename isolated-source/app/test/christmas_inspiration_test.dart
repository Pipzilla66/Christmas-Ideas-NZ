import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/christmas_inspiration.dart';
void main(){
 test('Every age group has suitable choices and preschool excludes teen crafts',(){
 for(final age in ['Preschool (3–5)','Kids (6–9)','Tweens (10–12)','Teens','Adults']){expect(activitiesForAge(age),isNotEmpty);}
 expect(activitiesForAge('Preschool (3–5)').any((e)=>e.title=='Yarn-wrapped Christmas wreath'),isFalse);
 expect(festiveActivities.every((e)=>e.steps.isNotEmpty&&e.materials.isNotEmpty),isTrue);
 expect(festiveActivities.where((e)=>e.kind=='Craft').every((e)=>craftPhotos.containsKey(e.title)),isTrue);
 });
 testWidgets('Craft page shows instructions and an explicit community empty state',(tester)async{
 await tester.pumpWidget(MaterialApp(home:ChristmasInspirationPage(loader:()async=>[],onIdea:(_){})));
 await tester.pumpAndSettle();
 await tester.ensureVisible(find.text('Little handprint Christmas cards'));await tester.pumpAndSettle();await tester.tap(find.text('Little handprint Christmas cards'));await tester.pumpAndSettle();
 expect(find.text('1. Cover the table and fold a card in half.'),findsOneWidget);expect(find.byType(Image),findsWidgets);expect(tester.takeException(),isNull);
 });
 testWidgets('Traditions distinguish starter ideas from family submissions',(tester)async{
 await tester.pumpWidget(MaterialApp(home:ChristmasInspirationPage(traditions:true,loader:()async=>[],onIdea:(_){})));
 await tester.pumpAndSettle();expect(find.text('Share our family tradition'),findsOneWidget);expect(find.textContaining('not stories submitted by individual families'),findsOneWidget);expect(find.text('The same photo, every Christmas'),findsOneWidget);expect(tester.takeException(),isNull);
 });
}
