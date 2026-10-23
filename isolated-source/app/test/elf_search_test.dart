import 'package:flutter_test/flutter_test.dart';

import 'package:christmas_ideas_nz_test/elf_search.dart';

void main() {
  final now = DateTime(2026, 10, 7);
  final items = <Map<String, dynamic>>[
    {
      'id': 'a',
      '_table': 'gift_ideas',
      'title': 'Gift for Mum',
      'recipient_group': 'her',
      'price_min': 45,
      'nz_made': true,
    },
    {
      'id': 'b',
      '_table': 'gift_ideas',
      'title': 'Luxury gift',
      'recipient_group': 'her',
      'price_min': 120,
    },
    {
      'id': 'c',
      '_table': 'gift_ideas',
      'title': 'Mystery price',
      'recipient_group': 'her',
    },
    {
      'id': 'd',
      '_table': 'events',
      'name': 'Family market',
      'city': 'Christchurch',
      'start_at': '2026-10-10T10:00:00',
      'end_at': '2026-10-10T14:00:00',
      'cost_text': 'Free',
    },
    {
      'id': 'e',
      '_table': 'events',
      'name': 'Family market',
      'city': 'Auckland',
      'start_at': '2026-10-10T10:00:00',
      'cost_text': '\$15',
    },
    {
      'id': 'f',
      '_table': 'events',
      'name': 'Old market',
      'city': 'Christchurch',
      'start_at': '2026-09-10T10:00:00',
      'cost_text': 'Free',
    },
    {
      'id': 'g',
      '_table': 'light_displays',
      'name': 'Christmas lights',
      'city': 'Christchurch',
      'start_date': '2026-12-01',
      'end_date': '2026-12-25',
    },
  ];
  test('budget excludes expensive gifts and unknown prices', () {
    expect(
      findElfMatches(
        'Gifts for Mum under \$50',
        items,
        now,
      ).map((r) => r['id']),
      ['a'],
    );
  });
  test('city and weekend are hard constraints', () {
    expect(
      findElfMatches(
        'Christchurch events this weekend',
        items,
        now,
      ).map((r) => r['id']),
      ['d'],
    );
  });
  test('free is recorded cost, not a guessed cost', () {
    expect(
      findElfMatches('Free family activities', items, now).map((r) => r['id']),
      contains('d'),
    );
    expect(
      findElfMatches('Free family activities', items, now).map((r) => r['id']),
      isNot(contains('e')),
    );
  });
  test('NZ made only returns confirmed NZ-made gifts', () {
    expect(findElfMatches('NZ-made gifts', items, now).map((r) => r['id']), [
      'a',
    ]);
  });
  test('lights excludes shops, gifts and events', () {
    expect(findElfMatches('Christmas lights', items, now).map((r) => r['id']), [
      'g',
    ]);
  });
  test('unmatched query does not fabricate a result', () {
    expect(findElfMatches('Astronaut telescope', items, now), isEmpty);
  });
}
