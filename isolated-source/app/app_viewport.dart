import 'package:flutter/material.dart';
import 'phone_screen.dart';

// Flutter's fitted layout transforms painting and hit testing together.
// CSS scaling cannot reliably do that for its embedded input surface.
class AppViewport extends StatelessWidget {
 final Widget child;
 final double? phoneWidth;
 const AppViewport({super.key, required this.child, this.phoneWidth});
 @override
 Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
  final width = phoneWidth ?? phoneScreenWidth();
  if (width == null || !constraints.hasBoundedHeight || constraints.maxWidth <= width * 1.25) return child;
  final scale = constraints.maxWidth / width;
  final size = Size(width, constraints.maxHeight / scale);
  final media = MediaQuery.of(context);
  return FittedBox(fit: BoxFit.fill, alignment: Alignment.topLeft,
   child: SizedBox(width: size.width, height: size.height,
    child: MediaQuery(data: media.copyWith(size: size,
     padding: media.padding / scale, viewPadding: media.viewPadding / scale,
     viewInsets: media.viewInsets / scale), child: child)));
 });
}
