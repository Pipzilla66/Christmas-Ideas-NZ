import 'package:flutter/material.dart';
import '../main.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(String name, ChristmasTheme theme) onContinue;
  const OnboardingScreen({super.key, required this.onContinue});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _name = TextEditingController();
  ChristmasTheme _selected = ChristmasTheme.kiwi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            Container(
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F4C45), Color(0xFF173B36)],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🎄', style: TextStyle(fontSize: 68)),
                    SizedBox(height: 8),
                    Text('CHRISTMAS IDEAS NZ', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
                    SizedBox(height: 4),
                    Text('NEW ZEALAND', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w800, letterSpacing: 2)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Kia ora! 🎄', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Welcome to Christmas Ideas NZ', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: "What's your name?", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Text('Choose your Christmas style', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _choice('Kiwi Christmas', ChristmasTheme.kiwi, const Color(0xFF0F4C45)),
                _choice('Classic ✨', ChristmasTheme.classic, const Color(0xFF9E1B32)),
                _choice('Grinchy 💚', ChristmasTheme.grinchy, const Color(0xFF8CCF3F)),
                _choice('Winter Wonderland ❄️', ChristmasTheme.winter, const Color(0xFF2A4C73)),
              ],
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => widget.onContinue(_name.text, _selected),
              icon: const Icon(Icons.celebration),
              label: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Enter Christmas Ideas NZ')),
            ),
            const SizedBox(height: 10),
            Text('Browse without an account. Create one later only when you want to save boards, premium content or submissions.',
                textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _choice(String label, ChristmasTheme value, Color swatch) {
    return ChoiceChip(
      avatar: CircleAvatar(backgroundColor: swatch, radius: 8),
      label: Text(label),
      selected: _selected == value,
      onSelected: (_) => setState(() => _selected = value),
    );
  }
}
