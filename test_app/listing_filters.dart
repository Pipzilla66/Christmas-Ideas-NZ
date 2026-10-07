String listingCategory(Map<String, dynamic> item) {
  if (item['_type'] == 'Lights') return 'Lights';
  if (item['_type'] == 'Store') return 'Christmas Shops';
  final type = (item['event_type'] ?? '').toString().toLowerCase();
  if (['santa', 'santa_visit', 'santa_visits'].contains(type)) return 'Santa Visits';
  // Match visits and photos, while keeping Santa parades under events.
  final name = (item['name'] ?? '').toString().toLowerCase();
  if (name.contains('santa') && !name.contains('parade') &&
      RegExp(r'visit|grotto|photo|meet').hasMatch(name)) return 'Santa Visits';
  return 'Events / Markets';
}

String listingCostType(Map<String, dynamic> item) {
  final text = (item['cost_text'] ?? '').toString().trim().toLowerCase();
  if (text.isEmpty) return 'Unknown';
  if (RegExp(r'^(free\b|no charge\b|\$0(?:\.00)?(?:\s|$))').hasMatch(text)) return 'Free';
  if (text == 'paid' || RegExp(r'\$\s*[1-9]|\$\s*0\.\d*[1-9]|\b[1-9]\d*(?:\.\d+)?\s*nzd\b').hasMatch(text)) return 'Paid';
  return 'Unknown';
}

DateTime? listingStart(Map<String, dynamic> item) =>
    DateTime.tryParse((item['_type'] == 'Lights' ? item['start_date'] : item['start_at'])?.toString() ?? '')?.toLocal();
DateTime? listingEnd(Map<String, dynamic> item) =>
    DateTime.tryParse((item['_type'] == 'Lights' ? item['end_date'] : item['end_at'])?.toString() ?? '')?.toLocal();

bool listingMatchesDate(Map<String, dynamic> item, String when, DateTime now, DateTime? chosen) {
  if (when == 'Any time') return true;
  final first = listingStart(item);
  if (first == null) return false;
  final end = listingEnd(item);
  final last = end ?? first;
  final today = DateTime(now.year, now.month, now.day);
  DateTime windowStart;
  DateTime windowEnd;
  if (when == 'This weekend') {
    final days = now.weekday == DateTime.sunday ? -1 : DateTime.saturday - now.weekday;
    windowStart = DateTime(today.year, today.month, today.day + days);
    windowEnd = DateTime(windowStart.year, windowStart.month, windowStart.day + 2);
  } else {
    final day = when == 'Choose a date' ? chosen : today;
    if (day == null) return false;
    windowStart = DateTime(day.year, day.month, day.day);
    windowEnd = DateTime(day.year, day.month, day.day + 1);
  }
  if (item['_type'] == 'Lights') {
    // Light-display end dates are inclusive calendar dates.
    final exclusiveEnd = DateTime(last.year, last.month, last.day + 1);
    return first.isBefore(windowEnd) && exclusiveEnd.isAfter(windowStart);
  }
  return first.isBefore(windowEnd) &&
    (end == null ? !last.isBefore(windowStart) : last.isAfter(windowStart));
}

List<Map<String, dynamic>> filterListings(List<Map<String, dynamic>> all, {
  String region = 'All', String city = 'All', String category = 'All',
  String when = 'Any time', String cost = 'All', String query = '',
  required DateTime now, DateTime? chosenDate,
}) {
  final q = query.trim().toLowerCase();
  return all.where((item) {
    final hay = ['name', 'city', 'region', 'address', 'description']
        .map((key) => item[key] ?? '').join(' ').toLowerCase();
    return (region == 'All' || item['region'] == region) &&
      (city == 'All' || item['city'] == city) &&
      (category == 'All' || listingCategory(item) == category) &&
      (cost == 'All' || listingCostType(item) == cost) &&
      (q.isEmpty || hay.contains(q)) && listingMatchesDate(item, when, now, chosenDate);
  }).toList();
}
