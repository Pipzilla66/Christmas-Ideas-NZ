import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/listing_filters.dart';

void main() {
  final now = DateTime(2026, 12, 12, 12); // Saturday
  Map<String, dynamic> event(
    String name, {
    String? start,
    String? end,
    String? cost,
  }) => {
    '_type': 'Event',
    'name': name,
    'region': 'Canterbury',
    'city': 'Christchurch',
    'start_at': start,
    'end_at': end,
    'cost_text': cost,
  };

  test('Unknown costs do not pass free or paid filters', () {
    final all = [
      event('Unknown'),
      event('Free market', cost: 'Free entry'),
      event('Ticketed', cost: '\$5 per person'),
    ];
    expect(filterListings(all, now: now, cost: 'Free').map((e) => e['name']), [
      'Free market',
    ]);
    expect(filterListings(all, now: now, cost: 'Paid').map((e) => e['name']), [
      'Ticketed',
    ]);
    expect(filterListings(all, now: now).length, 3);
    expect(
      listingCostType(event('Donation', cost: 'Optional donation')),
      'Unknown',
    );
    expect(listingCostType(event('Not free', cost: 'Not free')), 'Unknown');
  });

  test(
    'Today includes ongoing events and excludes events ending at midnight',
    () {
      final all = [
        event(
          'Ongoing',
          start: '2026-12-01T10:00:00',
          end: '2026-12-24T18:00:00',
        ),
        event(
          'Ended',
          start: '2026-12-11T18:00:00',
          end: '2026-12-12T00:00:00',
        ),
        event('Today only', start: '2026-12-12T15:00:00'),
        event('Tomorrow', start: '2026-12-13T10:00:00'),
        event('No dates'),
      ];
      expect(
        filterListings(all, now: now, when: 'Today').map((e) => e['name']),
        ['Ongoing', 'Today only'],
      );
    },
  );

  test('Light end dates are inclusive', () {
    final light = <String, dynamic>{
      '_type': 'Lights',
      'name': 'Display',
      'start_date': '2026-12-01',
      'end_date': '2026-12-12',
    };
    expect(listingMatchesDate(light, 'Today', now, null), true);
    expect(
      listingMatchesDate(light, 'Today', DateTime(2026, 12, 13), null),
      false,
    );
  });

  test('Weekend includes Saturday and Sunday but excludes Monday', () {
    final all = [
      event('Sat', start: '2026-12-12T12:00:00'),
      event('Sun', start: '2026-12-13T12:00:00'),
      event('Mon', start: '2026-12-14T12:00:00'),
    ];
    expect(
      filterListings(all, now: now, when: 'This weekend').map((e) => e['name']),
      ['Sat', 'Sun'],
    );
    expect(
      filterListings(
        all,
        now: DateTime(2026, 12, 13),
        when: 'This weekend',
      ).length,
      2,
    );
    expect(
      filterListings(
        all,
        now: DateTime(2026, 12, 7),
        when: 'This weekend',
      ).length,
      2,
    );
  });

  test('Chosen date works across years and respects unknown dates', () {
    final all = [
      event('New year', start: '2027-01-01T12:00:00'),
      event('Unknown'),
    ];
    expect(
      filterListings(
        all,
        now: now,
        when: 'Choose a date',
        chosenDate: DateTime(2027, 1, 1),
      ).length,
      1,
    );
    expect(filterListings(all, now: now, when: 'Choose a date').isEmpty, true);
  });

  test('Region, city, category and search combine', () {
    final all = [
      event('Market'),
      {...event('Auckland Market'), 'region': 'Auckland', 'city': 'Auckland'},
      <String, dynamic>{
        '_type': 'Lights',
        'name': 'Light display',
        'region': 'Canterbury',
        'city': 'Christchurch',
        'address': 'Shands Road',
      },
    ];
    expect(
      filterListings(
        all,
        now: now,
        region: 'Canterbury',
        city: 'Christchurch',
        category: 'Light Displays',
        query: ' SHANDS ',
      ).length,
      1,
    );
    expect(
      filterListings(
        all,
        now: now,
        region: 'Auckland',
        city: 'Christchurch',
      ).isEmpty,
      true,
    );
  });

  test('Santa visits and parades use distinct categories', () {
    expect(listingCategory(event('Santa photos')), 'Santa Visits');
    expect(listingCategory(event('Santa Parade')), 'Events / Markets');
    expect(
      listingCategory({
        ...event('Christmas grotto'),
        'event_type': 'santa_visit',
      }),
      'Santa Visits',
    );
    expect(listingCategory({'_type': 'Store'}), 'Christmas Shops');
  });

  test('UTC timestamps are evaluated on the local calendar date', () {
    final first = DateTime(2026, 12, 12, 10);
    expect(
      listingMatchesDate(
        event('Timed', start: first.toUtc().toIso8601String()),
        'Today',
        now,
        null,
      ),
      true,
    );
  });
}
