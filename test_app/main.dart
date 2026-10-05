import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const supabaseUrl = 'https://ocrwnkeqemcsklsnbufq.supabase.co';
const supabaseKey = 'sb_publishable_ciIHpWT3mWNzgEpUebXGkw_EBzELVZ3';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const ChristmasIdeasNZ());
}

enum XmasTheme { kiwi, classic, grinchy, winter }

class ChristmasIdeasNZ extends StatefulWidget {
  const ChristmasIdeasNZ({super.key});
  @override
  State<ChristmasIdeasNZ> createState() => _ChristmasIdeasNZState();
}

class _ChristmasIdeasNZState extends State<ChristmasIdeasNZ> {
  String? name;
  XmasTheme theme = XmasTheme.kiwi;

  ColorScheme scheme() {
    switch (theme) {
      case XmasTheme.classic:
        return const ColorScheme.light(
          primary: Color(0xFF9E1B32),
          secondary: Color(0xFFD4AF37),
          surface: Color(0xFFFBF4EA),
          onSurface: Color(0xFF34161B),
        );
      case XmasTheme.grinchy:
        return const ColorScheme.light(
          primary: Color(0xFF8CCF3F),
          secondary: Color(0xFFB3202A),
          surface: Color(0xFFF3F7E7),
          onSurface: Color(0xFF223118),
        );
      case XmasTheme.winter:
        return const ColorScheme.light(
          primary: Color(0xFF2A4C73),
          secondary: Color(0xFFDCEBFA),
          surface: Color(0xFFF4F8FD),
          onSurface: Color(0xFF1A2B40),
        );
      case XmasTheme.kiwi:
        return const ColorScheme.light(
          primary: Color(0xFF0F4C45),
          secondary: Color(0xFFC9A44D),
          surface: Color(0xFFF4EFE6),
          onSurface: Color(0xFF18302C),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = scheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christmas Ideas NZ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: s,
        scaffoldBackgroundColor: s.surface,
        textTheme: GoogleFonts.montserratTextTheme().apply(
          bodyColor: s.onSurface,
          displayColor: s.onSurface,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white.withValues(alpha: .95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      home: name == null
          ? Onboarding(
              theme: theme,
              onThemeChanged: (t) => setState(() => theme = t),
              onContinue: (n) => setState(() => name = n.trim().isEmpty ? 'Christmas Lover' : n.trim()),
            )
          : Shell(
              name: name!,
              theme: theme,
              onThemeChanged: (t) => setState(() => theme = t),
            ),
    );
  }
}

class Onboarding extends StatefulWidget {
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  final ValueChanged<String> onContinue;
  const Onboarding({super.key, required this.theme, required this.onThemeChanged, required this.onContinue});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              height: 215,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: .72)],
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🎄', style: TextStyle(fontSize: 70)),
                  SizedBox(height: 8),
                  Text('CHRISTMAS IDEAS NZ', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('NEW ZEALAND', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w800, letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Kia ora! 🎄', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('Welcome to your NZ Christmas hub.'),
            const SizedBox(height: 20),
            TextField(controller: controller, decoration: const InputDecoration(labelText: "What's your name?")),
            const SizedBox(height: 20),
            const Text('Choose your Christmas style', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(label: const Text('Kiwi Christmas'), selected: widget.theme == XmasTheme.kiwi, onSelected: (_) => widget.onThemeChanged(XmasTheme.kiwi)),
                ChoiceChip(label: const Text('Classic ✨'), selected: widget.theme == XmasTheme.classic, onSelected: (_) => widget.onThemeChanged(XmasTheme.classic)),
                ChoiceChip(label: const Text('Grinchy 💚'), selected: widget.theme == XmasTheme.grinchy, onSelected: (_) => widget.onThemeChanged(XmasTheme.grinchy)),
                ChoiceChip(label: const Text('Winter ❄️'), selected: widget.theme == XmasTheme.winter, onSelected: (_) => widget.onThemeChanged(XmasTheme.winter)),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => widget.onContinue(controller.text),
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Enter Christmas Ideas NZ')),
            ),
          ],
        ),
      ),
    );
  }
}

class Shell extends StatefulWidget {
  final String name;
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  const Shell({super.key, required this.name, required this.theme, required this.onThemeChanged});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(name: widget.name, goTo: (i) => setState(() => index = i)),
      const DiscoverPage(),
      const NearMePage(),
      const SavedPage(),
      MePage(theme: widget.theme, onThemeChanged: widget.onThemeChanged),
    ];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.location_on_outlined), selectedIcon: Icon(Icons.location_on), label: 'Near Me'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String name;
  final ValueChanged<int> goTo;
  const HomePage({super.key, required this.name, required this.goTo});

  String countdown() {
    final now = DateTime.now();
    var target = DateTime(now.year, 12, 25);
    if (now.isAfter(target)) target = DateTime(now.year + 1, 12, 25);
    final d = target.difference(now);
    if (now.month < 12) return '${d.inDays} days until Christmas';
    if (now.day < 15) return '${d.inDays} days • ${d.inHours % 24} hours';
    return '${d.inDays}d ${d.inHours % 24}h ${d.inMinutes % 60}m';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Kia ora, $name 🎄', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: .72)]),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('THE COUNTDOWN IS ON', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(countdown(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
            ]),
          ),
          const SizedBox(height: 20),
          const Text("✨ Today's Christmas Idea", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: Supabase.instance.client.from('content_items').select('title,summary').eq('status','published').order('published_at', ascending: false).limit(1),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Card(child: Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())));
              if (snap.hasError || (snap.data ?? []).isEmpty) {
                return const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('Christmas inspiration is being loaded.')));
              }
              final item = snap.data!.first;
              return Card(child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['title'] ?? 'Christmas idea', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                  const SizedBox(height: 8),
                  Text(item['summary'] ?? ''),
                ]),
              ));
            },
          ),
          const SizedBox(height: 14),
          _HomeButton(icon: Icons.card_giftcard, title: 'Gift Finder', subtitle: 'Find gifts by person, budget and NZ-made', onTap: () => goTo(1)),
          _HomeButton(icon: Icons.location_on, title: 'Christmas Near You', subtitle: 'Lights, markets, Santa and events', onTap: () => goTo(2)),
          _HomeButton(icon: Icons.favorite, title: 'Saved Boards', subtitle: 'Keep your Christmas ideas together', onTap: () => goTo(3)),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _HomeButton({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Discover', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          TextField(onChanged: (v) => setState(() => q = v.toLowerCase()), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'What are you looking for?')),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: Supabase.instance.client.from('categories').select('name,slug,description').eq('is_active', true).order('sort_order'),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()));
              final items = (snap.data ?? []).where((e) => ('${e['name']} ${e['description'] ?? ''}').toLowerCase().contains(q)).toList();
              if (items.isEmpty) return const Padding(padding: EdgeInsets.all(24), child: Text('No categories found.'));
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.25, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Text('🎄', style: TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(item['name'] ?? 'Christmas', style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(item['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                      ]),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('🎁 Gift Finder', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: Supabase.instance.client.from('gift_ideas').select('title,description,recipient_group,price_min,price_max,nz_made').eq('status','published').limit(8),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const LinearProgressIndicator();
              final gifts = snap.data ?? [];
              return Column(children: gifts.map((g) => Card(child: ListTile(
                leading: const CircleAvatar(child: Text('🎁')),
                title: Text(g['title'] ?? 'Gift idea', style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text("${g['recipient_group'] ?? ''} • NZ\${g['price_min'] ?? ''}${g['nz_made'] == true ? ' • NZ Made' : ''}"),
              ))).toList());
            },
          ),
        ],
      ),
    );
  }
}

class NearMePage extends StatelessWidget {
  const NearMePage({super.key});

  Future<List<Map<String, dynamic>>> load() async {
    final events = await Supabase.instance.client.from('events').select('name,city,region,start_at').eq('status','published').limit(12);
    final lights = await Supabase.instance.client.from('light_displays').select('name,city,region,start_date').eq('status','published').limit(12);
    return [
      ...List<Map<String,dynamic>>.from(events).map((e) => {...e, '_type':'Event'}),
      ...List<Map<String,dynamic>>.from(lights).map((e) => {...e, '_type':'Lights'}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Christmas Near Me', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('The full map is coming next. This test build is already connected to your approved NZ listings.'),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String,dynamic>>>(
            future: load(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final items = snap.data ?? [];
              if (items.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('No published events or light displays yet.')));
              return Column(children: items.map((e) => Card(child: ListTile(
                leading: CircleAvatar(child: Text(e['_type'] == 'Lights' ? '✨' : '🎪')),
                title: Text(e['name'] ?? 'Christmas listing', style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${e['city'] ?? ''}${e['region'] != null ? ', ${e['region']}' : ''}'),
              ))).toList());
            },
          ),
        ],
      ),
    );
  }
}


class SavedPage extends StatefulWidget {
  const SavedPage({super.key});
  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final boardName = TextEditingController();

  Future<List<Map<String,dynamic>>> loadBoards() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    final rows = await Supabase.instance.client
        .from('boards')
        .select('id,name,emoji,created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<void> createBoard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in from Me first.')));
      return;
    }
    final name = boardName.text.trim();
    if (name.isEmpty) return;
    await Supabase.instance.client.from('boards').insert({
      'user_id': user.id,
      'name': name,
      'emoji': '🎄',
    });
    boardName.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Saved', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          if (user == null) ...[
            const Card(child: Padding(
              padding: EdgeInsets.all(18),
              child: Text('Sign in from Me to create real Christmas boards and keep them across devices.'),
            )),
          ] else ...[
            Row(children: [
              Expanded(child: TextField(controller: boardName, decoration: const InputDecoration(hintText: 'New board name'))),
              const SizedBox(width: 8),
              FilledButton(onPressed: createBoard, child: const Text('Add')),
            ]),
            const SizedBox(height: 14),
            FutureBuilder<List<Map<String,dynamic>>>(
              future: loadBoards(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final boards = snap.data ?? [];
                if (boards.isEmpty) return const Card(child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No boards yet. Try Christmas Dinner, Gift Ideas or Elf Ideas.'),
                ));
                return Column(children: boards.map((b) => Card(child: ListTile(
                  leading: Text((b['emoji'] ?? '🎄').toString(), style: const TextStyle(fontSize: 24)),
                  title: Text((b['name'] ?? 'Board').toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Text('Saved Christmas ideas will appear here'),
                ))).toList());
              },
            ),
          ],
        ],
      ),
    );
  }
}

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});
  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  String type = 'event';
  final title = TextEditingController();
  final description = TextEditingController();
  final city = TextEditingController();
  final region = TextEditingController();
  String? message;
  bool busy = false;

  Future<void> submit() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => message = 'Please sign in first.');
      return;
    }
    if (title.text.trim().isEmpty) {
      setState(() => message = 'Please add a title.');
      return;
    }
    setState(() { busy = true; message = null; });
    try {
      await Supabase.instance.client.from('submissions').insert({
        'user_id': user.id,
        'submission_type': type,
        'title': title.text.trim(),
        'description': description.text.trim(),
        'payload': {
          'city': city.text.trim(),
          'region': region.text.trim(),
        },
        'status': 'pending',
      });
      title.clear();
      description.clear();
      city.clear();
      region.clear();
      message = 'Submitted for approval ✅';
    } catch (e) {
      message = 'Could not submit. Please try again.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit a Christmas Find')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Help build the NZ Christmas map and idea library.', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(labelText: 'What are you submitting?'),
            items: const [
              DropdownMenuItem(value:'event', child: Text('Event / Market')),
              DropdownMenuItem(value:'light', child: Text('Christmas Lights')),
              DropdownMenuItem(value:'business', child: Text('NZ Christmas Business')),
              DropdownMenuItem(value:'idea', child: Text('Christmas Idea')),
            ],
            onChanged: (v) => setState(() => type = v ?? 'event'),
          ),
          const SizedBox(height: 12),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title / Name')),
          const SizedBox(height: 12),
          TextField(controller: description, maxLines: 4, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 12),
          TextField(controller: city, decoration: const InputDecoration(labelText: 'City or town')),
          const SizedBox(height: 12),
          TextField(controller: region, decoration: const InputDecoration(labelText: 'Region')),
          if (message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(message!)),
          const SizedBox(height: 18),
          FilledButton(onPressed: busy ? null : submit, child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Text(busy ? 'Submitting…' : 'Send for approval'),
          )),
        ],
      ),
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Future<List<Map<String,dynamic>>> pending() async {
    final rows = await Supabase.instance.client
        .from('submissions')
        .select('id,submission_type,title,description,payload,status,created_at')
        .eq('status','pending')
        .order('created_at', ascending: true);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<void> review(Map<String,dynamic> item, bool approve) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    if (approve) {
      final payload = Map<String,dynamic>.from(item['payload'] ?? {});
      final type = item['submission_type'];
      if (type == 'event') {
        await Supabase.instance.client.from('events').insert({
          'name': item['title'],
          'description': item['description'],
          'city': payload['city'],
          'region': payload['region'],
          'event_type': 'community',
          'status': 'published',
          'created_by': user.id,
        });
      } else if (type == 'light') {
        await Supabase.instance.client.from('light_displays').insert({
          'name': item['title'],
          'description': item['description'],
          'city': payload['city'],
          'region': payload['region'],
          'status': 'published',
          'created_by': user.id,
        });
      } else if (type == 'business') {
        await Supabase.instance.client.from('businesses').insert({
          'name': item['title'],
          'description': item['description'],
          'city': payload['city'],
          'region': payload['region'],
          'status': 'published',
        });
      } else if (type == 'idea') {
        await Supabase.instance.client.from('content_items').insert({
          'title': item['title'],
          'summary': item['description'],
          'content_type': 'idea',
          'status': 'published',
          'published_at': DateTime.now().toIso8601String(),
          'created_by': user.id,
        });
      }
    }
    await Supabase.instance.client.from('submissions').update({
      'status': approve ? 'approved' : 'rejected',
      'reviewed_by': user.id,
      'reviewed_at': DateTime.now().toIso8601String(),
    }).eq('id', item['id']);
    if (mounted) setState(() {});
  }

  Future<Map<String,int>> counts() async {
    final ideas = await Supabase.instance.client.from('content_items').select('id');
    final gifts = await Supabase.instance.client.from('gift_ideas').select('id');
    final events = await Supabase.instance.client.from('events').select('id');
    final lights = await Supabase.instance.client.from('light_displays').select('id');
    final pendingRows = await Supabase.instance.client.from('submissions').select('id').eq('status','pending');
    return {
      'Ideas': (ideas as List).length,
      'Gifts': (gifts as List).length,
      'Events': (events as List).length,
      'Lights': (lights as List).length,
      'Pending': (pendingRows as List).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Christmas Ideas NZ Admin')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          FutureBuilder<Map<String,int>>(
            future: counts(),
            builder: (context, snap) {
              final data = snap.data ?? {};
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Ideas: ' + (data['Ideas']?.toString() ?? '…'))),
                  Chip(label: Text('Gifts: ' + (data['Gifts']?.toString() ?? '…'))),
                  Chip(label: Text('Events: ' + (data['Events']?.toString() ?? '…'))),
                  Chip(label: Text('Lights: ' + (data['Lights']?.toString() ?? '…'))),
                  Chip(label: Text('Pending: ' + (data['Pending']?.toString() ?? '…'))),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          const Text('Pending submissions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String,dynamic>>>(
            future: pending(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final items = snap.data ?? [];
              if (items.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('Nothing waiting for approval 🎄')));
              return Column(children: items.map((item) => Card(child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text((item['submission_type'] ?? '').toString().toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text((item['title'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  if ((item['description'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text((item['description'] ?? '').toString()),
                  ],
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => review(item, false), child: const Text('Reject'))),
                    const SizedBox(width: 8),
                    Expanded(child: FilledButton(onPressed: () => review(item, true), child: const Text('Approve & Publish'))),
                  ]),
                ]),
              ))).toList());
            },
          ),
        ],
      ),
    );
  }
}

class MePage extends StatefulWidget {
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  const MePage({super.key, required this.theme, required this.onThemeChanged});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String? message;
  Map<String,dynamic>? profile;
  bool busy = false;

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => profile = null);
      return;
    }
    final rows = await Supabase.instance.client.from('profiles').select('display_name,role,premium_status').eq('id', user.id).limit(1);
    if (mounted) setState(() {
      profile = List<Map<String,dynamic>>.from(rows).isEmpty ? null : List<Map<String,dynamic>>.from(rows).first;
    });
  }

  Future<void> signIn() async {
    setState(() { busy = true; message = null; });
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: email.text.trim(), password: password.text);
      await loadProfile();
      message = profile?['role'] == 'admin' ? 'Admin access confirmed ✅' : 'Signed in ✅';
    } catch (e) {
      message = 'Sign in failed. Check your email and password.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) setState(() { profile = null; message = 'Signed out'; });
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final isAdmin = profile?['role'] == 'admin' || profile?['role'] == 'editor';
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Me', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          const Text('Christmas theme', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(label: const Text('Kiwi'), selected: widget.theme == XmasTheme.kiwi, onSelected: (_) => widget.onThemeChanged(XmasTheme.kiwi)),
              ChoiceChip(label: const Text('Classic ✨'), selected: widget.theme == XmasTheme.classic, onSelected: (_) => widget.onThemeChanged(XmasTheme.classic)),
              ChoiceChip(label: const Text('Grinchy 💚'), selected: widget.theme == XmasTheme.grinchy, onSelected: (_) => widget.onThemeChanged(XmasTheme.grinchy)),
              ChoiceChip(label: const Text('Winter ❄️'), selected: widget.theme == XmasTheme.winter, onSelected: (_) => widget.onThemeChanged(XmasTheme.winter)),
            ],
          ),
          const SizedBox(height: 22),
          if (user == null) ...[
            const Text('Sign in', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 6),
            const Text('Sign in to save boards, submit Christmas finds and access admin tools.'),
            const SizedBox(height: 10),
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 12),
            FilledButton(onPressed: busy ? null : signIn, child: Text(busy ? 'Signing in…' : 'Sign in')),
          ] else ...[
            Card(child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text((profile?['display_name'] ?? user.email ?? 'Signed in').toString()),
              subtitle: Text(isAdmin ? 'Owner / Admin' : 'Member'),
            )),
            Card(child: ListTile(
              leading: const CircleAvatar(child: Text('⬆')),
              title: const Text('Submit a Christmas Find', style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: const Text('Events, lights, businesses or ideas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmissionPage())),
            )),
            if (isAdmin)
              Card(child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.admin_panel_settings)),
                title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.w900)),
                subtitle: const Text('Approve submissions and view live content totals'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
              )),
            FilledButton.tonal(onPressed: signOut, child: const Text('Sign out')),
          ],
          if (message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(message!)),
          const SizedBox(height: 20),
          const Card(child: ListTile(
            leading: Text('f', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
            title: Text('Christmas Ideas NZ on Facebook'),
            subtitle: Text('Facebook link will be connected before launch'),
          )),
        ],
      ),
    );
  }
}
