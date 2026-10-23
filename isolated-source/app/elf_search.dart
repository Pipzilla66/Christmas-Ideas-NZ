import 'listing_filters.dart';

/// Read-only guide matching; never creates tickets or invents listings.
List<Map<String, dynamic>> findElfMatches(
  String question,
  List<Map<String, dynamic>> items,
  DateTime now,
) {
  final q = question.toLowerCase().trim();
  final budgetMatch = RegExp(
    r'(?:under|below|less than|up to|budget(?: of)?)\s*\$?\s*(\d+(?:\.\d+)?)',
  ).firstMatch(q);
  final budget = budgetMatch == null
      ? null
      : double.tryParse(budgetMatch.group(1)!);
  final gifts = RegExp(r'\bgifts?\b|\bpresents?\b').hasMatch(q);
  final lights = RegExp(r'\blights?\b').hasMatch(q);
  final events = RegExp(r'\bevents?\b|\bmarkets?\b|\bactivities\b|\bsanta\b')
      .hasMatch(q);
  final nzMade = RegExp(r'nz[ -]?made|new zealand[ -]?made').hasMatch(q);
  final free = RegExp(r'\bfree\b').hasMatch(q);
  final when = q.contains('weekend')
      ? 'This weekend'
      : RegExp(r'\btoday\b').hasMatch(q)
      ? 'Today'
      : 'Any time';
  final recipient = RegExp(r'\bmum\b|\bmom\b|\bher\b|\bwoman\b').hasMatch(q)
      ? 'her'
      : RegExp(r'\bdad\b|\bhim\b|\bman\b').hasMatch(q)
      ? 'him'
      : RegExp(r'\bkids?\b|\bchild\b|\bboy\b|\bgirl\b').hasMatch(q)
      ? 'kids'
      : RegExp(r'\bpets?\b|\bdog\b|\bcat\b').hasMatch(q)
      ? 'pets'
      : null;
  final places = items
      .expand((r) => [r['city'], r['region']])
      .whereType<String>()
      .where((p) => p.isNotEmpty && q.contains(p.toLowerCase()))
      .toSet();
  const stop = {
    'a',
    'an',
    'the',
    'for',
    'me',
    'my',
    'find',
    'show',
    'please',
    'ideas',
    'idea',
    'gifts',
    'gift',
    'presents',
    'present',
    'under',
    'below',
    'less',
    'than',
    'up',
    'to',
    'budget',
    'of',
    'christmas',
    'nz',
    'made',
    'new',
    'zealand',
    'free',
    'this',
    'weekend',
    'today',
    'events',
    'event',
    'markets',
    'market',
    'lights',
    'light',
    'activities',
    'what',
    'are',
    'on',
    'in',
    'at',
    'can',
    'i',
    'get',
    'some',
    'mum',
    'mom',
    'dad',
    'her',
    'him',
    'kids',
    'kid',
    'pets',
    'family',
    'year',
    'years',
    'old',
    'boy',
    'girl',
    'woman',
    'man',
    'dog',
    'cat',
  };
  final words = q
      .split(RegExp(r'[^a-z0-9]+'))
      .where(
        (w) =>
            w.length > 2 &&
            !stop.contains(w) &&
            double.tryParse(w) == null &&
            !places.any((p) => p.toLowerCase().split(' ').contains(w)),
      )
      .toSet();
  final scored = <({Map<String, dynamic> item, int score})>[];
  for (final item in items) {
    final table = item['_table'];
    if (gifts && table != 'gift_ideas') continue;
    if (lights && table != 'light_displays') continue;
    if (events && !lights && table != 'events' && table != 'content_items')
      continue;
    if (nzMade && item['nz_made'] != true) continue;
    final price = double.tryParse('${item['price_min'] ?? ''}');
    if (budget != null &&
        (table != 'gift_ideas' || price == null || price > budget))
      continue;
    if (recipient != null &&
        table == 'gift_ideas' &&
        '${item['recipient_group']}'.toLowerCase() != recipient)
      continue;
    final listing = {
      ...item,
      '_type': table == 'light_displays'
          ? 'Lights'
          : table == 'businesses'
          ? 'Store'
          : 'Event',
    };
    if (free && listingCostType(listing) != 'Free') continue;
    if (when != 'Any time' && !listingMatchesDate(listing, when, now, null))
      continue;
    if (places.isNotEmpty &&
        !places.any((p) => item['city'] == p || item['region'] == p))
      continue;
    final hay = [
      'title',
      'name',
      'description',
      'summary',
      'body',
      'content_type',
      'recipient_group',
      'city',
      'region',
    ].map((k) => item[k] ?? '').join(' ').toLowerCase();
    final hits = words.where(hay.contains).length;
    if (words.isNotEmpty && hits == 0) continue;
    scored.add((
      item: item,
      score: hits * 10 + (item['featured'] == true ? 2 : 0),
    ));
  }
  scored.sort((a, b) => b.score.compareTo(a.score));
  return scored.take(8).map((r) => r.item).toList();
}
