import 'package:flutter/material.dart';
import '../main.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'near_me_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';

class ShellScreen extends StatefulWidget {
  final String name;
  final ChristmasTheme theme;
  final ValueChanged<ChristmasTheme> onThemeChanged;
  const ShellScreen({super.key, required this.name, required this.theme, required this.onThemeChanged});
  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(name: widget.name, onNavigate: (i) => setState(() => _index = i)),
      const DiscoverScreen(),
      const NearMeScreen(),
      const SavedScreen(),
      ProfileScreen(name: widget.name, theme: widget.theme, onThemeChanged: widget.onThemeChanged),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
