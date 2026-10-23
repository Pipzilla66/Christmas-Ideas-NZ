double? giftPrice(Map<String, dynamic> gift) =>
    double.tryParse((gift['price_min'] ?? '').toString());

String giftPriceLabel(Map<String, dynamic> gift) {
  final low = giftPrice(gift);
  final high = double.tryParse((gift['price_max'] ?? '').toString());
  if (low == null) return 'Check price with retailer';
  String amount(double value) => value.toStringAsFixed(2);
  final price = high != null && high > low
      ? 'NZ\$${amount(low)}–${amount(high)}'
      : 'NZ\$${amount(low)}';
  final gst = giftGstLabel(gift);
  return gst == null ? price : '$price · $gst';
}

// Retailer pricing terms checked 11 October 2026. Unknown sellers have no
// inferred tax status; explicit information on the listing takes precedence.
const gstInclusiveRetailers = {
  'farmers.co.nz': 'https://www.farmers.co.nz/terms-and-conditions',
  'bedbathandbeyond.co.nz': 'https://www.bedbathandbeyond.co.nz/pages/terms-of-use',
  'thewarehouse.co.nz': 'https://help.thewarehouse.co.nz/Help/s/article/Terms-and-conditions',
  'ecowarehouse.nz': 'https://ecowarehouse.nz/info/delivery-information',
};

String? giftGstLabel(Map<String, dynamic> gift) {
  final description = (gift['description'] ?? '').toString();
  final included = RegExp(r'\b(?:incl\.?|including|inclusive of)\s+GST\b|\bGST[ -]inclusive\b', caseSensitive: false).hasMatch(description);
  final excluded = RegExp(r'\b(?:excl\.?|excluding|exclusive of)\s+GST\b|\bGST[ -]exclusive\b', caseSensitive: false).hasMatch(description);
  if (included && excluded) return null;
  if (excluded) return 'excl. GST';
  if (included) return 'incl. GST';
  final host = Uri.tryParse((gift['product_url'] ?? '').toString())?.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
  return gstInclusiveRetailers.containsKey(host) ? 'incl. GST' : null;
}

bool hasDirectProductLink(Map<String, dynamic> gift) {
  final uri = Uri.tryParse((gift['product_url'] ?? '').toString());
  if (uri == null || !['https', 'http'].contains(uri.scheme)) return false;
  final path = uri.path.toLowerCase();
  return path.length > 1 &&
      !RegExp(
        r'/collections(?:/|$)|/c/|/all-products(?:/|$)|christmas-gifts|christmas-gift-guide',
      ).hasMatch(path);
}

List<Map<String, dynamic>> curateGifts(
  List<Map<String, dynamic>> all, {
  String query = '',
  String recipient = 'All',
  double maxBudget = 50,
  bool nzMadeOnly = false,
  bool includeUnpriced = false,
  bool lowestPriceFirst = false,
}) {
  final q = query.trim().toLowerCase();
  final result = all.where((gift) {
    final hay = '${gift['title'] ?? ''} ${gift['description'] ?? ''}'
        .toLowerCase();
    final low = giftPrice(gift);
    final high = double.tryParse((gift['price_max'] ?? '').toString()) ?? low;
    return (q.isEmpty || hay.contains(q)) &&
        (recipient == 'All' ||
            (gift['recipient_group'] ?? '').toString().toLowerCase() ==
                recipient.toLowerCase()) &&
        (low == null ? includeUnpriced : low >= 0 && high! <= maxBudget) &&
        (!nzMadeOnly || gift['nz_made'] == true);
  }).toList();
  int quality(Map<String, dynamic> g) =>
      (hasDirectProductLink(g) ? 8 : 0) +
      ((g['image_url'] ?? '').toString().isNotEmpty ? 4 : 0) +
      (g['featured'] == true ? 2 : 0);
  result.sort((a, b) {
    final priceOrder = (giftPrice(a) ?? double.infinity).compareTo(
      giftPrice(b) ?? double.infinity,
    );
    final qualityOrder = quality(b).compareTo(quality(a));
    if (lowestPriceFirst && priceOrder != 0) return priceOrder;
    if (qualityOrder != 0) return qualityOrder;
    if (priceOrder != 0) return priceOrder;
    return (a['title'] ?? '').toString().compareTo(
      (b['title'] ?? '').toString(),
    );
  });
  return result;
}

bool contentMatchesSection(Map<String, dynamic> item, String section) {
  const types = {
    'Decorations': 'decoration',
    'Recipes': 'recipe',
    'Elf Ideas': 'elf',
  };
  return item['content_type'] != 'budget' &&
      (section == 'All' || item['content_type'] == types[section]);
}
