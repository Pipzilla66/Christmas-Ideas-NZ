import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const supabaseUrl = 'https://ocrwnkeqemcsklsnbufq.supabase.co';
const supabaseKey = 'sb_publishable_ciIHpWT3mWNzgEpUebXGkw_EBzELVZ3';
const _coverPhotoBase64 = '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';

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
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(base64Decode(_coverPhotoBase64), fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x22000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CHRISTMAS IDEAS NZ',
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 2.1, fontSize: 12)),
                        const Spacer(),
                        Text('Make it a magical\nKiwi Christmas.',
                          style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 38, height: 1.04)),
                        const SizedBox(height: 10),
                        Text('Ideas, gifts, lights and events — all in one place.',
                          style: GoogleFonts.inter(color: Colors.white.withValues(alpha: .92), fontSize: 15, height: 1.45)),
                      ],
                    ),
                  ),
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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                const Text('✦', style: TextStyle(color:Color(0xFFC69A3A),fontSize:20)),
                const SizedBox(width:8),
                Expanded(child:Text('Christmas Ideas NZ',style:GoogleFonts.playfairDisplay(fontSize:22,fontWeight:FontWeight.w700,color:const Color(0xFF173B36)))),
                IconButton(onPressed:()=>goTo(4),icon:const Icon(Icons.person_outline,color:Color(0xFF173B36))),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal:14),
            height: 290,
            clipBehavior: Clip.antiAlias,
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(12)),
            child:Stack(
              fit:StackFit.expand,
              children:[
                Image.memory(base64Decode(_coverPhotoBase64),fit:BoxFit.cover),
                Container(decoration:const BoxDecoration(
                  gradient:LinearGradient(
                    begin:Alignment.topCenter,
                    end:Alignment.bottomCenter,
                    colors:[Color(0x22000000),Color(0xCC000000)],
                  ),
                )),
                Padding(
                  padding:const EdgeInsets.fromLTRB(22,22,22,18),
                  child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text('✦  MAKE THIS CHRISTMAS',style:GoogleFonts.inter(color:Colors.white,fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1.4)),
                    const Spacer(),
                    Text('More\nMeaningful',style:GoogleFonts.playfairDisplay(color:Colors.white,fontSize:42,fontWeight:FontWeight.w600,fontStyle:FontStyle.italic,height:.92)),
                    const SizedBox(height:10),
                    Text('Inspiration, gifts, food and ideas for a Christmas you’ll love in New Zealand.',style:GoogleFonts.inter(color:Colors.white,fontSize:13,height:1.35)),
                    const SizedBox(height:14),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal:14,vertical:10),
                      decoration:BoxDecoration(color:const Color(0xFFF7F2E8).withValues(alpha:.94),borderRadius:BorderRadius.circular(8)),
                      child:Row(mainAxisSize:MainAxisSize.min,children:[
                        Text(daysUntilChristmas().toString(),style:GoogleFonts.playfairDisplay(fontSize:25,fontWeight:FontWeight.w700,color:const Color(0xFF173B36))),
                        const SizedBox(width:7),
                        const Text('DAYS\nUNTIL CHRISTMAS',style:TextStyle(fontSize:8.5,fontWeight:FontWeight.w800,letterSpacing:.8,color:Color(0xFF6B6F6C))),
                      ]),
                    ),
                  ]),
                ),
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
          _SectionHeading(title:'Featured Gifts', action:'See all', onTap:()=>goTo(1)),
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
          _SectionHeading(title:'Christmas Ideas', action:'See all', onTap:()=>goTo(1)),
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
                          ClipRRect(
                            borderRadius:BorderRadius.circular(4),
                            child:(item['image_url']??'').toString().isNotEmpty
                              ? Image.network(
                                  (item['image_url']??'').toString(),
                                  width:72,
                                  height:72,
                                  fit:BoxFit.cover,
                                  errorBuilder:(_,__,___)=>Container(width:72,height:72,color:const Color(0xFF9E1B32),child:const Icon(Icons.star_outline,color:Colors.white,size:30)),
                                )
                              : Container(width:72,height:72,color:const Color(0xFF9E1B32),child:const Icon(Icons.star_outline,color:Colors.white,size:30)),
                          ),
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
          const Text('GIFTS, IDEAS, RECIPES AND MORE FOR A BRIGHTER CHRISTMAS.', style: TextStyle(fontSize:11,fontWeight:FontWeight.w700,letterSpacing:1.1,color:Color(0xFF6B6F6C))),
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
                contentPadding:const EdgeInsets.symmetric(vertical:6),
                leading:ClipRRect(
                  borderRadius:BorderRadius.circular(4),
                  child:(item['image_url']??'').toString().isNotEmpty
                    ? Image.network(
                        (item['image_url']??'').toString(),
                        width:58,
                        height:58,
                        fit:BoxFit.cover,
                        errorBuilder:(_,__,___)=>Container(width:58,height:58,color:const Color(0xFF9E1B32),child:const Icon(Icons.star_outline,color:Colors.white)),
                      )
                    : Container(width:58,height:58,color:const Color(0xFF9E1B32),child:const Icon(Icons.star_outline,color:Colors.white)),
                ),
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
          const SizedBox(height: 8),
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
