import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/password_entry.dart';
void main(){testWidgets('Passwords start hidden and toggle independently without changing text',(tester)async{
 final password=TextEditingController(text:'example123'),confirm=TextEditingController(text:'example123');addTearDown(password.dispose);addTearDown(confirm.dispose);
 await tester.pumpWidget(MaterialApp(home:Scaffold(body:Column(children:[PasswordEntry(controller:password),PasswordEntry(controller:confirm,label:'Confirm password')]))));
 expect(tester.widget<TextField>(find.byType(TextField).first).obscureText,isTrue);
 await tester.tap(find.byTooltip('Show password'));await tester.pump();
 expect(tester.widget<TextField>(find.byType(TextField).first).obscureText,isFalse);expect(tester.widget<TextField>(find.byType(TextField).last).obscureText,isTrue);expect(password.text,'example123');
 await tester.tap(find.byTooltip('Hide password'));await tester.pump();expect(tester.widget<TextField>(find.byType(TextField).first).obscureText,isTrue);
 await tester.tap(find.byTooltip('Show confirm password'));await tester.pump();expect(tester.widget<TextField>(find.byType(TextField).last).obscureText,isFalse);
 });}
