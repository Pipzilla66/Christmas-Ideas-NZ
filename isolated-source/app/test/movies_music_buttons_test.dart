import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';
import 'package:christmas_ideas_nz_test/festive_decoration.dart';

void main() {
  for (final width in [320.0, 412.0, 1100.0]) {
    for (final scale in [1.0, 1.5]) {
      testWidgets('Both section buttons are visible, high contrast and usable at $width/$scale', (t) async {
        t.view.physicalSize = Size(width, 1000); t.view.devicePixelRatio = 1;
        addTearDown(t.view.resetPhysicalSize); addTearDown(t.view.resetDevicePixelRatio);
        await t.pumpWidget(MaterialApp(
          theme: ThemeData(useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xfff7f2e8),
            appBarTheme: const AppBarTheme(backgroundColor: festiveGreen, foregroundColor: Colors.white),
            // Reproduce the conflicting app defaults that hid the former tabs.
            tabBarTheme: const TabBarThemeData(labelColor: festiveRed, unselectedLabelColor: festiveGreen),
            outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: festiveGreen)),
          ),
          builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)), child: child!),
          home: const MoviesHubPage(),
        ));
        final movies = find.byKey(const ValueKey('movies-tab-button'));
        final music = find.byKey(const ValueKey('music-tab-button'));
        for (final button in [movies, music]) {
          expect(button.hitTestable(), findsOneWidget);
          final rect = t.getRect(button);
          expect(rect.height, greaterThanOrEqualTo(48));
          expect(rect.left, greaterThanOrEqualTo(0)); expect(rect.right, lessThanOrEqualTo(width));
          final style = t.widget<OutlinedButton>(button).style!;
          final foreground = style.foregroundColor!.resolve({})!;
          final background = style.backgroundColor!.resolve({})!;
          expect(foreground, Colors.white);
          expect(style.iconColor!.resolve({}), Colors.white);
          expect(style.side!.resolve({})!.color, festiveGold);
          final contrast = (foreground.computeLuminance() + .05) / (background.computeLuminance() + .05);
          expect(contrast, greaterThanOrEqualTo(4.5));
        }
        expect(t.getTopLeft(movies).dy, t.getTopLeft(music).dy);
        await t.tap(music); await t.pumpAndSettle();
        expect(find.text('The Ultimate Christmas Ideas NZ Playlist'), findsOneWidget);
        expect(movies.hitTestable(), findsOneWidget); expect(music.hitTestable(), findsOneWidget);
        await t.tap(movies); await t.pumpAndSettle();
        expect(find.text('Settle in for a Christmas movie'), findsOneWidget);
        await t.scrollUntilVisible(find.text('Movie voting'), 200, scrollable: find.byType(Scrollable).last);
        await t.pumpAndSettle();
        expect(find.text('Movie voting').hitTestable(), findsOneWidget);
        expect(t.takeException(), isNull);
      });
    }
  }
}
