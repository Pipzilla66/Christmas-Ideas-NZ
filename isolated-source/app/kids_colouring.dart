import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ColourRegion {
  final Path path;
  final bool fillable;
  ColourRegion(this.path, {this.fillable = true});
}

Path _oval(double x, double y, double w, double h) =>
    Path()..addOval(Rect.fromLTWH(x, y, w, h));
Path _rect(double x, double y, double w, double h, [double radius = 0]) =>
    Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        Radius.circular(radius),
      ),
    );
Path _polygon(List<Offset> points) => Path()..addPolygon(points, true);

/// Original closed shapes let children colour by tapping rather than tracing.
List<ColourRegion> colouringRegions(String picture) {
  final r = <ColourRegion>[];
  void add(Path p, {bool fillable = true}) =>
      r.add(ColourRegion(p, fillable: fillable));
  void ellipse(double x, double y, double w, double h) =>
      add(_oval(x, y, w, h));
  void box(double x, double y, double w, double h, [double radius = 0]) =>
      add(_rect(x, y, w, h, radius));
  void poly(List<Offset> points) => add(_polygon(points));
  if (picture == 'Santa') {
    ellipse(120, 90, 360, 430);
    add(
      Path()
        ..moveTo(155, 220)
        ..quadraticBezierTo(170, 40, 350, 65)
        ..quadraticBezierTo(470, 60, 465, 180)
        ..lineTo(370, 135)
        ..lineTo(420, 220)
        ..close(),
    );
    ellipse(433, 158, 58, 58);
    box(145, 210, 290, 45, 20);
    add(
      Path()
        ..moveTo(170, 260)
        ..quadraticBezierTo(110, 420, 225, 465)
        ..quadraticBezierTo(300, 550, 380, 465)
        ..quadraticBezierTo(480, 415, 430, 260)
        ..close(),
    );
    ellipse(200, 252, 200, 130);
    ellipse(258, 285, 14, 14);
    ellipse(328, 285, 14, 14);
    ellipse(276, 312, 48, 32);
    add(
      Path()
        ..moveTo(300, 345)
        ..quadraticBezierTo(240, 323, 220, 363)
        ..quadraticBezierTo(270, 396, 300, 355)
        ..quadraticBezierTo(330, 396, 380, 363)
        ..quadraticBezierTo(360, 323, 300, 345)
        ..close(),
    );
    add(
      Path()
        ..moveTo(280, 382)
        ..quadraticBezierTo(300, 404, 320, 382),
      fillable: false,
    );
    poly([
      const Offset(170, 455),
      const Offset(130, 585),
      const Offset(470, 585),
      const Offset(430, 455),
      const Offset(365, 493),
      const Offset(235, 493),
    ]);
    box(282, 493, 36, 92);
    ellipse(292, 517, 16, 16);
    ellipse(292, 551, 16, 16);
  } else if (picture == 'Christmas tree') {
    box(270, 480, 60, 110);
    poly([
      const Offset(300, 115),
      const Offset(170, 255),
      const Offset(220, 255),
      const Offset(120, 375),
      const Offset(195, 375),
      const Offset(65, 515),
      const Offset(535, 515),
      const Offset(405, 375),
      const Offset(480, 375),
      const Offset(380, 255),
      const Offset(430, 255),
    ]);
    poly([
      const Offset(300, 30),
      const Offset(317, 67),
      const Offset(357, 70),
      const Offset(327, 95),
      const Offset(337, 135),
      const Offset(300, 113),
      const Offset(263, 135),
      const Offset(273, 95),
      const Offset(243, 70),
      const Offset(283, 67),
    ]);
    add(
      Path()
        ..moveTo(200, 277)
        ..quadraticBezierTo(300, 347, 410, 292),
      fillable: false,
    );
    add(
      Path()
        ..moveTo(155, 402)
        ..quadraticBezierTo(300, 481, 447, 424),
      fillable: false,
    );
    for (final p in [
      const Offset(265, 230),
      const Offset(353, 336),
      const Offset(210, 426),
      const Offset(385, 458),
      const Offset(290, 470),
    ])
      ellipse(p.dx - 17, p.dy - 17, 34, 34);
    box(55, 535, 130, 85);
    box(110, 535, 20, 85);
    box(55, 558, 130, 18);
    box(440, 550, 115, 70);
    box(487, 550, 20, 70);
    box(440, 573, 115, 18);
  } else if (picture == 'Snowman') {
    ellipse(175, 320, 250, 250);
    ellipse(215, 200, 170, 170);
    box(235, 125, 125, 90);
    box(235, 177, 125, 25);
    box(205, 208, 190, 20, 6);
    ellipse(264, 258, 12, 12);
    ellipse(319, 258, 12, 12);
    poly([
      const Offset(300, 285),
      const Offset(375, 303),
      const Offset(300, 314),
    ]);
    add(
      Path()
        ..moveTo(265, 325)
        ..quadraticBezierTo(300, 350, 335, 325),
      fillable: false,
    );
    poly([
      const Offset(335, 365),
      const Offset(335, 465),
      const Offset(365, 480),
      const Offset(365, 365),
    ]);
    box(215, 345, 170, 32, 10);
    add(
      Path()
        ..moveTo(177, 416)
        ..lineTo(85, 325)
        ..lineTo(60, 285)
        ..moveTo(85, 325)
        ..lineTo(40, 335),
      fillable: false,
    );
    add(
      Path()
        ..moveTo(423, 416)
        ..lineTo(510, 325)
        ..lineTo(555, 320)
        ..moveTo(510, 325)
        ..lineTo(525, 280),
      fillable: false,
    );
    for (final y in [407.0, 455.0, 505.0]) ellipse(290, y - 10, 20, 20);
    add(
      Path()
        ..moveTo(55, 590)
        ..quadraticBezierTo(300, 625, 545, 590),
      fillable: false,
    );
  } else if (picture == 'Gingerbread house') {
    ellipse(70, 530, 460, 55);
    box(380, 135, 50, 130);
    box(370, 130, 70, 25, 8);
    box(145, 265, 310, 285, 8);
    poly([
      const Offset(95, 290),
      const Offset(300, 95),
      const Offset(505, 290),
    ]);
    add(
      Path()
        ..moveTo(95, 290)
        ..lineTo(300, 95)
        ..lineTo(505, 290)
        ..lineTo(485, 315)
        ..lineTo(300, 140)
        ..lineTo(115, 315)
        ..close(),
    );
    add(
      Path()
        ..moveTo(145, 290)
        ..lineTo(455, 290)
        ..lineTo(455, 315)
        ..quadraticBezierTo(430, 350, 410, 315)
        ..quadraticBezierTo(385, 350, 365, 315)
        ..quadraticBezierTo(340, 350, 320, 315)
        ..quadraticBezierTo(295, 350, 275, 315)
        ..quadraticBezierTo(250, 350, 230, 315)
        ..quadraticBezierTo(205, 350, 185, 315)
        ..quadraticBezierTo(160, 350, 145, 315)
        ..close(),
    );
    for (final x in [225.0, 275.0, 325.0, 375.0]) ellipse(x - 14, 245, 28, 28);
    ellipse(278, 174, 44, 44);
    box(260, 405, 80, 145, 32);
    ellipse(320, 470, 12, 12);
    for (final x in [177.0, 355.0]) {
      box(x, 365, 68, 75, 8);
      box(x + 30, 365, 8, 75);
      box(x, 398, 68, 8);
      box(x - 7, 440, 82, 15, 5);
    }
    box(142, 525, 118, 25, 8);
    box(340, 525, 118, 25, 8);
    for (final x in [164.0, 195.0, 226.0, 362.0, 393.0, 424.0])
      ellipse(x - 8, 530, 16, 16);
    // Candy lollipops and a path to the front door.
    box(72, 435, 12, 130, 5);
    ellipse(48, 380, 60, 60);
    ellipse(63, 395, 30, 30);
    box(517, 435, 12, 130, 5);
    ellipse(493, 380, 60, 60);
    ellipse(508, 395, 30, 30);
    box(265, 555, 70, 25, 6);
    box(250, 590, 100, 25, 6);
  } else {
    add(
      Path()
        ..moveTo(230, 245)
        ..lineTo(200, 180)
        ..lineTo(185, 85)
        ..moveTo(200, 175)
        ..lineTo(140, 140)
        ..lineTo(115, 85)
        ..moveTo(195, 130)
        ..lineTo(245, 85),
      fillable: false,
    );
    add(
      Path()
        ..moveTo(370, 245)
        ..lineTo(400, 180)
        ..lineTo(415, 85)
        ..moveTo(400, 175)
        ..lineTo(460, 140)
        ..lineTo(485, 85)
        ..moveTo(405, 130)
        ..lineTo(355, 85),
      fillable: false,
    );
    add(
      Path()
        ..moveTo(215, 260)
        ..quadraticBezierTo(130, 170, 125, 260)
        ..quadraticBezierTo(140, 325, 215, 305)
        ..close(),
    );
    add(
      Path()
        ..moveTo(385, 260)
        ..quadraticBezierTo(470, 170, 475, 260)
        ..quadraticBezierTo(460, 325, 385, 305)
        ..close(),
    );
    poly([
      const Offset(235, 470),
      const Offset(215, 585),
      const Offset(385, 585),
      const Offset(365, 470),
    ]);
    ellipse(200, 220, 200, 270);
    ellipse(256, 319, 18, 18);
    ellipse(326, 319, 18, 18);
    ellipse(238, 375, 124, 90);
    ellipse(274, 377, 52, 52);
    add(
      Path()
        ..moveTo(275, 445)
        ..quadraticBezierTo(300, 463, 325, 445),
      fillable: false,
    );
    box(230, 480, 140, 35, 12);
    ellipse(280, 515, 40, 40);
    add(
      Path()
        ..moveTo(283, 544)
        ..lineTo(317, 544)
        ..moveTo(300, 515)
        ..lineTo(300, 523),
      fillable: false,
    );
  }
  return r;
}

class KidsColouringPage extends StatefulWidget {
  final String picture;
  const KidsColouringPage({super.key, required this.picture});
  @override
  State<KidsColouringPage> createState() => _KidsColouringPageState();
}

class _KidsColouringPageState extends State<KidsColouringPage> {
  late final regions = colouringRegions(widget.picture);
  late List<int> colours = List.filled(regions.length, 0xFFFFFFFF);
  final history = <List<int>>[];
  int selected = 0xFFE63946;
  bool loading = true, saving = false, dirty = false;
  String? error;
  String get storageKey => 'kids_colouring_v1_${widget.picture}';
  static const palette = <String, int>{
    'Red': 0xFFE63946,
    'Green': 0xFF32834A,
    'Gold': 0xFFF5BD32,
    'Blue': 0xFF3476D1,
    'Purple': 0xFF8659BA,
    'Pink': 0xFFF08FBB,
    'Orange': 0xFFF28A32,
    'Brown': 0xFF99613E,
    'Peach': 0xFFF3C7A7,
    'Grey': 0xFF9AA3AE,
    'Black': 0xFF252525,
    'White': 0xFFFFFFFF,
  };
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(storageKey);
      if (raw != null) {
        final values = (jsonDecode(raw) as List).cast<int>();
        if (values.length == regions.length && mounted) colours = values;
      }
    } catch (_) {
      error = 'Your saved picture could not load. You can start a new one.';
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> save() async {
    setState(() => saving = true);
    try {
      if (!await (await SharedPreferences.getInstance()).setString(
        storageKey,
        jsonEncode(colours),
      ))
        throw Exception();
      if (mounted) {
        setState(() => dirty = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Picture saved on this device.')),
        );
      }
    } catch (_) {
      if (mounted)
        setState(() => error = 'The picture could not save. Please try again.');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  void fill(Offset position, Size size) {
    if (loading || saving) return;
    final point = Offset(
      position.dx / size.width * 600,
      position.dy / size.height * 660,
    );
    for (var i = regions.length - 1; i >= 0; i--) {
      if (regions[i].fillable && regions[i].path.contains(point)) {
        if (colours[i] != selected)
          setState(() {
            history.add(List.of(colours));
            colours[i] = selected;
            dirty = true;
            error = null;
          });
        break;
      }
    }
  }

  Future<bool> discard() async =>
      !dirty ||
      (await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Leave your unsaved picture?'),
              content: const Text(
                'Save your picture to keep your colours for next time.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: const Text('Keep colouring'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: const Text('Leave without saving'),
                ),
              ],
            ),
          ) ??
          false);
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !dirty,
    onPopInvokedWithResult: (didPop, result) async {
      if (!didPop && await discard() && mounted) {
        setState(() => dirty = false);
        Navigator.pop(context);
      }
    },
    child: Scaffold(
      appBar: AppBar(title: Text('Colour ${widget.picture}')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Pick a colour, then tap a part of the picture. Save it to come back to your colours later on this device.',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in palette.entries)
                          Semantics(
                            label: entry.key,
                            selected: selected == entry.value,
                            button: true,
                            child: Tooltip(
                              message: entry.key,
                              child: InkWell(
                                key: ValueKey('colour-${entry.key}'),
                                onTap: saving
                                    ? null
                                    : () => setState(
                                        () => selected = entry.value,
                                      ),
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Color(entry.value),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected == entry.value
                                          ? const Color(0xFF0F4C45)
                                          : Colors.grey,
                                      width: selected == entry.value ? 4 : 1,
                                    ),
                                  ),
                                  child: selected == entry.value
                                      ? Icon(
                                          Icons.check,
                                          color:
                                              entry.key == 'Black' ||
                                                  entry.key == 'Blue' ||
                                                  entry.key == 'Purple' ||
                                                  entry.key == 'Green'
                                              ? Colors.white
                                              : Colors.black,
                                          size: 22,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: history.isEmpty || saving
                              ? null
                              : () => setState(() {
                                  colours = history.removeLast();
                                  dirty = true;
                                }),
                          icon: const Icon(Icons.undo),
                          label: const Text('Undo'),
                        ),
                        OutlinedButton.icon(
                          onPressed: saving
                              ? null
                              : () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                      title: const Text(
                                        'Start this picture again?',
                                      ),
                                      content: const Text(
                                        'All colours will be cleared. You can use Undo to bring them back.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(c, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(c, true),
                                          child: const Text('Start again'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true && mounted)
                                    setState(() {
                                      history.add(List.of(colours));
                                      colours = List.filled(
                                        regions.length,
                                        0xFFFFFFFF,
                                      );
                                      dirty = true;
                                    });
                                },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Start again'),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      color: Colors.white,
                      child: AspectRatio(
                        aspectRatio: 600 / 660,
                        child: LayoutBuilder(
                          builder: (context, box) => GestureDetector(
                            key: const ValueKey('colour-canvas'),
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (event) =>
                                fill(event.localPosition, box.biggest),
                            child: CustomPaint(
                              painter: ColouringPainter(regions, colours),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (error != null) Text(error!),
                    FilledButton.icon(
                      onPressed: saving ? null : save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(saving ? 'Saving…' : 'Save picture'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => launchUrl(
                        Uri.parse(
                          'https://christmasideasnz.co.nz/kids-colouring.html',
                        ).replace(queryParameters: {'picture': widget.picture}),
                        mode: LaunchMode.externalApplication,
                      ),
                      icon: const Icon(Icons.print_outlined),
                      label: const Text('Print a blank picture'),
                    ),
                  ],
                ),
              ),
            ),
    ),
  );
}

class ColouringPainter extends CustomPainter {
  final List<ColourRegion> regions;
  final List<int> colours;
  ColouringPainter(this.regions, this.colours);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 600, size.height / 660);
    final fill = Paint(),
        outline = Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.black
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    for (var i = 0; i < regions.length; i++) {
      if (regions[i].fillable)
        canvas.drawPath(regions[i].path, fill..color = Color(colours[i]));
      canvas.drawPath(regions[i].path, outline);
    }
  }

  @override
  bool shouldRepaint(ColouringPainter oldDelegate) => true;
}
