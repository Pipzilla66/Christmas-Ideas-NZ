// Original copy for Christmas Ideas NZ. Platform links checked 17 October 2026.
const santaRules = <({String title, String intro, String rules})>[
  (
    title: 'Classic Secret Santa',
    intro: 'One person, one thoughtful surprise.',
    rules: '1. Agree a spending cap and exchange date.\n2. Draw names privately; redraw if you get yourself. Agree exclusions before drawing.\n3. Everyone buys or makes one gift for their assigned person.\n4. Label gifts with the recipient’s name. Open together and reveal the givers if you like.',
  ),
  (
    title: 'Swap or steal',
    intro: 'Also known as White Elephant or a gift swap.',
    rules: '1. Everyone brings one wrapped, unlabelled gift within the same budget.\n2. Draw numbers for the turn order. Player 1 opens a gift.\n3. Each later player opens a new gift or takes an unlocked gift from someone else. That person then takes a turn.\n4. No immediately taking back the same gift. A gift locks after two steals; one turn ends after three steals, when the last person opens a new gift.\n5. After the last turn, player 1 may swap once with an unlocked gift. The game then ends. These are our suggested house rules—agree them first.',
  ),
  (
    title: 'Left / right gift passing',
    intro: 'A circle, a short story and a lot of passing.',
    rules: '1. Bring one wrapped, unlabelled gift each and sit in a circle.\n2. A reader tells a story containing LEFT and RIGHT. Pass the gift you are holding each time you hear either word.\n3. When the story ends, open the gift in your hands.\n4. Agree beforehand: if anyone ends up with their own gift, everyone passes left once more. Keep gifts within the agreed cap.',
  ),
  (
    title: 'Themed exchange',
    intro: 'Choose a theme before drawing names.',
    rules: '1. Vote on a theme: something local, a favourite book, a summer picnic, something red, or a useful kitchen find.\n2. Agree the cap, date and whether gifts should be new, homemade or second-hand.\n3. Draw names, or bring unlabelled gifts for a swap. Tell everyone which version you chose.\n4. Include a short note explaining your choice. Keep joke gifts kind and suitable for the group.',
  ),
  (
    title: 'Sustainable Secret Santa',
    intro: 'Elf Phillie’s pick: no buying brand new.',
    rules: '1. The finished gift must be homemade or second-hand: try op shops, garage sales, Marketplace or a second-hand shop.\n2. Agree a spending cap, exchange date and name-draw or swap format. Decide whether buying ingredients or craft supplies for homemade gifts is allowed.\n3. Choose clean, complete items you would be happy to receive. Check food allergies before gifting homemade treats.\n4. Wrap in reused paper, a scarf or a reusable bag, and add a note about the find or how you made it.',
  ),
];
const sustainableInvite =
    'Secret Santa this year comes with one rule: no buying brand new! Your gift must be homemade or second-hand. Get creative with op shops, garage sales or Marketplace and see what treasures you can find.\n\nBudget: [amount]\nExchange date and place: [details]\nHow we are exchanging: [name draw / swap]\nHomemade ingredients and supplies: [our agreed rule]\nPlease let the organiser know any allergies or preferences.';
const leftRightStory =
    'On Christmas Eve, Santa LEFT his list on the kitchen bench. “That can’t be RIGHT,” said an elf. They turned RIGHT past the tree, then LEFT towards the workshop. A reindeer had LEFT a trail of ribbon. The elf followed it RIGHT into the wrapping room. There, RIGHT beside a plate of biscuits, was the missing list! Santa checked it was the RIGHT one, LEFT a thank-you note and turned LEFT towards the sleigh. With everyone in the RIGHT seat and no presents LEFT behind, they were ready for Christmas.';
const santaGiftIdeas = <({String title, int cap, String audience, String idea})>[
  (
    title: 'A favourite-book find',
    cap: 10,
    audience: 'Family',
    idea: 'Find a second-hand book that suits them and tuck in a handwritten recommendation.',
  ),
  (
    title: 'Desk cheer',
    cap: 10,
    audience: 'Colleagues',
    idea: 'Make a little desk plant cutting in a reused jar, with a care note.',
  ),
  (
    title: 'Biscuit parcel',
    cap: 10,
    audience: 'Someone you barely know',
    idea: 'Bake a small batch and include the ingredients and allergens on the label.',
  ),
  (
    title: 'A very official award',
    cap: 10,
    audience: 'Funny',
    idea:
        'Make a kind, personalised certificate and put it in an op-shop frame.',
  ),
  (
    title: 'Second-hand summer reading',
    cap: 20,
    audience: 'Colleagues',
    idea: 'Pair a pre-loved paperback with a handmade bookmark.',
  ),
  (
    title: 'Picnic treasure',
    cap: 20,
    audience: 'Family',
    idea: 'Look for a clean, complete second-hand picnic set or a lovely serving bowl.',
  ),
  (
    title: 'Tea-break pick',
    cap: 20,
    audience: 'Someone you barely know',
    idea: 'Choose tea or coffee within the cap, or pair an op-shop cup with a handwritten tea-break invitation.',
  ),
  (
    title: 'Mystery op-shop masterpiece',
    cap: 20,
    audience: 'Funny',
    idea: 'Find an unusual ornament and write its fictional museum label. Keep the joke friendly.',
  ),
  (
    title: 'Memory in a frame',
    cap: 30,
    audience: 'Family',
    idea: 'Put a meaningful photo or your own illustration in a second-hand frame.',
  ),
  (
    title: 'Useful little bundle',
    cap: 30,
    audience: 'Colleagues',
    idea: 'Build a small stationery or snack bundle around preferences they have shared.',
  ),
  (
    title: 'A garden beginning',
    cap: 30,
    audience: 'Someone you barely know',
    idea: 'Try a hardy plant or a propagated cutting in a second-hand pot, with simple care instructions.',
  ),
  (
    title: 'The travelling trophy',
    cap: 30,
    audience: 'Funny',
    idea: 'Give an op-shop trophy with a removable homemade label and start an annual tradition.',
  ),
  (
    title: 'Time together',
    cap: 50,
    audience: 'Family',
    idea: 'Offer a homemade voucher for a picnic, baking afternoon or help in the garden. Agree the date together.',
  ),
  (
    title: 'Locally made treat',
    cap: 50,
    audience: 'Colleagues',
    idea: 'Choose a small local product based on what they enjoy. Check dietary needs and the final price.',
  ),
  (
    title: 'A hobby starter',
    cap: 50,
    audience: 'Someone you barely know',
    idea: 'Use their wish list to choose a small puzzle, creative kit or game. Check that second-hand sets are complete.',
  ),
  (
    title: 'A spectacularly practical gift',
    cap: 50,
    audience: 'Funny',
    idea: 'Wrap a useful everyday item with an over-the-top handwritten instruction manual.',
  ),
];
const santaPlatforms = <({String name, String description, String url})>[
  (
    name: 'drawnames NZ',
    description: 'Free online name draws, wish lists and pairing exclusions. A NZ site and optional mobile app. Useful for families or teams who want to avoid partners drawing each other.',
    url: 'https://www.drawnames.co.nz/online-secret-santa',
  ),
  (
    name: 'Elfster',
    description: 'Free Secret Santa draws with email invitations, wish lists and draw restrictions. Useful if your group wants to share detailed gift wishes. Follow its account setup prompts.',
    url: 'https://www.elfster.com/lp/ssg',
  ),
  (
    name: 'Secret Santa Organizer',
    description: 'Free browser-based draws with email assignments, wish lists and exclusions. No account required; exclusions have group-size and timing conditions explained in its FAQ.',
    url: 'https://www.secretsantaorganizer.com/en/faq',
  ),
];
const decemberIdeas = <({String title, String message, String link})>[
  (
    title: 'Let’s make December festive',
    message: 'You’re invited to our December Christmas countdown! Join in when you can—there’s no pressure to do every activity. Our Secret Santa budget is [amount], our theme is [theme] and we’ll exchange gifts on [date].',
    link: 'hub',
  ),
  (
    title: 'Choose our exchange',
    message: 'Which Secret Santa shall we do: a classic name draw, a gift swap, or a sustainable exchange? Reply with your pick by [time]. We’ll confirm the rules before drawing names.',
    link: 'rules',
  ),
  (
    title: 'Draw names',
    message: 'Our Secret Santa draw is ready! Use this invitation: [paste your private draw invitation here]. Please keep your person a secret. Our budget is [amount] and gifts are due [date].',
    link: 'platforms',
  ),
  (
    title: 'What’s your elf name?',
    message: 'Today’s tiny festive task: find your elf name! Share your result if you fancy it. No real name or birthday needed.',
    link: 'elf',
  ),
  (
    title: 'Three little clues',
    message: 'Help your Secret Santa out: add three things you enjoy to your wish list, plus any allergies or things you would rather avoid. Keep wishes within our agreed budget.',
    link: 'gifts',
  ),
  (
    title: 'The op-shop challenge',
    message: 'What’s the best gift you could find second-hand? Share a treasure or an idea—no need to reveal anything you’re buying for your person!',
    link: 'sustainable',
  ),
  (
    title: 'Which reindeer are you?',
    message: 'Are you the organiser, the entertainer or the quiet helper? Try our just-for-fun reindeer personality quiz and share your result.',
    link: 'reindeer',
  ),
  (
    title: 'Christmas song vote',
    message: 'One vote each: which Christmas song belongs at the top of our playlist? Reply with your favourite. We’ll collect the suggestions for our gift exchange.',
    link: 'hub',
  ),
  (
    title: 'A small-budget brainstorm',
    message: 'Thoughtfulness beats a big price tag. Share one gift idea under \$10 or \$20. A book, a cutting or something handmade could be perfect.',
    link: 'gifts',
  ),
  (
    title: 'Festive two truths and a wish',
    message: 'Share two true Christmas facts about yourself and one made-up Christmas wish. Let the group guess which is the wish. Keep it light and share only what you’re comfortable with.',
    link: 'hub',
  ),
  (
    title: 'Homemade inspiration',
    message: 'What could you make with what you already have? Think a bookmark, biscuits, a plant cutting or a framed drawing. For food gifts, include ingredients and check allergies.',
    link: 'sustainable',
  ),
  (
    title: 'Christmas memory',
    message: 'What’s one small Christmas memory that makes you smile? A sentence or two is plenty. Feel free to pass and simply enjoy everyone else’s stories.',
    link: 'hub',
  ),
  (
    title: 'Wrap it again',
    message: 'Today’s challenge: think of a way to wrap without buying new paper. Try a scarf, saved gift bag, newspaper or a decorated paper shopping bag.',
    link: 'sustainable',
  ),
  (
    title: 'Festive quick quiz',
    message: 'A tiny word quiz: 1. Unscramble AATNS. 2. What word completes “Secret ___”? 3. Which comes first: Christmas Eve or Boxing Day? Answers tomorrow!',
    link: 'hub',
  ),
  (
    title: 'Answers and a kindness',
    message: 'Yesterday’s answers: 1. SANTA. 2. Santa. 3. Christmas Eve. Today, leave someone a kind note or send a thank-you message—no spending required.',
    link: 'hub',
  ),
  (
    title: 'Summer Christmas pick',
    message: 'Your ideal Kiwi Christmas afternoon: beach, backyard cricket, a picnic or a nap in the shade? Vote for one—or suggest your own.',
    link: 'hub',
  ),
  (
    title: 'Check-in, quietly',
    message: 'A gentle Secret Santa check-in: have you got your person and the date? If anything has changed or the budget is tricky, message the organiser privately. We can help.',
    link: 'rules',
  ),
  (
    title: 'The silliest gift description',
    message: 'Describe an ordinary household item as if it’s a luxury Christmas gift. Keep the item unnamed and let us guess. No buying anything needed!',
    link: 'hub',
  ),
  (
    title: 'A festive photo detail',
    message: 'If you’d like, share a close-up of a decoration or something festive. Let everyone guess what it is. Please avoid including people or personal details without permission.',
    link: 'hub',
  ),
  (
    title: 'Final gift inspiration',
    message: 'Still deciding on your gift? Check your person’s wish list and our gift ideas. Stick to the cap and our theme. Something thoughtful is plenty.',
    link: 'gifts',
  ),
  (
    title: 'Confirm the exchange',
    message: 'Gift exchange reminder! Date: [date]. Time: [time]. Place: [place]. Budget: [amount]. Theme: [theme]. Bring: [wrapped / labelled / unlabelled] gifts. Let me know privately if you can’t make it.',
    link: 'rules',
  ),
  (
    title: 'Left or right?',
    message: 'Fancy a gift-passing game? Sit in a circle with one wrapped gift each, agree the rules, then use our original left/right story. Save this for your gathering if today doesn’t suit.',
    link: 'story',
  ),
  (
    title: 'The gratitude round',
    message: 'Before the rush: name one thing you’ve enjoyed about our December countdown, or thank someone who has made the month easier. Joining in is optional.',
    link: 'hub',
  ),
  (
    title: 'Christmas Eve wishes',
    message: 'Wishing you a lovely Christmas Eve, however you spend it. Thank you for joining our festive countdown. No task today—just enjoy a little breathing space.',
    link: 'hub',
  ),
  (
    title: 'Merry Christmas',
    message: 'Merry Christmas from our group! Wishing you a day with some joy, rest and good company. Thanks for being part of our Christmas fun.',
    link: 'hub',
  ),
  (
    title: 'A slower Boxing Day',
    message: 'No shopping challenge today. Enjoy something you already have: a book, a game, a walk or some leftovers. What’s your favourite way to slow down?',
    link: 'hub',
  ),
  (
    title: 'Thank your Secret Santa',
    message: 'If you haven’t already, send your Secret Santa a thank-you. A little note about what you enjoyed makes a thoughtful gift feel even more special.',
    link: 'hub',
  ),
  (
    title: 'Keep the good ideas',
    message: 'Which activity or exchange rule should we keep for next year? Reply with one favourite while it’s fresh in your mind.',
    link: 'rules',
  ),
  (
    title: 'Pass on a good idea',
    message: 'Got a Secret Santa theme or a house rule that worked brilliantly? Share it with Christmas Ideas NZ for review so other groups can try it too.',
    link: 'submit',
  ),
  (
    title: 'Save next year’s plan',
    message: 'Future-you will thank you: save our spending cap, exchange rules and what worked. Add one thing you’d simplify next year.',
    link: 'calendar',
  ),
  (
    title: 'A happy New Year',
    message: 'Thanks for a December full of little festive moments. Wishing you a happy New Year—and another thoughtful Christmas together when it rolls around!',
    link: 'hub',
  ),
];
String santaLink(String section) =>
    'https://christmasideasnz.co.nz/?secret-santa=$section';
String decemberMessage(int index) =>
    '${decemberIdeas[index].message}\n\n${santaLink(decemberIdeas[index].link)}';
String decemberTemplate() => [
  for (var i = 0; i < decemberIdeas.length; i++)
    'DECEMBER ${i + 1}: ${decemberIdeas[i].title}\nSubject: ${decemberIdeas[i].title}\n\n${decemberMessage(i)}',
].join('\n\n────────────────────\n\n');
String icsEscape(String value) => value
    .replaceAll('\\', '\\\\')
    .replaceAll('\n', r'\n')
    .replaceAll(',', '\\,')
    .replaceAll(';', '\\;');
String decemberIcs(int year) {
  final out = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Christmas Ideas NZ//Secret Santa December//EN',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    'X-WR-CALNAME:Secret Santa December',
  ];
  for (var i = 0; i < 31; i++) {
    final day = '${i + 1}'.padLeft(2, '0');
    final next = DateTime(year, 12, i + 2);
    final end =
        '${next.year}${next.month.toString().padLeft(2, '0')}${next.day.toString().padLeft(2, '0')}';
    out.addAll([
      'BEGIN:VEVENT',
      'UID:secret-santa-$year-$day@christmasideasnz.co.nz',
      'DTSTAMP:${year}1001T000000Z',
      'DTSTART;VALUE=DATE:${year}12$day',
      'DTEND;VALUE=DATE:$end',
      'SUMMARY:${icsEscape(decemberIdeas[i].title)}',
      'DESCRIPTION:${icsEscape(decemberMessage(i))}',
      'URL:${santaLink(decemberIdeas[i].link)}',
      'END:VEVENT',
    ]);
  }
  out.add('END:VCALENDAR');
  // ASCII-only escaped lines are folded below 75 octets for calendar importers.
  return out
          .map((line) {
            final runes = line.runes.toList();
            final chunks = <String>[];
            var part = '';
            var bytes = 0;
            for (final rune in runes) {
              final c = String.fromCharCode(rune);
              final n = rune < 128
                  ? 1
                  : rune < 2048
                  ? 2
                  : rune < 65536
                  ? 3
                  : 4;
              if (bytes + n > 70) {
                chunks.add(part);
                part = ' ';
                bytes = 1;
              }
              part += c;
              bytes += n;
            }
            chunks.add(part);
            return chunks.join('\r\n');
          })
          .join('\r\n') +
      '\r\n';
}
