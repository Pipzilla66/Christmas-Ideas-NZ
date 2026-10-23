import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'secret_santa_data.dart';
import 'text_download.dart';

const santaSections = [
  'hub',
  'rules',
  'gifts',
  'platforms',
  'sustainable',
  'elf',
  'reindeer',
  'calendar',
  'story',
];
const santaSectionLabels = [
  'Start here',
  'How to play',
  'Gift ideas',
  'Organise a draw',
  'Sustainable',
  'Elf name',
  'Reindeer quiz',
  'December calendar',
  'Passing story',
];

Future<void> santaCopy(BuildContext context, String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied—ready to paste.')));
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not copy. You can select the message text instead.',
          ),
        ),
      );
  }
}

class SecretSantaPage extends StatefulWidget {
  final String initialSection;
  final VoidCallback? onSubmit;
  final ValueChanged<double>? onBrowseGifts;
  const SecretSantaPage({
    super.key,
    this.initialSection = 'hub',
    this.onSubmit,
    this.onBrowseGifts,
  });
  @override
  State<SecretSantaPage> createState() => _SecretSantaPageState();
}

class _SecretSantaPageState extends State<SecretSantaPage> {
  late String section;
  final scroll = ScrollController();
  int budget = 20;
  String audience = 'All';
  int year = DateTime.now().year;
  @override
  void initState() {
    super.initState();
    section = santaSections.contains(widget.initialSection)
        ? widget.initialSection
        : 'hub';
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void select(String s) {
    setState(() => section = s);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  Widget heading(String title, String sub) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(sub),
      ],
    ),
  );
  Widget card(
    String title,
    String body, {
    Widget? footer,
    IconData? icon,
  }) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SelectableText(body),
          if (footer != null) ...[const SizedBox(height: 12), footer],
        ],
      ),
    ),
  );
  Widget choice(
    String title,
    String detail,
    IconData icon,
    String target,
  ) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => select(target),
    ),
  );
  Widget copyButton(String text, {String label = 'Copy message'}) =>
      OutlinedButton.icon(
        onPressed: () => santaCopy(context, text),
        icon: const Icon(Icons.copy_outlined),
        label: Text(label),
      );
  Future<void> external(String url) async {
    try {
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) throw StateError('open');
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the website. Please try again.'),
          ),
        );
    }
  }

  void download(String value, String filename, String mime) {
    try {
      downloadText(value, filename, mime);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Open the web app in a browser to download the plan.'),
        ),
      );
    }
  }

  List<Widget> content() {
    switch (section) {
      case 'rules':
        return [
          heading(
            'Choose how to play',
            'Simple house rules for your family, workplace or friends. Agree the budget, date and format before anyone buys a gift.',
          ),
          for (final rule in santaRules)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(
                  rule.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(rule.intro),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(rule.rules),
                  const SizedBox(height: 10),
                  copyButton(
                    '${rule.title}\n\n${rule.rules}',
                    label: 'Copy rules',
                  ),
                  if (rule.title == 'Left / right gift passing')
                    TextButton(
                      onPressed: () => select('story'),
                      child: const Text('Read the passing story'),
                    ),
                ],
              ),
            ),
          if (widget.onSubmit != null)
            TextButton.icon(
              onPressed: widget.onSubmit,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('Share your own theme or rules'),
            ),
        ];
      case 'story':
        return [
          heading(
            'A left / right passing story',
            'An original Christmas Ideas NZ story for your gathering.',
          ),
          card(
            'Before you start',
            'Sit in a circle with one wrapped gift each. Read the story aloud, slowly. Pass the gift in your hands whenever you hear LEFT or RIGHT. At the end, keep the gift you are holding. If someone has their own gift, everyone passes left once more.',
          ),
          card(
            'The missing Christmas list',
            leftRightStory,
            footer: copyButton(leftRightStory, label: 'Copy story'),
          ),
        ];
      case 'platforms':
        return [
          heading(
            'Organise your draw',
            'Let an online tool privately assign names. Check everyone can use your chosen tool, then agree exclusions before drawing.',
          ),
          for (final p in santaPlatforms)
            card(
              p.name,
              p.description,
              icon: Icons.shuffle,
              footer: FilledButton.icon(
                onPressed: () => external(p.url),
                icon: const Icon(Icons.open_in_new),
                label: Text('Visit ${p.name}'),
              ),
            ),
          const Text(
            'Links go to independent services. Features checked 17 October 2026; see each provider for its current terms and privacy information.',
          ),
          const SizedBox(height: 14),
          card(
            'The paper option',
            'Write each name once, fold the slips and draw privately. If anyone draws themselves or an excluded partner, start the whole draw again. For larger groups or complex exclusions, an online draw is easier.',
          ),
        ];
      case 'gifts':
        return [
          heading(
            'Thoughtful gifts, sensible budgets',
            'Choose a cap and who you are buying for. These are starting ideas, not live product prices—adapt each one to your budget.',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final b in [10, 20, 30, 50])
                ChoiceChip(
                  label: Text('Up to \$$b'),
                  selected: budget == b,
                  onSelected: (_) => setState(() => budget = b),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final a in [
                'All',
                'Colleagues',
                'Family',
                'Funny',
                'Someone you barely know',
              ])
                ChoiceChip(
                  label: Text(a),
                  selected: audience == a,
                  onSelected: (_) => setState(() => audience = a),
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final g in santaGiftIdeas.where(
            (g) =>
                g.cap <= budget &&
                (audience == 'All' || g.audience == audience),
          ))
            card(g.title, '${g.audience} · Try within \$${g.cap}\n\n${g.idea}'),
          if (widget.onBrowseGifts != null)
            FilledButton.icon(
              onPressed: () => widget.onBrowseGifts!(budget.toDouble()),
              icon: const Icon(Icons.card_giftcard_outlined),
              label: Text('Browse listed gifts up to \$$budget'),
            ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => select('sustainable'),
            child: const Text('Doing a no-new-gifts exchange? Start here'),
          ),
        ];
      case 'sustainable':
        return [
          heading(
            'Sustainable Secret Santa',
            'Elf Phillie’s pick: thoughtful gifts without buying brand new.',
          ),
          card(
            santaRules.last.title,
            santaRules.last.rules,
            icon: Icons.eco_outlined,
            footer: copyButton(
              santaRules.last.rules,
              label: 'Copy sustainable rules',
            ),
          ),
          card(
            'Try one of these',
            '• A pre-loved book with a handwritten note.\n• A plant cutting in a second-hand pot.\n• A board game with all its pieces.\n• A photo or drawing in an op-shop frame.\n• Homemade treats with an ingredient label.\n• A homemade voucher for time or a useful skill.\n• An interesting garage-sale serving dish.\n• A knitted, sewn or repaired treasure.',
          ),
          card(
            'Ready-to-copy invitation',
            sustainableInvite,
            footer: copyButton(sustainableInvite, label: 'Copy invitation'),
          ),
          card(
            'Make it easy to join in',
            'Keep the cap comfortable for everyone. Clarify whether craft supplies and ingredients may be bought new. Ask about preferences, check second-hand items are clean and complete, and reuse the wrapping too.',
          ),
        ];
      case 'elf':
        return [
          heading(
            'What’s your elf name?',
            'A tiny bit of North Pole nonsense. Make a name for your gift tag or group chat.',
          ),
          const ElfNameGenerator(),
        ];
      case 'reindeer':
        return [
          heading(
            'Which reindeer are you?',
            'Four quick questions for a bit of fun—there are no wrong answers.',
          ),
          const ReindeerQuiz(),
        ];
      case 'calendar':
        return [
          heading(
            'A little Christmas, every day',
            'A ready-to-use organiser’s plan for 1–31 December. Copy a message, replace the [brackets] and share by email or group chat. Move activities to suit your exchange date.',
          ),
          card(
            'Make it yours',
            'Set your budget, theme and exchange date before sending. Paste your own private draw invitation into 3 December. The public links open the relevant part of this Secret Santa section.',
          ),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              DropdownButton<int>(
                value: year,
                items: [
                  for (
                    var y = DateTime.now().year;
                    y <= DateTime.now().year + 2;
                    y++
                  )
                    DropdownMenuItem(value: y, child: Text('December $y')),
                ],
                onChanged: (y) => setState(() => year = y!),
              ),
              OutlinedButton.icon(
                onPressed: () => download(
                  decemberTemplate(),
                  'secret-santa-december-$year.txt',
                  'text/plain;charset=utf-8',
                ),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Download messages'),
              ),
              OutlinedButton.icon(
                onPressed: () => download(
                  decemberIcs(year),
                  'secret-santa-december-$year.ics',
                  'text/calendar;charset=utf-8',
                ),
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Add to my calendar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          card(
            'Reminders and email delivery',
            'The calendar download contains 31 all-day entries with the message and link for each day. Import it into Google, Outlook or Apple Calendar and choose reminders there. These are calendar entries, not automatic emails.\n\nDaily email sign-up is not available yet.',
          ),
          for (var i = 0; i < decemberIdeas.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(
                  '${i + 1} December · ${decemberIdeas[i].title}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    'Subject: ${decemberIdeas[i].title}\n\n${decemberMessage(i)}',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      copyButton(
                        'Subject: ${decemberIdeas[i].title}\n\n${decemberMessage(i)}',
                      ),
                      TextButton(
                        onPressed: () {
                          final target = decemberIdeas[i].link;
                          if (target == 'submit') {
                            widget.onSubmit?.call();
                          } else {
                            select(target);
                          }
                        },
                        child: const Text('Open activity'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ];
      default:
        return [
          Container(
            padding: const EdgeInsets.all(22),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F4C45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.card_giftcard_outlined,
                  size: 40,
                  color: Color(0xFFE2BE72),
                ),
                SizedBox(height: 12),
                Text(
                  'Small gifts. Big Christmas spirit.',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Plan your exchange, find a thoughtful gift and keep the fun going all December.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          choice(
            'Choose how to play',
            'Classic draws, swapping, stealing and left/right passing.',
            Icons.swap_horiz,
            'rules',
          ),
          choice(
            'Find a gift',
            'Ideas by budget and person, plus the gift directory.',
            Icons.card_giftcard_outlined,
            'gifts',
          ),
          choice(
            'Organise your draw',
            'Compare free online name-draw tools.',
            Icons.shuffle,
            'platforms',
          ),
          choice(
            'Sustainable Secret Santa',
            'Homemade and second-hand treasures. No buying brand new.',
            Icons.eco_outlined,
            'sustainable',
          ),
          choice(
            'Your December calendar',
            '31 activities and ready-to-copy messages.',
            Icons.calendar_month_outlined,
            'calendar',
          ),
          const SizedBox(height: 10),
          Text(
            'A little festive fun',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          choice(
            'What’s your elf name?',
            'Make a name for your gift tag or group chat.',
            Icons.auto_awesome_outlined,
            'elf',
          ),
          choice(
            'Which reindeer are you?',
            'A four-question personality quiz.',
            Icons.celebration_outlined,
            'reindeer',
          ),
          if (widget.onSubmit != null)
            TextButton.icon(
              onPressed: widget.onSubmit,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('Share your own theme or rules'),
            ),
          const Text(
            'Community suggestions go to the existing review queue before publication.',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Secret Santa')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          children: [
            SizedBox(
              height: 44 * MediaQuery.textScalerOf(context).scale(14) / 14 + 16,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  for (var i = 0; i < santaSections.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(santaSectionLabels[i]),
                        selected: section == santaSections[i],
                        onSelected: (_) => select(santaSections[i]),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                children: content(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

const elfFirstNames = [
  'Twinkle',
  'Pipkin',
  'Jingle',
  'Tinsel',
  'Biscuit',
  'Sparkle',
  'Merry',
  'Clover',
  'Pudding',
  'Cinnamon',
  'Fizzy',
  'Jolly',
];
const elfLastNames = [
  'Pōhutukawa',
  'Giftwhisper',
  'Ribbonboots',
  'Pavlovapop',
  'Jandalspark',
  'Tinseltwist',
  'Snowbell',
  'Gingercrumb',
  'Starbutton',
  'Cocoasocks',
  'Bellberry',
  'Peppermint',
];
String elfNameFor(int treat, int mood, int surprise) =>
    '${elfFirstNames[(treat * 3 + mood + surprise) % elfFirstNames.length]} ${elfLastNames[(mood * 3 + treat + surprise) % elfLastNames.length]}';

class ElfNameGenerator extends StatefulWidget {
  const ElfNameGenerator({super.key});
  @override
  State<ElfNameGenerator> createState() => _ElfNameGeneratorState();
}

class _ElfNameGeneratorState extends State<ElfNameGenerator> {
  int treat = 0, mood = 0, surprise = 0;
  String? result;
  final random = Random();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pick a festive treat'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (var i = 0; i < 4; i++)
                ChoiceChip(
                  label: Text(
                    [
                      'Pavlova',
                      'Gingerbread',
                      'Chocolate',
                      'Fruit mince pie',
                    ][i],
                  ),
                  selected: treat == i,
                  onSelected: (_) => setState(() {
                    treat = i;
                    result = null;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Choose your Christmas mood'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (var i = 0; i < 4; i++)
                ChoiceChip(
                  label: Text(['Cosy', 'Sparkly', 'Cheeky', 'Beachy'][i]),
                  selected: mood == i,
                  onSelected: (_) => setState(() {
                    mood = i;
                    result = null;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: () =>
                    setState(() => result = elfNameFor(treat, mood, surprise)),
                child: const Text('Make my elf name'),
              ),
              OutlinedButton(
                onPressed: () => setState(() {
                  surprise = (surprise + 1 + random.nextInt(11)) % 12;
                  result = elfNameFor(treat, mood, surprise);
                }),
                child: const Text('Surprise me'),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 22),
            Semantics(
              liveRegion: true,
              child: Text(
                result!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => santaCopy(
                context,
                'My Christmas elf name is $result! Find yours: ${santaLink('elf')}',
              ),
              icon: const Icon(Icons.copy_outlined),
              label: const Text('Copy my elf name'),
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'No real names or birthdays needed. Your choices stay on this page.',
          ),
        ],
      ),
    ),
  );
}

const reindeerQuestions = [
  'The gift exchange is coming up. You…',
  'Your ideal Christmas gathering has…',
  'A present needs a little rescue. You…',
  'Your favourite part of giving is…',
];
const reindeerOptions = [
  [
    'Make a clear plan',
    'Get everyone laughing',
    'Check everyone feels included',
    'Try a new creative idea',
  ],
  [
    'A relaxed, organised flow',
    'Music and a bit of silliness',
    'Time for a good catch-up',
    'A little surprise',
  ],
  [
    'Find the wrapping and tape',
    'Turn it into a funny story',
    'Quietly lend a hand',
    'Make a brilliant new gift tag',
  ],
  [
    'Knowing it all came together',
    'The delight when it opens',
    'Making someone feel seen',
    'Finding something unexpected',
  ],
];
const reindeerNames = ['Dasher', 'Dancer', 'Cupid', 'Comet'];
const reindeerDescriptions = [
  'The organiser. You keep the sleigh moving with a plan, a checklist and a calm word. Your festive superpower is making it easy for everyone to join in.',
  'The entertainer. You bring the playlist, the laughter and the joyful energy. Your festive superpower is helping everyone relax and have fun.',
  'The thoughtful helper. You notice the little things and make people feel included. Your festive superpower is the personal touch.',
  'The creative spark. You love a fresh idea and a happy surprise. Your festive superpower is turning something ordinary into something memorable.',
];
int reindeerResult(List<int> answers) {
  final scores = List.filled(4, 0);
  for (final a in answers) {
    if (a >= 0 && a < 4) scores[a]++;
  }
  var best = 0;
  for (var i = 1; i < 4; i++) {
    if (scores[i] > scores[best]) best = i;
  }
  return best;
}

class ReindeerQuiz extends StatefulWidget {
  const ReindeerQuiz({super.key});
  @override
  State<ReindeerQuiz> createState() => _ReindeerQuizState();
}

class _ReindeerQuizState extends State<ReindeerQuiz> {
  final answers = List.filled(4, -1);
  bool show = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var q = 0; q < 4; q++)
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${q + 1}. ${reindeerQuestions[q]}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (var a = 0; a < 4; a++)
                  RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    value: a,
                    groupValue: answers[q],
                    title: Text(reindeerOptions[q][a]),
                    onChanged: (value) => setState(() {
                      answers[q] = value!;
                      show = false;
                    }),
                  ),
              ],
            ),
          ),
        ),
      FilledButton(
        onPressed: answers.contains(-1)
            ? null
            : () => setState(() => show = true),
        child: const Text('Meet my reindeer'),
      ),
      if (answers.contains(-1))
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Answer all four questions to see your result.'),
        ),
      if (show) ...[
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Text(
                    'You’re ${reindeerNames[reindeerResult(answers)]}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 10),
                Text(reindeerDescriptions[reindeerResult(answers)]),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => santaCopy(
                    context,
                    'I’m ${reindeerNames[reindeerResult(answers)]}! Which Christmas reindeer are you? ${santaLink('reindeer')}',
                  ),
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy my result'),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    answers.fillRange(0, 4, -1);
                    show = false;
                  }),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ],
      const SizedBox(height: 14),
      const Text('A little festive fun to share with friends.'),
    ],
  );
}
