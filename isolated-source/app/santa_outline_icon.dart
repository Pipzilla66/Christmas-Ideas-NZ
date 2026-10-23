import 'package:flutter/material.dart';

/// A single-colour Santa outline sized to match the other Explore icons.
class SantaOutlineIcon extends StatelessWidget {
  const SantaOutlineIcon({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 22,
    height: 22,
    child: CustomPaint(
      painter: _SantaPainter(
        IconTheme.of(context).color ?? Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class _SantaPainter extends CustomPainter {
  final Color color;
  const _SantaPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.65
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    // Hat, bobble and rounded brim.
    canvas.drawPath(
      Path()
        ..moveTo(6, 8)
        ..quadraticBezierTo(8, 1, 15, 2)
        ..quadraticBezierTo(20, 2, 20, 5)
        ..lineTo(17.5, 4)
        ..quadraticBezierTo(17, 6, 18, 8),
      pen,
    );
    canvas.drawCircle(const Offset(20, 6), 1.8, pen);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(4, 8, 16, 3),
        const Radius.circular(1.4),
      ),
      pen,
    );
    // Cheeks and beard.
    canvas.drawPath(
      Path()
        ..moveTo(5, 11)
        ..lineTo(5, 15)
        ..quadraticBezierTo(4, 19, 12, 22)
        ..quadraticBezierTo(20, 19, 19, 15)
        ..lineTo(19, 11),
      pen,
    );
    canvas.drawCircle(const Offset(9, 13), .55, pen);
    canvas.drawCircle(const Offset(15, 13), .55, pen);
    canvas.drawPath(
      Path()
        ..moveTo(7, 17)
        ..quadraticBezierTo(10, 14, 12, 16)
        ..quadraticBezierTo(14, 14, 17, 17)
        ..quadraticBezierTo(14, 19, 12, 17.5)
        ..quadraticBezierTo(10, 19, 7, 17),
      pen,
    );
  }

  @override
  bool shouldRepaint(_SantaPainter oldDelegate) => color != oldDelegate.color;
}
