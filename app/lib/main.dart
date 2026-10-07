import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/onboarding_screen.dart';
import 'screens/shell_screen.dart';

const supabaseUrl = 'https://ocrwnkeqemcsklsnbufq.supabase.co';
const supabasePublishableKey = 'sb_publishable_ciIHpWT3mWNzgEpUebXGkw_EBzELVZ3';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublishableKey,
  );
  runApp(const ChristmasIdeasNZApp());
}

class ChristmasIdeasNZApp extends StatefulWidget {
  const ChristmasIdeasNZApp({super.key});
  @override
  State<ChristmasIdeasNZApp> createState() => _ChristmasIdeasNZAppState();
}

class _ChristmasIdeasNZAppState extends State<ChristmasIdeasNZApp> {
  String? _name;
  ChristmasTheme _theme = ChristmasTheme.kiwi;

  void _finishOnboarding(String name, ChristmasTheme theme) {
    setState(() {
      _name = name.trim().isEmpty ? 'Christmas Lover' : name.trim();
      _theme = theme;
    });
  }

  ThemeData _themeData(ChristmasTheme t) {
    final scheme = switch (t) {
      ChristmasTheme.kiwi => const ColorScheme.light(
          primary: Color(0xFF0F4C45), secondary: Color(0xFFC9A44D), surface: Color(0xFFF4EFE6), onSurface: Color(0xFF18302C)),
      ChristmasTheme.classic => const ColorScheme.light(
          primary: Color(0xFF9E1B32), secondary: Color(0xFFD4AF37), surface: Color(0xFFFBF4EA), onSurface: Color(0xFF34161B)),
      ChristmasTheme.grinchy => const ColorScheme.light(
          primary: Color(0xFF8CCF3F), secondary: Color(0xFFB3202A), surface: Color(0xFFF3F7E7), onSurface: Color(0xFF223118)),
      ChristmasTheme.winter => const ColorScheme.light(
          primary: Color(0xFF2A4C73), secondary: Color(0xFFDCEBFA), surface: Color(0xFFF4F8FD), onSurface: Color(0xFF1A2B40)),
    };
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: GoogleFonts.montserratTextTheme().apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: .92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: .96),
        indicatorColor: scheme.primary.withValues(alpha: .16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: .88),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christmas Ideas NZ',
      theme: _themeData(_theme),
      home: _name == null
          ? OnboardingScreen(onContinue: _finishOnboarding)
          : ShellScreen(name: _name!, theme: _theme, onThemeChanged: (t) => setState(() => _theme = t)),
    );
  }
}

enum ChristmasTheme { kiwi, classic, grinchy, winter }
