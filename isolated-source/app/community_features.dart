import 'secret_santa.dart';
import 'christmas_music.dart';
import 'festive_decoration.dart';
import 'calendar_time.dart';
export 'calendar_time.dart' show nzCalendarToday;
import 'dart:convert';
import 'dart:math';
import 'christmas_inspiration.dart';
import 'hallmark_checklist.dart';
import 'home_navigation.dart';
import 'santa_outline_icon.dart';
import 'kids_colouring.dart';
import 'catch_presents.dart';
import 'santa_mailbox.dart';
import 'santa_journey.dart';
export 'santa_mailbox.dart' show SantaLetterPage;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

SupabaseClient get communityDb => Supabase.instance.client;
void communityMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
Future<bool> communityAdmin() async {
  final user = communityDb.auth.currentUser;
  if (user == null) return false;
  final p = await communityDb
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .maybeSingle();
  return ['admin', 'editor'].contains(p?['role']);
}

String communityName() {
  final raw =
      (communityDb.auth.currentUser?.userMetadata?['display_name'] ?? 'Member')
          .toString()
          .trim();
  return raw.isEmpty
      ? 'Member'
      : raw
            .split(RegExp(r'\s+'))
            .first
            .substring(0, min(60, raw.split(RegExp(r'\s+')).first.length));
}

class CommunityLinks extends StatelessWidget {
  final void Function(Map<String, dynamic>) onIdea;
  final WidgetBuilder? secretSantaBuilder;
  const CommunityLinks({super.key, required this.onIdea, this.secretSantaBuilder});
  static List<ExploreShortcut> shortcuts(BuildContext context,
      void Function(Map<String,dynamic>) onIdea, {WidgetBuilder? secretSantaBuilder}) => [
    ExploreShortcut('Secret Santa', const Icon(Icons.card_giftcard_outlined, size: 22), () => Navigator.push(context, MaterialPageRoute(builder: secretSantaBuilder ?? (_) => const SecretSantaPage()))),
    ExploreShortcut('Kids Zone', const SantaOutlineIcon(), () => Navigator.push(context,
      MaterialPageRoute(builder: (_) => const KidsSantaPage()))),
    ExploreShortcut('Movies & Music', const Icon(Icons.movie_outlined, size: 22), () => Navigator.push(context,
      MaterialPageRoute(builder: (_) => const MoviesHubPage()))),
    ExploreShortcut('Activities & Traditions', const Icon(Icons.palette_outlined, size: 22), () => Navigator.push(context,
      MaterialPageRoute(builder: (_) => ActivitiesTraditionsPage(onIdea: onIdea)))),
    ExploreShortcut('Idea Calendar', const Icon(Icons.calendar_month, size: 22), () => Navigator.push(context,
      MaterialPageRoute(builder: (_) => IdeaCalendarPage(onIdea: onIdea)))),
  ];
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    child: ExploreShortcutGrid(shortcuts: shortcuts(context, onIdea, secretSantaBuilder: secretSantaBuilder)),
  );
}

class ActivitiesTraditionsPage extends StatelessWidget {
  final void Function(Map<String, dynamic>) onIdea;
  const ActivitiesTraditionsPage({super.key, required this.onIdea});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Activities & Traditions')),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Make Christmas memories', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Find something to make, a game to play or a tradition to enjoy together.'),
        const SizedBox(height: 24),
        Card(child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(Icons.palette_outlined, color: Color(0xFF0F4C45), size: 32),
          title: const Text('Crafts & activities', style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: const Text('Christmas crafts, games and activities for every age.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ChristmasInspirationPage(onIdea: onIdea))),
        )),
        const SizedBox(height: 12),
        Card(child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(Icons.favorite_outline, color: Color(0xFF0F4C45), size: 32),
          title: const Text('Family traditions', style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: const Text('Little rituals and meaningful ways to celebrate together.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ChristmasInspirationPage(traditions: true, onIdea: onIdea))),
        )),
      ]),
    )),
  );
}

/// Match the existing Explore buttons; both destinations stay visible on green.
class MoviesMusicSwitcher extends StatelessWidget implements PreferredSizeWidget {
  const MoviesMusicSwitcher({super.key});
  @override Size get preferredSize => const Size.fromHeight(68);
  @override Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    return AnimatedBuilder(animation: controller, builder: (context, _) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SizedBox(height: 56, child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: Semantics(selected: controller.index == i,
            child: OutlinedButton.icon(
              key: ValueKey(i == 0 ? 'movies-tab-button' : 'music-tab-button'),
              onPressed: () => controller.animateTo(i),
              icon: Icon(i == 0 ? Icons.movie_outlined : Icons.music_note_outlined, size: 22),
              label: Text(i == 0 ? 'Movies' : 'Music', maxLines: 1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white, iconColor: Colors.white,
                backgroundColor: i == 0 ? festiveRed : festiveGreen,
                side: BorderSide(color: festiveGold, width: controller.index == i ? 2 : 1),
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )),
        ],
      ])),
    ));
  }
}

class MoviesHubPage extends StatelessWidget {
  const MoviesHubPage({super.key});

  Widget movieChoice(BuildContext context, IconData icon, String title,
      String description, WidgetBuilder page) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: Icon(icon, color: const Color(0xFF0F4C45), size: 32),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 8), child: Text(description)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: page)),
    ),
  );

  @override
  Widget build(BuildContext context) => DefaultTabController(length: 2, child: Scaffold(
    appBar: AppBar(title: const Text('Movies & Music'), bottom: const MoviesMusicSwitcher()),
    body: TabBarView(children: [Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Settle in for a Christmas movie', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Keep your own watchlist or help choose the community’s favourites.'),
        const SizedBox(height: 24),
        movieChoice(context, Icons.checklist, 'Hallmark & Christmas checklist',
          'Tick off Hallmark favourites and other Christmas movies as you watch. Your checklist is personal.',
          (_) => const HallmarkChecklistPage()),
        movieChoice(context, Icons.movie_outlined, 'Movie voting',
          'Vote for your favourite Christmas films and suggest one to add.',
          (_) => const ChristmasMoviesPage()),
      ]),
    )), const ChristmasMusicPage()]),
  ));
}

/// Original Santa illustration, painted locally rather than loading a stock image.
class SantaPicture extends StatelessWidget {
  const SantaPicture({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Santa smiling in his red hat',
    image: true,
    child: Center(
      child: SizedBox.square(
        dimension: 180,
        child: CustomPaint(painter: _SantaPainter()),
      ),
    ),
  );
}

class _SantaPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size size) {
    final scale = min(size.width, size.height) / 160;
    c.translate((size.width - 160 * scale) / 2, (size.height - 160 * scale) / 2);
    c.scale(scale);
    c.translate(5, 0);
    final p = Paint();
    c.drawCircle(const Offset(75, 75), 73, p..color = const Color(0xFFE7EFE8));
    c.drawOval(
      const Rect.fromLTWH(25, 93, 100, 65),
      p..color = const Color(0xFFA51232),
    );
    c.drawOval(
      const Rect.fromLTWH(36, 53, 78, 79),
      p..color = const Color(0xFFFFFCF6),
    );
    c.drawOval(
      const Rect.fromLTWH(45, 44, 60, 57),
      p..color = const Color(0xFFF3C7A7),
    );
    final hat = Path()
      ..moveTo(36, 56)
      ..quadraticBezierTo(45, 2, 99, 18)
      ..quadraticBezierTo(126, 22, 122, 48)
      ..lineTo(100, 33)
      ..lineTo(113, 56)
      ..close();
    c.drawPath(hat, p..color = const Color(0xFFA51232));
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(34, 49, 82, 15),
        const Radius.circular(8),
      ),
      p..color = Colors.white,
    );
    c.drawCircle(const Offset(122, 46), 12, p);
    c.drawCircle(const Offset(61, 76), 3, p..color = const Color(0xFF253F37));
    c.drawCircle(const Offset(89, 76), 3, p);
    c.drawOval(
      const Rect.fromLTWH(63, 82, 24, 13),
      p..color = const Color(0xFFE9AC91),
    );
    c.drawOval(const Rect.fromLTWH(48, 94, 28, 13), p..color = Colors.white);
    c.drawOval(const Rect.fromLTWH(75, 94, 28, 13), p);
    c.drawArc(
      const Rect.fromLTWH(65, 98, 20, 13),
      0,
      pi,
      false,
      p
        ..color = const Color(0xFF8C1731)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SantaPainter oldDelegate) => false;
}

class KidsSantaPage extends StatelessWidget {
  const KidsSantaPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Kids Zone')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SantaPicture(),
        Text(
          'A little Christmas magic',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Play together, colour a picture right here or write a wish to Santa. Save a separate letter for each child. No account needed.',
            textAlign: TextAlign.center,
          ),
        ),
        Card(
          color: const Color(0xffe8eee9),
          child: ListTile(
            leading: const Icon(Icons.travel_explore, color: Color(0xff9f1738)),
            title: const Text('Where’s Santa?'),
            subtitle: const Text('Follow Santa’s magical Christmas journey'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SantaJourneyPage())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.extension_outlined),
            title: const Text('Christmas matching game'),
            subtitle: const Text('Find six festive pairs'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChristmasMatchGame()),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.card_giftcard_outlined),
            title: const Text('Catch the presents'),
            subtitle: const Text('A 30-second Christmas catching game'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CatchPresentsPage())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Write to Santa'),
            subtitle: const Text('Your family’s saved Santa letters'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SantaLetterPage()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Colour a Christmas picture',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Text('Choose a picture and tap to colour it in the app. You can still print a blank copy too.'),
        for (final name in ['Santa', 'Christmas tree', 'Snowman', 'Reindeer', 'Gingerbread house'])
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => KidsColouringPage(picture: name))),
            ),
          ),
      ],
    ),
  );
}

class ChristmasMatchGame extends StatefulWidget {
  final List<String>? initialCards;
  const ChristmasMatchGame({super.key, this.initialCards});
  @override
  State<ChristmasMatchGame> createState() => _ChristmasMatchGameState();
}

class _ChristmasMatchGameState extends State<ChristmasMatchGame> {
  late List<String> cards;
  Set<int> matched = {};
  List<int> turned = [];
  bool waiting = false;
  int turns = 0;
  int game = 0;
  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    game++;
    cards =
        widget.initialCards?.toList() ??
        (['🎅', '🎄', '🎁', '⛄', '⭐', '🦌', '🎅', '🎄', '🎁', '⛄', '⭐', '🦌']
          ..shuffle());
    matched = {};
    turned = [];
    waiting = false;
    turns = 0;
  }

  Future<void> flip(int i) async {
    if (waiting || matched.contains(i) || turned.contains(i)) return;
    setState(() {
      turned.add(i);
    });
    if (turned.length == 2) {
      turns++;
      if (cards[turned[0]] == cards[turned[1]]) {
        setState(() {
          matched.addAll(turned);
          turned = [];
        });
      } else {
        waiting = true;
        final round = game;
        await Future<void>.delayed(const Duration(milliseconds: 850));
        if (!mounted || round != game) return;
        setState(() {
          turned = [];
          waiting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Christmas matching')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          matched.length == cards.length
              ? 'You found every pair! 🎉'
              : 'Tap two cards to find a matching pair.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          '${matched.length ~/ 2} / ${cards.length ~/ 2} pairs • $turns turns',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: cards.length,
          itemBuilder: (_, i) => Semantics(
            label: 'Card ${i + 1}${matched.contains(i) ? ', matched' : ''}',
            button: true,
            child: FilledButton(
              key: ValueKey('match-$i'),
              onPressed: () => flip(i),
              style: FilledButton.styleFrom(
                backgroundColor: matched.contains(i)
                    ? const Color(0xFF236C50)
                    : const Color(0xFFA51232),
              ),
              child: Text(
                matched.contains(i) || turned.contains(i) ? cards[i] : '?',
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => setState(reset),
          icon: const Icon(Icons.refresh),
          label: const Text('Play again'),
        ),
      ],
    ),
  );
}

List<Map<String, dynamic>> rankedMovies(List<Map<String, dynamic>> movies) =>
    movies.toList()..sort((a, b) {
      final votes = (b['votes'] as num? ?? 0).compareTo(
        a['votes'] as num? ?? 0,
      );
      return votes != 0
          ? votes
          : a['title'].toString().compareTo(b['title'].toString());
    });

class ChristmasMoviesPage extends StatefulWidget {
  const ChristmasMoviesPage({super.key});
  @override
  State<ChristmasMoviesPage> createState() => _ChristmasMoviesPageState();
}

class _ChristmasMoviesPageState extends State<ChristmasMoviesPage> {
  List<Map<String, dynamic>> movies = [];
  Set<String> votes = {};
  bool loading = true, busy = false, admin = false;
  String? error;
  final movieTitle=TextEditingController(), movieYear=TextEditingController();
  @override void dispose(){movieTitle.dispose();movieYear.dispose();super.dispose();}
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final rows = await communityDb.from('christmas_movies').select().eq('cosy',false);
      final user = communityDb.auth.currentUser;
      final own = user == null
          ? <Map<String, dynamic>>[]
          : await communityDb
                .from('movie_votes')
                .select('movie_id')
                .eq('user_id', user.id);
      final isAdmin = await communityAdmin();
      if (mounted)
        setState(() {
          movies = rankedMovies(List<Map<String, dynamic>>.from(rows));
          votes = own.map((v) => v['movie_id'].toString()).toSet();
          admin = isAdmin;
          loading = false;
          error = null;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          loading = false;
          error = 'Movies could not load. Please try again.';
        });
    }
  }

  Future<void> vote(Map<String, dynamic> movie) async {
    final user = communityDb.auth.currentUser;
    if (user == null) {
      communityMessage(
        context,
        'Sign in from Account to vote for your favourites.',
      );
      return;
    }
    setState(() => busy = true);
    try {
      if (votes.contains(movie['id'])) {
        await communityDb
            .from('movie_votes')
            .delete()
            .eq('movie_id', movie['id'])
            .eq('user_id', user.id);
      } else {
        await communityDb.from('movie_votes').insert({
          'movie_id': movie['id'],
          'user_id': user.id,
        });
      }
      await load();
    } catch (_) {
      if (mounted)
        communityMessage(
          context,
          'Your vote could not save. Please try again.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> submit() async {
    final user = communityDb.auth.currentUser;
    if (user == null) {
      communityMessage(context, 'Sign in from Account to suggest a movie.');
      return;
    }
    final title = movieTitle, year = movieYear;
    title.clear(); year.clear();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Suggest a Christmas movie'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                maxLength: 100,
                decoration: const InputDecoration(labelText: 'Movie title'),
              ),
              TextField(
                controller: year,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Year (optional)'),
              ),
              const Text(
                'Suggestions are reviewed before joining the leaderboard.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Submit movie'),
          ),
        ],
      ),
    );
    final text = title.text.trim(), date = year.text.trim();
    if (ok != true || !mounted) return;
    if (text.length < 2 ||
        (date.isNotEmpty &&
            (int.tryParse(date) == null ||
                int.parse(date) < 1900 ||
                int.parse(date) > 2100))) {
      communityMessage(
        context,
        'Enter a movie title and a valid year, or leave the year blank.',
      );
      return;
    }
    try {
      await communityDb.from('christmas_movies').insert({
        'title': text,
        'year': int.tryParse(date),
        'submitted_by': user.id,
      });
      if (mounted)
        communityMessage(context, 'Thanks! Your movie is waiting for review.');
      await load();
    } on PostgrestException catch (e) {
      if (mounted)
        communityMessage(
          context,
          e.code == '23505'
              ? 'That movie has already been added or suggested.'
              : 'The suggestion could not save. Please try again.',
        );
    }
  }

  Future<void> review(Map<String, dynamic> movie, String status) async {
    try {
      await communityDb
          .from('christmas_movies')
          .update({'status': status})
          .eq('id', movie['id']);
      await load();
    } catch (_) {
      if (mounted) communityMessage(context, 'The review could not save.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Christmas movie favourites'),
      actions: [
        IconButton(
          onPressed: load,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh votes',
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'What’s your favourite Christmas film?',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Text(
          'Vote for the films you love. Most votes rise to the top. One vote per film per member; tap again to remove it. Check age ratings before watching with children.',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: submit,
          icon: const Icon(Icons.add),
          label: const Text('Suggest a movie'),
        ),
        if (loading) const LinearProgressIndicator(),
        if (error != null) Text(error!),
        for (final movie in movies.where((m) => m['status'] == 'published'))
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  '${movies.where((m) => m['status'] == 'published').toList().indexOf(movie) + 1}',
                ),
              ),
              title: Text(movie['title']),
              subtitle: Text(
                '${movie['year'] ?? ''} • ${movie['votes']} votes',
              ),
              trailing: IconButton(
                tooltip: votes.contains(movie['id'])
                    ? 'Remove my vote'
                    : 'Vote for this movie',
                onPressed: busy ? null : () => vote(movie),
                icon: Icon(
                  votes.contains(movie['id'])
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: const Color(0xFFA51232),
                ),
              ),
            ),
          ),
        if (movies.any((m) => m['status'] == 'pending')) ...[
          const SizedBox(height: 16),
          Text(
            admin ? 'Movie suggestions to review' : 'Your pending suggestions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          for (final movie in movies.where((m) => m['status'] == 'pending'))
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(movie['title']),
                    subtitle: const Text('Waiting for review'),
                  ),
                  if (admin)
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () => review(movie, 'published'),
                          child: const Text('Approve'),
                        ),
                        TextButton(
                          onPressed: () => review(movie, 'rejected'),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ],
    ),
  );
}


List<Map<String, dynamic>> pastCalendarIdeas(
  List<Map<String, dynamic>> items,
  DateTime today,
) => items.where((m) {
  final d = DateTime.tryParse((m['idea_of_day_date'] ?? '').toString());
  return d != null && !d.isAfter(DateUtils.dateOnly(today));
}).toList();

class IdeaCalendarPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onIdea;
  final List<Map<String, dynamic>>? initialIdeas;
  const IdeaCalendarPage({super.key, required this.onIdea, this.initialIdeas});
  @override
  State<IdeaCalendarPage> createState() => _IdeaCalendarPageState();
}

class _IdeaCalendarPageState extends State<IdeaCalendarPage> {
  DateTime month = DateTime(nzCalendarToday().year, nzCalendarToday().month);
  List<Map<String, dynamic>> items = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final rows =
          widget.initialIdeas ??
          (await communityDb
                  .from('daily_idea_archive')
                  .select('idea_date,content_items(*)')
                  .order('idea_date', ascending: false))
              .where((r) => r['content_items'] != null)
              .map(
                (r) => <String, dynamic>{
                  ...Map<String, dynamic>.from(r['content_items']),
                  'idea_of_day_date': r['idea_date'],
                },
              )
              .toList();
      if (mounted)
        setState(() {
          items = pastCalendarIdeas(rows, nzCalendarToday());
          loading = false;
          error = null;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          loading = false;
          error = 'The calendar could not load. Try again.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final offset = month.weekday % 7;
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final current = items
        .where(
          (m) => m['idea_of_day_date'].toString().startsWith(
            '${month.year}-${month.month.toString().padLeft(2, '0')}',
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Idea of the Day calendar')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Revisit earlier daily ideas. Highlighted dates have an idea to open.',
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () => setState(
                  () => month = DateTime(month.year, month.month - 1),
                ),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${months[month.month - 1]} ${month.year}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed:
                    month.isBefore(
                      DateTime(nzCalendarToday().year, nzCalendarToday().month),
                    )
                    ? () => setState(
                        () => month = DateTime(month.year, month.month + 1),
                      )
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          Row(
            children: [
              for (final d in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
                Expanded(child: Text(d, textAlign: TextAlign.center)),
            ],
          ),
          if (loading) const LinearProgressIndicator(),
          if (error != null) TextButton(onPressed: load, child: Text(error!)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: days + offset,
            itemBuilder: (_, i) {
              if (i < offset) return const SizedBox();
              final day = i - offset + 1;
              final matches = current
                  .where(
                    (m) => DateTime.parse(m['idea_of_day_date']).day == day,
                  )
                  .toList();
              return TextButton(
                onPressed: matches.isEmpty
                    ? null
                    : () => widget.onIdea(matches.first),
                style: TextButton.styleFrom(
                  backgroundColor: matches.isEmpty
                      ? null
                      : const Color(0xFFF0DDD9),
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontWeight: matches.isEmpty
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          if (current.isEmpty && !loading)
            const Text('No archived ideas for this month yet.'),
          for (final idea in current)
            Card(
              child: ListTile(
                leading: const Icon(Icons.auto_awesome),
                title: Text(idea['title']),
                subtitle: Text(idea['idea_of_day_date']),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => widget.onIdea(idea),
              ),
            ),
        ],
      ),
    );
  }
}

class IdeaCommunitySection extends StatefulWidget {
  final String contentId;
  const IdeaCommunitySection({super.key, required this.contentId});
  @override
  State<IdeaCommunitySection> createState() => _IdeaCommunitySectionState();
}

class _IdeaCommunitySectionState extends State<IdeaCommunitySection> {
  List<Map<String, dynamic>> makes = [];
  Map<String, String> images = {};
  int rating = 0, count = 0;
  double average = 0;
  bool loading = true, busy = false, admin = false;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final db = communityDb;
      final item = await db
          .from('content_items')
          .select('rating_count,rating_average')
          .eq('id', widget.contentId)
          .single();
      final rows = await db
          .from('idea_makes')
          .select()
          .eq('content_id', widget.contentId)
          .order('created_at', ascending: false);
      final user = db.auth.currentUser;
      final own = user == null
          ? null
          : await db
                .from('idea_ratings')
                .select('rating')
                .eq('content_id', widget.contentId)
                .eq('user_id', user.id)
                .maybeSingle();
      final isAdmin = await communityAdmin();
      final urls = <String, String>{};
      for (final row in rows) {
        if (row['image_path'] != null) {
          try {
            urls[row['id']] = await db.storage
                .from('idea-makes')
                .createSignedUrl(row['image_path'], 3600);
          } catch (_) {}
        }
      }
      if (mounted)
        setState(() {
          makes = List<Map<String, dynamic>>.from(rows);
          images = urls;
          rating = own?['rating'] ?? 0;
          count = item['rating_count'] ?? 0;
          average = (item['rating_average'] as num? ?? 0).toDouble();
          admin = isAdmin;
          loading = false;
          error = null;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          loading = false;
          error = 'Community posts could not load.';
        });
    }
  }

  Future<void> rate(int value) async {
    final user = communityDb.auth.currentUser;
    if (user == null) {
      communityMessage(context, 'Sign in from Account to rate this idea.');
      return;
    }
    setState(() => busy = true);
    try {
      await communityDb.from('idea_ratings').upsert({
        'content_id': widget.contentId,
        'user_id': user.id,
        'rating': value,
      });
      await load();
    } catch (_) {
      if (mounted) communityMessage(context, 'Your rating could not save.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> addMake() async {
    if (communityDb.auth.currentUser == null) {
      communityMessage(
        context,
        'Sign in from Account to add a comment or photo.',
      );
      return;
    }
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => IdeaMakeForm(contentId: widget.contentId),
      ),
    );
    if (result == true) await load();
  }

  Future<void> moderate(Map<String, dynamic> row, String status) async {
    try {
      await communityDb
          .from('idea_makes')
          .update({'status': status})
          .eq('id', row['id']);
      await load();
    } catch (_) {
      if (mounted) communityMessage(context, 'The review could not save.');
    }
  }

  Future<void> remove(Map<String, dynamic> row) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete your post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await communityDb.from('idea_makes').delete().eq('id', row['id']);
      if (row['image_path'] != null)
        await communityDb.storage.from('idea-makes').remove([
          row['image_path'],
        ]);
      await load();
    } catch (_) {
      if (mounted) communityMessage(context, 'The post could not be deleted.');
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 28),
      const Divider(),
      Text(
        'Made it? Share it!',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      FilledButton.icon(
        onPressed: addMake,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Add a comment or my photo'),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Share how it went. Comments and photos are reviewed before appearing here.',
        ),
      ),
      Text(
        count == 0
            ? 'Be the first to rate this idea.'
            : '${average.toStringAsFixed(1)} / 5 • $count ${count == 1 ? 'rating' : 'ratings'}',
      ),
      Wrap(
        children: [
          for (var i = 1; i <= 5; i++)
            IconButton(
              tooltip: 'Rate $i out of 5',
              onPressed: busy ? null : () => rate(i),
              icon: Icon(
                i <= rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFC29B28),
              ),
            ),
        ],
      ),
      if (loading) const LinearProgressIndicator(),
      if (error != null)
        TextButton(onPressed: load, child: Text('$error Tap to retry.')),
      for (final row in makes)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row['author_name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (row['status'] != 'published')
                  Text(
                    row['status'] == 'pending'
                        ? 'Waiting for review'
                        : 'Not published',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                if ((row['caption'] ?? '').isNotEmpty) Text(row['caption']),
                if (images[row['id']] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: Image.network(
                        images[row['id']]!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Text('Photo unavailable'),
                      ),
                    ),
                  ),
                Wrap(
                  spacing: 8,
                  children: [
                    if (admin && row['status'] == 'pending') ...[
                      TextButton(
                        onPressed: () => moderate(row, 'published'),
                        child: const Text('Approve'),
                      ),
                      TextButton(
                        onPressed: () => moderate(row, 'rejected'),
                        child: const Text('Reject'),
                      ),
                    ],
                    if (row['user_id'] == communityDb.auth.currentUser?.id ||
                        admin)
                      TextButton(
                        onPressed: () => remove(row),
                        child: const Text('Delete post'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

class IdeaMakeForm extends StatefulWidget {
  final String contentId;
  const IdeaMakeForm({super.key, required this.contentId});
  @override
  State<IdeaMakeForm> createState() => _IdeaMakeFormState();
}

class _IdeaMakeFormState extends State<IdeaMakeForm> {
  final caption = TextEditingController();
  XFile? photo;
  bool permission = false, busy = false;
  String? error;
  @override
  void dispose() {
    caption.dispose();
    super.dispose();
  }

  Future<void> pick() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file != null && mounted) setState(() => photo = file);
    } catch (_) {
      if (mounted)
        setState(() => error = 'The photo could not open. Please try another.');
    }
  }

  Future<void> send() async {
    final user = communityDb.auth.currentUser;
    if (user == null) return;
    if (caption.text.trim().isEmpty && photo == null) {
      setState(() => error = 'Add a comment or a photo first.');
      return;
    }
    if (photo != null && !permission) {
      setState(
        () => error = 'Confirm that you have permission to share this photo.',
      );
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    String? path;
    bool inserted = false;
    try {
      if (photo != null) {
        final bytes = await photo!.readAsBytes();
        if (bytes.length > 5 * 1024 * 1024)
          throw Exception('Choose a photo smaller than 5 MB.');
        final ext = photo!.name.split('.').last.toLowerCase();
        final mime = {
          'jpg': 'image/jpeg',
          'jpeg': 'image/jpeg',
          'png': 'image/png',
          'webp': 'image/webp',
        }[ext];
        if (mime == null) throw Exception('Choose a JPG, PNG or WebP photo.');
        path = '${user.id}/${DateTime.now().microsecondsSinceEpoch}.$ext';
        await communityDb.storage
            .from('idea-makes')
            .uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(contentType: mime),
            );
      }
      await communityDb.from('idea_makes').insert({
        'content_id': widget.contentId,
        'user_id': user.id,
        'author_name': communityName(),
        'caption': caption.text.trim(),
        'image_path': path,
      });
      inserted = true;
      if (mounted) {
        communityMessage(context, 'Thanks! Your post is waiting for review.');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (path != null && !inserted) {
        try {
          await communityDb.storage.from('idea-makes').remove([path]);
        } catch (_) {}
      }
      if (mounted)
        setState(
          () => error = e is PostgrestException || e is StorageException
              ? 'Your post could not save. Please try again.'
              : e.toString().replaceFirst('Exception: ', ''),
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Share your Christmas make')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Tell us how you made it, or leave a helpful comment. Please keep children’s names and personal details out of public posts.',
        ),
        TextField(
          controller: caption,
          maxLength: 1000,
          minLines: 3,
          maxLines: 8,
          decoration: const InputDecoration(labelText: 'Your comment'),
        ),
        OutlinedButton.icon(
          onPressed: busy ? null : pick,
          icon: const Icon(Icons.photo_library_outlined),
          label: Text(photo == null ? 'Choose my photo' : photo!.name),
        ),
        if (photo != null) ...[
          TextButton(
            onPressed: busy ? null : () => setState(() => photo = null),
            child: const Text('Remove photo'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: permission,
            onChanged: busy
                ? null
                : (v) => setState(() => permission = v ?? false),
            title: const Text(
              'This is my photo and I have permission from anyone shown to share it publicly.',
            ),
          ),
        ],
        if (error != null) Text(error!),
        const Text('Your first name will appear with your post after review.'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: busy ? null : send,
          child: Text(busy ? 'Submitting…' : 'Submit for review'),
        ),
      ],
    ),
  );
}

class CommunityModerationPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onIdea;
  const CommunityModerationPage({super.key, required this.onIdea});
  @override
  State<CommunityModerationPage> createState() =>
      _CommunityModerationPageState();
}

class _CommunityModerationPageState extends State<CommunityModerationPage> {
  late Future<List<Map<String, dynamic>>> pending;
  @override
  void initState() {
    super.initState();
    pending = load();
  }

  Future<List<Map<String, dynamic>>> load() async {
    if (!await communityAdmin()) return [];
    final rows = await communityDb
        .from('idea_makes')
        .select('content_id')
        .eq('status', 'pending');
    final ids = rows.map((r) => r['content_id'].toString()).toSet().toList();
    if (ids.isEmpty) return [];
    return List<Map<String, dynamic>>.from(
      await communityDb.from('content_items').select().inFilter('id', ids),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Community review'),
      actions: [
        IconButton(
          onPressed: () => setState(() => pending = load()),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        FilledButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChristmasMoviesPage()),
          ),
          icon: const Icon(Icons.movie),
          label: const Text('Review movie suggestions'),
        ),
        const SizedBox(height: 16),
        const Text('Open an idea to review its pending comments and photos.'),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: pending,
          builder: (ctx, s) {
            if (s.hasError)
              return const Text('Review queue could not load. Try Refresh.');
            if (!s.hasData) return const LinearProgressIndicator();
            if (s.data!.isEmpty)
              return const Text('No idea posts waiting for review.');
            return Column(
              children: [
                for (final idea in s.data!)
                  ListTile(
                    title: Text(idea['title']),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => widget.onIdea(idea),
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
