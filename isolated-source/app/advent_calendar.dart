import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'advent_facts.dart';
import 'calendar_time.dart';

bool adventDoorAvailable(int day, DateTime today) =>
  day >= 1 && day <= 24 && today.month == 12 && day <= today.day;
String adventOpenedKey(int year) => 'christmas-advent-opened-v1-$year';

class AdventCalendarPage extends StatefulWidget {
  final DateTime Function()? clock;
  const AdventCalendarPage({super.key, this.clock});
  @override
  State<AdventCalendarPage> createState() => _AdventCalendarPageState();
}
class _AdventCalendarPageState extends State<AdventCalendarPage> with WidgetsBindingObserver {
  final opened = <int>{};
  Timer? timer;
  int? loadedYear;
  DateTime get today => nzCalendarToday(widget.clock?.call());
  @override
  void initState() {
    super.initState(); WidgetsBinding.instance.addObserver(this); loadOpened();
    timer = Timer.periodic(const Duration(minutes: 1), (_) => refresh());
  }
  void refresh() {
    if (!mounted) return;
    if (loadedYear != today.year) { opened.clear(); loadOpened(); }
    setState(() {});
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { if (state == AppLifecycleState.resumed) refresh(); }
  Future<void> loadOpened() async {
    final year = today.year; loadedYear = year;
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = (prefs.getStringList(adventOpenedKey(year)) ?? []).map(int.tryParse).whereType<int>().where((d) => d >= 1 && d <= 24);
      if (mounted && loadedYear == year) setState(() => opened.addAll(saved));
    } catch (_) { /* The calendar still works if local storage is unavailable. */ }
  }
  Future<void> remember(int day, int year) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final all = <String>{...(prefs.getStringList(adventOpenedKey(year)) ?? []), '$day'};
      await prefs.setStringList(adventOpenedKey(year), all.toList());
    } catch (_) {}
  }
  void open(AdventFact item, {bool sample = false}) {
    final date = today;
    if (!sample && !adventDoorAvailable(item.day, date)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Door ${item.day} opens on ${item.day} December, in New Zealand time.')));
      return;
    }
    if (!sample) { setState(() => opened.add(item.day)); remember(item.day, date.year); }
    showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text(sample ? 'A little Advent preview' : 'Day ${item.day}: ${item.title}'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (sample) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(item.title, style: Theme.of(context).textTheme.titleMedium)),
        Text(item.fact, style: const TextStyle(fontSize: 17, height: 1.5)),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xffe8eee9), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('A little idea to try', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6), Text(item.activity, style: const TextStyle(height: 1.5)),
        ])),
        const SizedBox(height: 12),
        TextButton(onPressed: () async {
          final ok = await launchUrl(Uri.parse(item.sourceUrl), mode: LaunchMode.externalApplication);
          if (!ok && dialogContext.mounted) ScaffoldMessenger.of(dialogContext).showSnackBar(const SnackBar(content: Text('The source could not be opened. Please try again.')));
        }, child: Text('Source: ${item.sourceName}', textAlign: TextAlign.center)),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close'))],
    ));
  }
  @override
  void dispose() { timer?.cancel(); WidgetsBinding.instance.removeObserver(this); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final date = today;
    final available = date.month == 12 ? date.day.clamp(0,24) : 0;
    final before = date.month != 12;
    return Scaffold(appBar: AppBar(title: const Text('Advent calendar')), body: ListView(padding: const EdgeInsets.all(20), children: [
      Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 740), child: Column(children: [
        const Icon(Icons.auto_awesome, size: 36, color: Color(0xffb98222)),
        const SizedBox(height: 12),
        Text('24 little Christmas surprises', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        const Text('A short Christmas fact and an optional family activity behind each door.', textAlign: TextAlign.center, style: TextStyle(height: 1.5)),
        const SizedBox(height: 10),
        Text(before ? 'The first door opens on 1 December ${date.year}.' : date.day > 24 ? 'Merry Christmas! All 24 doors are open.' : 'Door ${date.day} is ready! Earlier doors can be opened too.', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff9f1738))),
        const SizedBox(height: 8),
        const Text('Doors open at midnight in New Zealand time.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
        const SizedBox(height: 14),
        if (before) OutlinedButton.icon(onPressed: () => open(adventFacts.first, sample: true), icon: const Icon(Icons.visibility_outlined), label: const Text('See a sample fact')),
        if (date.month == 12) FilledButton.icon(onPressed: () => open(adventFacts[available - 1]), icon: const Icon(Icons.card_giftcard_outlined), label: Text(date.day > 24 ? 'Open door 24' : 'Open today’s door')),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) => GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: (constraints.maxWidth / (76 * MediaQuery.textScalerOf(context).scale(1).clamp(1, 3))).floor().clamp(2, 6),
          crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .85 / MediaQuery.textScalerOf(context).scale(1).clamp(1, 3),
          children: adventFacts.map((item) {
            final unlocked = adventDoorAvailable(item.day, date);
            final seen = opened.contains(item.day) && unlocked;
            return Semantics(button: true, label: 'Door ${item.day}, ${unlocked ? seen ? 'opened, tap to read again' : 'ready to open' : 'opens ${item.day} December'}', child: ExcludeSemantics(child: Material(
              color: unlocked ? item.day.isOdd ? const Color(0xff0f4c45) : const Color(0xff9f1738) : const Color(0xffe9e5da),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: unlocked ? const Color(0xffd6bc75) : const Color(0xffd1cabb))),
              clipBehavior: Clip.antiAlias,
              child: InkWell(key: ValueKey('advent-door-${item.day}'), onTap: () => open(item), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(unlocked ? seen ? Icons.check_circle_outline : Icons.card_giftcard_outlined : Icons.lock_outline, size: 18, color: unlocked ? const Color(0xffe5c774) : const Color(0xff686459)),
                const SizedBox(height: 5),
                Text('${item.day}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: unlocked ? Colors.white : const Color(0xff514d45))),
              ]))),
            )));
          }).toList(),
        )),
        const SizedBox(height: 18),
        Text('$available of 24 doors available • ${opened.where((d) => adventDoorAvailable(d,date)).length} opened on this device', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 8),
        const Text('Tap any available door to read it again. Your opened doors are remembered on this device.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, height: 1.5)),
      ]))),
    ]));
  }
}
