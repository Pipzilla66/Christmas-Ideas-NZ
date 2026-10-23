import 'dart:js_interop';
@JS('window.screen.width')
external JSNumber get _screenWidth;
@JS('navigator.maxTouchPoints')
external JSNumber get _touchPoints;
double? phoneScreenWidth() {
 final width = _screenWidth.toDartDouble;
 return _touchPoints.toDartDouble > 0 && width > 0 && width <= 600 ? width : null;
}
