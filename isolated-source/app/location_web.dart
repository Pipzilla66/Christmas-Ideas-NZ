import 'dart:convert';
import 'dart:js_interop';

@JS('christmasLocation')
external JSPromise<JSString> _location();

Future<List<double>> requestLocation() async {
  final value = jsonDecode((await _location().toDart).toDart) as List;
  return value.map((v) => (v as num).toDouble()).toList();
}
