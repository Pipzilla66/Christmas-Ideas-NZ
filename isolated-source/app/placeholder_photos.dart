/// Category artwork is illustrative; it never replaces a supplied listing photo.
const placeholderPhotoPools = <String,List<String>>{
  'gift': ['gifts-red','gifts-green','gifts-hamper'],
  'event': ['events-market','events-festive'],
  'santa': ['events-santa-v2'],
  'market': ['events-market-v2'],
  'workshop': ['events-craft-v2'],
  'celebration': ['events-celebration-v2'],
  'light': ['lights-garden','lights-house'],
  'tree': ['trees-farm'],
  'shop': ['shops-ornaments','gifts-red','gifts-green'],
  'recipe': ['recipes-baking'],
  'craft': ['ideas-crafts','gifts-green'],
  'charity': ['charity-gifts'],
  'idea': ['ideas-crafts','shops-ornaments','gifts-green','events-festive'],
};

bool isLandingPhoto(String? url) {
  if(url == null || url.trim().isEmpty) return false;
  var value = url.toLowerCase();
  try { value = Uri.decodeComponent(value); } catch (_) {}
  value = value.split('?').first.split('#').first;
  return (value.contains('/assets/') || value.startsWith('assets/')) &&
      ['kiwi_christmas_hero_v1.webp','landing_christmas.webp','christmas_hero.webp'].any(value.endsWith);
}

String placeholderPhotoFor({required String kind, String reference = '', String title = ''}) {
  final type=kind.toLowerCase();
  final words=title.toLowerCase();
  String group;
  if(type.contains('gift')) { group='gift'; }
  else if(type.contains('recipe')) { group='recipe'; }
  else if(type.contains('charit')) { group='charity'; }
  else if(type.contains('christmas_tree') || type=='tree') { group='tree'; }
  else if(type.contains('light')) { group='light'; }
  else if(type.contains('santa_visit')) { group='santa'; }
  else if(type.contains('workshop')) { group='workshop'; }
  else if(type.contains('market')) { group='market'; }
  else if(type.contains('craft') || type.contains('elf')) { group='craft'; }
  else if(type.contains('event') || type.contains('market') || type.contains('santa_visit') || type=='christmas' || type=='community') {
    if(words.contains('workshop') || words.contains('wreath') || words.contains('craft class')) { group='workshop'; }
    else if(words.contains('market') || words.contains('fete') || words.contains('fête')) { group='market'; }
    else if(words.contains('grotto') || (words.contains('santa') && words.contains('photo'))) { group='santa'; }
    else { group='celebration'; }
  }
  else if(type.contains('business') || type.contains('store') || type.contains('retail') || type.contains('supplier') || type=='shop') { group='shop'; }
  else { group='idea'; }
  final pool=placeholderPhotoPools[group]!;
  final identity=reference.isEmpty ? title : reference;
  var hash=0;
  for(final unit in '$group:$identity'.codeUnits) { hash=(hash*31+unit)&0x7fffffff; }
  return 'assets/placeholders/${pool[hash%pool.length]}.webp';
}
