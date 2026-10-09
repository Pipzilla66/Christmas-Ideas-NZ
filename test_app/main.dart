import 'dart:convert';
import 'dart:io';

import 'listing_filters.dart';
import 'elf_search.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const supabaseUrl = 'https://ocrwnkeqemcsklsnbufq.supabase.co';
const supabaseKey = 'sb_publishable_ciIHpWT3mWNzgEpUebXGkw_EBzELVZ3';
Widget safeEmbeddedImage(
  String data, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  try {
    return Image.memory(
      base64Decode(data),
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE9E2D4),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Color(0xFF0F4C45)),
        ),
      ),
    );
  } catch (_) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE9E2D4),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF0F4C45)),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (details) => Material(
    color: const Color(0xFFF7F2E8),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFA80F24)),
            const SizedBox(height: 16),
            const Text(
              'Christmas Ideas NZ hit a loading problem.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              details.exceptionAsString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseKey,
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
    );
    final preferences = await SharedPreferences.getInstance();
    rememberedName = preferences.getString('welcome_name');
    runApp(const ChristmasIdeasNZ());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFF7F2E8),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not connect to Christmas Ideas NZ.\n\n$e',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? rememberedName;

enum XmasTheme { kiwi, classic, grinchy, winter }

class ChristmasIdeasNZ extends StatefulWidget {
  const ChristmasIdeasNZ({super.key});
  @override
  State<ChristmasIdeasNZ> createState() => _ChristmasIdeasNZState();
}

class _ChristmasIdeasNZState extends State<ChristmasIdeasNZ> {
  String? name = rememberedName;
  XmasTheme theme = XmasTheme.classic;

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
        scaffoldBackgroundColor: const Color(0xFFF7F2E8),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF173B36),
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF173B36),
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF173B36),
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF173B36),
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF173B36),
          ),
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E2522),
          ),
          titleMedium: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E2522),
          ),
          bodyLarge: GoogleFonts.inter(
            color: const Color(0xFF343936),
            height: 1.45,
          ),
          bodyMedium: GoogleFonts.inter(
            color: const Color(0xFF343936),
            height: 1.45,
          ),
        ),
        dividerColor: const Color(0xFFD9D1C4),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Color(0xFFFFFCF6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            side: BorderSide(color: Color(0xFFE4DCCF)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFFCF6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Color(0xFFCFC5B5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Color(0xFF0F4C45), width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ),
      home: name == null
          ? Onboarding(
              theme: theme,
              onThemeChanged: (t) => setState(() => theme = t),
              onContinue: (n) async {
                final value = n.trim().isEmpty ? 'Christmas Lover' : n.trim();
                await (await SharedPreferences.getInstance()).setString(
                  'welcome_name',
                  value,
                );
                if (mounted) setState(() => name = value);
              },
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
  const Onboarding({
    super.key,
    required this.theme,
    required this.onThemeChanged,
    required this.onContinue,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/christmas_hero.webp', fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x22000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHRISTMAS IDEAS NZ',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.1,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Make it a magical\nKiwi Christmas.',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 38,
                            height: 1.04,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ideas, gifts, lights and events — all in one place.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: .92),
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'A name helps us make the app feel more personal. You can browse without creating an account.',
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Your name'),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => widget.onContinue(controller.text),
                      child: const Text('Start exploring'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : const Color(0xFFFFFCF6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFCFC5B5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF343936),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PhillieButton extends StatelessWidget {
  const PhillieButton({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Ask Elf Phillie, automated Christmas helper',
    button: true,
    child: InkWell(
      onTap: () => showElf(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC69A3A), width: 2),
              boxShadow: const [
                BoxShadow(color: Color(0x22000000), blurRadius: 8),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/elf_phillie.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -.5),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFA80F24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Elf Phillie',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    ),
  );
}

void showElf(BuildContext context) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  enableDrag: false,
  backgroundColor: const Color(0xFFF7F2E8),
  builder: (_) => const PhillieSupportSheet(),
);

class PhillieSupportSheet extends StatefulWidget {
  const PhillieSupportSheet({super.key, this.initialCatalogue});
  final List<Map<String, dynamic>>? initialCatalogue;
  @override
  State<PhillieSupportSheet> createState() => _PhillieSupportSheetState();
}

class _PhillieSupportSheetState extends State<PhillieSupportSheet> {
  final question = TextEditingController();
  final scrollController = ScrollController();
  final resultsKey = GlobalKey();
  bool busy = false;
  String? answer;
  List<Map<String, dynamic>> matches = [];
  List<Map<String, dynamic>>? catalogue;
  @override
  void initState() {
    super.initState();
    catalogue = widget.initialCatalogue;
  }

  @override
  void dispose() {
    question.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> ask([String? prompt]) async {
    if (prompt != null) question.text = prompt;
    if (question.text.trim().isEmpty || busy) return;
    FocusScope.of(context).unfocus();
    setState(() {
      busy = true;
      answer = null;
      matches = [];
    });
    try {
      if (catalogue == null) {
        final client = Supabase.instance.client;
        final tables = [
          'gift_ideas',
          'content_items',
          'events',
          'light_displays',
          'businesses',
        ];
        final rows = await Future.wait(
          tables.map((t) => client.from(t).select().eq('status', 'published')),
        );
        catalogue = [
          for (var i = 0; i < tables.length; i++)
            ...List<Map<String, dynamic>>.from(rows[i])
                .map((r) => {...r, '_table': tables[i]}),
        ];
      }
      final result = findElfMatches(question.text, catalogue!, DateTime.now());
      if (!mounted) return;
      setState(() {
        matches = result;
        answer = result.isEmpty
            ? 'I couldn’t find a published match yet. Try a city, a gift recipient or a different budget. You can also browse Discover and Near Me.'
            : 'Here are ${result.length} ideas from our Christmas guide. Tap one to explore. Check the listing or retailer for current details.';
      });
    } catch (_) {
      if (mounted)
        setState(
          () => answer = 'I can’t load the Christmas guide right now. Please try again when you’re connected.',
        );
    } finally {
      if (mounted) {
        setState(() => busy = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final target = resultsKey.currentContext;
          if (!mounted || target == null) return;
          Scrollable.ensureVisible(
            target,
            alignment: 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }
  }

  void open(Map<String, dynamic> item) {
    if (item['_table'] == 'gift_ideas') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GiftDetailPage(gift: item)),
      );
    } else if (item['_table'] == 'content_items') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContentDetailPage(item: item)),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text((item['name'] ?? 'Festive find').toString()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    item['address'],
                    item['city'],
                    item['region'],
                  ].where((v) => v != null).join(', '),
                ),
                const SizedBox(height: 8),
                Text((item['description'] ?? '').toString()),
                const SizedBox(height: 8),
                Text(
                  (item['cost_text'] ?? 'Check details with organiser')
                      .toString(),
                ),
                if (item['start_at'] != null || item['start_date'] != null)
                  Text('From: ${item['start_at'] ?? item['start_date']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            if ((item['website_url'] ?? '').toString().isNotEmpty)
              TextButton(
                onPressed: () async {
                  final uri = Uri.tryParse(item['website_url'].toString());
                  if (uri != null && ['http', 'https'].contains(uri.scheme)) {
                    try {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (_) {}
                  }
                },
                child: const Text('Website'),
              ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.sizeOf(context).height * .9,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        20, 16, 20, MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/elf_phillie.webp'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Hi, I’m Elf Phillie!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                tooltip: 'Close Elf Phillie',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView(
                key: const ValueKey('elf-support-scroll'),
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(right: 8, bottom: 24),
                children: [
                  const Text(
                    'Your automated Christmas helper. I find gifts, ideas, events and lights from our published guide.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final prompt in [
                        'Gifts under \$50',
                        'Christchurch events this weekend',
                        'Free family activities',
                        'Christmas lights',
                        'NZ-made gifts',
                      ])
                        ActionChip(
                          label: Text(prompt),
                          onPressed: busy ? null : () => ask(prompt),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: question,
                    onSubmitted: busy ? null : (_) => ask(),
                    decoration: const InputDecoration(
                      labelText: 'What are you looking for?',
                      hintText: 'Gifts for Mum under \$50',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: busy ? null : () => ask(),
                    child: Text(busy ? 'Finding ideas…' : 'Ask Elf Phillie ✨'),
                  ),
                  const SizedBox(height: 12),
                  if (answer != null)
                    Column(
                      key: resultsKey,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(answer!),
                        ),
                        for (final item in matches)
                          Card(
                            child: ListTile(
                              leading: SizedBox(
                                width: 56,
                                height: 56,
                                child: EditorialImage(
                                  url: item['image_url']?.toString(),
                                  kind: item['_table'].toString(),
                                ),
                              ),
                              title: Text(
                                (item['title'] ?? item['name'] ?? 'Christmas idea').toString(),
                              ),
                              subtitle: Text(
                                item['_table'] == 'gift_ideas'
                                    ? 'NZ\$${item['price_min'] ?? '—'}'
                                    : (item['city'] ?? item['content_type'] ?? 'Christmas inspiration').toString(),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => open(item),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class EditorialImage extends StatelessWidget {
  final String? url;
  final String kind;
  final double? width, height;
  const EditorialImage({
    super.key,
    this.url,
    this.kind = 'ideas',
    this.width,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      'assets/christmas_hero.webp',
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
    if (url == null || url!.trim().isEmpty)
      return Stack(
        fit: StackFit.passthrough,
        children: [
          fallback,
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              color: const Color(0xAA173B36),
              padding: const EdgeInsets.all(3),
              child: const Text(
                'Inspiration',
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ],
      );
    return Image.network(
      url!,
      fit: BoxFit.cover,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class PhillieGuideCard extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const PhillieGuideCard({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF6),
        border: Border.all(color: const Color(0xFFE0D2B7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF3E5C3),
              border: Border.all(color: const Color(0xFFC69A3A), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/elf_phillie.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -.5),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF173B36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12.5, height: 1.35),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .8,
                        color: Color(0xFFA80F24),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Shell extends StatefulWidget {
  final String name;
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  const Shell({
    super.key,
    required this.name,
    required this.theme,
    required this.onThemeChanged,
  });

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
      floatingActionButton: const PhillieButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFFCF6),
        selectedItemColor: const Color(0xFFA80F24),
        unselectedItemColor: const Color(0xFF77736D),
        elevation: 2,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            activeIcon: Icon(Icons.place),
            label: 'Near Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String name;
  final ValueChanged<int> goTo;
  const HomePage({super.key, required this.name, required this.goTo});

  int daysUntilChristmas() {
    final now = DateTime.now();
    var target = DateTime(now.year, 12, 25);
    if (now.isAfter(target)) target = DateTime(now.year + 1, 12, 25);
    return target.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Future<List<Map<String, dynamic>>> featuredGifts() async {
    final rows = await Supabase.instance.client
        .from('gift_ideas')
        .select(
          'id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored',
        )
        .eq('status', 'published')
        .order('featured', ascending: false)
        .limit(6);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<List<Map<String, dynamic>>> latestIdeas() async {
    final rows = await Supabase.instance.client
        .from('content_items')
        .select(
          'id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label',
        )
        .eq('status', 'published')
        .order('featured', ascending: false)
        .limit(4);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<Map<String, dynamic>?> dailyIdea() async {
    final now = DateTime.now();
    final date = now.toIso8601String().substring(0, 10);
    final scheduled = await Supabase.instance.client
        .from('content_items')
        .select(
          'id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label,idea_of_day_date',
        )
        .eq('status', 'published')
        .eq('idea_of_day_date', date)
        .limit(1);
    final scheduledRows = List<Map<String, dynamic>>.from(scheduled);
    if (scheduledRows.isNotEmpty) return scheduledRows.first;

    final rows = await Supabase.instance.client
        .from('content_items')
        .select(
          'id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label,idea_of_day_date',
        )
        .eq('status', 'published')
        .order('created_at', ascending: true)
        .limit(100);
    final items = List<Map<String, dynamic>>.from(rows);
    if (items.isEmpty) return null;
    final start = DateTime(now.year, 1, 1);
    final day = now.difference(start).inDays;
    return items[day % items.length];
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 10, 12),
          child: Row(
            children: [
              const Text(
                '✦',
                style: TextStyle(color: Color(0xFFC69A3A), fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Christmas Ideas NZ',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => goTo(4),
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 330,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/christmas_hero.webp', fit: BoxFit.cover),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0x99000000), Color(0x11000000)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✦  MAKE THIS CHRISTMAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'More\nMeaningful',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 46,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 230,
                      child: Text(
                        'Inspiration, gifts, food, events and ideas for a brighter Christmas in New Zealand.',
                        style: TextStyle(color: Colors.white, height: 1.3),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFCF6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${daysUntilChristmas()}',
                            style: GoogleFonts.playfairDisplay(fontSize: 26),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'DAYS UNTIL\nCHRISTMAS',
                            style: TextStyle(fontSize: 9, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<Map<String, dynamic>?>(
          future: dailyIdea(),
          builder: (context, snap) {
            final item = snap.data;
            if (item == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContentDetailPage(item: item),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '✦ IDEA OF THE DAY',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                  color: Color(0xFFA80F24),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item['title']}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 21,
                                  fontStyle: FontStyle.italic,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item['summary'] ?? ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'VIEW IDEA →',
                                style: TextStyle(
                                  color: Color(0xFFA80F24),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: EditorialImage(
                            url: item['image_url']?.toString(),
                            width: 125,
                            height: 160,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _SectionHeading(
          title: 'Featured Gifts',
          action: 'See all',
          onTap: () => goTo(1),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: featuredGifts(),
          builder: (context, snap) =>
              editorialRail(context, snap.data ?? [], true),
        ),
        const SizedBox(height: 22),
        _SectionHeading(
          title: 'Christmas Ideas',
          action: 'See all',
          onTap: () => goTo(1),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: latestIdeas(),
          builder: (context, snap) =>
              editorialRail(context, snap.data ?? [], false),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
          child: PhillieGuideCard(
            title: 'Hi, I’m Elf Phillie!',
            message: 'Find gifts, lights, events and Christmas inspiration in our guide.',
            actionLabel: 'Ask Elf Phillie ✨',
            onAction: () => showElf(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(
                'Christmas near you',
                style: GoogleFonts.playfairDisplay(fontSize: 22),
              ),
              subtitle: const Text('Lights, markets, Santa visits and more'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => goTo(2),
            ),
          ),
        ),
      ],
    ),
  );

  Widget editorialRail(
    BuildContext context,
    List<Map<String, dynamic>> items,
    bool gifts,
  ) {
    if (items.isEmpty)
      return const Padding(
        padding: EdgeInsets.all(18),
        child: Text('More Christmas inspiration is on its way.'),
      );
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, i) {
          final item = items[i];
          return SizedBox(
            width: 125,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => gifts
                        ? GiftDetailPage(gift: item)
                        : ContentDetailPage(item: item),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditorialImage(
                      url: item['image_url']?.toString(),
                      width: 125,
                      height: 116,
                      kind: gifts ? 'gift' : 'idea',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${item['title']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontSize: 24),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              action.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: .8,
              ),
            ),
          ),
        ],
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
  String recipient = 'All';
  double maxBudget = 250;
  bool nzMadeOnly = false;

  Future<List<Map<String, dynamic>>> loadGifts() async {
    final rows = await Supabase.instance.client
        .from('gift_ideas')
        .select(
          'id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored',
        )
        .eq('status', 'published')
        .order('featured', ascending: false)
        .limit(200);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<List<Map<String, dynamic>>> loadContent() async {
    final rows = await Supabase.instance.client
        .from('content_items')
        .select(
          'id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label',
        )
        .eq('status', 'published')
        .order('featured', ascending: false)
        .limit(40);
    return List<Map<String, dynamic>>.from(rows);
  }

  Widget recipientTab(String value) {
    final selected = recipient == value;
    return InkWell(
      onTap: () => setState(() => recipient = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFA80F24) : const Color(0xFFFFFCF6),
          border: Border.all(
            color: selected ? const Color(0xFF0F4C45) : const Color(0xFFCFC5B5),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF343936),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          Text('Discover', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          const Text(
            'GIFTS, IDEAS, RECIPES AND MORE FOR A BRIGHTER CHRISTMAS.',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: Color(0xFF6B6F6C),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (v) => setState(() => q = v.toLowerCase()),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search gifts and Christmas ideas',
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF173B36),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gift Finder',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Thoughtful finds for everyone on your list.',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.card_giftcard_outlined,
                  color: Color(0xFFC69A3A),
                  size: 34,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                        'All',
                        'Kids',
                        'Teens',
                        'Her',
                        'Him',
                        'Grandparents',
                        'Teachers',
                        'Secret Santa',
                      ]
                      .map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: recipientTab(r),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text(
                'Budget',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                'Up to NZ\$' + maxBudget.round().toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8B6F2E),
                ),
              ),
            ],
          ),
          Slider(
            value: maxBudget,
            min: 20,
            max: 500,
            divisions: 24,
            onChanged: (v) => setState(() => maxBudget = v),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Only show NZ-made gifts',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Switch(
                value: nzMadeOnly,
                onChanged: (v) => setState(() => nzMadeOnly = v),
              ),
            ],
          ),
          const Divider(height: 30),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: loadGifts(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return const LinearProgressIndicator();
              var gifts = snap.data ?? [];
              gifts = gifts.where((g) {
                final title = (g['title'] ?? '').toString().toLowerCase();
                final desc = (g['description'] ?? '').toString().toLowerCase();
                final rec = (g['recipient_group'] ?? '').toString();
                final pmin =
                    double.tryParse((g['price_min'] ?? '0').toString()) ?? 0;
                return (q.isEmpty || title.contains(q) || desc.contains(q)) &&
                    (recipient == 'All' ||
                        rec.toLowerCase() == recipient.toLowerCase()) &&
                    pmin <= maxBudget &&
                    (!nzMadeOnly || g['nz_made'] == true);
              }).toList();
              if (gifts.isEmpty)
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('No gifts match those filters yet.'),
                );
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 245,
                ),
                itemCount: gifts.length,
                itemBuilder: (context, i) {
                  final g = gifts[i];
                  return Card(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GiftDetailPage(gift: g),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 145,
                            width: double.infinity,
                            child: EditorialImage(
                              url: g['image_url']?.toString(),
                              kind: 'gift',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${g['title']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 16,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'NZ\$${g['price_min'] ?? '—'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (g['nz_made'] == true)
                                  const Text(
                                    'NZ Made',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF0F4C45),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            'Christmas Ideas',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: loadContent(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return const LinearProgressIndicator();
              var items = snap.data ?? [];
              items = items.where((item) {
                final hay =
                    ((item['title'] ?? '').toString() +
                            ' ' +
                            (item['summary'] ?? '').toString() +
                            ' ' +
                            (item['body'] ?? '').toString())
                        .toLowerCase();
                return q.isEmpty || hay.contains(q);
              }).toList();
              return Column(
                children: items.map((item) {
                  final image = (item['image_url'] ?? '').toString();
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentDetailPage(item: item),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFCF6),
                        border: Border.all(color: const Color(0xFFE4DCCF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 145,
                            width: double.infinity,
                            child: EditorialImage(url: image),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (item['content_type'] ?? 'IDEA')
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.1,
                                    color: Color(0xFF8B6F2E),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  (item['title'] ?? 'Christmas idea')
                                      .toString(),
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF173B36),
                                  ),
                                ),
                                if ((item['summary'] ?? '')
                                    .toString()
                                    .isNotEmpty) ...[
                                  const SizedBox(height: 5),
                                  Text(
                                    (item['summary'] ?? '').toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12.5),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                const Text(
                                  'READ MORE  →',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .8,
                                    color: Color(0xFFA80F24),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> saveItemToBoard(
  BuildContext context,
  String itemType,
  dynamic itemId,
) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in from Me to save this.')),
    );
    return;
  }
  final rows = await Supabase.instance.client
      .from('boards')
      .select('id,name')
      .eq('user_id', user.id)
      .order('created_at');
  final boards = List<Map<String, dynamic>>.from(rows);
  if (boards.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create a Saved board first.')),
      );
    }
    return;
  }
  if (!context.mounted) return;
  final boardId = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          const ListTile(
            title: Text(
              'Save to board',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          ...boards.map(
            (b) => ListTile(
              leading: const Text('🎄'),
              title: Text((b['name'] ?? 'Board').toString()),
              onTap: () => Navigator.pop(ctx, b['id'].toString()),
            ),
          ),
        ],
      ),
    ),
  );
  if (boardId == null) return;
  try {
    await Supabase.instance.client.from('board_items').insert({
      'board_id': boardId,
      'item_type': itemType,
      'item_id': itemId,
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved to board ❤️')));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already saved, or unable to save right now.'),
        ),
      );
    }
  }
}

class GiftDetailPage extends StatelessWidget {
  final Map<String, dynamic> gift;
  const GiftDetailPage({super.key, required this.gift});

  Future<void> openLink(BuildContext context) async {
    final raw = (gift['affiliate_url'] ?? gift['product_url'] ?? '').toString();
    final uri = Uri.tryParse(raw);
    if (uri == null ||
        raw.isEmpty ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Retailer link is not available yet.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final price =
        'NZ\$' +
        (gift['price_min'] ?? '').toString() +
        (gift['price_max'] != null &&
                gift['price_max'].toString() != gift['price_min'].toString()
            ? '–' + gift['price_max'].toString()
            : '');
    final image = (gift['image_url'] ?? '').toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        elevation: 0,
        title: const Text('Gift idea'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (image.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _giftHero(),
              ),
            )
          else
            _giftHero(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (gift['sponsored'] == true)
                  const Text(
                    'SPONSORED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                      color: Color(0xFF8B6F2E),
                    ),
                  ),
                Text(
                  (gift['title'] ?? 'Gift idea').toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaTag((gift['recipient_group'] ?? 'Gift').toString()),
                    _MetaTag(price),
                    if (gift['nz_made'] == true) const _MetaTag('NZ made'),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  (gift['description'] ?? '').toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            saveItemToBoard(context, 'gift', gift['id']),
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => openLink(context),
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: Text(
                          (gift['affiliate_url'] ?? '').toString().isNotEmpty
                              ? 'Shop gift'
                              : 'View retailer',
                        ),
                      ),
                    ),
                  ],
                ),
                if ((gift['affiliate_url'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Some links may earn Christmas Ideas NZ a commission at no extra cost to you.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF77736D),
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _giftHero() => const SizedBox(
    height: 220,
    width: double.infinity,
    child: EditorialImage(kind: 'gift'),
  );
}

class _MetaTag extends StatelessWidget {
  final String text;
  const _MetaTag(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFCF6),
      border: Border.all(color: const Color(0xFFD9D1C4)),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
    ),
  );
}

class ContentDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const ContentDetailPage({super.key, required this.item});

  Future<void> openExternal() async {
    final raw = (item['external_url'] ?? '').toString();
    final uri = Uri.tryParse(raw);
    if (uri != null && raw.isNotEmpty) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = (item['image_url'] ?? '').toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        elevation: 0,
        title: const Text('Christmas idea'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (image.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ideaHero(),
              ),
            )
          else
            _ideaHero(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item['content_type'] ?? 'IDEA').toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3,
                    color: Color(0xFF8B6F2E),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  (item['title'] ?? 'Christmas idea').toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if ((item['summary'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    (item['summary'] ?? '').toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  (item['body'] ?? item['summary'] ?? '').toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            saveItemToBoard(context, 'content', item['id']),
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('Save'),
                      ),
                    ),
                    if ((item['external_url'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: openExternal,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Open link'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ideaHero() => const SizedBox(
    height: 220,
    width: double.infinity,
    child: EditorialImage(),
  );
}

class NearMePage extends StatefulWidget {
  const NearMePage({super.key});
  @override
  State<NearMePage> createState() => _NearMePageState();
}

class _NearMePageState extends State<NearMePage> {
  final search = TextEditingController();
  String category = 'All';
  String region = 'All';
  String city = 'All';
  String when = 'Any time';
  String cost = 'All';
  DateTime? chosenDate;
  late Future<List<Map<String, dynamic>>> listings;

  @override
  void initState() {
    super.initState();
    listings = load();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> load() async {
    final rows = await Future.wait([
      Supabase.instance.client
          .from('events')
          .select(
            'id,name,image_url,description,city,region,address,start_at,end_at,website_url,event_type,cost_text',
          )
          .eq('status', 'published')
          .order('name'),
      Supabase.instance.client
          .from('light_displays')
          .select(
            'id,name,image_url,description,city,region,address,start_date,end_date,website_url,cost_text',
          )
          .eq('status', 'published')
          .order('name'),
      Supabase.instance.client
          .from('businesses')
          .select(
            'id,name,image_url,description,city,region,address,website_url,business_type',
          )
          .eq('status', 'published')
          .order('name'),
    ]);
    final all = <Map<String, dynamic>>[
      ...List<Map<String, dynamic>>.from(rows[0])
          .map((e) => {...e, '_type': 'Event'}),
      ...List<Map<String, dynamic>>.from(rows[1])
          .map((e) => {...e, '_type': 'Lights'}),
      ...List<Map<String, dynamic>>.from(rows[2])
          .map((e) => {...e, '_type': 'Store'}),
    ];
    all.sort(
      (a, b) =>
          (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()),
    );
    return all;
  }

  Future<void> chooseWhen(String value) async {
    if (value == 'Choose a date') {
      final date = await showDatePicker(
        context: context,
        initialDate: chosenDate ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (date == null || !mounted) return;
      setState(() {
        chosenDate = date;
        when = value;
      });
    } else {
      setState(() => when = value);
    }
  }

  String dateText(DateTime value) =>
      '${value.day}/${value.month}/${value.year}';
  String datesLabel(Map<String, dynamic> item) {
    if (item['_type'] == 'Store') return 'Check website for opening hours';
    final start = listingStart(item);
    if (start == null) return 'Dates to be confirmed';
    final end = listingEnd(item);
    return end == null || dateText(start) == dateText(end)
        ? dateText(start)
        : '${dateText(start)} – ${dateText(end)}';
  }

  Future<void> openDirections(Map<String, dynamic> item) async {
    final address = (item['address'] ?? '').toString().trim();
    if (address.isEmpty) return;
    final destination = [
      address,
      item['city'],
      item['region'],
      'New Zealand',
    ].where((v) => v != null && v.toString().trim().isNotEmpty).join(', ');
    try {
      final ok = await launchUrl(
        Uri.https('www.google.com', '/maps/dir/', {
          'api': '1',
          'destination': destination,
        }),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) throw Exception('Maps unavailable');
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open maps. Please try again.'),
          ),
        );
    }
  }

  Future<void> openWebsite(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !['http', 'https'].contains(uri.scheme)) return;
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication))
        throw Exception('Website unavailable');
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this website.')),
        );
    }
  }

  Future<void> reportIssue(Map<String, dynamic> item) async {
    final issue = TextEditingController();
    final email = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report an issue'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (item['name'] ?? 'Christmas listing').toString(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: issue,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'What needs correcting?',
                  hintText:
                      'Wrong date, location, closed store, duplicate listing…',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                ),
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
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (ok != true || issue.text.trim().isEmpty) return;
    try {
      await Supabase.instance.client.from('support_tickets').insert({
        'email': email.text.trim().isEmpty ? null : email.text.trim(),
        'message':
            '[LISTING ISSUE] ' +
            (item['name'] ?? 'Christmas listing').toString() +
            ' | ' +
            (item['city'] ?? '').toString() +
            ', ' +
            (item['region'] ?? '').toString() +
            ' | ' +
            (item['_type'] ?? '').toString() +
            '\n' +
            issue.text.trim(),
      });
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanks — your correction has been sent.'),
          ),
        );
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not send that just now. Please try again.'),
          ),
        );
    }
  }

  Widget filterDropdown(
    String label,
    String value,
    List<String> values,
    ValueChanged<String> changed,
  ) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: values
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Text(
                    v == 'All'
                        ? (label == 'Region'
                              ? 'All regions'
                              : label == 'City / town'
                              ? 'All cities / towns'
                              : label == 'Category'
                              ? 'All categories'
                              : 'All entry costs')
                        : v,
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) changed(v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: listings,
        builder: (context, snap) {
          final all = snap.data ?? <Map<String, dynamic>>[];
          final regions =
              all
                  .map((e) => (e['region'] ?? '').toString())
                  .where((v) => v.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort();
          final cities =
              all
                  .where((e) => region == 'All' || e['region'] == region)
                  .map((e) => (e['city'] ?? '').toString())
                  .where((v) => v.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort();
          final items = filterListings(
            all,
            region: region,
            city: city,
            category: category,
            when: when,
            cost: cost,
            query: search.text,
            now: DateTime.now(),
            chosenDate: chosenDate,
          );
          final active =
              region != 'All' ||
              city != 'All' ||
              category != 'All' ||
              when != 'Any time' ||
              cost != 'All' ||
              search.text.isNotEmpty;
          return RefreshIndicator(
            onRefresh: () async {
              final next = load();
              setState(() => listings = next);
              await next;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                const Text(
                  'EXPLORE YOUR AREA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                    color: Color(0xFF8B6F2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Christmas Near You',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 6),
                const Text('Find festive things by area, date and category.'),
                const SizedBox(height: 16),
                TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search a place, event or address',
                  ),
                ),
                const SizedBox(height: 12),
                filterDropdown(
                  'Region',
                  regions.contains(region) ? region : 'All',
                  ['All', ...regions],
                  (v) => setState(() {
                    region = v;
                    city = 'All';
                  }),
                ),
                const SizedBox(height: 12),
                filterDropdown(
                  'City / town',
                  cities.contains(city) ? city : 'All',
                  ['All', ...cities],
                  (v) => setState(() => city = v),
                ),
                const SizedBox(height: 12),
                filterDropdown('Category', category, [
                  'All',
                  'Lights',
                  'Events / Markets',
                  'Santa Visits',
                  'Christmas Shops',
                ], (v) => setState(() => category = v)),
                const SizedBox(height: 12),
                filterDropdown('When', when, [
                  'Any time',
                  'Today',
                  'This weekend',
                  'Choose a date',
                ], chooseWhen),
                if (when == 'Choose a date')
                  TextButton.icon(
                    onPressed: () => chooseWhen('Choose a date'),
                    icon: const Icon(Icons.calendar_month),
                    label: Text(dateText(chosenDate!)),
                  ),
                const SizedBox(height: 12),
                filterDropdown('Entry cost', cost, [
                  'All',
                  'Free',
                  'Paid',
                ], (v) => setState(() => cost = v)),
                if (cost != 'All' || when != 'Any time')
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Only listings with matching recorded dates or entry costs are shown.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                if (active)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() {
                        region = 'All';
                        city = 'All';
                        category = 'All';
                        when = 'Any time';
                        cost = 'All';
                        chosenDate = null;
                        search.clear();
                      }),
                      child: const Text('Clear filters'),
                    ),
                  ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Festive finds',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      '${items.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF8B6F2E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (snap.connectionState == ConnectionState.waiting)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (snap.hasError)
                  Column(
                    children: [
                      const Text('Could not load listings. Please try again.'),
                      TextButton(
                        onPressed: () => setState(() => listings = load()),
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                else if (items.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        'No listings match yet. Try another area, date or category.',
                      ),
                    ),
                  )
                else
                  ...items.map((e) {
                    final address = (e['address'] ?? '').toString().trim();
                    final url = (e['website_url'] ?? '').toString().trim();
                    final location = [e['city'], e['region']]
                        .where((v) => v != null && v.toString().isNotEmpty)
                        .join(', ');
                    final entry = (e['cost_text'] ?? '').toString().trim();
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 145,
                              child: ListingPhoto(item: e),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              listingCategory(e),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF8B6F2E),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (e['name'] ?? 'Christmas listing').toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address.isEmpty
                                  ? (location.isEmpty
                                        ? 'Address to be confirmed'
                                        : location)
                                  : '$address${location.isEmpty ? '' : ', $location'}',
                            ),
                            const SizedBox(height: 5),
                            Text(datesLabel(e)),
                            const SizedBox(height: 5),
                            Text(
                              e['_type'] == 'Store'
                                  ? 'Christmas shopping'
                                  : entry.isEmpty
                                  ? 'Check entry cost with organiser'
                                  : entry,
                            ),
                            if ((e['description'] ?? '')
                                .toString()
                                .trim()
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  e['description'].toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (address.isNotEmpty)
                                  OutlinedButton.icon(
                                    onPressed: () => openDirections(e),
                                    icon: const Icon(
                                      Icons.directions_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Get directions'),
                                  ),
                                if (url.isNotEmpty)
                                  TextButton.icon(
                                    onPressed: () => openWebsite(url),
                                    icon: const Icon(
                                      Icons.open_in_new,
                                      size: 16,
                                    ),
                                    label: const Text('Details / Website'),
                                  ),
                                TextButton.icon(
                                  onPressed: () => reportIssue(e),
                                  icon: const Icon(
                                    Icons.flag_outlined,
                                    size: 16,
                                  ),
                                  label: const Text('Report issue'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
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

  Future<List<Map<String, dynamic>>> loadBoards() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    final rows = await Supabase.instance.client
        .from('boards')
        .select('id,name,emoji,created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> createBoard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sign in from Me first.')));
      return;
    }
    final name = boardName.text.trim();
    if (name.isEmpty) return;
    await Supabase.instance.client.from('boards').insert({
      'user_id': user.id,
      'name': name,
      'emoji': '✦',
    });
    boardName.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          const Text(
            'YOUR CHRISTMAS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
              color: Color(0xFF8B6F2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Saved Collections',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep the gifts, recipes and ideas you want to come back to.',
          ),
          const SizedBox(height: 16),
          const PhillieGuideCard(
            title: 'Elf Phillie’s tip',
            message: 'Use boards to keep Christmas organised. Try Gift Ideas, Christmas Dinner, Elf Ideas or Kids Activities — then tap Save on anything you want to keep.',
          ),
          const SizedBox(height: 22),
          if (user == null)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF6),
                border: Border.all(color: const Color(0xFFE4DCCF)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Sign in from Me to create boards and keep your favourite gifts and ideas across devices.',
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: boardName,
                    decoration: const InputDecoration(
                      hintText: 'New board name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: createBoard,
                  child: const Text('Create'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: loadBoards(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                final boards = snap.data ?? [];
                if (boards.isEmpty)
                  return const Text(
                    'No boards yet. Try “Gift Ideas”, “Christmas Dinner” or “Elf Ideas”.',
                  );
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.15,
                  children: boards
                      .map(
                        (b) => InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BoardDetailPage(board: b),
                            ),
                          ).then((_) => setState(() {})),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFCF6),
                              border: Border.all(
                                color: const Color(0xFFE4DCCF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.bookmark_outline,
                                      color: Color(0xFFA80F24),
                                    ),
                                    const Spacer(),
                                    Text(
                                      (b['emoji'] ?? '✦').toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  (b['name'] ?? 'Board').toString(),
                                  style: GoogleFonts.playfairDisplay(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19,
                                    color: const Color(0xFF173B36),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'OPEN COLLECTION  →',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .7,
                                    color: Color(0xFF8B6F2E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class BoardDetailPage extends StatefulWidget {
  final Map<String, dynamic> board;
  const BoardDetailPage({super.key, required this.board});
  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  Future<List<Map<String, dynamic>>> loadItems() async {
    final rows = await Supabase.instance.client
        .from('board_items')
        .select('id,item_type,item_id,created_at')
        .eq('board_id', widget.board['id'])
        .order('created_at', ascending: false);
    final items = List<Map<String, dynamic>>.from(rows);
    final out = <Map<String, dynamic>>[];
    for (final row in items) {
      final type = (row['item_type'] ?? '').toString();
      final itemId = row['item_id'];
      if (type == 'gift') {
        final data = await Supabase.instance.client
            .from('gift_ideas')
            .select(
              'id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored',
            )
            .eq('id', itemId)
            .maybeSingle();
        if (data != null)
          out.add({
            ...Map<String, dynamic>.from(data),
            '_board_item_id': row['id'],
            '_type': 'gift',
          });
      } else if (type == 'content') {
        final data = await Supabase.instance.client
            .from('content_items')
            .select(
              'id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label',
            )
            .eq('id', itemId)
            .maybeSingle();
        if (data != null)
          out.add({
            ...Map<String, dynamic>.from(data),
            '_board_item_id': row['id'],
            '_type': 'content',
          });
      }
    }
    return out;
  }

  Future<void> removeItem(dynamic id) async {
    await Supabase.instance.client.from('board_items').delete().eq('id', id);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        title: Text((widget.board['name'] ?? 'Saved board').toString()),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadItems(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty)
            return const Padding(
              padding: EdgeInsets.all(20),
              child: PhillieGuideCard(
                title: 'This board is ready',
                message: 'Nothing saved here yet. Open a gift or Christmas idea and tap Save — I’ll keep it here for you.',
              ),
            );
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final item = items[i];
              final isGift = item['_type'] == 'gift';
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isGift
                        ? GiftDetailPage(gift: item)
                        : ContentDetailPage(item: item),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCF6),
                    border: Border.all(color: const Color(0xFFE4DCCF)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: (item['image_url'] ?? '').toString().isNotEmpty
                            ? Image.network(
                                (item['image_url'] ?? '').toString(),
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 54,
                                  height: 54,
                                  color: isGift
                                      ? const Color(0xFFECE4D7)
                                      : const Color(0xFF9E1B32),
                                  child: Icon(
                                    isGift
                                        ? Icons.card_giftcard
                                        : Icons.star_outline,
                                    color: isGift
                                        ? const Color(0xFF0F4C45)
                                        : Colors.white,
                                  ),
                                ),
                              )
                            : Container(
                                width: 54,
                                height: 54,
                                color: isGift
                                    ? const Color(0xFFECE4D7)
                                    : const Color(0xFF9E1B32),
                                child: Icon(
                                  isGift
                                      ? Icons.card_giftcard
                                      : Icons.star_outline,
                                  color: isGift
                                      ? const Color(0xFF0F4C45)
                                      : Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (item['title'] ?? 'Saved item').toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isGift ? 'Gift idea' : 'Christmas idea',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF77736D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        onPressed: () => removeItem(item['_board_item_id']),
                        icon: const Icon(Icons.close, size: 19),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
  String? region;
  static const regions = [
    'Northland',
    'Auckland',
    'Waikato',
    'Bay of Plenty',
    'Gisborne',
    'Hawke’s Bay',
    'Taranaki',
    'Manawatū-Whanganui',
    'Wellington',
    'Tasman',
    'Nelson',
    'Marlborough',
    'West Coast',
    'Canterbury',
    'Otago',
    'Southland',
    'Chatham Islands',
    'Nationwide / Online',
  ];
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
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await Supabase.instance.client.from('submissions').insert({
        'user_id': user.id,
        'submission_type': type,
        'title': title.text.trim(),
        'description': description.text.trim(),
        'payload': {'city': city.text.trim(), 'region': region},
        'status': 'pending',
      });
      title.clear();
      description.clear();
      city.clear();
      message = 'Thanks — it is now waiting for approval.';
    } catch (e) {
      message = 'Could not submit. Please try again.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        elevation: 0,
        title: const Text('Submit a Christmas find'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Text(
            'Add something festive',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Help make Christmas Ideas NZ more useful for families around Aotearoa.',
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(
              labelText: 'What are you adding?',
            ),
            items: const [
              DropdownMenuItem(value: 'event', child: Text('Event / Market')),
              DropdownMenuItem(value: 'light', child: Text('Christmas Lights')),
              DropdownMenuItem(
                value: 'business',
                child: Text('NZ Christmas Business'),
              ),
              DropdownMenuItem(value: 'idea', child: Text('Christmas Idea')),
            ],
            onChanged: (v) => setState(() => type = v ?? 'event'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Title / Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: description,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: city,
            decoration: const InputDecoration(labelText: 'City or town'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: region,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Region'),
            hint: const Text('Select a region'),
            items: regions
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: busy ? null : (v) => setState(() => region = v),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(message!),
            ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: busy ? null : submit,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(busy ? 'Submitting…' : 'Send for approval'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminContentEditorPage extends StatefulWidget {
  const AdminContentEditorPage({super.key});
  @override
  State<AdminContentEditorPage> createState() => _AdminContentEditorPageState();
}

class _AdminContentEditorPageState extends State<AdminContentEditorPage> {
  bool showGifts = true;

  Future<List<Map<String, dynamic>>> loadItems() async {
    if (showGifts) {
      final rows = await Supabase.instance.client
          .from('gift_ideas')
          .select(
            'id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored,status',
          )
          .order('title');
      return List<Map<String, dynamic>>.from(rows);
    }
    final rows = await Supabase.instance.client
        .from('content_items')
        .select(
          'id,title,summary,body,image_url,external_url,content_type,featured,sponsored,status,idea_of_day_date',
        )
        .order('title');
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        title: const Text('Content Editor'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Gifts'),
                  icon: Icon(Icons.card_giftcard_outlined),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Ideas'),
                  icon: Icon(Icons.auto_awesome_outlined),
                ),
              ],
              selected: {showGifts},
              onSelectionChanged: (s) => setState(() => showGifts = s.first),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: loadItems(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                final items = snap.data ?? [];
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final image = (item['image_url'] ?? '').toString();
                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => showGifts
                                ? AdminGiftEditPage(item: item)
                                : AdminIdeaEditPage(item: item),
                          ),
                        );
                        if (mounted) setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCF6),
                          border: Border.all(color: const Color(0xFFE4DCCF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: image.isNotEmpty
                                  ? Image.network(
                                      image,
                                      width: 58,
                                      height: 58,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _editorPlaceholder(showGifts),
                                    )
                                  : _editorPlaceholder(showGifts),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (item['title'] ?? 'Untitled').toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    showGifts
                                        ? ((item['recipient_group'] ?? 'Gift')
                                                  .toString() +
                                              ' · ' +
                                              (item['status'] ?? '').toString())
                                        : ((item['content_type'] ?? 'Idea')
                                                  .toString() +
                                              ' · ' +
                                              (item['status'] ?? '')
                                                  .toString()),
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF77736D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.edit_outlined,
                              color: Color(0xFF173B36),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _editorPlaceholder(bool gift) => Container(
    width: 58,
    height: 58,
    color: gift ? const Color(0xFFECE4D7) : const Color(0xFFA80F24),
    child: Icon(
      gift ? Icons.card_giftcard : Icons.auto_awesome,
      color: gift ? const Color(0xFF0F4C45) : Colors.white,
    ),
  );
}

mixin _AdminImageUpload<T extends StatefulWidget> on State<T> {
  final ImagePicker adminPicker = ImagePicker();

  Future<String?> chooseAndUploadImage(String folder, dynamic id) async {
    final picked = await adminPicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1800,
    );
    if (picked == null) return null;
    final ext = picked.name.contains('.')
        ? picked.name.split('.').last.toLowerCase()
        : 'jpg';
    final path =
        'admin/' +
        folder +
        '/' +
        id.toString() +
        '_' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        ext;
    await Supabase.instance.client.storage
        .from('content-images')
        .upload(
          path,
          File(picked.path),
          fileOptions: const FileOptions(upsert: true),
        );
    return Supabase.instance.client.storage
        .from('content-images')
        .getPublicUrl(path);
  }
}

class AdminGiftEditPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const AdminGiftEditPage({super.key, required this.item});
  @override
  State<AdminGiftEditPage> createState() => _AdminGiftEditPageState();
}

class _AdminGiftEditPageState extends State<AdminGiftEditPage>
    with _AdminImageUpload<AdminGiftEditPage> {
  late final TextEditingController title;
  late final TextEditingController description;
  late final TextEditingController imageUrl;
  late final TextEditingController recipient;
  late final TextEditingController priceMin;
  late final TextEditingController priceMax;
  late final TextEditingController productUrl;
  late final TextEditingController affiliateUrl;
  late bool nzMade;
  late bool featured;
  late bool sponsored;
  late bool published;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    final x = widget.item;
    title = TextEditingController(text: (x['title'] ?? '').toString());
    description = TextEditingController(
      text: (x['description'] ?? '').toString(),
    );
    imageUrl = TextEditingController(text: (x['image_url'] ?? '').toString());
    recipient = TextEditingController(
      text: (x['recipient_group'] ?? '').toString(),
    );
    priceMin = TextEditingController(text: (x['price_min'] ?? '').toString());
    priceMax = TextEditingController(text: (x['price_max'] ?? '').toString());
    productUrl = TextEditingController(
      text: (x['product_url'] ?? '').toString(),
    );
    affiliateUrl = TextEditingController(
      text: (x['affiliate_url'] ?? '').toString(),
    );
    nzMade = x['nz_made'] == true;
    featured = x['featured'] == true;
    sponsored = x['sponsored'] == true;
    published = (x['status'] ?? 'published') == 'published';
  }

  num? numberOrNull(String s) =>
      s.trim().isEmpty ? null : num.tryParse(s.trim());

  Future<void> save() async {
    if (title.text.trim().isEmpty) return;
    setState(() => busy = true);
    try {
      await Supabase.instance.client
          .from('gift_ideas')
          .update({
            'title': title.text.trim(),
            'description': description.text.trim().isEmpty
                ? null
                : description.text.trim(),
            'image_url': imageUrl.text.trim().isEmpty
                ? null
                : imageUrl.text.trim(),
            'recipient_group': recipient.text.trim().isEmpty
                ? null
                : recipient.text.trim(),
            'price_min': numberOrNull(priceMin.text),
            'price_max': numberOrNull(priceMax.text),
            'product_url': productUrl.text.trim().isEmpty
                ? null
                : productUrl.text.trim(),
            'affiliate_url': affiliateUrl.text.trim().isEmpty
                ? null
                : affiliateUrl.text.trim(),
            'nz_made': nzMade,
            'featured': featured,
            'sponsored': sponsored,
            'status': published ? 'published' : 'draft',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', widget.item['id']);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Gift updated ✓')));
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        title: const Text('Edit gift'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Gift title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: description,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: recipient,
            decoration: const InputDecoration(labelText: 'Recipient category'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceMin,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price from'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: priceMax,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price to'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: productUrl,
            decoration: const InputDecoration(
              labelText: 'Product / retailer link',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: affiliateUrl,
            decoration: const InputDecoration(labelText: 'Affiliate link'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: imageUrl,
            decoration: const InputDecoration(labelText: 'Photo URL'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: busy
                ? null
                : () async {
                    setState(() => busy = true);
                    try {
                      final url = await chooseAndUploadImage(
                        'gifts',
                        widget.item['id'],
                      );
                      if (url != null) setState(() => imageUrl.text = url);
                    } finally {
                      if (mounted) setState(() => busy = false);
                    }
                  },
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose a different photo'),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('NZ made'),
            value: nzMade,
            onChanged: (v) => setState(() => nzMade = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Featured'),
            value: featured,
            onChanged: (v) => setState(() => featured = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sponsored'),
            value: sponsored,
            onChanged: (v) => setState(() => sponsored = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Published'),
            value: published,
            onChanged: (v) => setState(() => published = v),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFA80F24),
            ),
            onPressed: busy ? null : save,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(busy ? 'Saving…' : 'Save changes'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminIdeaEditPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const AdminIdeaEditPage({super.key, required this.item});
  @override
  State<AdminIdeaEditPage> createState() => _AdminIdeaEditPageState();
}

class _AdminIdeaEditPageState extends State<AdminIdeaEditPage>
    with _AdminImageUpload<AdminIdeaEditPage> {
  late final TextEditingController title;
  late final TextEditingController summary;
  late final TextEditingController body;
  late final TextEditingController imageUrl;
  late final TextEditingController externalUrl;
  late String contentType;
  late bool featured;
  late bool sponsored;
  late bool published;
  bool busy = false;

  static const types = [
    'idea',
    'recipe',
    'elf',
    'wallpaper',
    'movie',
    'music',
    'activity',
    'decoration',
    'budget',
    'tradition',
    'work_christmas',
  ];

  @override
  void initState() {
    super.initState();
    final x = widget.item;
    title = TextEditingController(text: (x['title'] ?? '').toString());
    summary = TextEditingController(text: (x['summary'] ?? '').toString());
    body = TextEditingController(text: (x['body'] ?? '').toString());
    imageUrl = TextEditingController(text: (x['image_url'] ?? '').toString());
    externalUrl = TextEditingController(
      text: (x['external_url'] ?? '').toString(),
    );
    contentType = types.contains((x['content_type'] ?? 'idea').toString())
        ? (x['content_type'] ?? 'idea').toString()
        : 'idea';
    featured = x['featured'] == true;
    sponsored = x['sponsored'] == true;
    published = (x['status'] ?? 'published') == 'published';
  }

  Future<void> save() async {
    if (title.text.trim().isEmpty) return;
    setState(() => busy = true);
    try {
      await Supabase.instance.client
          .from('content_items')
          .update({
            'title': title.text.trim(),
            'summary': summary.text.trim().isEmpty ? null : summary.text.trim(),
            'body': body.text.trim().isEmpty ? null : body.text.trim(),
            'image_url': imageUrl.text.trim().isEmpty
                ? null
                : imageUrl.text.trim(),
            'external_url': externalUrl.text.trim().isEmpty
                ? null
                : externalUrl.text.trim(),
            'content_type': contentType,
            'featured': featured,
            'sponsored': sponsored,
            'status': published ? 'published' : 'draft',
            'published_at': published
                ? (widget.item['status'] == 'published'
                      ? widget.item['published_at']
                      : DateTime.now().toIso8601String())
                : null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', widget.item['id']);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Idea updated ✓')));
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        title: const Text('Edit idea'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: contentType,
            decoration: const InputDecoration(labelText: 'Type'),
            items: types
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.replaceAll('_', ' ')),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => contentType = v ?? 'idea'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: summary,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Short summary'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: body,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Main text / instructions',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: externalUrl,
            decoration: const InputDecoration(
              labelText: 'External link (optional)',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: imageUrl,
            decoration: const InputDecoration(labelText: 'Photo URL'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: busy
                ? null
                : () async {
                    setState(() => busy = true);
                    try {
                      final url = await chooseAndUploadImage(
                        'ideas',
                        widget.item['id'],
                      );
                      if (url != null) setState(() => imageUrl.text = url);
                    } finally {
                      if (mounted) setState(() => busy = false);
                    }
                  },
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choose a different photo'),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Featured / Elf Phillie pick eligible'),
            value: featured,
            onChanged: (v) => setState(() => featured = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sponsored'),
            value: sponsored,
            onChanged: (v) => setState(() => sponsored = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Published'),
            value: published,
            onChanged: (v) => setState(() => published = v),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFA80F24),
            ),
            onPressed: busy ? null : save,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(busy ? 'Saving…' : 'Save changes'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminMediaManagerPage extends StatefulWidget {
  const AdminMediaManagerPage({super.key});
  @override
  State<AdminMediaManagerPage> createState() => _AdminMediaManagerPageState();
}

class _AdminMediaManagerPageState extends State<AdminMediaManagerPage> {
  String table = 'gift_ideas';
  bool get showGifts => table == 'gift_ideas';
  bool get content => table == 'gift_ideas' || table == 'content_items';
  bool busy = false;
  final picker = ImagePicker();

  Future<List<Map<String, dynamic>>> loadItems() async {
    final rows = await Supabase.instance.client
        .from(table)
        .select()
        .order(content ? 'title' : 'name');
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<String?> uploadImage(dynamic id) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1800,
    );
    if (picked == null) return null;
    final ext = picked.name.contains('.')
        ? picked.name.split('.').last.toLowerCase()
        : 'jpg';
    final folder = table;
    final path =
        'admin/' +
        folder +
        '/' +
        id.toString() +
        '_' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        ext;
    await Supabase.instance.client.storage
        .from('content-images')
        .upload(
          path,
          File(picked.path),
          fileOptions: const FileOptions(upsert: true),
        );
    return Supabase.instance.client.storage
        .from('content-images')
        .getPublicUrl(path);
  }

  Future<void> editItem(Map<String, dynamic> item) async {
    final imageUrl = TextEditingController(
      text: (item['image_url'] ?? '').toString(),
    );
    final sourceUrl = TextEditingController(
      text: (item['image_source_url'] ?? '').toString(),
    );
    final credit = TextEditingController(
      text: (item['image_credit'] ?? '').toString(),
    );
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(
            'Image for ' + (item['title'] ?? item['name'] ?? 'item').toString(),
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: imageUrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: busy
                        ? null
                        : () async {
                            setLocal(() => busy = true);
                            try {
                              final uploaded = await uploadImage(item['id']);
                              if (uploaded != null) imageUrl.text = uploaded;
                            } finally {
                              setLocal(() => busy = false);
                            }
                          },
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      busy ? 'Uploading…' : 'Choose photo from gallery',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (content)
                    TextField(
                      controller: sourceUrl,
                      decoration: const InputDecoration(
                        labelText: 'Source/product page URL',
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (content)
                    TextField(
                      controller: credit,
                      decoration: const InputDecoration(
                        labelText: 'Image credit / permission note',
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'For retailer products, use approved retailer or affiliate imagery. For Elf and Secret Santa ideas, use your own, licensed or generated images.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF6B6F6C)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save image'),
            ),
          ],
        ),
      ),
    );
    if (saved != true || !mounted) return;
    setState(() => busy = true);
    try {
      await Supabase.instance.client
          .from(table)
          .update({
            'image_url': imageUrl.text.trim().isEmpty
                ? null
                : imageUrl.text.trim(),
            if (content)
              'image_source_url': sourceUrl.text.trim().isEmpty
                  ? null
                  : sourceUrl.text.trim(),
            if (content)
              'image_credit': credit.text.trim().isEmpty
                  ? null
                  : credit.text.trim(),
          })
          .eq('id', item['id']);
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save the photo. Please try again.'),
          ),
        );
    } finally {
      imageUrl.dispose();
      sourceUrl.dispose();
      credit.dispose();
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        title: const Text('Photos & Logos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: DropdownButtonFormField<String>(
              value: table,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Photos for'),
              items: const [
                DropdownMenuItem(value: 'gift_ideas', child: Text('Gifts')),
                DropdownMenuItem(
                  value: 'content_items',
                  child: Text('Ideas / Recipes'),
                ),
                DropdownMenuItem(value: 'events', child: Text('Events')),
                DropdownMenuItem(
                  value: 'light_displays',
                  child: Text('Light displays'),
                ),
                DropdownMenuItem(value: 'businesses', child: Text('Stores')),
              ],
              onChanged: busy
                  ? null
                  : (v) {
                      if (v != null) setState(() => table = v);
                    },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: loadItems(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                if (snap.hasError)
                  return const Center(
                    child: Text('Could not load photos. Please try again.'),
                  );
                final items = snap.data ?? [];
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final image = (item['image_url'] ?? '').toString();
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 7),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: image.isNotEmpty
                            ? Image.network(
                                image,
                                width: 58,
                                height: 58,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _mediaPlaceholder(),
                              )
                            : _mediaPlaceholder(),
                      ),
                      title: Text(
                        (item['title'] ?? item['name'] ?? 'Untitled')
                            .toString(),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        image.isEmpty ? 'No image yet' : 'Image connected',
                      ),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: () => editItem(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaPlaceholder() => Container(
    width: 58,
    height: 58,
    color: const Color(0xFFECE4D7),
    child: const Icon(Icons.image_outlined, color: Color(0xFF0F4C45)),
  );
}

class AdminCorrectionsPage extends StatefulWidget {
  const AdminCorrectionsPage({super.key});
  @override
  State<AdminCorrectionsPage> createState() => _AdminCorrectionsPageState();
}

class _AdminCorrectionsPageState extends State<AdminCorrectionsPage> {
  Future<List<Map<String, dynamic>>> load() async {
    final rows = await Supabase.instance.client
        .from('support_tickets')
        .select('id,email,message,status,created_at')
        .like('message', '[LISTING ISSUE]%')
        .order('created_at', ascending: false)
        .limit(200);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> close(dynamic id) async {
    await Supabase.instance.client
        .from('support_tickets')
        .update({
          'status': 'closed',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFF7F2E8),
      title: const Text('Listing Corrections'),
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: load(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        final items = snap.data ?? [];
        if (items.isEmpty)
          return const Center(child: Text('No listing corrections waiting.'));
        return ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final t = items[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF6),
                border: Border.all(color: const Color(0xFFE3D8C8)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'LISTING CORRECTION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: Color(0xFFA80F24),
                          ),
                        ),
                      ),
                      Text(
                        (t['status'] ?? 'open').toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (t['message'] ?? '').toString().replaceFirst(
                      '[LISTING ISSUE] ',
                      '',
                    ),
                  ),
                  if ((t['email'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Contact: ' + (t['email'] ?? '').toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF77736D),
                      ),
                    ),
                  ],
                  if ((t['status'] ?? '') != 'closed') ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: () => close(t['id']),
                        child: const Text('Mark resolved'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    ),
  );
}

class AdminSupportPage extends StatefulWidget {
  const AdminSupportPage({super.key});
  @override
  State<AdminSupportPage> createState() => _AdminSupportPageState();
}

class _AdminSupportPageState extends State<AdminSupportPage> {
  Future<List<Map<String, dynamic>>> load() async {
    final rows = await Supabase.instance.client
        .from('support_tickets')
        .select(
          'id,user_id,name,email,message,status,admin_reply,created_at,replied_at',
        )
        .order('created_at', ascending: false)
        .limit(100);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> reply(Map<String, dynamic> ticket) async {
    final controller = TextEditingController(
      text: (ticket['admin_reply'] ?? '').toString(),
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Reply to ' +
              ((ticket['name'] ?? ticket['email'] ?? 'user').toString()),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Reply'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Send reply'),
          ),
        ],
      ),
    );
    if (ok != true || controller.text.trim().isEmpty) return;
    final user = Supabase.instance.client.auth.currentUser;
    await Supabase.instance.client
        .from('support_tickets')
        .update({
          'admin_reply': controller.text.trim(),
          'status': 'replied',
          'replied_by': user?.id,
          'replied_at': DateTime.now().toIso8601String(),
          'user_seen_reply': false,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', ticket['id']);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        title: const Text('Archived support messages'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: load(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty)
            return const Center(child: Text('No support messages yet.'));
          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final t = items[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF6),
                  border: Border.all(color: const Color(0xFFE3D8C8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (t['name'] ?? t['email'] ?? 'App user').toString(),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(
                          (t['status'] ?? 'open').toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFA80F24),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    if ((t['email'] ?? '').toString().isNotEmpty)
                      Text(
                        (t['email'] ?? '').toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF77736D),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text((t['message'] ?? '').toString()),
                    if ((t['admin_reply'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xFFF0E7D8),
                        child: Text(
                          'Your reply: ' + (t['admin_reply'] ?? '').toString(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: () => reply(t),
                        child: Text(
                          (t['admin_reply'] ?? '').toString().isEmpty
                              ? 'Reply'
                              : 'Edit reply',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
  Future<List<Map<String, dynamic>>> pending() async {
    final rows = await Supabase.instance.client
        .from('submissions')
        .select(
          'id,submission_type,title,description,payload,status,created_at',
        )
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows);
  }

  final Set<String> reviewing = {};

  Future<void> review(Map<String, dynamic> item, bool approve) async {
    final id = item['id'].toString();
    if (reviewing.contains(id)) return;
    setState(() => reviewing.add(id));
    try {
      await Supabase.instance.client.rpc(
        'review_christmas_submission',
        params: {'submission_id': id, 'approve': approve},
      );
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              approve ? 'Approved and published.' : 'Submission rejected.',
            ),
          ),
        );
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not complete the review. Your submission is still saved. Please try again.',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => reviewing.remove(id));
    }
  }

  Future<Map<String, int>> counts() async {
    final ideas = await Supabase.instance.client
        .from('content_items')
        .select('id');
    final gifts = await Supabase.instance.client
        .from('gift_ideas')
        .select('id');
    final events = await Supabase.instance.client.from('events').select('id');
    final lights = await Supabase.instance.client
        .from('light_displays')
        .select('id');
    final pendingRows = await Supabase.instance.client
        .from('submissions')
        .select('id')
        .eq('status', 'pending');
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2E8),
        elevation: 0,
        title: const Text('Admin'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          FutureBuilder<Map<String, int>>(
            future: counts(),
            builder: (context, snap) {
              final data = snap.data ?? {};
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text('Ideas: ' + (data['Ideas']?.toString() ?? '…')),
                  ),
                  Chip(
                    label: Text('Gifts: ' + (data['Gifts']?.toString() ?? '…')),
                  ),
                  Chip(
                    label: Text(
                      'Events: ' + (data['Events']?.toString() ?? '…'),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Lights: ' + (data['Lights']?.toString() ?? '…'),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Pending: ' + (data['Pending']?.toString() ?? '…'),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.edit_note_outlined,
                color: Color(0xFFA80F24),
              ),
              title: const Text(
                'Content Editor',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Edit gift and idea text, photos, prices and links',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminContentEditorPage(),
                ),
              ).then((_) => setState(() {})),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Color(0xFF0F4C45),
              ),
              title: const Text(
                'Photos & Logos',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Add and manage photos for gifts, ideas, events, lights and stores',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminMediaManagerPage(),
                ),
              ).then((_) => setState(() {})),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.flag_outlined,
                color: Color(0xFFA80F24),
              ),
              title: const Text(
                'Listing Corrections',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Review user reports about events, lights and stores',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminCorrectionsPage()),
              ).then((_) => setState(() {})),
            ),
          ),

          const SizedBox(height: 18),
          Text(
            'Pending submissions',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontSize: 25),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: pending(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (snap.hasError)
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Could not load submissions. Reopen Admin to try again.',
                    ),
                  ),
                );
              final items = snap.data ?? [];
              if (items.isEmpty)
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text('Nothing waiting for approval 🎄'),
                  ),
                );
              return Column(
                children: items
                    .map(
                      (item) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (item['submission_type'] ?? '')
                                    .toString()
                                    .toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (item['title'] ?? '').toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              if ((item['description'] ?? '')
                                  .toString()
                                  .isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text((item['description'] ?? '').toString()),
                              ],
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final saved = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SubmissionEditorPage(item: item),
                                    ),
                                  );
                                  if (saved == true && mounted) setState(() {});
                                },
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit before approval'),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed:
                                          reviewing.contains(
                                            item['id'].toString(),
                                          )
                                          ? null
                                          : () => review(item, false),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed:
                                          reviewing.contains(
                                            item['id'].toString(),
                                          )
                                          ? null
                                          : () => review(item, true),
                                      child: const Text('Approve & Publish'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SubmissionEditorPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const SubmissionEditorPage({super.key, required this.item});
  @override
  State<SubmissionEditorPage> createState() => _SubmissionEditorPageState();
}

class _SubmissionEditorPageState extends State<SubmissionEditorPage> {
  final form = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController description;
  late final TextEditingController city;
  late final TextEditingController address;
  late final TextEditingController website;
  late final TextEditingController cost;
  late Map<String, dynamic> payload;
  String? region;
  String eventCategory = 'community';
  DateTime? start;
  DateTime? end;
  bool busy = false;
  String? error;
  bool get isEvent => widget.item['submission_type'] == 'event';
  bool get isLights => widget.item['submission_type'] == 'light';
  bool get isPlace => widget.item['submission_type'] != 'idea';

  @override
  void initState() {
    super.initState();
    payload = Map<String, dynamic>.from(widget.item['payload'] ?? {});
    title = TextEditingController(text: widget.item['title']?.toString() ?? '');
    description = TextEditingController(
      text: widget.item['description']?.toString() ?? '',
    );
    city = TextEditingController(text: payload['city']?.toString() ?? '');
    address = TextEditingController(text: payload['address']?.toString() ?? '');
    website = TextEditingController(
      text: payload['website_url']?.toString() ?? '',
    );
    cost = TextEditingController(text: payload['cost_text']?.toString() ?? '');
    eventCategory = payload['event_type'] == 'santa_visit'
        ? 'santa_visit'
        : 'community';
    region = payload['region']?.toString();
    if (region?.isEmpty ?? true) region = null;
    start = DateTime.tryParse(
      (payload[isEvent ? 'start_at' : 'start_date'] ?? '').toString(),
    )?.toLocal();
    end = DateTime.tryParse(
      (payload[isEvent ? 'end_at' : 'end_date'] ?? '').toString(),
    )?.toLocal();
  }

  @override
  void dispose() {
    for (final c in [title, description, city, address, website, cost]) {
      c.dispose();
    }
    super.dispose();
  }

  String dateLabel(DateTime? value) {
    if (value == null) return 'Not added';
    final date = '${value.day}/${value.month}/${value.year}';
    return isEvent
        ? '$date ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'
        : date;
  }

  Future<void> chooseDate(bool first) async {
    final current = (first ? start : end) ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    var value = date;
    if (isEvent) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(current),
      );
      if (time == null || !mounted) return;
      value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    setState(() {
      if (first) {
        start = value;
      } else {
        end = value;
      }
    });
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    if (start != null && end != null && end!.isBefore(start!)) {
      setState(() => error = 'The end must be after the start.');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    final next = {...payload};
    if (isPlace)
      next.addAll({
        'city': city.text.trim(),
        'region': region,
        'address': address.text.trim(),
        'website_url': website.text.trim(),
      });
    if (isEvent || isLights) {
      next[isEvent ? 'start_at' : 'start_date'] = start == null
          ? null
          : (isEvent
                ? start!.toUtc().toIso8601String()
                : start!.toIso8601String().substring(0, 10));
      next[isEvent ? 'end_at' : 'end_date'] = end == null
          ? null
          : (isEvent
                ? end!.toUtc().toIso8601String()
                : end!.toIso8601String().substring(0, 10));
    }
    if (isEvent || isLights) next['cost_text'] = cost.text.trim();
    if (isEvent) next['event_type'] = eventCategory;
    try {
      await Supabase.instance.client
          .from('submissions')
          .update({
            'title': title.text.trim(),
            'description': description.text.trim(),
            'payload': next,
          })
          .eq('id', widget.item['id'])
          .eq('status', 'pending')
          .select('id')
          .single();
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted)
        setState(
          () => error = 'Could not save. Check your connection and that this submission is still pending.',
        );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final regions = <String>{
      ..._SubmissionPageState.regions,
      if (region != null) region!,
    }.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Edit submission')),
      body: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Fact-check and add details. Saving keeps this submission pending for approval.',
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: title,
              enabled: !busy,
              decoration: const InputDecoration(labelText: 'Title / Name'),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Add a title.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: description,
              enabled: !busy,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Description and extra information',
              ),
            ),
            if (isPlace) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: address,
                enabled: !busy,
                decoration: const InputDecoration(
                  labelText: 'Street address / Venue',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: city,
                enabled: !busy,
                decoration: const InputDecoration(labelText: 'City or town'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: region,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Region'),
                items: regions
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: busy ? null : (v) => setState(() => region = v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: website,
                enabled: !busy,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Website / Source link',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final uri = Uri.tryParse(v.trim());
                  return uri != null &&
                          ['https', 'http'].contains(uri.scheme) &&
                          uri.host.isNotEmpty
                      ? null
                      : 'Use a full link starting with https://';
                },
              ),
            ],
            if (isEvent) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: eventCategory,
                decoration: const InputDecoration(labelText: 'Event category'),
                items: const [
                  DropdownMenuItem(
                    value: 'community',
                    child: Text('Events / Markets'),
                  ),
                  DropdownMenuItem(
                    value: 'santa_visit',
                    child: Text('Santa Visits'),
                  ),
                ],
                onChanged: busy
                    ? null
                    : (v) => setState(() => eventCategory = v ?? 'community'),
              ),
            ],
            if (isEvent || isLights) ...[
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start'),
                subtitle: Text(dateLabel(start)),
                onTap: busy ? null : () => chooseDate(true),
                trailing: IconButton(
                  onPressed: busy ? null : () => setState(() => start = null),
                  icon: const Icon(Icons.clear),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('End'),
                subtitle: Text(dateLabel(end)),
                onTap: busy ? null : () => chooseDate(false),
                trailing: IconButton(
                  onPressed: busy ? null : () => setState(() => end = null),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ],
            if (isEvent || isLights)
              TextFormField(
                controller: cost,
                enabled: !busy,
                decoration: const InputDecoration(
                  labelText: 'Cost / Entry details',
                ),
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: busy ? null : save,
              child: Text(busy ? 'Saving…' : 'Save changes — keep pending'),
            ),
          ],
        ),
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
  Map<String, dynamic>? profile;
  bool busy = false;

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => profile = null);
      return;
    }
    final rows = await Supabase.instance.client
        .from('profiles')
        .select('display_name,role,premium_status')
        .eq('id', user.id)
        .limit(1);
    if (mounted)
      setState(() {
        profile = List<Map<String, dynamic>>.from(rows).isEmpty
            ? null
            : List<Map<String, dynamic>>.from(rows).first;
      });
  }

  Future<void> signIn() async {
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          busy = false;
          message = 'Sign in failed. Check your email and password.';
        });
      }
      return;
    }

    try {
      await loadProfile();
      if (mounted) {
        setState(() {
          message = profile?['role'] == 'admin' || profile?['role'] == 'editor'
              ? 'Admin access confirmed ✅'
              : 'Signed in ✅';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          message = 'Signed in, but your account details could not be loaded. Please try again.';
        });
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted)
      setState(() {
        profile = null;
        message = null;
      });
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
          Text('Me', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 5),
          const Text('Your Christmas preferences, account and contributions.'),
          const SizedBox(height: 22),
          const SizedBox(height: 8),
          if (user == null) ...[
            const Text(
              'Sign in',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign in to save boards, submit Christmas finds and access admin tools.',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: busy ? null : signIn,
              child: Text(busy ? 'Signing in…' : 'Sign in'),
            ),
          ] else ...[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCF6),
                border: Border.all(color: const Color(0xFFE4DCCF)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF0F4C45),
                ),
                title: Text(
                  (profile?['display_name'] ?? user.email ?? 'Signed in')
                      .toString(),
                ),
                subtitle: Text(isAdmin ? 'Owner / Admin' : 'Member'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Text('⬆')),
                title: const Text(
                  'Submit a Christmas Find',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text('Events, lights, businesses or ideas'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubmissionPage()),
                ),
              ),
            ),
            if (isAdmin)
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.admin_panel_settings),
                  ),
                  title: const Text(
                    'Admin Dashboard',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: const Text(
                    'Approve submissions and view live content totals',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardPage(),
                    ),
                  ),
                ),
              ),
            FilledButton.tonal(
              onPressed: signOut,
              child: const Text('Sign out'),
            ),
          ],
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(message!),
            ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEE6D8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const ListTile(
              leading: Icon(Icons.facebook, color: Color(0xFF0F4C45)),
              title: Text('Christmas Ideas NZ on Facebook'),
              subtitle: Text('Facebook link will be connected before launch'),
            ),
          ),
        ],
      ),
    );
  }
}

class ListingPhoto extends StatelessWidget {
  final Map<String, dynamic> item;
  const ListingPhoto({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final image = (item['image_url'] ?? '').toString();
    final name = (item['name'] ?? '').toString().toLowerCase();
    String? brand;
    if (name.startsWith('the warehouse'))
      brand = 'warehouse';
    else if (name.startsWith('farmers'))
      brand = 'farmers';
    else if (name.startsWith('kmart'))
      brand = 'kmart';
    else if (name.startsWith('typo'))
      brand = 'typo';
    if (image.isEmpty && brand != null)
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(26),
        child: Image.asset('assets/${brand}_logo.png', fit: BoxFit.contain),
      );
    return EditorialImage(
      url: image,
      kind: item['_type']?.toString() ?? 'listing',
    );
  }
}
