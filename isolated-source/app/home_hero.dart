import 'brand_logo.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'advent_calendar.dart';
import 'festive_decoration.dart';

const christmasHook = 'Your Christmas in New Zealand, all in one place.';
const christmasHookDescription =
    'Find festive outings, local shops, gift inspiration and little traditions to make Christmas more meaningful.';

class ChristmasHomeHero extends StatelessWidget {
  final int days;
  const ChristmasHomeHero({super.key, required this.days});
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ChristmasBrandHeader(),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: wide ? 370 : 320),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: wide ? 280 : 240,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    1.12,
                    0,
                    0,
                    0,
                    8,
                    0,
                    1.12,
                    0,
                    0,
                    8,
                    0,
                    0,
                    1.12,
                    0,
                    8,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ]),
                  child: Image.asset(
                    'assets/kiwi_christmas_hero_v1.webp',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0x33000000), Color(0x00000000)],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, wide ? 260 : 220, 18, 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xeb0f4c45),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: festiveGold),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 620),
                            child: Text(
                              christmasHook,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: wide ? 30 : 25,
                                height: 1.15,
                                shadows: const [
                                  Shadow(
                                    color: Color(0xCC000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 430),
                            child: const Text(
                              christmasHookDescription,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.4,
                                shadows: [
                                  Shadow(
                                    color: Color(0xCC000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFCF6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$days',
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 30,
                                              color: const Color(0xff9f1738),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'DAYS UNTIL\nCHRISTMAS',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10,
                                              letterSpacing: 1,
                                              color: Color(0xff0f4c45),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Material(
                                      color: const Color(0xFFFFFCF6),
                                      borderRadius: BorderRadius.circular(10),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        key: const ValueKey('advent-home-link'),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AdventCalendarPage(),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.calendar_month_outlined,
                                                size: 26,
                                                color: Color(0xff9f1738),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                'Advent calendar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff0f4c45),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'A Christmas fact each day',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xff0f4c45),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: CustomPaint(painter: FestiveSparkles(hero: true)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
