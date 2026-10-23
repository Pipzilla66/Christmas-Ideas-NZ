import 'dart:math' as math;
import 'package:flutter/material.dart';

const festiveGreen = Color(0xff0f4c45);
const festiveRed = Color(0xff9f1738);
const festiveGold = Color(0xffc9a44d);

/// Static decoration respects reduced motion, has no ticker, and never takes taps.
class FestiveFrame extends StatelessWidget {
  final Widget child;
  const FestiveFrame({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
    child,
    const Positioned.fill(child: IgnorePointer(child: ExcludeSemantics(child: RepaintBoundary(child: CustomPaint(painter: FestiveSparkles()))))),
  ]);
}
class FestiveSparkles extends CustomPainter {
  final bool hero;
  const FestiveSparkles({this.hero = false});
  void star(Canvas canvas, Offset p, double r, Paint pen) {
    final path = Path();
    for (var i=0;i<8;i++) {
      final a = i * math.pi / 4 - math.pi / 2;
      final radius = i.isEven ? r : r * .23;
      final v = p + Offset(math.cos(a), math.sin(a)) * radius;
      if(i==0) { path.moveTo(v.dx,v.dy); } else { path.lineTo(v.dx,v.dy); }
    }
    canvas.drawPath(path..close(),pen);
  }
  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()..color=festiveGold.withValues(alpha: hero ? .85 : .32);
    if(hero) {
      for(final point in const [Offset(.06,.06),Offset(.2,.12),Offset(.36,.04),Offset(.62,.11),Offset(.8,.04),Offset(.93,.15),Offset(.12,.2),Offset(.53,.19),Offset(.87,.23)]) {
        star(canvas,Offset(point.dx*size.width,point.dy*size.height),5,pen);
      }
    } else {
      final top=32.0;
      for(final x in [7.0,size.width-7]) {
        for(var i=0;i<6;i++) {
          star(canvas,Offset(x,top+(size.height-160)*i/6),i.isEven?4:2.5,pen);
        }
      }
    }
  }
  @override
  bool shouldRepaint(FestiveSparkles old) => old.hero!=hero;
}
