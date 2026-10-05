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

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Saved', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Sign in from Me to use your real saved boards.'),
          const SizedBox(height: 14),
          for (final name in const ['Christmas Dinner','Gift Ideas','Kids Activities','Decorating the House','Elf Ideas','Christmas Day'])
            Card(child: ListTile(leading: const Text('❤️'), title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('Ready for saved items'))),
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

  Future<void> signIn() async {
    setState(() { busy = true; message = null; });
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: email.text.trim(), password: password.text);
      final uid = Supabase.instance.client.auth.currentUser!.id;
      final rows = await Supabase.instance.client.from('profiles').select('display_name,role,premium_status').eq('id', uid).limit(1);
      profile = List<Map<String,dynamic>>.from(rows).isEmpty ? null : List<Map<String,dynamic>>.from(rows).first;
      message = profile?['role'] == 'admin' ? 'Admin access confirmed ✅' : 'Signed in ✅';
    } catch (e) {
      message = 'Sign in failed. Check your email and password.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    setState(() { profile = null; message = 'Signed out'; });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
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
            const Text('Owner/Admin sign in', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 12),
            FilledButton(onPressed: busy ? null : signIn, child: Text(busy ? 'Signing in…' : 'Sign in')),
          ] else ...[
            Card(child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(profile?['display_name'] ?? user.email ?? 'Signed in'),
              subtitle: Text(profile?['role'] == 'admin' ? 'Owner / Admin' : 'Member'),
            )),
            if (profile?['role'] == 'admin')
              const Card(child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Admin access is working 🎄', style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(height: 6),
                  Text('The full admin forms from the main build will be added after phone testing.'),
                ]),
              )),
            FilledButton.tonal(onPressed: signOut, child: const Text('Sign out')),
          ],
          if (message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(message!)),
          const SizedBox(height: 20),
          Card(child: ListTile(
            leading: const Text('f', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
            title: const Text('Christmas Ideas NZ on Facebook'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(Uri.parse('https://www.facebook.com/')),
          )),
        ],
      ),
    );
  }
}
