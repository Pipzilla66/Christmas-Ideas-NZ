import 'package:flutter/material.dart';

class ChristmasBrandHeader extends StatelessWidget {
  const ChristmasBrandHeader({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: const Color(0xFFF7F2E8),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Center(
      child: Image.asset(
        'assets/christmas_brand_logo_v3.webp',
        height: MediaQuery.sizeOf(context).width >= 700 ? 150 : 120,
        width: 340,
        fit: BoxFit.contain,
        semanticLabel: 'Christmas Ideas NZ logo',
      ),
    ),
  );
}
