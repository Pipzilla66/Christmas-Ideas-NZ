import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChristmasSong {
  final String title, artist, category;
  const ChristmasSong(this.title, this.artist, this.category);
  Uri get spotifySearch => Uri.https('open.spotify.com', '/search/$title $artist');
}

// Editorial song recommendations only: no lyrics, recordings or cover art are hosted.
const christmasSongs = <ChristmasSong>[
  ChristmasSong('All I Want for Christmas Is You', 'Mariah Carey', 'Pop favourites'),
  ChristmasSong('Last Christmas', 'Wham!', 'Pop favourites'),
  ChristmasSong('Rockin’ Around the Christmas Tree', 'Brenda Lee', 'Classics'),
  ChristmasSong('Jingle Bell Rock', 'Bobby Helms', 'Classics'),
  ChristmasSong('It’s Beginning to Look a Lot Like Christmas', 'Michael Bublé', 'Pop favourites'),
  ChristmasSong('Santa Tell Me', 'Ariana Grande', 'Pop favourites'),
  ChristmasSong('Underneath the Tree', 'Kelly Clarkson', 'Pop favourites'),
  ChristmasSong('Merry Christmas', 'Ed Sheeran & Elton John', 'Pop favourites'),
  ChristmasSong('Wonderful Christmastime', 'Paul McCartney', 'Pop favourites'),
  ChristmasSong('Merry Xmas Everybody', 'Slade', 'Pop favourites'),
  ChristmasSong('Driving Home for Christmas', 'Chris Rea', 'Pop favourites'),
  ChristmasSong('Feliz Navidad', 'José Feliciano', 'Classics'),
  ChristmasSong('Snoopy’s Christmas', 'The Royal Guardsmen', 'Classics'),
  ChristmasSong('Mary’s Boy Child / Oh My Lord', 'Boney M.', 'Classics'),
  ChristmasSong('White Christmas', 'Bing Crosby', 'Classics'),
  ChristmasSong('The Christmas Song', 'Nat King Cole', 'Classics'),
  ChristmasSong('Have Yourself a Merry Little Christmas', 'Judy Garland', 'Classics'),
  ChristmasSong('Let It Snow! Let It Snow! Let It Snow!', 'Dean Martin', 'Classics'),
  ChristmasSong('Sleigh Ride', 'The Ronettes', 'Classics'),
  ChristmasSong('Christmas (Baby Please Come Home)', 'Darlene Love', 'Classics'),
  ChristmasSong('It’s the Most Wonderful Time of the Year', 'Andy Williams', 'Classics'),
  ChristmasSong('Little Saint Nick', 'The Beach Boys', 'Classics'),
  ChristmasSong('O Holy Night', 'Céline Dion', 'Carols'),
  ChristmasSong('Silent Night', 'Bing Crosby', 'Carols'),
  ChristmasSong('Hark! The Herald Angels Sing', 'The King’s Singers', 'Carols'),
  ChristmasSong('O Come, All Ye Faithful', 'Nat King Cole', 'Carols'),
  ChristmasSong('Pukeko in a Ponga Tree', 'Carmel Carroll', 'Kiwi Christmas'),
  ChristmasSong('Sticky Beak the Kiwi', 'Julie Nelson', 'Kiwi Christmas'),
  ChristmasSong('Aotearoa Christmas', 'The Polkadots', 'Kiwi Christmas'),
  ChristmasSong('Meri Kirihimete', 'Erny Belle', 'Kiwi Christmas'),
];

List<ChristmasSong> filterChristmasSongs(String query, String category) {
  final q = query.trim().toLowerCase();
  return christmasSongs.where((song) =>
    (category == 'All songs' || song.category == category) &&
    (q.isEmpty || '${song.title} ${song.artist}'.toLowerCase().contains(q))).toList();
}

class ChristmasMusicPage extends StatefulWidget {
  final Future<bool> Function(Uri)? openLink;
  const ChristmasMusicPage({super.key, this.openLink});
  @override State<ChristmasMusicPage> createState() => _ChristmasMusicPageState();
}
class _ChristmasMusicPageState extends State<ChristmasMusicPage> {
  final search = TextEditingController();
  String category = 'All songs';
  @override void dispose() { search.dispose(); super.dispose(); }
  Future<void> listen(ChristmasSong song) async {
    try {
      final opened = await (widget.openLink?.call(song.spotifySearch) ??
        launchUrl(song.spotifySearch, mode: LaunchMode.externalApplication));
      if (!opened && mounted) showLinkError();
    } catch (_) { if (mounted) showLinkError(); }
  }
  void showLinkError() => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Spotify could not open. Please try again, or search for the song in your music app.')));
  @override Widget build(BuildContext context) {
    final songs = filterChristmasSongs(search.text, category);
    return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720),
      child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('The Ultimate Christmas Ideas NZ Playlist', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        const Text('A festive mix for decorating the tree, wrapping presents and getting into the Christmas spirit.'),
        const SizedBox(height: 10),
        const Text('Tap a song to find it on Spotify, then choose a recording to play or add to your own playlist.', style: TextStyle(fontSize: 13)),
        const SizedBox(height: 16),
        TextField(controller: search, onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: 'Search songs or artists', prefixIcon: const Icon(Icons.search),
            suffixIcon: search.text.isEmpty ? null : IconButton(tooltip: 'Clear search', icon: const Icon(Icons.close), onPressed: () => setState(() => search.clear())))),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in ['All songs', 'Classics', 'Pop favourites', 'Carols', 'Kiwi Christmas'])
            ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)),
        ]),
        const SizedBox(height: 16),
        Text('${songs.length} ${songs.length == 1 ? 'song' : 'songs'}', style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (songs.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No songs match. Try another title, artist or category.')),
        for (final song in songs) Card(child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: const Icon(Icons.music_note_outlined, color: Color(0xFF0F4C45)),
          title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${song.artist}\nFind on Spotify ↗'), isThreeLine: true,
          trailing: const Icon(Icons.open_in_new, size: 20),
          onTap: () => listen(song),
        )),
        const SizedBox(height: 16),
        const Text('Music opens outside Christmas Ideas NZ. Spotify access, playback and availability depend on your account and region. No audio plays automatically.', style: TextStyle(fontSize: 12)),
      ]),
    ));
  }
}
