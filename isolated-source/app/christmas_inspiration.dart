import 'package:flutter/material.dart';
import 'share_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class CraftPhoto {
 final String asset,caption,photographer,source;
 const CraftPhoto(this.asset,this.caption,this.photographer,this.source);
}
const craftPhotos=<String,CraftPhoto>{
  "Little handprint Christmas cards": CraftPhoto('assets/crafts/6156889.jpg', "Christmas card-making inspiration", "cottonbro studio", 'https://www.pexels.com/photo/6156889/'),
  "Make your own gift bags": CraftPhoto('assets/crafts/1666067.jpg', "Plain bags ready for your own decorations", "George Dolgikh", 'https://www.pexels.com/photo/1666067/'),
  "Recycled paper chains": CraftPhoto('assets/crafts/8535172.jpg', "Paper-crafting inspiration", "Ksenia Chernaya", 'https://www.pexels.com/photo/8535172/'),
  "Salt dough keepsake ornaments": CraftPhoto('assets/crafts/9016508.jpg', "Painting salt-dough shapes", "Kevin Malik", 'https://www.pexels.com/photo/9016508/'),
  "Folded paper stars": CraftPhoto('assets/crafts/6072435.jpg', "Paper-star decoration inspiration", "cottonbro studio", 'https://www.pexels.com/photo/6072435/'),
  "Fabric gift wrapping": CraftPhoto('assets/crafts/6305931.jpg', "Reusable fabric gift-wrap inspiration", "Anastasia Shuraeva", 'https://www.pexels.com/photo/6305931/'),
  "Yarn-wrapped Christmas wreath": CraftPhoto('assets/crafts/5709742.jpg', "Yarn and wreath-making inspiration", "Arina Krasnikova", 'https://www.pexels.com/photo/5709742/'),
  "Make a festive table centrepiece": CraftPhoto('assets/crafts/6212328.jpg', "Natural decorations with battery lights", "Arina Krasnikova", 'https://www.pexels.com/photo/6212328/'),
};

class FestiveActivity {
 final String title,kind,time,materials;
 final int minAge,maxAge;
 final List<String> steps;
 const FestiveActivity(this.title,this.kind,this.minAge,this.maxAge,this.time,this.materials,this.steps);
}
const festiveActivities=<FestiveActivity>[
 FestiveActivity('Little handprint Christmas cards','Craft',3,5,'20 minutes','Folded card, washable paint, a brush, a cloth',['Cover the table and fold a card in half.','Help your child paint a palm and press it onto the front. Let it dry.','Turn the print into a tree or reindeer using drawn details.','Write a message together and choose someone to surprise.']),
 FestiveActivity('Make your own gift bags','Craft',3,9,'20 minutes','Plain paper bags, crayons, paper shapes, child-safe glue',['Give each person a plain bag.','Draw stars, trees or summer Christmas scenes.','Stick on large paper shapes and let the glue dry.','Add the recipient’s name and use the bag for a small gift.']),
 FestiveActivity('Christmas colour hunt','Activity',3,99,'15 minutes','Paper, coloured pencils',['Draw five colour circles: red, green, gold, white and blue.','Walk around home or a park together and look for each colour.','Draw or describe what you found. No need to pick plants or take objects.','Finish by choosing the most surprising Christmas-coloured find.']),
 FestiveActivity('Recycled paper chains','Craft',5,99,'30 minutes','Old magazines or paper, scissors, glue stick',['An adult can pre-cut strips for younger children.','Join the first strip into a loop.','Thread the next strip through it and glue its ends together.','Keep going and hang the chain safely away from candles or heat.']),
 FestiveActivity('Design a Christmas treasure hunt','Activity',6,12,'30 minutes','Paper, pencils, five everyday objects',['Choose five safe places around the house.','Write or draw a clue for each place.','Hide a star, picture or small surprise at the end.','Take turns being the clue maker and the treasure hunter.']),
 FestiveActivity('Salt dough keepsake ornaments','Craft',6,99,'30 minutes + adult oven drying','1 cup plain flour, ½ cup salt, about ½ cup water, rolling pin, cutters, ribbon',['Mix flour and salt. Add water gradually until you have a firm dough.','Roll to about 5 mm thick and cut simple shapes. Make a ribbon hole.','An adult can dry them in a 100°C oven for about 2 hours, checking them; thicker pieces may need longer. Let them cool completely.','Paint the dry shapes and add ribbon. These are decorations, not food.']),
 FestiveActivity('Create your family Christmas quiz','Activity',10,99,'30 minutes','Paper, pens, a willing quiz host',['Each person writes three questions about Christmas or your family.','Include picture clues or simple questions so younger players can join.','Make mixed-age teams and read the questions aloud.','Keep the questions for next year and add a new round each Christmas.']),
 FestiveActivity('Folded paper stars','Craft',10,99,'30 minutes','Square paper, scissors, glue',['Fold a square diagonally and then into smaller triangles.','Draw a few simple cuts along the folded edges, leaving the joins intact.','Cut carefully, then unfold to reveal a star or snowflake.','Glue onto cards or hang with thread. An adult helps with cutting if needed.']),
 FestiveActivity('Fabric gift wrapping','Craft',10,99,'20 minutes','A clean scarf or square cloth, a boxed gift',['Place the gift diagonally in the centre of the cloth.','Fold opposite corners over the gift.','Bring the other corners together and tie a secure knot.','Add a handmade tag explaining that the wrap can be reused.']),
 FestiveActivity('Yarn-wrapped Christmas wreath','Craft',13,99,'45 minutes','Reused cardboard, wool, scissors, ribbon, glue',['Cut a ring from sturdy cardboard.','Wrap wool around the ring until the cardboard is covered.','Tie the end securely at the back.','Add ribbon or paper leaves and hang indoors with a loop of wool.']),
 FestiveActivity('Make a festive table centrepiece','Craft',13,99,'30 minutes','A tray, clean fallen pinecones, leaves, ribbon, battery lights',['Choose a low tray so everyone can still see each other across the table.','Arrange clean, dry natural pieces and ribbon.','Add battery lights if you have them.','Keep loose pieces away from very young children; use lights instead of an open flame.']),
 FestiveActivity('Christmas memory interview','Activity',6,99,'20 minutes','Paper or a phone recorder, with permission',['Ask a grandparent, neighbour or friend what Christmas was like when they were young.','Ask about their favourite food, game and tradition.','Write down one story or record it with their permission.','Choose one part to try together this year.']),
];
class TraditionIdea {
 final String title,theme,why;final List<String> steps;
 const TraditionIdea(this.title,this.theme,this.why,this.steps);
}
const traditionIdeas=<TraditionIdea>[
 TraditionIdea('The same photo, every Christmas','Keepsakes','A simple way to watch your family’s story grow.',['Pick a familiar spot and take one photo each December.','Use the same pose or a favourite decoration if you like.','Keep the photos in a dated album. Let each person add one memory.']),
 TraditionIdea('Our Christmas Eve picnic','Food & fun','A summer-friendly ritual that can stay simple.',['Choose a park, the garden or a rug in the lounge.','Each person chooses one picnic food from what you already have.','Share one happy memory from the year before you pack up.']),
 TraditionIdea('A new ornament with a story','Keepsakes','The meaning comes from the memory rather than the price.',['Make an ornament together, or reuse a small keepsake.','Write the year and a sentence about what it represents.','Read the old stories when you decorate next Christmas.']),
 TraditionIdea('The Christmas book basket','Together','A quiet ritual for busy December evenings.',['Collect books you own or borrow some from the library.','Choose one night a week to read together.','Let different people choose the book. Add cocoa or a cool drink if you fancy.']),
 TraditionIdea('Kindness instead of countdown treats','Kindness','Small actions can make the season feel more meaningful.',['Write a handful of manageable kindness ideas.','Try things such as calling someone, making a card or helping at home.','Choose one whenever your family has time; it does not have to be daily.']),
 TraditionIdea('The lights-and-snacks outing','Together','Turn an ordinary outing into an annual family favourite.',['Choose a few displays from the app and check dates first.','Pack a snack and choose a shared playlist.','At the end, everyone picks their favourite display.']),
 TraditionIdea('A recipe from someone we love','Food & fun','Keep a person’s story alongside their favourite food.',['Ask a relative or friend for a recipe and the story behind it.','Cook it together, adjusting jobs for each person’s age.','Keep the recipe and a photo in your family Christmas folder.']),
 TraditionIdea('Christmas morning, our way','Together','Build a rhythm that suits your household.',['Choose one thing to do before gifts: breakfast, a walk, church or a family photo.','Agree on a pace that works for everyone.','Repeat the bits you enjoy and change the bits that create stress.']),
 TraditionIdea('A Christmas memory jar','Keepsakes','Notice the small moments you might otherwise forget.',['Put a jar and scraps of paper somewhere easy to reach.','Write or draw a happy December moment when it happens.','Read them together at Christmas or New Year and save a few.']),
 TraditionIdea('A thank-you tradition','Kindness','Include the people who make your everyday life better.',['Choose someone you would like to thank.','Make a card or record a message together.','Deliver it in a way that suits them, without expecting anything in return.']),
];
List<FestiveActivity> activitiesForAge(String age)=>festiveActivities.where((e){final ranges={'Preschool (3–5)':[3,5],'Kids (6–9)':[6,9],'Tweens (10–12)':[10,12],'Teens':[13,17],'Adults':[18,99]};final r=ranges[age];return r==null||(e.minAge<=r[1]&&e.maxAge>=r[0]);}).toList();

class ChristmasInspirationPage extends StatefulWidget {
 final bool traditions;final void Function(Map<String,dynamic>) onIdea;
 final Future<List<Map<String,dynamic>>> Function()? loader;
 const ChristmasInspirationPage({super.key,this.traditions=false,required this.onIdea,this.loader});
 @override State<ChristmasInspirationPage> createState()=>_ChristmasInspirationPageState();
}
class _ChristmasInspirationPageState extends State<ChristmasInspirationPage>{
 final ScrollController listScroll = ScrollController();
 @override void dispose(){listScroll.dispose();super.dispose();}
 String age='All ages',kind='All',theme='All';late Future<List<Map<String,dynamic>>> community;
 Future<List<Map<String,dynamic>>> load()async=>widget.loader!=null?await widget.loader!():List<Map<String,dynamic>>.from(await Supabase.instance.client.from('content_items').select('id,title,summary,body,image_url,external_url,content_type,rating_count,rating_average').eq('status','published').eq('content_type',widget.traditions?'tradition':'activity').order('published_at',ascending:false));
 @override void initState(){super.initState();community=load();}
 void refresh()=>setState(()=>community=load());
 Future<void> share({BuildContext? presentationContext})async{
 final shareContext=presentationContext??context;
 final user=Supabase.instance.client.auth.currentUser;
 if(user==null){ScaffoldMessenger.of(shareContext).showSnackBar(const SnackBar(content:Text('Sign in from Me to share your family’s idea.')));return;}
 final title=TextEditingController(),story=TextEditingController(),credit=TextEditingController();bool sending=false;String? error;
 await showDialog(context:shareContext,builder:(ctx)=>StatefulBuilder(builder:(ctx,change)=>AlertDialog(title:Text(widget.traditions?'Share your family tradition':'Share a craft or activity'),content:SizedBox(width:440,child:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
 const Text('Your story and public credit will appear after admin review. Leave out personal contact details. Use your own words.'),
 TextField(controller:title,maxLength:100,decoration:const InputDecoration(labelText:'Give it a name')),
 TextField(controller:story,maxLength:3000,maxLines:5,decoration:InputDecoration(labelText:widget.traditions?'How does your family do it? What makes it special?':'Materials, suitable ages and steps')),
 TextField(controller:credit,maxLength:60,decoration:const InputDecoration(labelText:'Public credit (optional)',hintText:'e.g. The Smith family')),
 if(error!=null)Text(error!,style:const TextStyle(color:Colors.red)),
 ]))),actions:[TextButton(onPressed:sending?null:()=>Navigator.pop(ctx),child:const Text('Cancel')),FilledButton(onPressed:sending?null:()async{
 if(title.text.trim().length<2||story.text.trim().length<10){change(()=>error='Add a title and a little more detail.');return;}
 change((){sending=true;error=null;});
 try{await Supabase.instance.client.from('submissions').insert({'user_id':user.id,'submission_type':'idea','title':title.text.trim(),'description':story.text.trim(),'payload':{'content_type':widget.traditions?'tradition':'activity','public_credit':credit.text.trim().isEmpty?'A community member':credit.text.trim()},'status':'pending'});
 if(ctx.mounted)Navigator.pop(ctx);if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Thank you! Your idea is waiting for admin review. Check Me → Notifications for the outcome.')));
 }catch(_){if(ctx.mounted)change((){sending=false;error='Could not confirm your submission. Please check your connection before retrying.';});}
 },child:Text(sending?'Sending…':'Submit for review'))])));
 await Future<void>.delayed(const Duration(milliseconds:350));
 title.dispose();story.dispose();credit.dispose();
 }
 Future<void> openActivity(FestiveActivity activity) async {
 // Keep the selection-time position, including when web focus moves the hidden list.
 final selectedOffset = listScroll.hasClients ? listScroll.offset : null;
 final route = MaterialPageRoute<void>(builder: (_) => BuiltInActivityDetailPage(
   activity: activity,
   onShare: (detailContext) => share(presentationContext: detailContext),
 ));
 await Navigator.of(context).push(route);
 // A popped route finishes before its reverse animation. Restore after removal
 // so focus restoration during the transition cannot overwrite this position.
 await route.completed;
 if (!mounted || selectedOffset == null) return;
 await WidgetsBinding.instance.endOfFrame;
 if (!mounted || !listScroll.hasClients) return;
 final position = listScroll.position;
 listScroll.jumpTo(selectedOffset.clamp(position.minScrollExtent, position.maxScrollExtent));
 }
 Widget activityCard(FestiveActivity activity){
 final photo=craftPhotos[activity.title];
 return Card(key:ValueKey('builtin-${activity.title}'),margin:const EdgeInsets.only(bottom:16),clipBehavior:Clip.antiAlias,child:InkWell(
 onTap:()=>openActivity(activity),
 child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 if(photo!=null)...[
 Image.asset(photo.asset,height:220,width:double.infinity,fit:BoxFit.cover,semanticLabel:photo.caption),
 Padding(padding:const EdgeInsets.fromLTRB(16,8,16,0),child:Text(photo.caption,style:Theme.of(context).textTheme.bodySmall)),
 ],
 ListTile(leading:Icon(activity.kind=='Craft'?Icons.palette_outlined:Icons.celebration_outlined,color:const Color(0xFF0F4C45)),title:Text(activity.title,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text('${activity.kind} · ${activity.minAge}–${activity.maxAge>=99?'adult':activity.maxAge} · ${activity.time}\nView materials & steps'),trailing:const Icon(Icons.chevron_right,color:Color(0xFF0F4C45))),
 ])));
 }
 Widget ideaCard(String title,String subtitle,String materials,List<String> steps,IconData icon){
 final photo=craftPhotos[title];
 return Card(margin:const EdgeInsets.only(bottom:16),clipBehavior:Clip.antiAlias,child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 if(photo!=null)...[
 Image.asset(photo.asset,height:220,width:double.infinity,fit:BoxFit.cover,semanticLabel:photo.caption,errorBuilder:(_,__,___)=>const SizedBox(height:180,child:Center(child:Icon(Icons.palette_outlined,size:48)))),
 Padding(padding:const EdgeInsets.fromLTRB(16,8,16,0),child:Text(photo.caption,style:Theme.of(context).textTheme.bodySmall)),
 ],
 ExpansionTile(leading:Icon(icon,color:const Color(0xFF0F4C45)),title:Text(title,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text('$subtitle\nTap for materials & steps'),children:[Padding(padding:const EdgeInsets.fromLTRB(18,0,18,18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[if(materials.isNotEmpty)...[Text('You’ll need: $materials'),const SizedBox(height:12)],for(var i=0;i<steps.length;i++)Padding(padding:const EdgeInsets.only(bottom:8),child:Text('${i+1}. ${steps[i]}')),
 if(!widget.traditions)OwnIdeaButton(onPressed:share),
 if(photo!=null)TextButton(onPressed:()=>launchUrl(Uri.parse(photo.source),mode:LaunchMode.externalApplication),child:Text('Photo: ${photo.photographer} / Pexels')),
 ]))]),
 ]));
 }
 @override Widget build(BuildContext context){final activities=activitiesForAge(age).where((e)=>kind=='All'||e.kind==kind).toList();final traditions=traditionIdeas.where((e)=>theme=='All'||e.theme==theme).toList();return Scaffold(appBar:AppBar(title:Text(widget.traditions?'Family Christmas traditions':'Christmas crafts & activities')),body:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:900),child:ListView(key:PageStorageKey(widget.traditions?'traditions-list':'craft-activity-list'),controller:listScroll,padding:const EdgeInsets.all(20),children:[
 Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:const Color(0xFF0F4C45),borderRadius:BorderRadius.circular(18)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(widget.traditions?'Make Christmas your own':'Make, play & spend time together',style:const TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.bold)),const SizedBox(height:10),Text(widget.traditions?'Borrow an idea, adapt it to your family and let it become something you look forward to each year.':'Simple ideas for little hands, older kids, teens and grown-ups. Pick an age and tap an idea for materials and steps.',style:const TextStyle(color:Colors.white,height:1.5))])),
 const SizedBox(height:16),FilledButton.icon(onPressed:share,icon:const Icon(Icons.add),label:Text(widget.traditions?'Share our family tradition':'Share a craft or activity')),
 const SizedBox(height:16),
 if(widget.traditions)DropdownButtonFormField<String>(initialValue:theme,decoration:const InputDecoration(labelText:'What matters to your family?'),items:['All','Together','Keepsakes','Kindness','Food & fun'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>theme=v!))
 else ...[DropdownButtonFormField<String>(initialValue:age,decoration:const InputDecoration(labelText:'Who is joining in?'),items:['All ages','Preschool (3–5)','Kids (6–9)','Tweens (10–12)','Teens','Adults'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>age=v!)),const SizedBox(height:12),DropdownButtonFormField<String>(initialValue:kind,decoration:const InputDecoration(labelText:'Type'),items:['All','Craft','Activity'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>kind=v!))],
 const SizedBox(height:20),Text(widget.traditions?'Ideas to start your own traditions':'Ready-to-try ideas',style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:8),
 if(!widget.traditions)const Padding(padding:EdgeInsets.only(bottom:12),child:Text('Stock photos offer inspiration; your finished craft may look different.')),
 if(widget.traditions)const Padding(padding:EdgeInsets.only(bottom:12),child:Text('These are starter ideas, not stories submitted by individual families. Their stories will appear below after review.')),
 if(widget.traditions)for(final e in traditions)ideaCard(e.title,'${e.theme} · ${e.why}','',e.steps,Icons.favorite_outline)
 else for(final e in activities)activityCard(e),
 const SizedBox(height:20),Text(widget.traditions?'Traditions from the directory':'Community crafts & activities',style:Theme.of(context).textTheme.titleLarge),
 FutureBuilder<List<Map<String,dynamic>>>(future:community,builder:(context,snap){if(snap.hasError)return TextButton(onPressed:refresh,child:const Text('Could not load shared ideas. Tap to retry.'));if(!snap.hasData)return const Padding(padding:EdgeInsets.all(16),child:LinearProgressIndicator());if(snap.data!.isEmpty)return Padding(padding:const EdgeInsets.symmetric(vertical:12),child:Text(widget.traditions?'Be one of the first families to share a tradition.':'Shared activities will appear here after admin review.'));return Column(children:[for(final e in snap.data!)Card(child:ListTile(title:Text('${e['title']}'),subtitle:Text('${e['summary']??''}',maxLines:3,overflow:TextOverflow.ellipsis),trailing:const Icon(Icons.chevron_right),onTap:()=>widget.onIdea(e)))]);}),
 ]))));}
}

/// Local catalogue detail: no fabricated content IDs or database writes.
class BuiltInActivityDetailPage extends StatelessWidget {
 final FestiveActivity activity;
 final void Function(BuildContext) onShare;
 const BuiltInActivityDetailPage({super.key,required this.activity,required this.onShare});
 @override Widget build(BuildContext context){
 final photo=craftPhotos[activity.title];
 return Scaffold(
 backgroundColor:const Color(0xFFF7F2E8),
 appBar:AppBar(backgroundColor:const Color(0xFFF7F2E8),foregroundColor:const Color(0xFF0F4C45),surfaceTintColor:Colors.transparent,title:const Text('Christmas idea')),
 body:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:900),child:ListView(key:ValueKey('detail-${activity.title}'),children:[
 if(photo!=null)...[
 AspectRatio(aspectRatio:16/10,child:Image.asset(photo.asset,fit:BoxFit.cover,semanticLabel:photo.caption)),
 Padding(padding:const EdgeInsets.fromLTRB(20,8,20,0),child:Text(photo.caption,style:Theme.of(context).textTheme.bodySmall)),
 ],
 Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Text(activity.kind.toUpperCase(),style:const TextStyle(fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1.3,color:Color(0xFF8B6F2E))),
 const SizedBox(height:8),
 Text(activity.title,style:Theme.of(context).textTheme.headlineMedium?.copyWith(color:const Color(0xFF0F4C45))),
 const SizedBox(height:12),
 Text('${activity.minAge}–${activity.maxAge>=99?'adult':activity.maxAge} · ${activity.time}'),
 const SizedBox(height:24),
 Text('Materials',style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:8),Text(activity.materials),
 const SizedBox(height:24),Text('Instructions',style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:12),
 for(var i=0;i<activity.steps.length;i++)Padding(padding:const EdgeInsets.only(bottom:12),child:Text('${i+1}. ${activity.steps[i]}')),
 if(photo!=null)...[
 const SizedBox(height:8),TextButton(onPressed:()=>launchUrl(Uri.parse(photo.source),mode:LaunchMode.externalApplication),child:Text('Photo: ${photo.photographer} / Pexels')),
 Text('Stock photo for inspiration; your finished craft may look different.',style:Theme.of(context).textTheme.bodySmall),
 ],
 const SizedBox(height:20),OwnIdeaButton(onPressed:()=>onShare(context)),
 ])),
 ]))),
 );
 }
}
