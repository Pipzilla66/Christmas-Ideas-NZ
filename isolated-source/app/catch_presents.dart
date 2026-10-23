import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FallingPresent {
  final int id, lane;
  final Color colour;
  double position;
  FallingPresent(this.id, this.lane, this.colour, [this.position = 0]);
}

class CatchPresentsPage extends StatefulWidget {
  final int? randomSeed;
  const CatchPresentsPage({super.key, this.randomSeed});
  @override
  State<CatchPresentsPage> createState() => _CatchPresentsPageState();
}

class _CatchPresentsPageState extends State<CatchPresentsPage>
    with WidgetsBindingObserver {
  late final random = Random(widget.randomSeed);
  final presents = <FallingPresent>[];
  Timer? timer;
  int score = 0, elapsed = 0, spawnElapsed = 0, nextId = 0;
  bool started = false, finished = false, paused = false;
  static const roundMs = 30000, stepMs = 40;
  static const giftColours = [
    Color(0xFFA51232),
    Color(0xFF23734C),
    Color(0xFF3D76BE),
    Color(0xFF9D59AE),
  ];
  int get secondsLeft => max(0, ((roundMs - elapsed) / 1000).ceil());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && started && !finished && !paused)
      setState(() => paused = true);
  }

  void spawn() {
    final available = [
      for (var lane = 0; lane < 4; lane++)
        if (!presents.any((p) => p.lane == lane && p.position < .27)) lane,
    ];
    if (available.isEmpty) return;
    presents.add(
      FallingPresent(
        nextId++,
        available[random.nextInt(available.length)],
        giftColours[random.nextInt(giftColours.length)],
      ),
    );
  }

  void start() {
    timer?.cancel();
    setState(() {
      score = 0;
      elapsed = 0;
      spawnElapsed = 0;
      presents.clear();
      started = true;
      finished = false;
      paused = false;
      spawn();
    });
    timer = Timer.periodic(const Duration(milliseconds: stepMs), (_) {
      if (!mounted || paused || finished) return;
      setState(() {
        elapsed = min(roundMs, elapsed + stepMs);
        if (elapsed >= roundMs) {
          finished = true;
          presents.clear();
          timer?.cancel();
          return;
        }
        for (final present in presents) {
          present.position += stepMs / 1000 * .16;
        }
        presents.removeWhere((p) => p.position > 1);
        spawnElapsed += stepMs;
        if (spawnElapsed >= 800) {
          spawnElapsed -= 800;
          spawn();
        }
      });
    });
  }

  void catchGift(int id) {
    if (paused || finished || !started) return;
    if (presents.any((p) => p.id == id))
      setState(() {
        presents.removeWhere((p) => p.id == id);
        score++;
      });
  }

  Widget gift(FallingPresent present) => Semantics(
    label: 'Catch present',
    button: true,
    child: Tooltip(
      message: 'Catch present',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('present-${present.id}'),
          onTap: () => catchGift(present.id),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: SizedBox(
              width: 48,
              height: 52,
              child: CustomPaint(painter: _PresentPainter(present.colour)),
            ),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Catch the presents')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Tap the falling presents before they reach the snow. Catch as many as you can in 30 seconds!',
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 20,
              runSpacing: 8,
              children: [
                Text(
                  'Presents caught: $score',
                  key: const ValueKey('catch-score'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Time left: $secondsLeft s',
                  key: const ValueKey('catch-time'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 360,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LayoutBuilder(
                  builder: (context, bounds) => Stack(
                    key: const ValueKey('catch-board'),
                    children: [
                      const Positioned.fill(
                        child: CustomPaint(painter: _SnowScenePainter()),
                      ),
                      if (started && !finished && !paused)
                        for (final present in presents)
                          Positioned(
                            left:
                                (present.lane + .5) * bounds.maxWidth / 4 - 32,
                            top: present.position * (bounds.maxHeight - 80),
                            width: 64,
                            height: 64,
                            child: gift(present),
                          ),
                      if (!started || finished || paused)
                        Positioned.fill(
                          child: ColoredBox(
                            color: const Color(0xE6E7EFE8),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.card_giftcard,
                                      color: Color(0xFFA51232),
                                      size: 56,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      finished
                                          ? 'You caught $score ${score == 1 ? 'present' : 'presents'}! 🎉'
                                          : paused
                                          ? 'Game paused'
                                          : 'Ready to catch some Christmas magic?',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      onPressed: paused
                                          ? () => setState(() => paused = false)
                                          : start,
                                      icon: const Icon(Icons.play_arrow),
                                      label: Text(
                                        paused
                                            ? 'Keep playing'
                                            : finished
                                            ? 'Play again'
                                            : 'Start game',
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
            ),
            const SizedBox(height: 12),
            if (started && !finished)
              OutlinedButton.icon(
                onPressed: () => setState(() => paused = !paused),
                icon: Icon(paused ? Icons.play_arrow : Icons.pause),
                label: Text(paused ? 'Resume game' : 'Pause game'),
              ),
            const SizedBox(height: 8),
            const Text(
              'No worries if you miss one. Have another go and try to beat your score!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

class _PresentPainter extends CustomPainter {
  final Color colour;
  _PresentPainter(this.colour);
  @override
  void paint(Canvas c, Size size) {
    c.scale(size.width / 48, size.height / 52);
    final p = Paint()..color = colour;
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(3, 18, 42, 32),
        const Radius.circular(4),
      ),
      p,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 14, 48, 10),
        const Radius.circular(3),
      ),
      p,
    );
    p.color = const Color(0xFFF9DB7A);
    c.drawRect(const Rect.fromLTWH(20, 14, 8, 36), p);
    c.drawRect(const Rect.fromLTWH(3, 31, 42, 7), p);
    p
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    c.drawOval(const Rect.fromLTWH(8, 3, 16, 12), p);
    c.drawOval(const Rect.fromLTWH(24, 3, 16, 12), p);
  }

  @override
  bool shouldRepaint(_PresentPainter old) => old.colour != colour;
}

class _SnowScenePainter extends CustomPainter {
  const _SnowScenePainter();
  @override
  void paint(Canvas c, Size size) {
    c.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE7EFE8));
    final white = Paint()..color = Colors.white;
    for (var i = 0; i < 18; i++)
      c.drawCircle(
        Offset(
          ((i * 71 + 29) % 307) / 307 * size.width,
          ((i * 43 + 17) % 293) / 293 * (size.height - 30),
        ),
        i.isEven ? 3 : 2,
        white,
      );
    final snow = Path()
      ..moveTo(0, size.height - 24)
      ..quadraticBezierTo(
        size.width * .3,
        size.height - 48,
        size.width * .55,
        size.height - 22,
      )
      ..quadraticBezierTo(
        size.width * .8,
        size.height - 40,
        size.width,
        size.height - 18,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    c.drawPath(snow, white);
  }

  @override
  bool shouldRepaint(_SnowScenePainter old) => false;
}
