class AdventFact {
  final int day;
  final String title, fact, activity, sourceName, sourceUrl;
  const AdventFact(this.day, this.title, this.fact, this.activity, this.sourceName, this.sourceUrl);
}
const _doc = 'https://www.doc.govt.nz/nature/native-plants/pohutukawa/';
const _nz = 'https://nzhistory.govt.nz/culture/kiwi-christmas';
const _kew = 'https://www.kew.org/read-and-watch/12-plants-of-christmas';
const _card = 'https://www.vam.ac.uk/articles/the-first-christmas-card';
const _cracker = 'https://www.vam.ac.uk/articles/the-christmas-cracker';
const _deer = 'https://www.nps.gov/articles/caribou-did-you-know.htm';
// Original short summaries, checked against the linked primary sources.
const adventFacts = <AdventFact>[
  AdventFact(1, 'Our Christmas tree', 'Pōhutukawa earned its Christmas-tree nickname from the bright red flowers it produces around Christmas.', 'Look for red Christmas colours on a walk, or draw a flowering pōhutukawa.', 'DOC', _doc),
  AdventFact(2, 'A Christmas card first', 'Henry Cole commissioned the first Christmas card in 1843. His artist friend John Callcott Horsley designed it.', 'Make a card for someone who would love a little Christmas cheer.', 'V&A', _card),
  AdventFact(3, 'Reindeer antlers', 'Both male and female reindeer grow antlers, unlike most other members of the deer family.', 'Draw a reindeer and give it a name for your own imaginary sleigh team.', 'National Park Service', _deer),
  AdventFact(4, 'Santa’s island visit', 'In 1951, Santa arrived at the Chatham Islands on a flying boat. Hundreds of islanders came to welcome him.', 'Find the Chatham Islands on a map and imagine how Santa might visit today.', 'NZ History', _nz),
  AdventFact(5, 'Leaves in disguise', 'The red parts of a poinsettia are special leaves called bracts, rather than flower petals.', 'Draw a poinsettia using bright red paper shapes for its leaves.', 'Kew', _kew),
  AdventFact(6, 'The cracker inventor', 'London baker and confectioner Tom Smith invented Christmas crackers. He patented his first cracker device in 1847.', 'Write your own cheerful cracker joke to share at Christmas dinner.', 'V&A', _cracker),
  AdventFact(7, 'A fragrant bark', 'Cinnamon, used in many festive treats, comes from the inner bark of the cinnamon tree.', 'Choose a favourite festive baking smell and ask someone about theirs.', 'Kew', _kew),
  AdventFact(8, 'Parades with a history', 'New Zealand’s early Santa parades began in the main centres in the early 1900s, organised by department stores.', 'Share a favourite Santa-parade memory with your family.', 'NZ History', _nz),
  AdventFact(9, 'A travelling tradition', 'Decorating Christmas trees is a tradition from Germany. Prince Albert helped popularise it in Britain during the nineteenth century.', 'Choose one decoration and tell the story of how it joined your tree.', 'Kew', _kew),
  AdventFact(10, 'A familiar tune', 'Jingle Bells was first published in 1857 with a different title: The One Horse Open Sleigh.', 'Hum a favourite Christmas tune and see who can guess it.', 'Library of Congress', 'https://www.loc.gov/item/2023812429/'),
  AdventFact(11, 'Ginger from underground', 'Gingerbread gets its distinctive flavour from ginger. The part we eat is the ginger plant’s underground stem, called a rhizome.', 'Sketch your dream gingerbread house, complete with a festive front door.', 'Kew', _kew),
  AdventFact(12, 'A leafy clue', 'Tiny hairs underneath its leaves help distinguish mainland pōhutukawa from its relative, rātā.', 'Look closely at a fallen leaf and draw the details you notice.', 'DOC', _doc),
  AdventFact(13, 'The first card batch', 'A thousand copies of Henry Cole’s 1843 Christmas card were printed, with space to add a greeting by hand.', 'Write a personal message inside a card instead of only signing your name.', 'V&A', _card),
  AdventFact(14, 'Holly’s surprise', 'Holly can have both smooth and spiky leaves. Pricklier leaves can develop in response to animals grazing the plant.', 'Design a Christmas wreath on paper using different leaf shapes.', 'Kew', _kew),
  AdventFact(15, 'A Kiwi Christmas song', 'Sticky Beak the kiwi was a popular New Zealand Christmas song in the 1960s, giving the season a local flavour.', 'Make up a silly festive verse about a kiwi, tūī or family pet.', 'NZ History', _nz),
  AdventFact(16, 'Cosy reindeer coats', 'Air trapped in caribou hair helps keep these Arctic deer warm.', 'Draw a winter outfit for Santa, then a summer outfit for his NZ visit.', 'National Park Service', _deer),
  AdventFact(17, 'The paper crown', 'Walter Smith, the cracker inventor’s son, added decorative paper hats and sourced little gifts for the crackers.', 'Make a paper crown and award it to someone who made you smile.', 'V&A', _cracker),
  AdventFact(18, 'Floating festive berries', 'Cranberries float. Flooding their growing areas helps harvesters gather the ripe berries used in festive sauces and other treats.', 'Plan a festive meal together and let everyone suggest one favourite food.', 'Kew', _kew),
  AdventFact(19, 'A giant Auckland Santa', 'Farmers first put a giant Santa above its Hobson Street department store in Auckland in 1960.', 'Draw a giant Christmas character you would love to see in your town.', 'NZ History', _nz),
  AdventFact(20, 'Christmas-tree relatives', 'Pōhutukawa and rātā belong to the same plant genus, Metrosideros. Both have a special place among New Zealand’s native trees.', 'Add a native-tree drawing to a handmade Christmas card.', 'DOC', _doc),
  AdventFact(21, 'A Christmas classic', 'Charles Dickens published A Christmas Carol in 1843, the same year as Henry Cole’s first Christmas card.', 'Choose a Christmas story or movie for a cosy family evening.', 'V&A', _card),
  AdventFact(22, 'A festive plant’s home', 'Poinsettias originally come from Mexico and are suited to warm climates.', 'Find Mexico on a map and talk about places your family would like to visit.', 'Kew', _kew),
  AdventFact(23, 'A summer Christmas', 'A Kiwi Christmas often comes with summer holidays: beaches, backyard cricket, barbecues and time at the bach or crib.', 'Pick one small summer tradition your family would like to keep.', 'NZ History', _nz),
  AdventFact(24, 'A call that started a tradition', 'A child’s misdialled phone call in 1955 began the Santa-tracking tradition that NORAD continues today.', 'Visit Where’s Santa in Kids Zone, then leave out treats and water before bedtime.', 'NORAD', 'https://www.norad.mil/NORAD-Tracks-Santa/'),
];
