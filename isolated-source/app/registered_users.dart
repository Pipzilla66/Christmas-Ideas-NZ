import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'csv_export.dart';
class RegisteredUsersPage extends StatefulWidget {
 final Future<Map<String,dynamic>> Function()? loader;
 const RegisteredUsersPage({super.key,this.loader});
 @override State<RegisteredUsersPage> createState()=>_RegisteredUsersPageState();
}
class _RegisteredUsersPageState extends State<RegisteredUsersPage> {
 Map<String,dynamic>? data;String? error;bool busy=false;String search='';Timer? timer;
 Future<void> refresh() async {if(busy)return;setState(()=>busy=true);try{final next=widget.loader!=null?await widget.loader!():Map<String,dynamic>.from(await Supabase.instance.client.rpc('admin_registered_users') as Map);if(mounted)setState((){data=next;error=null;});}catch(_){if(mounted)setState(()=>error='Could not load accounts. Admin access is required.');}finally{if(mounted)setState(()=>busy=false);}}
 Future<void> manage(String action,{String? target,String? reason}) async {if(busy)return;setState(()=>busy=true);try{final next=await Supabase.instance.client.rpc('admin_signup_draw',params:{'action':action,'target':target,'reason':reason});if(mounted)setState((){data=Map<String,dynamic>.from(next as Map);error=null;});}catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Could not update the draw. Refresh and try again.')));}finally{if(mounted)setState(()=>busy=false);}}
 @override void initState(){super.initState();refresh();timer=Timer.periodic(const Duration(minutes:1),(_)=>refresh());}
 @override void dispose(){timer?.cancel();super.dispose();}
 void export(List<Map<String,dynamic>> rows,bool entrants){try{downloadCsv(accountCsv(rows,entriesOnly:entrants),entrants?'christmas-prize-draw.csv':'christmas-registered-users.csv');}catch(_){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Open the web app to download CSV files.')));}}
 @override Widget build(BuildContext context){
 final rows=List<Map<String,dynamic>>.from(data?['accounts']??[]);final draw=Map<String,dynamic>.from(data?['draw']??{});
 final count=(draw['count'] as num? ?? 0).toInt();final frozen=draw['drawn_at']!=null;
 final snapshots=List<Map<String,dynamic>>.from(draw['entries']??[]).map((e)=>{'entry_number':e['entry_number'],'id':e['user_id'],'name':e['display_name'],'email':e['email'],'created_at':e['signed_up_at'],'role':'member'}).toList();
 final entrants=frozen?snapshots:rows;
 final winners=entrants.where((e)=>e['id']==draw['winner_id']);
 final filtered=rows.where((e)=>'${e['name']} ${e['email']}'.toLowerCase().contains(search.toLowerCase())).toList();
 return Scaffold(appBar:AppBar(title:const Text('Registered users'),actions:[IconButton(onPressed:busy?null:refresh,tooltip:'Refresh accounts',icon:const Icon(Icons.refresh))]),body:data==null?Center(child:error!=null?TextButton(onPressed:refresh,child:Text(error!)):const CircularProgressIndicator()):ListView(padding:const EdgeInsets.all(18),children:[
 Text('${rows.length} accounts',style:Theme.of(context).textTheme.headlineSmall),const Text('Admin only · accounts ordered by original sign-up time · refreshes every minute'),
 if(error!=null)Text(error!,style:const TextStyle(color:Colors.red)),
 const SizedBox(height:10),Wrap(spacing:8,children:[FilledButton.icon(onPressed:()=>export(rows,false),icon:const Icon(Icons.download),label:const Text('Export all accounts (CSV)')),if(draw['enabled']!=true)OutlinedButton(onPressed:busy?null:()=>manage('show'),child:const Text('Show temporary prize draw'))]),
 if(draw['enabled']==true)Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Text('First 250 prize draw · $count / 250',style:const TextStyle(fontWeight:FontWeight.bold,fontSize:20)),const SizedBox(height:8),LinearProgressIndicator(value:count/250),const SizedBox(height:10),
 const Text('Existing members are included. Admins and editors are excluded. Mark test accounts and duplicate people below before drawing. Matching names are flagged for review; an email address alone cannot confirm a person’s identity.'),
 if(frozen)...[const SizedBox(height:10),Text('Winner: ${winners.isEmpty?'Account unavailable':winners.first['name']}',style:const TextStyle(fontWeight:FontWeight.bold)),if(winners.isNotEmpty)SelectableText('${winners.first['email']}'),Text('Draw saved: ${draw['drawn_at']} · entries are frozen.')],
 Wrap(spacing:8,children:[TextButton.icon(onPressed:()=>export(entrants,true),icon:const Icon(Icons.download),label:const Text('Export entrants (CSV)')),TextButton(onPressed:busy?null:()=>manage('hide'),child:const Text('Hide prize draw')),if(!frozen)FilledButton(onPressed:busy||count<250?null:()async{final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Draw and save one winner?'),content:const Text('Check exclusions first. This freezes the first 250 eligible entries and saves one random winner. Refreshing will show the same winner.'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Draw winner'))]));if(ok==true)await manage('draw');},child:const Text('Draw winner'))]),
 ]))),
 const SizedBox(height:14),TextField(decoration:const InputDecoration(labelText:'Find a name or email',prefixIcon:Icon(Icons.search)),onChanged:(v)=>setState(()=>search=v)),const SizedBox(height:10),
 for(final e in filtered)Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Row(children:[Expanded(child:Text('${e['name']}',style:const TextStyle(fontWeight:FontWeight.bold))),Text('${e['role']}')]),SelectableText('${e['email']??'Email not supplied'}'),Text('Signed up: ${DateTime.tryParse('${e['created_at']}')?.toLocal().toString()??e['created_at']}'),
 if(draw['enabled']==true)...[Text(e['entry_number']!=null?'Entry #${e['entry_number']}':e['exclusion']!=null?'Excluded: ${e['exclusion']}':['admin','editor'].contains(e['role'])?'Admin / editor — excluded':'Outside first 250 or not eligible'),if(e['possible_duplicate']==true)const Text('Matching name — check for duplicate person',style:TextStyle(color:Colors.deepOrange)),
 if(!frozen&&!['admin','editor'].contains(e['role']))PopupMenuButton<String>(enabled:!busy,onSelected:(v)=>manage(v=='include'?'include':'exclude',target:'${e['id']}',reason:v=='include'?null:v),itemBuilder:(_)=>[if(e['exclusion']!=null)const PopupMenuItem(value:'include',child:Text('Include in draw')),const PopupMenuItem(value:'test',child:Text('Exclude test account')),const PopupMenuItem(value:'duplicate',child:Text('Exclude duplicate person')),const PopupMenuItem(value:'ineligible',child:Text('Exclude ineligible account'))],child:const Padding(padding:EdgeInsets.symmetric(vertical:10),child:Text('Manage eligibility ▾')))],
 ]))),
 ]));
 }
}
