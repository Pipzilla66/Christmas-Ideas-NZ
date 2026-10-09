import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:christmas_ideas_nz_test/main.dart';

void main() {
  final catalogue = [
    for (var i = 1; i <= 5; i++)
      <String, dynamic>{
        'id': 'light-$i',
        '_table': 'light_displays',
        'name': 'Light display $i',
        'city': 'Christchurch',
        'description': 'Christmas lights for families.',
      },
  ];

  Future<void> openSheet(WidgetTester tester, double height) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(360, height);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: PhillieSupportSheet(initialCatalogue: catalogue)),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('small mobile screen reveals results and can reach the final card', (tester) async {
    await openSheet(tester, 430);
    await tester.tap(find.text('Christmas lights'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Here are 5 ideas').hitTestable(), findsOneWidget);
    final scrolling = find.descendant(
      of: find.byKey(const ValueKey('elf-support-scroll')),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(find.text('Light display 5'), 120, scrollable: scrolling);
    expect(find.text('Light display 5').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Light display 5'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard inset keeps the form scrollable and submission reveals results', (tester) async {
    await openSheet(tester, 640);
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    await tester.pump();
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Christmas lights');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.textContaining('Here are 5 ideas').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
