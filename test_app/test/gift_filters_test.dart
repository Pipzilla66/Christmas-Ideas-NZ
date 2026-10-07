import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/gift_filters.dart';

void main() {
  test(
    'Budget includes the whole price range and unknown prices are opt in',
    () {
      final gifts = <Map<String, dynamic>>[
        {'title': 'Affordable', 'price_min': 20, 'price_max': 30},
        {'title': 'Wide range', 'price_min': 10, 'price_max': 100},
        {'title': 'Unknown'},
      ];
      expect(curateGifts(gifts).map((g) => g['title']), ['Affordable']);
      expect(curateGifts(gifts, includeUnpriced: true).length, 2);
      expect(giftPriceLabel(gifts.last), 'Check price with retailer');
    },
  );
  test('Recipient search and NZ made combine, direct links rank ahead of generic pages', () {
    final gifts = <Map<String, dynamic>>[
      {
        'title': 'Garden idea',
        'recipient_group': 'Teachers',
        'price_min': 5,
        'nz_made': true,
        'featured': true,
        'product_url': 'https://shop.nz/collections/gifts',
      },
      {
        'title': 'Garden seeds',
        'recipient_group': 'Teachers',
        'price_min': 19,
        'nz_made': true,
        'product_url': 'https://shop.nz/garden-seeds',
      },
      {'title': 'Garden toy', 'recipient_group': 'Kids', 'price_min': 10},
    ];
    expect(
      curateGifts(
        gifts,
        recipient: 'Teachers',
        query: 'Garden',
        nzMadeOnly: true,
      ).first['title'],
      'Garden seeds',
    );
    expect(
      curateGifts(gifts, lowestPriceFirst: true).first['title'],
      'Garden idea',
    );
  });
  test('Decorations use their own content category', () {
    expect(
      contentMatchesSection({'content_type': 'decoration'}, 'Decorations'),
      true,
    );
    expect(
      contentMatchesSection({'content_type': 'recipe'}, 'Decorations'),
      false,
    );
  });
}
