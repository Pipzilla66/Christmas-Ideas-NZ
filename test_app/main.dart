import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const supabaseUrl = 'https://ocrwnkeqemcsklsnbufq.supabase.co';
const supabaseKey = 'sb_publishable_ciIHpWT3mWNzgEpUebXGkw_EBzELVZ3';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const ChristmasIdeasNZ());
}

enum XmasTheme { kiwi, classic, grinchy, winter }

class ChristmasIdeasNZ extends StatefulWidget {
  const ChristmasIdeasNZ({super.key});
  @override
  State<ChristmasIdeasNZ> createState() => _ChristmasIdeasNZState();
}

class _ChristmasIdeasNZState extends State<ChristmasIdeasNZ> {
  String? name;
  XmasTheme theme = XmasTheme.kiwi;

  ColorScheme scheme() {
    switch (theme) {
      case XmasTheme.classic:
        return const ColorScheme.light(
          primary: Color(0xFF9E1B32),
          secondary: Color(0xFFD4AF37),
          surface: Color(0xFFFBF4EA),
          onSurface: Color(0xFF34161B),
        );
      case XmasTheme.grinchy:
        return const ColorScheme.light(
          primary: Color(0xFF8CCF3F),
          secondary: Color(0xFFB3202A),
          surface: Color(0xFFF3F7E7),
          onSurface: Color(0xFF223118),
        );
      case XmasTheme.winter:
        return const ColorScheme.light(
          primary: Color(0xFF2A4C73),
          secondary: Color(0xFFDCEBFA),
          surface: Color(0xFFF4F8FD),
          onSurface: Color(0xFF1A2B40),
        );
      case XmasTheme.kiwi:
        return const ColorScheme.light(
          primary: Color(0xFF0F4C45),
          secondary: Color(0xFFC9A44D),
          surface: Color(0xFFF4EFE6),
          onSurface: Color(0xFF18302C),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = scheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christmas Ideas NZ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: s,
        scaffoldBackgroundColor: const Color(0xFFF7F2E8),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: const Color(0xFF173B36)),
          displayMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: const Color(0xFF173B36)),
          headlineLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: const Color(0xFF173B36)),
          headlineMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: const Color(0xFF173B36)),
          headlineSmall: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: const Color(0xFF173B36)),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w800, color: const Color(0xFF1E2522)),
          titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w700, color: const Color(0xFF1E2522)),
          bodyLarge: GoogleFonts.inter(color: const Color(0xFF343936), height: 1.45),
          bodyMedium: GoogleFonts.inter(color: const Color(0xFF343936), height: 1.45),
        ),
        dividerColor: const Color(0xFFD9D1C4),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Color(0xFFFFFCF6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            side: BorderSide(color: Color(0xFFE4DCCF)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFFCF6),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Color(0xFFCFC5B5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Color(0xFF0F4C45), width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ),
      home: name == null
          ? Onboarding(
              theme: theme,
              onThemeChanged: (t) => setState(() => theme = t),
              onContinue: (n) => setState(() => name = n.trim().isEmpty ? 'Christmas Lover' : n.trim()),
            )
          : Shell(
              name: name!,
              theme: theme,
              onThemeChanged: (t) => setState(() => theme = t),
            ),
    );
  }
}

class Onboarding extends StatefulWidget {
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  final ValueChanged<String> onContinue;
  const Onboarding({super.key, required this.theme, required this.onThemeChanged, required this.onContinue});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 280,
              padding: const EdgeInsets.fromLTRB(26, 34, 26, 28),
              color: green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CHRISTMAS IDEAS NZ',
                    style: GoogleFonts.inter(color: Colors.white70, fontWeight: FontWeight.w800, letterSpacing: 2.1, fontSize: 12)),
                  const Spacer(),
                  Text('Make Christmas\nfeel a little easier.',
                    style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 38, height: 1.04)),
                  const SizedBox(height: 12),
                  Text('Ideas, gifts, lights and events — all in one very Kiwi place.',
                    style: GoogleFonts.inter(color: Colors.white.withValues(alpha: .86), fontSize: 15, height: 1.45)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 7),
                  const Text('A name helps us make the app feel more personal. You can browse without creating an account.'),
                  const SizedBox(height: 22),
                  TextField(controller: controller, decoration: const InputDecoration(labelText: 'Your name')),
                  const SizedBox(height: 24),
                  const Text('CHOOSE A LOOK', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.4, fontSize: 12)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ThemeOption(label:'Kiwi', selected:widget.theme==XmasTheme.kiwi, onTap:()=>widget.onThemeChanged(XmasTheme.kiwi)),
                      _ThemeOption(label:'Classic', selected:widget.theme==XmasTheme.classic, onTap:()=>widget.onThemeChanged(XmasTheme.classic)),
                      _ThemeOption(label:'Grinchy', selected:widget.theme==XmasTheme.grinchy, onTap:()=>widget.onThemeChanged(XmasTheme.grinchy)),
                      _ThemeOption(label:'Winter', selected:widget.theme==XmasTheme.winter, onTap:()=>widget.onThemeChanged(XmasTheme.winter)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => widget.onContinue(controller.text),
                      child: const Text('Start exploring'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeOption({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : const Color(0xFFFFFCF6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : const Color(0xFFCFC5B5)),
        ),
        child: Text(label, style: TextStyle(color:selected ? Colors.white : const Color(0xFF343936), fontWeight:FontWeight.w700)),
      ),
    );
  }
}

class Shell extends StatefulWidget {
  final String name;
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  const Shell({super.key, required this.name, required this.theme, required this.onThemeChanged});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(name: widget.name, goTo: (i) => setState(() => index = i)),
      const DiscoverPage(),
      const NearMePage(),
      const SavedPage(),
      MePage(theme: widget.theme, onThemeChanged: widget.onThemeChanged),
    ];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFFCF6),
        selectedItemColor: const Color(0xFF0F4C45),
        unselectedItemColor: const Color(0xFF77736D),
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.place_outlined), activeIcon: Icon(Icons.place), label: 'Near Me'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), activeIcon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String name;
  final ValueChanged<int> goTo;
  const HomePage({super.key, required this.name, required this.goTo});

  int daysUntilChristmas() {
    final now = DateTime.now();
    var target = DateTime(now.year, 12, 25);
    if (now.isAfter(target)) target = DateTime(now.year + 1, 12, 25);
    return target.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Future<List<Map<String,dynamic>>> featuredGifts() async {
    final rows = await Supabase.instance.client
      .from('gift_ideas')
      .select('id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored')
      .eq('status','published')
      .order('featured', ascending:false)
      .limit(6);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<List<Map<String,dynamic>>> latestIdeas() async {
    final rows = await Supabase.instance.client
      .from('content_items')
      .select('id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label')
      .eq('status','published')
      .order('featured', ascending:false)
      .limit(4);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<Map<String,dynamic>?> dailyIdea() async {
    final now = DateTime.now();
    final date = now.toIso8601String().substring(0,10);
    final scheduled = await Supabase.instance.client
      .from('content_items')
      .select('id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label,idea_of_day_date')
      .eq('status','published')
      .eq('idea_of_day_date', date)
      .limit(1);
    final scheduledRows = List<Map<String,dynamic>>.from(scheduled);
    if (scheduledRows.isNotEmpty) return scheduledRows.first;

    final rows = await Supabase.instance.client
      .from('content_items')
      .select('id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label,idea_of_day_date')
      .eq('status','published')
      .order('created_at', ascending:true)
      .limit(100);
    final items = List<Map<String,dynamic>>.from(rows);
    if (items.isEmpty) return null;
    final start = DateTime(now.year,1,1);
    final day = now.difference(start).inDays;
    return items[day % items.length];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Row(
              children: [
                Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
                  Text('CHRISTMAS IDEAS NZ', style:GoogleFonts.inter(fontSize:11,fontWeight:FontWeight.w800,letterSpacing:1.7,color:const Color(0xFF8B6F2E))),
                  const SizedBox(height:5),
                  Text('Kia ora, ' + name, style:Theme.of(context).textTheme.headlineMedium),
                ])),
                IconButton(onPressed:()=>goTo(4), icon:const Icon(Icons.person_outline)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal:20),
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            decoration: BoxDecoration(
              color: const Color(0xFF0F4C45),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment:CrossAxisAlignment.end,
              children:[
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text('THE COUNTDOWN',style:GoogleFonts.inter(color:Colors.white70,fontSize:11,fontWeight:FontWeight.w800,letterSpacing:1.4)),
                  const SizedBox(height:7),
                  Text(daysUntilChristmas().toString() + ' days',style:GoogleFonts.playfairDisplay(color:Colors.white,fontSize:34,fontWeight:FontWeight.w700)),
                  const SizedBox(height:2),
                  Text('until Christmas Day',style:GoogleFonts.inter(color:Colors.white70,fontSize:14)),
                ])),
                const Icon(Icons.auto_awesome,color:Color(0xFFC9A44D),size:30),
              ],
            ),
          ),
          const SizedBox(height:24),
          FutureBuilder<Map<String,dynamic>?>(
            future:dailyIdea(),
            builder:(context,snap){
              if(snap.connectionState==ConnectionState.waiting) {
                return const Padding(
                  padding:EdgeInsets.symmetric(horizontal:20),
                  child:LinearProgressIndicator(),
                );
              }
              final item=snap.data;
              if(item==null) return const SizedBox.shrink();
              final image=(item['image_url']??'').toString();
              return Padding(
                padding:const EdgeInsets.symmetric(horizontal:20),
                child:InkWell(
                  onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ContentDetailPage(item:item))),
                  child:Container(
                    decoration:BoxDecoration(
                      color:const Color(0xFFFFFCF6),
                      border:Border.all(color:const Color(0xFFE4DCCF)),
                      borderRadius:BorderRadius.circular(7),
                    ),
                    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                      if(image.isNotEmpty)
                        ClipRRect(
                          borderRadius:const BorderRadius.vertical(top:Radius.circular(6)),
                          child:AspectRatio(
                            aspectRatio:16/8,
                            child:Image.network(
                              image,
                              fit:BoxFit.cover,
                              errorBuilder:(_,__,___)=>Container(
                                color:const Color(0xFF9E1B32),
                                child:const Center(child:Icon(Icons.auto_awesome,color:Colors.white,size:44)),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height:120,
                          width:double.infinity,
                          decoration:const BoxDecoration(
                            color:Color(0xFF9E1B32),
                            borderRadius:BorderRadius.vertical(top:Radius.circular(6)),
                          ),
                          child:const Center(child:Icon(Icons.auto_awesome,color:Colors.white,size:44)),
                        ),
                      Padding(
                        padding:const EdgeInsets.all(16),
                        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                          const Text('IDEA OF THE DAY',style:TextStyle(fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1.2,color:Color(0xFF8B6F2E))),
                          const SizedBox(height:6),
                          Text((item['title']??'Christmas idea').toString(),style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize:22)),
                          if((item['summary']??'').toString().isNotEmpty)...[
                            const SizedBox(height:6),
                            Text((item['summary']??'').toString(),maxLines:2,overflow:TextOverflow.ellipsis),
                          ],
                          const SizedBox(height:8),
                          const Text('READ THE IDEA →',style:TextStyle(fontSize:11,fontWeight:FontWeight.w800,letterSpacing:.8,color:Color(0xFF9E1B32))),
                        ]),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height:28),
          _SectionHeading(title:'Gift inspiration', action:'Find a gift', onTap:()=>goTo(1)),
          const SizedBox(height:12),
          SizedBox(
            height: 190,
            child: FutureBuilder<List<Map<String,dynamic>>>(
              future: featuredGifts(),
              builder:(context,snap){
                if(snap.connectionState==ConnectionState.waiting) return const Center(child:CircularProgressIndicator());
                final items=snap.data??[];
                return ListView.separated(
                  padding:const EdgeInsets.symmetric(horizontal:20),
                  scrollDirection:Axis.horizontal,
                  itemCount:items.length,
                  separatorBuilder:(_,__)=>const SizedBox(width:12),
                  itemBuilder:(context,i){
                    final g=items[i];
                    return InkWell(
                      onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>GiftDetailPage(gift:g))),
                      child:Container(
                        width:155,
                        decoration:BoxDecoration(
                          color:const Color(0xFFFFFCF6),
                          border:Border.all(color:const Color(0xFFE4DCCF)),
                          borderRadius:BorderRadius.circular(7),
                        ),
                        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                          ClipRRect(
                            borderRadius:const BorderRadius.vertical(top:Radius.circular(6)),
                            child:(g['image_url']??'').toString().isNotEmpty
                              ? Image.network(
                                  (g['image_url']??'').toString(),
                                  height:86,
                                  width:double.infinity,
                                  fit:BoxFit.cover,
                                  errorBuilder:(_,__,___)=>Container(
                                    height:86,
                                    width:double.infinity,
                                    color:const Color(0xFFE9E2D4),
                                    child:const Icon(Icons.card_giftcard,size:34,color:Color(0xFF0F4C45)),
                                  ),
                                )
                              : Container(
                                  height:86,
                                  width:double.infinity,
                                  color:const Color(0xFFE9E2D4),
                                  child:const Icon(Icons.card_giftcard,size:34,color:Color(0xFF0F4C45)),
                                ),
                          ),
                          Padding(
                            padding:const EdgeInsets.all(10),
                            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                              Text((g['title']??'Gift idea').toString(),maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:13)),
                              const SizedBox(height:5),
                              Text('NZ\$' + (g['price_min']??'').toString(),style:const TextStyle(fontSize:12,color:Color(0xFF8B6F2E),fontWeight:FontWeight.w700)),
                            ]),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height:28),
          _SectionHeading(title:'Christmas ideas', action:'Explore all', onTap:()=>goTo(1)),
          const SizedBox(height:10),
          FutureBuilder<List<Map<String,dynamic>>>(
            future: latestIdeas(),
            builder:(context,snap){
              if(snap.connectionState==ConnectionState.waiting) return const Padding(padding:EdgeInsets.all(28),child:Center(child:CircularProgressIndicator()));
              final items=snap.data??[];
              if(items.isEmpty) return const Padding(padding:EdgeInsets.symmetric(horizontal:20),child:Text('More Christmas inspiration is being added.'));
              return Padding(
                padding:const EdgeInsets.symmetric(horizontal:20),
                child:Column(
                  children:items.map((item)=>Padding(
                    padding:const EdgeInsets.only(bottom:10),
                    child:InkWell(
                      onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ContentDetailPage(item:item))),
                      child:Container(
                        padding:const EdgeInsets.all(14),
                        decoration:BoxDecoration(
                          color:const Color(0xFFFFFCF6),
                          border:Border.all(color:const Color(0xFFE4DCCF)),
                          borderRadius:BorderRadius.circular(7),
                        ),
                        child:Row(children:[
                          Container(width:72,height:72,color:const Color(0xFF9E1B32),child:const Icon(Icons.star_outline,color:Colors.white,size:30)),
                          const SizedBox(width:14),
                          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                            Text((item['title']??'Christmas idea').toString(),style:const TextStyle(fontWeight:FontWeight.w800,fontSize:15)),
                            if((item['summary']??'').toString().isNotEmpty)...[
                              const SizedBox(height:5),
                              Text((item['summary']??'').toString(),maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:12.5)),
                            ],
                          ])),
                          const Icon(Icons.chevron_right,size:20),
                        ]),
                      ),
                    ),
                  )).toList(),
                ),
              );
            },
          ),
          const SizedBox(height:20),
          Container(
            margin:const EdgeInsets.fromLTRB(20,0,20,24),
            padding:const EdgeInsets.all(18),
            color:const Color(0xFFEEE6D8),
            child:Row(children:[
              const Icon(Icons.place_outlined,color:Color(0xFF0F4C45),size:28),
              const SizedBox(width:14),
              const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text('Christmas near you',style:TextStyle(fontWeight:FontWeight.w800,fontSize:16)),
                SizedBox(height:3),
                Text('Lights, markets, Santa visits and more.'),
              ])),
              TextButton(onPressed:()=>goTo(2),child:const Text('OPEN')),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;
  const _SectionHeading({required this.title,required this.action,required this.onTap});
  @override
  Widget build(BuildContext context){
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:20),
      child:Row(children:[
        Expanded(child:Text(title,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize:24))),
        TextButton(onPressed:onTap,child:Text(action.toUpperCase(),style:const TextStyle(fontSize:11,fontWeight:FontWeight.w800,letterSpacing:.8))),
      ]),
    );
  }
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String q = '';
  String recipient = 'All';
  double maxBudget = 250;
  bool nzMadeOnly = false;

  Future<List<Map<String,dynamic>>> loadGifts() async {
    final rows = await Supabase.instance.client
        .from('gift_ideas')
        .select('id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored')
        .eq('status','published')
        .order('featured', ascending: false)
        .limit(200);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<List<Map<String,dynamic>>> loadContent() async {
    final rows = await Supabase.instance.client
        .from('content_items')
        .select('id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label')
        .eq('status','published')
        .order('featured', ascending: false)
        .limit(40);
    return List<Map<String,dynamic>>.from(rows);
  }

  Widget recipientTab(String value){
    final selected=recipient==value;
    return InkWell(
      onTap:()=>setState(()=>recipient=value),
      child:Container(
        padding:const EdgeInsets.symmetric(horizontal:12,vertical:9),
        decoration:BoxDecoration(
          color:selected?const Color(0xFF0F4C45):Colors.transparent,
          border:Border.all(color:selected?const Color(0xFF0F4C45):const Color(0xFFCFC5B5)),
          borderRadius:BorderRadius.circular(4),
        ),
        child:Text(value,style:TextStyle(color:selected?Colors.white:const Color(0xFF343936),fontWeight:FontWeight.w700,fontSize:12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20,20,20,28),
        children: [
          Text('Discover', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height:6),
          const Text('Ideas for a Christmas that feels like yours.'),
          const SizedBox(height:18),
          TextField(
            onChanged:(v)=>setState(()=>q=v.toLowerCase()),
            decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search gifts and Christmas ideas'),
          ),
          const SizedBox(height:28),
          Row(children:[
            Expanded(child:Text('Gift Finder',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize:26))),
            const Icon(Icons.card_giftcard_outlined,color:Color(0xFF9E1B32)),
          ]),
          const SizedBox(height:6),
          const Text('Start with who you are shopping for, then narrow it down.'),
          const SizedBox(height:14),
          SingleChildScrollView(
            scrollDirection:Axis.horizontal,
            child:Row(
              children:['All','Kids','Teens','Her','Him','Grandparents','Teachers','Secret Santa']
                .map((r)=>Padding(padding:const EdgeInsets.only(right:7),child:recipientTab(r))).toList(),
            ),
          ),
          const SizedBox(height:18),
          Row(children:[
            const Text('Budget',style:TextStyle(fontWeight:FontWeight.w800)),
            const Spacer(),
            Text('Up to NZ\$' + maxBudget.round().toString(),style:const TextStyle(fontWeight:FontWeight.w700,color:Color(0xFF8B6F2E))),
          ]),
          Slider(value:maxBudget,min:20,max:500,divisions:24,onChanged:(v)=>setState(()=>maxBudget=v)),
          Row(children:[
            const Expanded(child:Text('Only show NZ-made gifts',style:TextStyle(fontWeight:FontWeight.w600))),
            Switch(value:nzMadeOnly,onChanged:(v)=>setState(()=>nzMadeOnly=v)),
          ]),
          const Divider(height:30),
          FutureBuilder<List<Map<String,dynamic>>>(
            future:loadGifts(),
            builder:(context,snap){
              if(snap.connectionState==ConnectionState.waiting) return const LinearProgressIndicator();
              var gifts=snap.data??[];
              gifts=gifts.where((g){
                final title=(g['title']??'').toString().toLowerCase();
                final desc=(g['description']??'').toString().toLowerCase();
                final rec=(g['recipient_group']??'').toString();
                final pmin=double.tryParse((g['price_min']??'0').toString())??0;
                return (q.isEmpty||title.contains(q)||desc.contains(q))
                  &&(recipient=='All'||rec.toLowerCase()==recipient.toLowerCase())
                  &&pmin<=maxBudget&&(!nzMadeOnly||g['nz_made']==true);
              }).toList();
              if(gifts.isEmpty) return const Padding(padding:EdgeInsets.symmetric(vertical:20),child:Text('No gifts match those filters yet.'));
              return Column(
                children:gifts.map((g)=>InkWell(
                  onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>GiftDetailPage(gift:g))),
                  child:Container(
                    margin:const EdgeInsets.only(bottom:9),
                    padding:const EdgeInsets.all(12),
                    decoration:BoxDecoration(
                      color:const Color(0xFFFFFCF6),
                      border:Border.all(color:const Color(0xFFE4DCCF)),
                      borderRadius:BorderRadius.circular(6),
                    ),
                    child:Row(children:[
                      ClipRRect(
                        borderRadius:BorderRadius.circular(4),
                        child:(g['image_url']??'').toString().isNotEmpty
                          ? Image.network((g['image_url']??'').toString(),width:58,height:58,fit:BoxFit.cover,
                              errorBuilder:(_,__,___)=>Container(width:58,height:58,color:const Color(0xFFECE4D7),child:const Icon(Icons.card_giftcard,color:Color(0xFF0F4C45))))
                          : Container(width:58,height:58,color:const Color(0xFFECE4D7),child:const Icon(Icons.card_giftcard,color:Color(0xFF0F4C45))),
                      ),
                      const SizedBox(width:12),
                      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        Text((g['title']??'Gift idea').toString(),style:const TextStyle(fontWeight:FontWeight.w800,fontSize:14)),
                        const SizedBox(height:4),
                        Text((g['recipient_group']??'').toString() + '  ·  NZ\$' + (g['price_min']??'').toString() + (g['nz_made']==true?'  ·  NZ made':''),style:const TextStyle(fontSize:11.5,color:Color(0xFF6B6F6C))),
                      ])),
                      const Icon(Icons.chevron_right,size:20),
                    ]),
                  ),
                )).toList(),
              );
            },
          ),
          const SizedBox(height:30),
          Text('Christmas Ideas',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize:26)),
          const SizedBox(height:10),
          FutureBuilder<List<Map<String,dynamic>>>(
            future:loadContent(),
            builder:(context,snap){
              if(snap.connectionState==ConnectionState.waiting) return const LinearProgressIndicator();
              var items=snap.data??[];
              items=items.where((item){
                final hay=((item['title']??'').toString() + ' ' + (item['summary']??'').toString() + ' ' + (item['body']??'').toString()).toLowerCase();
                return q.isEmpty||hay.contains(q);
              }).toList();
              return Column(children:items.map((item)=>ListTile(
                contentPadding:const EdgeInsets.symmetric(vertical:4),
                title:Text((item['title']??'Christmas idea').toString(),style:const TextStyle(fontWeight:FontWeight.w800)),
                subtitle:Text((item['summary']??'').toString(),maxLines:2,overflow:TextOverflow.ellipsis),
                trailing:const Icon(Icons.arrow_forward,size:18),
                onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ContentDetailPage(item:item))),
              )).toList());
            },
          ),
        ],
      ),
    );
  }
}

Future<void> saveItemToBoard(BuildContext context, String itemType, dynamic itemId) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in from Me to save this.')));
    return;
  }
  final rows = await Supabase.instance.client
      .from('boards')
      .select('id,name')
      .eq('user_id', user.id)
      .order('created_at');
  final boards = List<Map<String,dynamic>>.from(rows);
  if (boards.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create a Saved board first.')));
    }
    return;
  }
  if (!context.mounted) return;
  final boardId = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          const ListTile(title: Text('Save to board', style: TextStyle(fontWeight: FontWeight.w900))),
          ...boards.map((b) => ListTile(
            leading: const Text('🎄'),
            title: Text((b['name'] ?? 'Board').toString()),
            onTap: () => Navigator.pop(ctx, b['id'].toString()),
          )),
        ],
      ),
    ),
  );
  if (boardId == null) return;
  try {
    await Supabase.instance.client.from('board_items').insert({
      'board_id': boardId,
      'item_type': itemType,
      'item_id': itemId,
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to board ❤️')));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already saved, or unable to save right now.')));
    }
  }
}

class GiftDetailPage extends StatelessWidget {
  final Map<String,dynamic> gift;
  const GiftDetailPage({super.key, required this.gift});

  Future<void> openLink(BuildContext context) async {
    final raw = (gift['affiliate_url'] ?? gift['product_url'] ?? '').toString();
    final uri = Uri.tryParse(raw);
    if (uri == null || raw.isEmpty || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Retailer link is not available yet.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = 'NZ\$' + (gift['price_min'] ?? '').toString()
        + (gift['price_max'] != null && gift['price_max'].toString() != gift['price_min'].toString()
            ? '–' + gift['price_max'].toString()
            : '');
    final image = (gift['image_url'] ?? '').toString();
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF7F2E8), elevation: 0, title: const Text('Gift idea')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (image.isNotEmpty)
            AspectRatio(
              aspectRatio: 16/10,
              child: Image.network(image, fit: BoxFit.cover, errorBuilder: (_,__,___) => _giftHero()),
            )
          else
            _giftHero(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,22,20,30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (gift['sponsored'] == true)
                  const Text('SPONSORED', style: TextStyle(fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1.3,color:Color(0xFF8B6F2E))),
                Text((gift['title'] ?? 'Gift idea').toString(), style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height:10),
                Wrap(spacing:8,runSpacing:8,children:[
                  _MetaTag((gift['recipient_group'] ?? 'Gift').toString()),
                  _MetaTag(price),
                  if (gift['nz_made'] == true) const _MetaTag('NZ made'),
                ]),
                const SizedBox(height:20),
                Text((gift['description'] ?? '').toString(), style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height:26),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => saveItemToBoard(context, 'gift', gift['id']),
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('Save'),
                  )),
                  const SizedBox(width:10),
                  Expanded(child: FilledButton.icon(
                    onPressed: () => openLink(context),
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('View retailer'),
                  )),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _giftHero() => Container(
    height:230,
    color:const Color(0xFFE8E0D2),
    child:const Center(child:Icon(Icons.card_giftcard,size:74,color:Color(0xFF0F4C45))),
  );
}

class _MetaTag extends StatelessWidget {
  final String text;
  const _MetaTag(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),
    decoration:BoxDecoration(
      color:const Color(0xFFFFFCF6),
      border:Border.all(color:const Color(0xFFD9D1C4)),
      borderRadius:BorderRadius.circular(4),
    ),
    child:Text(text,style:const TextStyle(fontSize:11.5,fontWeight:FontWeight.w700)),
  );
}

class ContentDetailPage extends StatelessWidget {
  final Map<String,dynamic> item;
  const ContentDetailPage({super.key, required this.item});

  Future<void> openExternal() async {
    final raw = (item['external_url'] ?? '').toString();
    final uri = Uri.tryParse(raw);
    if (uri != null && raw.isNotEmpty) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = (item['image_url'] ?? '').toString();
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF7F2E8), elevation:0, title: const Text('Christmas idea')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (image.isNotEmpty)
            AspectRatio(
              aspectRatio:16/10,
              child:Image.network(image,fit:BoxFit.cover,errorBuilder:(_,__,___)=>_ideaHero()),
            )
          else
            _ideaHero(),
          Padding(
            padding:const EdgeInsets.fromLTRB(20,22,20,30),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text((item['content_type'] ?? 'IDEA').toString().toUpperCase(),
                style:const TextStyle(fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1.3,color:Color(0xFF8B6F2E))),
              const SizedBox(height:7),
              Text((item['title'] ?? 'Christmas idea').toString(),style:Theme.of(context).textTheme.headlineMedium),
              if((item['summary']??'').toString().isNotEmpty)...[
                const SizedBox(height:10),
                Text((item['summary']??'').toString(),style:const TextStyle(fontSize:16,fontWeight:FontWeight.w700,height:1.4)),
              ],
              const SizedBox(height:20),
              Text((item['body'] ?? item['summary'] ?? '').toString(),style:Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height:26),
              Row(children:[
                Expanded(child:OutlinedButton.icon(
                  onPressed:()=>saveItemToBoard(context,'content',item['id']),
                  icon:const Icon(Icons.bookmark_border),
                  label:const Text('Save'),
                )),
                if((item['external_url']??'').toString().isNotEmpty)...[
                  const SizedBox(width:10),
                  Expanded(child:FilledButton.icon(onPressed:openExternal,icon:const Icon(Icons.open_in_new),label:const Text('Open link'))),
                ],
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _ideaHero() => Container(
    height:230,
    color:const Color(0xFF9E1B32),
    child:const Center(child:Icon(Icons.star_outline,size:72,color:Colors.white)),
  );
}

class NearMePage extends StatelessWidget {
  const NearMePage({super.key});

  Future<List<Map<String, dynamic>>> load() async {
    final events = await Supabase.instance.client.from('events').select('name,city,region,start_at').eq('status','published').limit(20);
    final lights = await Supabase.instance.client.from('light_displays').select('name,city,region,start_date').eq('status','published').limit(20);
    return [
      ...List<Map<String,dynamic>>.from(events).map((e) => {...e, '_type':'Event'}),
      ...List<Map<String,dynamic>>.from(lights).map((e) => {...e, '_type':'Lights'}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:ListView(
        padding:const EdgeInsets.fromLTRB(20,20,20,28),
        children:[
          Text('Near Me',style:Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height:6),
          const Text('Christmas lights, markets and local festive finds around Aotearoa.'),
          const SizedBox(height:18),
          Container(
            height:180,
            decoration:BoxDecoration(
              color:const Color(0xFFDDE5DD),
              border:Border.all(color:const Color(0xFFC5D0C7)),
              borderRadius:BorderRadius.circular(6),
            ),
            child:Stack(children:[
              const Center(child:Icon(Icons.map_outlined,size:58,color:Color(0xFF0F4C45))),
              Positioned(left:14,bottom:12,child:Container(
                padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),
                color:const Color(0xFFFFFCF6),
                child:const Text('Interactive map coming in the next build',style:TextStyle(fontSize:11,fontWeight:FontWeight.w700)),
              )),
            ]),
          ),
          const SizedBox(height:22),
          Text('Festive finds',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize:25)),
          const SizedBox(height:10),
          FutureBuilder<List<Map<String,dynamic>>>(
            future:load(),
            builder:(context,snap){
              if(snap.connectionState==ConnectionState.waiting) return const Center(child:CircularProgressIndicator());
              final items=snap.data??[];
              if(items.isEmpty) return Container(
                padding:const EdgeInsets.all(18),
                decoration:BoxDecoration(color:const Color(0xFFFFFCF6),border:Border.all(color:const Color(0xFFE4DCCF)),borderRadius:BorderRadius.circular(6)),
                child:const Text('We are building the national Christmas map. Events and light displays will appear here as they are approved.'),
              );
              return Column(children:items.map((e)=>Container(
                margin:const EdgeInsets.only(bottom:9),
                padding:const EdgeInsets.all(13),
                decoration:BoxDecoration(color:const Color(0xFFFFFCF6),border:Border.all(color:const Color(0xFFE4DCCF)),borderRadius:BorderRadius.circular(6)),
                child:Row(children:[
                  Container(width:46,height:46,color:e['_type']=='Lights'?const Color(0xFFC9A44D):const Color(0xFF9E1B32),child:Icon(e['_type']=='Lights'?Icons.lightbulb_outline:Icons.storefront_outlined,color:Colors.white)),
                  const SizedBox(width:12),
                  Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text((e['name']??'Christmas listing').toString(),style:const TextStyle(fontWeight:FontWeight.w800)),
                    const SizedBox(height:3),
                    Text((e['city']??'').toString() + ((e['region']??'').toString().isNotEmpty ? ', ' + (e['region']??'').toString() : ''),style:const TextStyle(fontSize:12,color:Color(0xFF6B6F6C))),
                  ])),
                  Text((e['_type']??'').toString().toUpperCase(),style:const TextStyle(fontSize:9.5,fontWeight:FontWeight.w800,letterSpacing:.8,color:Color(0xFF8B6F2E))),
                ]),
              )).toList());
            },
          ),
        ],
      ),
    );
  }
}

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});
  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final boardName = TextEditingController();

  Future<List<Map<String,dynamic>>> loadBoards() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    final rows = await Supabase.instance.client
        .from('boards')
        .select('id,name,emoji,created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<void> createBoard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in from Me first.')));
      return;
    }
    final name = boardName.text.trim();
    if (name.isEmpty) return;
    await Supabase.instance.client.from('boards').insert({'user_id':user.id,'name':name,'emoji':'✦'});
    boardName.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user=Supabase.instance.client.auth.currentUser;
    return SafeArea(
      child:ListView(
        padding:const EdgeInsets.fromLTRB(20,20,20,28),
        children:[
          Text('Saved',style:Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height:6),
          const Text('Your own little Christmas library.'),
          const SizedBox(height:22),
          if(user==null)
            Container(
              padding:const EdgeInsets.all(18),
              decoration:BoxDecoration(color:const Color(0xFFFFFCF6),border:Border.all(color:const Color(0xFFE4DCCF)),borderRadius:BorderRadius.circular(6)),
              child:const Text('Sign in from Me to create boards and keep your favourite gifts and ideas across devices.'),
            )
          else ...[
            Row(children:[
              Expanded(child:TextField(controller:boardName,decoration:const InputDecoration(hintText:'New board name'))),
              const SizedBox(width:8),
              FilledButton(onPressed:createBoard,child:const Text('Create')),
            ]),
            const SizedBox(height:18),
            FutureBuilder<List<Map<String,dynamic>>>(
              future:loadBoards(),
              builder:(context,snap){
                if(snap.connectionState==ConnectionState.waiting) return const Center(child:CircularProgressIndicator());
                final boards=snap.data??[];
                if(boards.isEmpty) return const Text('No boards yet. Try “Gift Ideas”, “Christmas Dinner” or “Elf Ideas”.');
                return GridView.count(
                  crossAxisCount:2,
                  crossAxisSpacing:10,
                  mainAxisSpacing:10,
                  shrinkWrap:true,
                  physics:const NeverScrollableScrollPhysics(),
                  childAspectRatio:1.15,
                  children:boards.map((b)=>InkWell(
                    onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>BoardDetailPage(board:b))).then((_)=>setState((){})),
                    child:Container(
                      padding:const EdgeInsets.all(15),
                      decoration:BoxDecoration(
                        color:const Color(0xFFFFFCF6),
                        border:Border.all(color:const Color(0xFFE4DCCF)),
                        borderRadius:BorderRadius.circular(6),
                      ),
                      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        const Icon(Icons.bookmark_outline,color:Color(0xFF0F4C45)),
                        const Spacer(),
                        Text((b['name']??'Board').toString(),style:GoogleFonts.playfairDisplay(fontWeight:FontWeight.w700,fontSize:18)),
                        const SizedBox(height:3),
                        const Text('Open collection',style:TextStyle(fontSize:11,color:Color(0xFF77736D))),
                      ]),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class BoardDetailPage extends StatefulWidget {
  final Map<String,dynamic> board;
  const BoardDetailPage({super.key, required this.board});
  @override
  State<BoardDetailPage> createState()=>_BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  Future<List<Map<String,dynamic>>> loadItems() async {
    final rows = await Supabase.instance.client
      .from('board_items')
      .select('id,item_type,item_id,created_at')
      .eq('board_id', widget.board['id'])
      .order('created_at', ascending:false);
    final items=List<Map<String,dynamic>>.from(rows);
    final out=<Map<String,dynamic>>[];
    for(final row in items){
      final type=(row['item_type']??'').toString();
      final itemId=row['item_id'];
      if(type=='gift'){
        final data=await Supabase.instance.client.from('gift_ideas')
          .select('id,title,description,image_url,recipient_group,price_min,price_max,nz_made,product_url,affiliate_url,featured,sponsored')
          .eq('id',itemId).maybeSingle();
        if(data!=null) out.add({...Map<String,dynamic>.from(data), '_board_item_id':row['id'], '_type':'gift'});
      } else if(type=='content'){
        final data=await Supabase.instance.client.from('content_items')
          .select('id,title,summary,body,image_url,external_url,content_type,featured,sponsored,sponsor_label')
          .eq('id',itemId).maybeSingle();
        if(data!=null) out.add({...Map<String,dynamic>.from(data), '_board_item_id':row['id'], '_type':'content'});
      }
    }
    return out;
  }

  Future<void> removeItem(dynamic id) async {
    await Supabase.instance.client.from('board_items').delete().eq('id',id);
    if(mounted) setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(backgroundColor:const Color(0xFFF7F2E8),title:Text((widget.board['name']??'Saved board').toString())),
      body:FutureBuilder<List<Map<String,dynamic>>>(
        future:loadItems(),
        builder:(context,snap){
          if(snap.connectionState==ConnectionState.waiting) return const Center(child:CircularProgressIndicator());
          final items=snap.data??[];
          if(items.isEmpty) return const Center(child:Padding(
            padding:EdgeInsets.all(28),
            child:Text('Nothing saved here yet. Open a gift or Christmas idea and tap Save.'),
          ));
          return ListView.separated(
            padding:const EdgeInsets.all(20),
            itemCount:items.length,
            separatorBuilder:(_,__)=>const SizedBox(height:10),
            itemBuilder:(context,i){
              final item=items[i];
              final isGift=item['_type']=='gift';
              return InkWell(
                onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>isGift?GiftDetailPage(gift:item):ContentDetailPage(item:item))),
                child:Container(
                  padding:const EdgeInsets.all(12),
                  decoration:BoxDecoration(
                    color:const Color(0xFFFFFCF6),
                    border:Border.all(color:const Color(0xFFE4DCCF)),
                    borderRadius:BorderRadius.circular(6),
                  ),
                  child:Row(children:[
                    ClipRRect(
                      borderRadius:BorderRadius.circular(4),
                      child:(item['image_url']??'').toString().isNotEmpty
                        ? Image.network((item['image_url']??'').toString(),width:54,height:54,fit:BoxFit.cover,
                            errorBuilder:(_,__,___)=>Container(width:54,height:54,color:isGift?const Color(0xFFECE4D7):const Color(0xFF9E1B32),child:Icon(isGift?Icons.card_giftcard:Icons.star_outline,color:isGift?const Color(0xFF0F4C45):Colors.white)))
                        : Container(width:54,height:54,color:isGift?const Color(0xFFECE4D7):const Color(0xFF9E1B32),child:Icon(isGift?Icons.card_giftcard:Icons.star_outline,color:isGift?const Color(0xFF0F4C45):Colors.white)),
                    ),
                    const SizedBox(width:12),
                    Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                      Text((item['title']??'Saved item').toString(),style:const TextStyle(fontWeight:FontWeight.w800)),
                      const SizedBox(height:3),
                      Text(isGift?'Gift idea':'Christmas idea',style:const TextStyle(fontSize:11,color:Color(0xFF77736D))),
                    ])),
                    IconButton(
                      tooltip:'Remove',
                      onPressed:()=>removeItem(item['_board_item_id']),
                      icon:const Icon(Icons.close,size:19),
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});
  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  String type = 'event';
  final title = TextEditingController();
  final description = TextEditingController();
  final city = TextEditingController();
  final region = TextEditingController();
  String? message;
  bool busy = false;

  Future<void> submit() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => message = 'Please sign in first.');
      return;
    }
    if (title.text.trim().isEmpty) {
      setState(() => message = 'Please add a title.');
      return;
    }
    setState(() { busy = true; message = null; });
    try {
      await Supabase.instance.client.from('submissions').insert({
        'user_id': user.id,
        'submission_type': type,
        'title': title.text.trim(),
        'description': description.text.trim(),
        'payload': {
          'city': city.text.trim(),
          'region': region.text.trim(),
        },
        'status': 'pending',
      });
      title.clear();
      description.clear();
      city.clear();
      region.clear();
      message = 'Thanks — it is now waiting for approval.';
    } catch (e) {
      message = 'Could not submit. Please try again.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF7F2E8), elevation: 0, title: const Text('Submit a Christmas find')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20,18,20,30),
        children: [
          Text('Add something festive', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Help make Christmas Ideas NZ more useful for families around Aotearoa.'),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(labelText: 'What are you adding?'),
            items: const [
              DropdownMenuItem(value:'event', child: Text('Event / Market')),
              DropdownMenuItem(value:'light', child: Text('Christmas Lights')),
              DropdownMenuItem(value:'business', child: Text('NZ Christmas Business')),
              DropdownMenuItem(value:'idea', child: Text('Christmas Idea')),
            ],
            onChanged: (v) => setState(() => type = v ?? 'event'),
          ),
          const SizedBox(height: 12),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title / Name')),
          const SizedBox(height: 12),
          TextField(controller: description, maxLines: 4, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 12),
          TextField(controller: city, decoration: const InputDecoration(labelText: 'City or town')),
          const SizedBox(height: 12),
          TextField(controller: region, decoration: const InputDecoration(labelText: 'Region')),
          if (message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(message!)),
          const SizedBox(height: 18),
          FilledButton(onPressed: busy ? null : submit, child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Text(busy ? 'Submitting…' : 'Send for approval'),
          )),
        ],
      ),
    );
  }
}

class AdminMediaManagerPage extends StatefulWidget {
  const AdminMediaManagerPage({super.key});
  @override
  State<AdminMediaManagerPage> createState() => _AdminMediaManagerPageState();
}

class _AdminMediaManagerPageState extends State<AdminMediaManagerPage> {
  bool showGifts = true;
  bool busy = false;
  final picker = ImagePicker();

  Future<List<Map<String,dynamic>>> loadItems() async {
    if (showGifts) {
      final rows = await Supabase.instance.client
          .from('gift_ideas')
          .select('id,title,image_url,image_source_url,image_credit,recipient_group')
          .eq('status','published')
          .order('title');
      return List<Map<String,dynamic>>.from(rows);
    }
    final rows = await Supabase.instance.client
        .from('content_items')
        .select('id,title,image_url,image_source_url,image_credit,content_type')
        .eq('status','published')
        .order('title');
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<String?> uploadImage(dynamic id) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1800,
    );
    if (picked == null) return null;
    final ext = picked.name.contains('.') ? picked.name.split('.').last.toLowerCase() : 'jpg';
    final folder = showGifts ? 'gifts' : 'ideas';
    final path = 'admin/' + folder + '/' + id.toString() + '_' + DateTime.now().millisecondsSinceEpoch.toString() + '.' + ext;
    await Supabase.instance.client.storage.from('content-images').upload(
      path,
      File(picked.path),
      fileOptions: const FileOptions(upsert: true),
    );
    return Supabase.instance.client.storage.from('content-images').getPublicUrl(path);
  }

  Future<void> editItem(Map<String,dynamic> item) async {
    final imageUrl = TextEditingController(text:(item['image_url']??'').toString());
    final sourceUrl = TextEditingController(text:(item['image_source_url']??'').toString());
    final credit = TextEditingController(text:(item['image_credit']??'').toString());
    final saved = await showDialog<bool>(
      context:context,
      builder:(ctx)=>StatefulBuilder(
        builder:(ctx,setLocal)=>AlertDialog(
          title:Text('Image for ' + (item['title']??'item').toString()),
          content:SizedBox(
            width:420,
            child:SingleChildScrollView(
              child:Column(
                mainAxisSize:MainAxisSize.min,
                children:[
                  TextField(controller:imageUrl,decoration:const InputDecoration(labelText:'Image URL')),
                  const SizedBox(height:10),
                  OutlinedButton.icon(
                    onPressed:busy?null:() async {
                      setLocal(()=>busy=true);
                      try {
                        final uploaded=await uploadImage(item['id']);
                        if(uploaded!=null) imageUrl.text=uploaded;
                      } finally {
                        setLocal(()=>busy=false);
                      }
                    },
                    icon:const Icon(Icons.photo_library_outlined),
                    label:Text(busy?'Uploading…':'Choose photo from gallery'),
                  ),
                  const SizedBox(height:10),
                  TextField(controller:sourceUrl,decoration:const InputDecoration(labelText:'Source/product page URL')),
                  const SizedBox(height:10),
                  TextField(controller:credit,decoration:const InputDecoration(labelText:'Image credit / permission note')),
                  const SizedBox(height:8),
                  const Text(
                    'For retailer products, use approved retailer or affiliate imagery. For Elf and Secret Santa ideas, use your own, licensed or generated images.',
                    style:TextStyle(fontSize:11.5,color:Color(0xFF6B6F6C)),
                  ),
                ],
              ),
            ),
          ),
          actions:[
            TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),
            FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Save image')),
          ],
        ),
      ),
    );
    if(saved!=true) return;
    setState(()=>busy=true);
    try {
      await Supabase.instance.client.from(showGifts?'gift_ideas':'content_items').update({
        'image_url': imageUrl.text.trim().isEmpty ? null : imageUrl.text.trim(),
        'image_source_url': sourceUrl.text.trim().isEmpty ? null : sourceUrl.text.trim(),
        'image_credit': credit.text.trim().isEmpty ? null : credit.text.trim(),
      }).eq('id',item['id']);
      if(mounted) setState((){});
    } finally {
      if(mounted) setState(()=>busy=false);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(backgroundColor:const Color(0xFFF7F2E8),title:const Text('Image Library')),
      body:Column(children:[
        Padding(
          padding:const EdgeInsets.fromLTRB(20,16,20,8),
          child:Row(children:[
            Expanded(child:SegmentedButton<bool>(
              segments:const [
                ButtonSegment(value:true,label:Text('Gifts'),icon:Icon(Icons.card_giftcard)),
                ButtonSegment(value:false,label:Text('Ideas'),icon:Icon(Icons.auto_awesome)),
              ],
              selected:{showGifts},
              onSelectionChanged:(s)=>setState(()=>showGifts=s.first),
            )),
          ]),
        ),
        Expanded(
          child:FutureBuilder<List<Map<String,dynamic>>>(
            future:loadItems(),
            builder:(context,snap){
              if(snap.connectionState==ConnectionState.waiting) return const Center(child:CircularProgressIndicator());
              final items=snap.data??[];
              return ListView.separated(
                padding:const EdgeInsets.fromLTRB(20,8,20,24),
                itemCount:items.length,
                separatorBuilder:(_,__)=>const Divider(height:1),
                itemBuilder:(context,i){
                  final item=items[i];
                  final image=(item['image_url']??'').toString();
                  return ListTile(
                    contentPadding:const EdgeInsets.symmetric(vertical:7),
                    leading:ClipRRect(
                      borderRadius:BorderRadius.circular(4),
                      child:image.isNotEmpty
                        ? Image.network(image,width:58,height:58,fit:BoxFit.cover,errorBuilder:(_,__,___)=>_mediaPlaceholder())
                        : _mediaPlaceholder(),
                    ),
                    title:Text((item['title']??'Untitled').toString(),style:const TextStyle(fontWeight:FontWeight.w800)),
                    subtitle:Text(image.isEmpty?'No image yet':'Image connected'),
                    trailing:const Icon(Icons.edit_outlined),
                    onTap:()=>editItem(item),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget _mediaPlaceholder()=>Container(
    width:58,height:58,color:const Color(0xFFECE4D7),
    child:const Icon(Icons.image_outlined,color:Color(0xFF0F4C45)),
  );
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  Future<List<Map<String,dynamic>>> pending() async {
    final rows = await Supabase.instance.client
        .from('submissions')
        .select('id,submission_type,title,description,payload,status,created_at')
        .eq('status','pending')
        .order('created_at', ascending: true);
    return List<Map<String,dynamic>>.from(rows);
  }

  Future<void> review(Map<String,dynamic> item, bool approve) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    if (approve) {
      final payload = Map<String,dynamic>.from(item['payload'] ?? {});
      final type = item['submission_type'];
      if (type == 'event') {
        await Supabase.instance.client.from('events').insert({
          'name': item['title'],
          'description': item['description'],
          'city': payload['city'],
          'region': payload['region'],
          'event_type': 'community',
          'status': 'published',
          'created_by': user.id,
        });
      } else if (type == 'light') {
        await Supabase.instance.client.from('light_displays').insert({
          'name': item['title'],
          'description': item['description'],
          'city': payload['city'],
          'region': payload['region'],
          'status': 'published',
          'created_by': user.id,
        });
      } else if (type == 'business') {
        await Supabase.instance.client.from('businesses').insert({
          'name': item['title'],
          'description': item['description'],
          'city': payload['city'],
          'region': payload['region'],
          'status': 'published',
        });
      } else if (type == 'idea') {
        await Supabase.instance.client.from('content_items').insert({
          'title': item['title'],
          'summary': item['description'],
          'content_type': 'idea',
          'status': 'published',
          'published_at': DateTime.now().toIso8601String(),
          'created_by': user.id,
        });
      }
    }
    await Supabase.instance.client.from('submissions').update({
      'status': approve ? 'approved' : 'rejected',
      'reviewed_by': user.id,
      'reviewed_at': DateTime.now().toIso8601String(),
    }).eq('id', item['id']);
    if (mounted) setState(() {});
  }

  Future<Map<String,int>> counts() async {
    final ideas = await Supabase.instance.client.from('content_items').select('id');
    final gifts = await Supabase.instance.client.from('gift_ideas').select('id');
    final events = await Supabase.instance.client.from('events').select('id');
    final lights = await Supabase.instance.client.from('light_displays').select('id');
    final pendingRows = await Supabase.instance.client.from('submissions').select('id').eq('status','pending');
    return {
      'Ideas': (ideas as List).length,
      'Gifts': (gifts as List).length,
      'Events': (events as List).length,
      'Lights': (lights as List).length,
      'Pending': (pendingRows as List).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF7F2E8), elevation: 0, title: const Text('Admin')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20,18,20,30),
        children: [
          FutureBuilder<Map<String,int>>(
            future: counts(),
            builder: (context, snap) {
              final data = snap.data ?? {};
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Ideas: ' + (data['Ideas']?.toString() ?? '…'))),
                  Chip(label: Text('Gifts: ' + (data['Gifts']?.toString() ?? '…'))),
                  Chip(label: Text('Events: ' + (data['Events']?.toString() ?? '…'))),
                  Chip(label: Text('Lights: ' + (data['Lights']?.toString() ?? '…'))),
                  Chip(label: Text('Pending: ' + (data['Pending']?.toString() ?? '…'))),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Card(child: ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF0F4C45)),
            title: const Text('Image Library', style: TextStyle(fontWeight: FontWeight.w900)),
            subtitle: const Text('Add and manage photos for gifts, Elf ideas and Secret Santa content'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMediaManagerPage())).then((_)=>setState((){})),
          )),
          const SizedBox(height: 18),
          Text('Pending submissions', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize:25)),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String,dynamic>>>(
            future: pending(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final items = snap.data ?? [];
              if (items.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('Nothing waiting for approval 🎄')));
              return Column(children: items.map((item) => Card(child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text((item['submission_type'] ?? '').toString().toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text((item['title'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  if ((item['description'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text((item['description'] ?? '').toString()),
                  ],
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => review(item, false), child: const Text('Reject'))),
                    const SizedBox(width: 8),
                    Expanded(child: FilledButton(onPressed: () => review(item, true), child: const Text('Approve & Publish'))),
                  ]),
                ]),
              ))).toList());
            },
          ),
        ],
      ),
    );
  }
}

class MePage extends StatefulWidget {
  final XmasTheme theme;
  final ValueChanged<XmasTheme> onThemeChanged;
  const MePage({super.key, required this.theme, required this.onThemeChanged});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String? message;
  Map<String,dynamic>? profile;
  bool busy = false;

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => profile = null);
      return;
    }
    final rows = await Supabase.instance.client.from('profiles').select('display_name,role,premium_status').eq('id', user.id).limit(1);
    if (mounted) setState(() {
      profile = List<Map<String,dynamic>>.from(rows).isEmpty ? null : List<Map<String,dynamic>>.from(rows).first;
    });
  }

  Future<void> signIn() async {
    setState(() { busy = true; message = null; });
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: email.text.trim(), password: password.text);
      await loadProfile();
      message = profile?['role'] == 'admin' ? 'Admin access confirmed ✅' : 'Signed in ✅';
    } catch (e) {
      message = 'Sign in failed. Check your email and password.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) setState(() { profile = null; message = 'Signed out'; });
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final isAdmin = profile?['role'] == 'admin' || profile?['role'] == 'editor';
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Me', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 5),
          const Text('Your Christmas preferences, account and contributions.'),
          const SizedBox(height: 22),
          const Text('CHRISTMAS STYLE', style: TextStyle(fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1.2,color:Color(0xFF8B6F2E))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(label: const Text('Kiwi'), selected: widget.theme == XmasTheme.kiwi, onSelected: (_) => widget.onThemeChanged(XmasTheme.kiwi)),
              ChoiceChip(label: const Text('Classic ✨'), selected: widget.theme == XmasTheme.classic, onSelected: (_) => widget.onThemeChanged(XmasTheme.classic)),
              ChoiceChip(label: const Text('Grinchy 💚'), selected: widget.theme == XmasTheme.grinchy, onSelected: (_) => widget.onThemeChanged(XmasTheme.grinchy)),
              ChoiceChip(label: const Text('Winter ❄️'), selected: widget.theme == XmasTheme.winter, onSelected: (_) => widget.onThemeChanged(XmasTheme.winter)),
            ],
          ),
          const SizedBox(height: 22),
          if (user == null) ...[
            const Text('Sign in', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 6),
            const Text('Sign in to save boards, submit Christmas finds and access admin tools.'),
            const SizedBox(height: 10),
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 12),
            FilledButton(onPressed: busy ? null : signIn, child: Text(busy ? 'Signing in…' : 'Sign in')),
          ] else ...[
            Container(
              decoration: BoxDecoration(color: const Color(0xFFFFFCF6), border: Border.all(color: const Color(0xFFE4DCCF)), borderRadius: BorderRadius.circular(5)),
              child: ListTile(
              leading: const Icon(Icons.person_outline, color: Color(0xFF0F4C45)),
              title: Text((profile?['display_name'] ?? user.email ?? 'Signed in').toString()),
              subtitle: Text(isAdmin ? 'Owner / Admin' : 'Member'),
            )),
            Card(child: ListTile(
              leading: const CircleAvatar(child: Text('⬆')),
              title: const Text('Submit a Christmas Find', style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: const Text('Events, lights, businesses or ideas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmissionPage())),
            )),
            if (isAdmin)
              Card(child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.admin_panel_settings)),
                title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.w900)),
                subtitle: const Text('Approve submissions and view live content totals'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
              )),
            FilledButton.tonal(onPressed: signOut, child: const Text('Sign out')),
          ],
          if (message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(message!)),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFEEE6D8), borderRadius: BorderRadius.circular(5)),
            child: const ListTile(
            leading: Icon(Icons.facebook, color: Color(0xFF0F4C45)),
            title: Text('Christmas Ideas NZ on Facebook'),
            subtitle: Text('Facebook link will be connected before launch'),
          )),
        ],
      ),
    );
  }
}
