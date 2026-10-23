import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class HallmarkChecklistPage extends StatefulWidget {
 final Future<List<Map<String,dynamic>>> Function()? loader;
 final Future<Set<String>> Function()? watchedLoader;
 final Future<void> Function(String,bool)? saver;
 const HallmarkChecklistPage({super.key,this.loader,this.watchedLoader,this.saver});
 @override State<HallmarkChecklistPage> createState()=>_HallmarkChecklistPageState();
}
class _HallmarkChecklistPageState extends State<HallmarkChecklistPage>{
 List<Map<String,dynamic>> movies=[];Set<String> watched={};bool loading=true,busy=false;String? error;String filter='All',query='';bool guest=true,hallmarkOnly=false;
 @override void initState(){super.initState();load();}
 Future<void> load()async{try{
 final client=widget.loader==null?Supabase.instance.client:null;final user=client?.auth.currentUser;
 final rows=widget.loader!=null?await widget.loader!():List<Map<String,dynamic>>.from(await client!.from('christmas_movies').select('id,title,year,cosy').eq('status','published').order('title'));
 final seen=widget.watchedLoader!=null?await widget.watchedLoader!():user==null?((await SharedPreferences.getInstance()).getStringList('guest-movie-watched')??[]).toSet():(await client!.from('movie_watched').select('movie_id').eq('user_id',user.id)).map((e)=>e['movie_id'].toString()).toSet();
 if(mounted)setState((){movies=rows;watched=seen;guest=user==null;loading=false;error=null;});
 }catch(_){if(mounted)setState((){loading=false;error='Could not load the checklist. Please try again.';});}}
 Future<void> tick(String id,bool selected)async{
 if(busy)return;setState(()=>busy=true);final next=watched.toSet();if(selected)next.add(id);else next.remove(id);
 try{if(widget.saver!=null){await widget.saver!(id,selected);}else{final client=Supabase.instance.client,user=Supabase.instance.client.auth.currentUser;
 if(user==null){if(!await (await SharedPreferences.getInstance()).setStringList('guest-movie-watched',next.toList()))throw StateError('Could not save');}
 else if(selected){await client.from('movie_watched').insert({'movie_id':id,'user_id':user.id});}
 else{await client.from('movie_watched').delete().eq('movie_id',id).eq('user_id',user.id);}}
 if(mounted)setState(()=>watched=next);
 }catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Your tick could not save. Please try again.')));}
 finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context){final visible=movies.where((e)=>(!hallmarkOnly||e['cosy']==true)&&(filter=='All'||(filter=='Watched'?watched.contains(e['id']):!watched.contains(e['id'])))&&e['title'].toString().toLowerCase().contains(query.toLowerCase().trim())).toList();final count=movies.where((e)=>watched.contains(e['id'])).length;
 return Scaffold(appBar:AppBar(title:const Text('Christmas movie checklist'),actions:[IconButton(onPressed:busy?null:load,tooltip:'Refresh checklist',icon:const Icon(Icons.refresh))]),body:ListView(padding:const EdgeInsets.all(20),children:[
 Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:const Color(0xFF0F4C45),borderRadius:BorderRadius.circular(18)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Your Christmas watchlist',style:TextStyle(fontSize:25,color:Colors.white,fontWeight:FontWeight.bold)),SizedBox(height:10),Text('Hallmark favourites, family classics, festive comedies and Christmas horror. Choose a movie and tick it off as you watch.',style:TextStyle(color:Colors.white,height:1.5))])),
 const SizedBox(height:16),Text('$count / ${movies.length} watched',style:Theme.of(context).textTheme.titleLarge),if(movies.isNotEmpty)LinearProgressIndicator(value:count/movies.length),const SizedBox(height:10),
 Text(guest?'Ticks save on this browser. Signed-in members have a separate account checklist that syncs across devices.':'Your checklist saves to your account and syncs across devices.'),
 const SizedBox(height:10),const Text('Check NZ availability and age ratings with your viewing provider. This independent checklist is separate from the Christmas movie voting page.'),
 const SizedBox(height:16),Wrap(spacing:8,children:[ChoiceChip(label:const Text('All Christmas movies'),selected:!hallmarkOnly,onSelected:(_)=>setState(()=>hallmarkOnly=false)),ChoiceChip(label:const Text('Hallmark'),selected:hallmarkOnly,onSelected:(_)=>setState(()=>hallmarkOnly=true))]),const SizedBox(height:12),TextField(decoration:const InputDecoration(labelText:'Find a movie',prefixIcon:Icon(Icons.search)),onChanged:(v)=>setState(()=>query=v)),const SizedBox(height:12),DropdownButtonFormField<String>(initialValue:filter,decoration:const InputDecoration(labelText:'Show movies'),items:['All','Still to watch','Watched'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)=>setState(()=>filter=v!)),const SizedBox(height:14),
 if(loading)const LinearProgressIndicator(),if(error!=null)TextButton(onPressed:load,child:Text(error!)),if(!loading&&error==null&&visible.isEmpty)const Text('No movies in this view. Try another filter.'),
 for(final e in visible)Card(child:CheckboxListTile(value:watched.contains(e['id']),onChanged:busy?null:(v)=>tick(e['id'].toString(),v!),title:Text('${e['title']}'),subtitle:e['year']==null?null:Text('${e['year']}'),controlAffinity:ListTileControlAffinity.leading)),
 ]));}
}
