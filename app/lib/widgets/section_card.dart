import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const SectionCard({super.key, required this.icon, required this.title, required this.subtitle, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Icon(icon)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            const Icon(Icons.chevron_right),
          ]),
        ),
      ),
    );
  }
}
