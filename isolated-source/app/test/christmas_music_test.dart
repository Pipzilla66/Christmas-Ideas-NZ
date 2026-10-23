import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/christmas_music.dart';
import 'package:christmas_ideas_nz_test/community_features.dart';

void main() {
  test('Song categories, search and Spotify URLs are complete', () {
    expect(christmasSongs.length, 30);
    expect(christmasSongs.map((s) => '${s.title}|${s.artist}').toSet().length, 30);
    expect(filterChristmasSongs('mariah', 'All songs').single.artist, 'Mariah Carey');
    expect(filterChristmasSongs('mariah', 'Carols'), isEmpty);
    expect(filterChristmasSongs('', 'Kiwi Christmas').length, 4);
    for (final song in christmasSongs) {
      expect(song.spotifySearch.scheme, 'https');
      expect(song.spotifySearch.host, 'open.spotify.com');
      expect(Uri.decodeComponent(song.spotifySearch.path), '/search/${song.title} ${song.artist}');
    }
  });
  for (final width in [320.0, 412.0, 1100.0]) {
    testWidgets('Music filters and links fit at $width with large text', (t) async {
      t.view.physicalSize = Size(width, 1000); t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize); addTearDown(t.view.resetDevicePixelRatio);
      Uri? opened;
      await t.pumpWidget(MaterialApp(builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(textScaler: const TextScaler.linear(1.3)), child: child!),
        home: Scaffold(body: ChristmasMusicPage(openLink: (uri) async { opened = uri; return true; }))));
      expect(t.takeException(), isNull);
      final kiwi = find.widgetWithText(ChoiceChip, 'Kiwi Christmas');
      await t.ensureVisible(kiwi); await t.pumpAndSettle(); await t.tap(kiwi); await t.pumpAndSettle();
      expect(find.text('4 songs'), findsOneWidget);
      final pukeko = find.text('Pukeko in a Ponga Tree');
      await t.ensureVisible(pukeko); await t.pumpAndSettle(); await t.tap(pukeko); await t.pumpAndSettle();
      expect(opened?.host, 'open.spotify.com');
      expect(Uri.decodeComponent(opened!.path), contains('Carmel Carroll'));
      final search = find.byType(TextField);
      await t.scrollUntilVisible(search, -250, scrollable: find.byType(Scrollable).first); await t.pumpAndSettle(); await t.enterText(search, 'no matching song'); await t.pump();
      expect(find.text('0 songs'), findsOneWidget);
      await t.tap(find.byTooltip('Clear search')); await t.pump();
      expect(find.text('4 songs'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  }
  testWidgets('A failed Spotify open is recoverable', (t) async {
    await t.pumpWidget(MaterialApp(home: Scaffold(body: ChristmasMusicPage(openLink: (_) async => false))));
    final song = find.text(christmasSongs.first.title);
    await t.ensureVisible(song); await t.pumpAndSettle(); await t.tap(song); await t.pumpAndSettle();
    expect(find.textContaining('Spotify could not open'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('Movies and Music tabs retain the movie tools', (t) async {
    await t.pumpWidget(const MaterialApp(home: MoviesHubPage()));
    expect(find.text('Movie voting'), findsOneWidget);
    await t.tap(find.text('Music')); await t.pumpAndSettle();
    expect(find.text('The Ultimate Christmas Ideas NZ Playlist'), findsOneWidget);
    await t.tap(find.text('Movies')); await t.pumpAndSettle();
    expect(find.text('Movie voting'), findsOneWidget);
    expect(find.text('Hallmark & Christmas checklist'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
