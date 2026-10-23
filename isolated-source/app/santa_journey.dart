import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SantaStop {
  final String name;
  final double longitude, latitude;
  final DateTime at;
  const SantaStop(this.name, this.longitude, this.latitude, this.at);
}

/// December is NZ daylight time (UTC+13). Independent of the device timezone.
class SantaJourney {
  final DateTime now;
  late final DateTime nzNow = now.toUtc().add(const Duration(hours: 13));
  late final int year = nzNow.year;
  late final DateTime christmasEve = DateTime.utc(year, 12, 23, 11);
  late final List<SantaStop> stops = [
    SantaStop('North Pole', 0, 85, DateTime.utc(year, 12, 24, 5)),
    SantaStop('The Pacific Islands', 178, -18, DateTime.utc(year, 12, 24, 7)),
    SantaStop('New Zealand', 174, -41, DateTime.utc(year, 12, 24, 8)),
    SantaStop('Australia', 134, -26, DateTime.utc(year, 12, 24, 10)),
    SantaStop('Japan', 138, 36, DateTime.utc(year, 12, 24, 12)),
    SantaStop('China', 104, 35, DateTime.utc(year, 12, 24, 13)),
    SantaStop('India', 79, 22, DateTime.utc(year, 12, 24, 15, 30)),
    SantaStop('Europe', 15, 49, DateTime.utc(year, 12, 24, 20)),
    SantaStop('The United Kingdom', -2, 54, DateTime.utc(year, 12, 24, 21)),
    SantaStop('Brazil', -48, -16, DateTime.utc(year, 12, 25, 0)),
    SantaStop('Eastern North America', -74, 41, DateTime.utc(year, 12, 25, 2)),
    SantaStop('Western North America', -120, 40, DateTime.utc(year, 12, 25, 5)),
    SantaStop('North Pole', 0, 85, DateTime.utc(year, 12, 25, 7)),
  ];
  SantaJourney(DateTime value) : now = value.toUtc();
  bool get travelling => !now.isBefore(stops.first.at) && now.isBefore(stops.last.at);
  bool get returned => !now.isBefore(stops.last.at);
  bool get christmasEveStarted => !now.isBefore(christmasEve);
  int get leg {
    for (var i = 0; i < stops.length - 1; i++) {
      if (now.isBefore(stops[i + 1].at)) return i;
    }
    return stops.length - 2;
  }
  double get progress {
    if (!travelling) return 0;
    final start = stops[leg].at;
    return (now.difference(start).inMilliseconds /
      stops[leg + 1].at.difference(start).inMilliseconds).clamp(0.0, 1.0);
  }
  SantaStop get nextStop => stops[leg + 1];
  Offset get position {
    if (!travelling) return project(stops.first.longitude, stops.first.latitude);
    return Offset.lerp(project(stops[leg].longitude, stops[leg].latitude),
      project(nextStop.longitude, nextStop.latitude), progress)!;
  }
  DateTime get countdownTarget => returned ? DateTime.utc(year + 1, 12, 23, 11)
    : christmasEveStarted ? stops.first.at : christmasEve;
  Duration get countdown => countdownTarget.difference(now);
  String get headline => travelling ? 'Santa is on his way to ${nextStop.name}!' : 'Santa is at the North Pole';
  String get message => travelling
    ? 'The sleigh is flying, the bells are jingling and Christmas magic is on its way.'
    : returned ? 'The presents are delivered! Santa and the reindeer are resting after their big night.'
    : christmasEveStarted ? 'It’s Christmas Eve in New Zealand! The elves are packing the sleigh and the reindeer are getting ready.'
    : 'The elves are busy making presents, and Santa is checking his list. His magical journey starts on Christmas Eve.';
  static Offset project(double lon, double lat) => Offset((lon + 180) / 360, (90 - lat) / 180);
}

class SantaJourneyPage extends StatefulWidget {
  final DateTime Function()? clock;
  const SantaJourneyPage({super.key, this.clock});
  @override
  State<SantaJourneyPage> createState() => _SantaJourneyPageState();
}
class _SantaJourneyPageState extends State<SantaJourneyPage> {
  Timer? timer;
  DateTime get now => widget.clock?.call() ?? DateTime.now();
  @override
  void initState() { super.initState(); timer = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); }); }
  @override
  void dispose() { timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final journey = SantaJourney(now);
    final count = journey.countdown;
    final total = math.max(0, count.inSeconds);
    final countdown = '${total ~/ 86400} days  ${(total ~/ 3600) % 24} hours  ${(total ~/ 60) % 60} minutes';
    return Scaffold(
      appBar: AppBar(title: const Text('Where’s Santa?')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: const Color(0xff0f4c45), borderRadius: BorderRadius.circular(20)), child: Column(children: [
          const Icon(Icons.auto_awesome, color: Color(0xffe5c774), size: 36),
          const SizedBox(height: 12),
          Text(journey.headline, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(journey.message, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xfff6f1e5), fontSize: 16, height: 1.5)),
        ])),
        const SizedBox(height: 20),
        Text('Santa’s magical journey', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('From the North Pole, around the world, and all the way to Aotearoa.'),
        const SizedBox(height: 12),
        Semantics(label: journey.travelling ? 'Illustrated world map. ${journey.headline}' : 'Illustrated world map. Santa is at the North Pole. New Zealand is marked in gold.',
          child: ExcludeSemantics(child: ClipRRect(borderRadius: BorderRadius.circular(18), child: AspectRatio(aspectRatio: 1.65, child: CustomPaint(painter: SantaMapPainter(journey))))),
        ),
        const SizedBox(height: 16),
        if (!journey.travelling) Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          Text(journey.christmasEveStarted && !journey.returned ? 'Until the sleigh takes off' : 'Until Christmas Eve', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(countdown, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, color: Color(0xff9f1738), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8), const Text('Following New Zealand time', textAlign: TextAlign.center),
        ]))),
        if (journey.travelling) Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Next stop: ${journey.nextStop.name}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8), Text('Last stop: ${journey.stops[journey.leg].name}'),
          const SizedBox(height: 12), LinearProgressIndicator(value: journey.progress, color: const Color(0xff9f1738), backgroundColor: const Color(0xffe8e1ce)),
        ]))),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.star_outline, color: Color(0xff9f1738)), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('New Zealand is on Santa’s list!', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('On Christmas Eve, leave out a treat for Santa and some water for the reindeer. Then snuggle into bed so the Christmas magic can begin.'),
          ])),
        ]))),
        const SizedBox(height: 16),
        const Text('A playful Christmas journey created for Christmas Ideas NZ. The map is illustrated and all countdowns follow New Zealand time.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, height: 1.5)),
      ]),
    );
  }
}

/// A lightweight illustrated map: no location permission, tiles or flight feed.
class SantaMapPainter extends CustomPainter {
  final SantaJourney journey;
  SantaMapPainter(this.journey);
  // Simplified continent outlines, longitude/latitude pairs.
  static const land = <List<Offset>>[
    [Offset(-168,70),Offset(-140,73),Offset(-122,60),Offset(-98,70),Offset(-60,54),Offset(-52,47),Offset(-80,25),Offset(-96,17),Offset(-107,25),Offset(-125,48),Offset(-151,60)],
    [Offset(-80,10),Offset(-64,11),Offset(-35,-6),Offset(-43,-23),Offset(-64,-55),Offset(-75,-42),Offset(-81,-6)],
    [Offset(-52,82),Offset(-22,80),Offset(-38,61),Offset(-52,60),Offset(-62,72)],
    [Offset(-10,36),Offset(-9,52),Offset(5,58),Offset(23,71),Offset(58,72),Offset(95,77),Offset(145,69),Offset(179,66),Offset(161,51),Offset(140,38),Offset(122,20),Offset(103,1),Offset(82,8),Offset(74,23),Offset(48,12),Offset(35,30),Offset(26,40)],
    [Offset(-17,35),Offset(10,37),Offset(34,30),Offset(51,11),Offset(41,-13),Offset(29,-35),Offset(17,-34),Offset(9,-6),Offset(-16,10)],
    [Offset(113,-21),Offset(129,-12),Offset(141,-11),Offset(154,-26),Offset(150,-38),Offset(131,-34),Offset(115,-35)],
    [Offset(166,-34),Offset(177,-37),Offset(175,-42),Offset(172,-42),Offset(166,-46),Offset(168,-46),Offset(175,-40)],
    [Offset(130,32),Offset(143,45),Offset(145,42),Offset(137,33)],
    [Offset(47,-13),Offset(50,-17),Offset(46,-25),Offset(44,-21)],
  ];
  @override
  void paint(Canvas canvas, Size size) {
    Offset point(Offset p) => Offset(p.dx * size.width, p.dy * size.height);
    final background = Paint()..color = const Color(0xffe7f1ee);
    canvas.drawRect(Offset.zero & size, background);
    final grid = Paint()..color = const Color(0xffd4e5df)..strokeWidth = .7;
    for (var i=1; i<6; i++) { canvas.drawLine(Offset(size.width*i/6,0),Offset(size.width*i/6,size.height),grid); }
    for (var i=1; i<4; i++) { canvas.drawLine(Offset(0,size.height*i/4),Offset(size.width,size.height*i/4),grid); }
    for (final polygon in land) {
      final path = Path();
      for (var i=0; i<polygon.length; i++) { final p=point(SantaJourney.project(polygon[i].dx,polygon[i].dy)); if(i==0) {path.moveTo(p.dx,p.dy);} else {path.lineTo(p.dx,p.dy);} }
      path.close(); canvas.drawPath(path, Paint()..color=const Color(0xffb8d1c2));
      canvas.drawPath(path, Paint()..color=const Color(0xff8eb3a1)..style=PaintingStyle.stroke..strokeWidth=.8);
    }
    if (journey.travelling) {
      final path=Path(); final first=point(SantaJourney.project(journey.stops.first.longitude,journey.stops.first.latitude));path.moveTo(first.dx,first.dy);
      for(var i=1;i<=journey.leg;i++){final p=point(SantaJourney.project(journey.stops[i].longitude,journey.stops[i].latitude));path.lineTo(p.dx,p.dy);}
      final p=point(journey.position);path.lineTo(p.dx,p.dy);
      canvas.drawPath(path,Paint()..color=const Color(0xffaf2845)..style=PaintingStyle.stroke..strokeWidth=2..strokeCap=StrokeCap.round);
    }
    final nz=point(SantaJourney.project(174,-41));
    canvas.drawCircle(nz,5,Paint()..color=const Color(0xffb98222));
    label(canvas,'NZ',Offset(nz.dx-27,nz.dy+6),size.width);
    final pole=point(SantaJourney.project(0,85));
    canvas.drawCircle(pole,4,Paint()..color=const Color(0xff9f1738));
    label(canvas,'North Pole',Offset(pole.dx+28,8),size.width);
    final santa=point(journey.position);
    // Keep the sleigh inside the map at the pole and near the dateline.
    final centre=Offset(santa.dx.clamp(27.0,size.width-27),santa.dy.clamp(24.0,size.height-24));
    canvas.drawCircle(centre,19,Paint()..color=const Color(0xfffffaf0));
    canvas.drawCircle(centre,19,Paint()..color=const Color(0xffd6bc75)..style=PaintingStyle.stroke..strokeWidth=2);
    canvas.save();canvas.translate(centre.dx,centre.dy);
    final red=Paint()..color=const Color(0xff9f1738);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-11,-3,22,9),const Radius.circular(3)),red);
    canvas.drawRect(const Rect.fromLTWH(-7,-10,10,8),Paint()..color=const Color(0xff0f4c45));
    canvas.drawLine(const Offset(-2,-10),const Offset(-2,-2),Paint()..color=const Color(0xffe5c774)..strokeWidth=2);
    final runner=Path()..moveTo(-13,10)..lineTo(10,10)..quadraticBezierTo(16,10,15,3);
    canvas.drawPath(runner,Paint()..color=const Color(0xffb98222)..style=PaintingStyle.stroke..strokeWidth=2..strokeCap=StrokeCap.round);
    canvas.restore();
  }
  void label(Canvas canvas,String text,Offset at,double width) {
    final painter=TextPainter(text:TextSpan(text:text,style:const TextStyle(fontSize:11,color:Color(0xff173b36),fontWeight:FontWeight.bold)),textDirection:TextDirection.ltr)..layout();
    painter.paint(canvas,Offset(at.dx.clamp(4.0,width-painter.width-4),at.dy));
  }
  @override
  bool shouldRepaint(SantaMapPainter oldDelegate) => oldDelegate.journey.now != journey.now;
}
