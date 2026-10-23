import 'dart:async';
import 'festive_decoration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeCategory {
 final String label;
 final String section;
 final bool nearby;
 final IconData icon;
 const HomeCategory(this.label, this.section, this.icon, {this.nearby = false});
}
const homeCategories = [
 HomeCategory('Gifts', 'Gifts', Icons.card_giftcard_outlined),
 HomeCategory('Events', 'Events', Icons.event_outlined, nearby: true),
 HomeCategory('Light Displays', 'Light Displays', Icons.lightbulb_outline, nearby: true),
 HomeCategory('Stores', 'Stores', Icons.storefront_outlined, nearby: true),
 HomeCategory('Recipes', 'Recipes', Icons.restaurant_outlined),
 HomeCategory('Elf Ideas', 'Elf Ideas', Icons.auto_awesome_outlined),
 HomeCategory('Charities', 'Christmas Charities', Icons.favorite_outline, nearby: true),
];
class ExploreShortcut {
 final String label;
 final Widget icon;
 final VoidCallback onPressed;
 const ExploreShortcut(this.label, this.icon, this.onPressed);
}

class ExploreShortcutGrid extends StatelessWidget {
 final List<ExploreShortcut> shortcuts;
 const ExploreShortcutGrid({super.key, required this.shortcuts});
 @override
 Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
  final columns = constraints.maxWidth >= 700 ? 4 : 2;
  final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
  final height = 62 * MediaQuery.textScalerOf(context).scale(14) / 14;
  return Wrap(spacing: 10, runSpacing: 10, children: [
   for(var i=0;i<shortcuts.length;i++) SizedBox(width: width, height: height,
    child: OutlinedButton.icon(onPressed: shortcuts[i].onPressed,
     icon: shortcuts[i].icon, label: Text(shortcuts[i].label, maxLines: 2),
     style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      foregroundColor: Colors.white,
      iconColor: Colors.white,
      side: const BorderSide(color: festiveGold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: i.isEven ? festiveRed : festiveGreen))),
  ]);
 });
}

class HomeCategoryShortcuts extends StatelessWidget {
 final ValueChanged<HomeCategory> onSelected;
 final List<ExploreShortcut> additionalShortcuts;
 const HomeCategoryShortcuts({super.key, required this.onSelected, this.additionalShortcuts = const []});
 @override
 Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
   const Text('Explore Christmas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
   const SizedBox(height: 10),
   ExploreShortcutGrid(shortcuts: [
    for(final category in homeCategories) ExploreShortcut(category.label,
     Icon(category.icon, size: 22), () => onSelected(category)),
    ...additionalShortcuts,
   ]),
  ]));
}

class MemberGreeting extends StatefulWidget {
 const MemberGreeting({super.key});
 @override State<MemberGreeting> createState() => _MemberGreetingState();
}
class _MemberGreetingState extends State<MemberGreeting> {
 StreamSubscription<AuthState>? subscription;
 String? userId;
 String? greeting;
 int generation = 0;
 @override void initState() {
  super.initState();refresh();
  subscription = Supabase.instance.client.auth.onAuthStateChange.listen((_) => refresh(), onError: (_, __) {});
 }
 Future<void> refresh() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user?.id == userId) return;
  userId = user?.id;
  final request = ++generation;
  if(user == null) { if(mounted) setState(() => greeting = null);return; }
  final prefs = await SharedPreferences.getInstance();
  final returning = prefs.getBool('member_welcomed_${user.id}') ?? false;
  final name = user.userMetadata?['display_name']?.toString().trim();
  final suffix = name == null || name.isEmpty ? '' : ', ${name.split(' ').first}';
  if(mounted && request == generation) setState(() => greeting = '${returning ? 'Welcome back' : 'Welcome'}$suffix!');
  await prefs.setBool('member_welcomed_${user.id}', true);
 }
 @override void dispose() { subscription?.cancel();super.dispose(); }
 @override Widget build(BuildContext context) => greeting == null ? const SizedBox.shrink() : Padding(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
  child: Text(greeting!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)));
}
