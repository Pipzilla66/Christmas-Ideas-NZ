import 'dart:convert';
import 'dart:js_interop';

@JS('christmasAnalytics')
external void _send(JSString event, JSString parameters);

void trackAnalytics(String event, Map<String, Object?> parameters) {
  try {
    _send(event.toJS, jsonEncode(parameters).toJS);
  } catch (_) {
    // Analytics must never interrupt browsing or opening a retailer.
  }
}

@JS('christmasUsageAllowed')
external JSBoolean _usageAllowed();
bool memberUsageAllowed() {
  try { return _usageAllowed().toDart; } catch (_) { return false; }
}
