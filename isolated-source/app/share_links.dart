import 'package:flutter/material.dart';
import 'festive_decoration.dart';

String submissionTypeForSection(String section) => switch (section) {
  'Events' || 'Markets & Workshops' || 'Santa Visits' => 'event',
  'Light Displays' => 'light',
  'Stores' || 'Christmas Shops' || 'Christmas Charities' || 'Real Christmas Trees' => 'business',
  _ => 'idea',
};

String shareLabelForSection(String section) => switch (section) {
  'Events' || 'Markets & Workshops' || 'Santa Visits' || 'Light Displays' || 'Christmas Charities' || 'Real Christmas Trees' => 'Add a listing',
  'Stores' || 'Christmas Shops' => 'Suggest a store',
  'Recipes' || 'Elf Ideas' => 'Share your own',
  'Gifts' => 'Suggest a gift',
  _ => 'Share an idea',
};

class ShareIdeaLink extends StatelessWidget {
  final String section;
  final VoidCallback onPressed;
  final bool home;
  const ShareIdeaLink({super.key, required this.onPressed, this.section = 'All', this.home = false});

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
    ),
    child: Text(home ? 'Share it here' : '+ ${shareLabelForSection(section)}'),
  );
}

class ShareSectionHeading extends StatelessWidget {
  final Widget title;
  final String section;
  final VoidCallback onShare;
  const ShareSectionHeading({super.key, required this.title, required this.section, required this.onShare});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final link = ShareIdeaLink(section: section, onPressed: onShare);
    if (constraints.maxWidth < 330 || MediaQuery.textScalerOf(context).scale(14) > 20) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, link]);
    }
    return Row(children: [Expanded(child: title), const SizedBox(width: 8), link]);
  });
}

class HomeShareIdeaButton extends StatelessWidget {
  final VoidCallback onPressed;
  const HomeShareIdeaButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final columns = constraints.maxWidth >= 700 ? 4 : 2;
    final tile = (constraints.maxWidth - (columns - 1) * 10) / columns;
    return Align(alignment: Alignment.center, child: SizedBox(
      width: columns == 2 ? constraints.maxWidth : tile * 2 + 10,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Share Your Christmas Idea', textAlign: TextAlign.center),
        style: FilledButton.styleFrom(
          backgroundColor: festiveRed, foregroundColor: Colors.white,
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: const BorderSide(color: festiveGold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ));
  });
}

class OwnIdeaButton extends StatelessWidget {
  final VoidCallback onPressed;
  const OwnIdeaButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.add_circle_outline),
    label: const Text('Share Your Own Idea'),
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF0F4C45),
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
