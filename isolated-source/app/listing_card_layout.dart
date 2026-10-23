import 'package:flutter/material.dart';

class ListingCardLayout extends StatelessWidget {
  final Widget photo;
  final Widget details;
  const ListingCardLayout({
    super.key,
    required this.photo,
    required this.details,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final image = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: constraints.maxWidth >= 600 ? 240 : double.infinity,
          height: constraints.maxWidth >= 600 ? 180 : 145,
          child: photo,
        ),
      );
      if (constraints.maxWidth >= 600) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image,
            const SizedBox(width: 18),
            Expanded(child: details),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [image, const SizedBox(height: 12), details],
      );
    },
  );
}
