/// Presentation only: original body, permission records and credits stay intact.
String ideaBodyWithoutDuplicateAcknowledgement(String body, String credit) {
  String normalise(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim();
  final acknowledgement = normalise(credit);
  if (acknowledgement.isEmpty) return body;
  final lines = body.split('\n');
  final retained = lines
      .where((line) => normalise(line) != acknowledgement)
      .toList();
  if (retained.length == lines.length) return body;
  return retained.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}
