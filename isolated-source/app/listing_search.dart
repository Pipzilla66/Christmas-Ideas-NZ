// All query words must match. Longer words tolerate one small typo, including
// swapped adjacent letters, without making short searches overly broad.
String _normaliseSearch(String text) => text
    .toLowerCase()
    .replaceAll('ā', 'a')
    .replaceAll('ē', 'e')
    .replaceAll('ī', 'i')
    .replaceAll('ō', 'o')
    .replaceAll('ū', 'u')
    .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
    .trim();

bool _oneTypo(String a, String b) {
  if ((a.length - b.length).abs() > 1) return false;
  if (a.length == b.length) {
    final differences = <int>[];
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) differences.add(i);
      if (differences.length > 2) return false;
    }
    if (differences.length <= 1) return true;
    final i = differences[0], j = differences[1];
    return j == i + 1 && a[i] == b[j] && a[j] == b[i];
  }
  final shorter = a.length < b.length ? a : b;
  final longer = a.length < b.length ? b : a;
  var i = 0, j = 0, skipped = false;
  while (i < shorter.length && j < longer.length) {
    if (shorter[i] == longer[j]) {
      i++;
      j++;
    } else {
      if (skipped) return false;
      skipped = true;
      j++;
    }
  }
  return true;
}

bool listingSearchMatches(String query, Iterable<Object?> fields) {
  final q = _normaliseSearch(query);
  if (q.isEmpty) return true;
  final hay = _normaliseSearch(fields.where((v) => v != null).join(' '));
  final words = hay.split(' ');
  final terms = q.split(' ');
  if (terms.length > 1) terms.removeWhere((term) => term == 'the');
  return terms.every(
    (term) => words.any(
      (word) =>
          word.contains(term) || (term.length >= 5 && _oneTypo(term, word)),
    ),
  );
}
