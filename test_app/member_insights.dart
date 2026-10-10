import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'analytics.dart';

bool _recording = false;
Future<void> recordMemberVisit() async {
  if (_recording || !memberUsageAllowed() || Supabase.instance.client.auth.currentUser == null) return;
  _recording = true;
  try { await Supabase.instance.client.rpc('record_member_visit'); } catch (_) {
    // Statistics must not interrupt browsing.
  } finally { _recording = false; }
}
String notificationDate(Object? raw) {
  final d = DateTime.tryParse('$raw')?.toLocal();
  if (d == null) return '';
  return '${d.day}/${d.month}/${d.year}';
}
class MemberNotificationTile extends StatefulWidget {
  const MemberNotificationTile({super.key});
  @override State<MemberNotificationTile> createState() => _MemberNotificationTileState();
}
class _MemberNotificationTileState extends State<MemberNotificationTile> {
  int? unread;
  Timer? timer;
  bool loading = false;
  Future<void> refresh() async {
    if (loading) return;
    loading = true;
    try {
      final u = Supabase.instance.client.auth.currentUser;
      if (u == null) return;
      final rows = await Supabase.instance.client.from('member_notifications').select('id').eq('user_id', u.id).isFilter('read_at', null);
      if (mounted) setState(() => unread = rows.length);
    } catch (_) {} finally { loading = false; }
  }
  @override void initState() { super.initState(); refresh(); timer = Timer.periodic(const Duration(seconds: 30), (_) => refresh()); }
  @override void dispose() { timer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) => Card(child: ListTile(
    leading: const Icon(Icons.notifications_outlined), title: const Text('Notifications'),
    subtitle: Text(unread == null ? 'Account confirmation and submission outcomes' : unread == 0 ? 'You’re all caught up' : '$unread unread ${unread == 1 ? 'notification' : 'notifications'}'),
    trailing: const Icon(Icons.chevron_right),
    onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberNotificationsPage())); refresh(); },
  ));
}
class MemberNotificationsPage extends StatefulWidget {
  const MemberNotificationsPage({super.key});
  @override State<MemberNotificationsPage> createState() => _MemberNotificationsPageState();
}
class _MemberNotificationsPageState extends State<MemberNotificationsPage> {
  late Future<List<Map<String,dynamic>>> inbox;
  Future<List<Map<String,dynamic>>> load() async {
    final u = Supabase.instance.client.auth.currentUser;
    if (u == null) throw StateError('Sign in required');
    return List<Map<String,dynamic>>.from(await Supabase.instance.client.from('member_notifications').select('id,title,body,kind,created_at,read_at').eq('user_id',u.id).order('created_at',ascending:false));
  }
  @override void initState() { super.initState(); inbox = load(); }
  void refresh() => setState(() => inbox = load());
  Future<void> markRead(Map<String,dynamic> n) async {
    try {
      await Supabase.instance.client.from('member_notifications').update({'read_at':DateTime.now().toUtc().toIso8601String()}).eq('id',n['id']);
      if (mounted) refresh();
    } catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not mark as read. Please try again.'))); }
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notifications'),actions:[IconButton(onPressed:refresh,tooltip:'Refresh',icon:const Icon(Icons.refresh))]),
    body: FutureBuilder<List<Map<String,dynamic>>>(future:inbox,builder:(context,snap) {
      if (snap.hasError) return Center(child: TextButton(onPressed:refresh,child:const Text('Could not load notifications. Tap to retry.')));
      if (!snap.hasData) return const Center(child:CircularProgressIndicator());
      final rows=snap.data!;
      return RefreshIndicator(onRefresh:() async { refresh(); await inbox; },child:ListView(padding:const EdgeInsets.all(18),physics:const AlwaysScrollableScrollPhysics(),children:[
        const Text('Your account confirmation and submission outcomes appear here. These are in-app notifications.'),
        const SizedBox(height:12),
        if (rows.isEmpty) const Text('No notifications yet.'),
        for (final n in rows) Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[Icon(n['kind']=='approved'?Icons.check_circle_outline:n['kind']=='rejected'?Icons.info_outline:Icons.person_outline),const SizedBox(width:8),Expanded(child:Text('${n['title']}',style:TextStyle(fontWeight:n['read_at']==null?FontWeight.w900:FontWeight.w600)))]),
          const SizedBox(height:8),Text('${n['body']}'),const SizedBox(height:8),Text(notificationDate(n['created_at']),style:Theme.of(context).textTheme.bodySmall),
          if(n['read_at']==null) TextButton(onPressed:()=>markRead(n),child:const Text('Mark as read')),
        ]))),
      ]));
    }),
  );
}
class MemberStatisticsPage extends StatefulWidget {
  final Future<Map<String,dynamic>> Function()? loader;
  const MemberStatisticsPage({super.key, this.loader});
  @override State<MemberStatisticsPage> createState()=>_MemberStatisticsPageState();
}
class _MemberStatisticsPageState extends State<MemberStatisticsPage> {
  late Future<Map<String,dynamic>> stats;
  Future<Map<String,dynamic>> load() async => widget.loader != null ? await widget.loader!() : Map<String,dynamic>.from(await Supabase.instance.client.rpc('member_usage_statistics') as Map);
  @override void initState(){super.initState();stats=load();}
  void refresh()=>setState(()=>stats=load());
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Account & usage statistics'),actions:[IconButton(onPressed:refresh,tooltip:'Refresh',icon:const Icon(Icons.refresh))]),
    body:FutureBuilder<Map<String,dynamic>>(future:stats,builder:(context,snap){
      if(snap.hasError)return Center(child:TextButton(onPressed:refresh,child:const Text('Admin access is required. If you are signed in as admin, tap to retry.')));
      if(!snap.hasData)return const Center(child:CircularProgressIndicator());
      final data=snap.data!;final daily=List<Map<String,dynamic>>.from(data['Daily activity'] as List? ?? []);
      return RefreshIndicator(onRefresh:() async {refresh();await stats;},child:ListView(padding:const EdgeInsets.all(18),physics:const AlwaysScrollableScrollPhysics(),children:[
        const Text('Live account totals',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        for(final key in ['Accounts','Admins / editors','Members','New members today','New members (7 days)','Member boards','Member saved items','Member submissions']) ListTile(title:Text(key),trailing:Text('${data[key] ?? 0}',style:const TextStyle(fontWeight:FontWeight.bold))),
        const Divider(),const Text('Member usage',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        const Text('Usage counts signed-in members who allow analytics, while the app is visible. Admins and guests are excluded. A new visit starts after 30 minutes away. Dates use New Zealand time. Returning members visited on at least two different days; average active days covers tracked members.'),
        const SizedBox(height:8),Text(data['Tracking started']==null?'No visits recorded yet. Tracking starts with this update.':'First recorded activity: ${data['Tracking started']}. Earlier visits are unavailable.'),
        for(final key in ['Active members today','Active members (7 days)','Active members (30 days)','Returning members (30 days)','Visits (30 days)','Average active days (30 days)']) ListTile(title:Text(key),trailing:Text('${data[key] ?? 0}',style:const TextStyle(fontWeight:FontWeight.bold))),
        const Divider(),const Text('Daily activity (last 30 days)',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        if(daily.isEmpty)const Padding(padding:EdgeInsets.all(12),child:Text('Activity will appear as members use the app.')),
        for(final day in daily) ListTile(title:Text('${day['day']}'),subtitle:Text('${day['active_members']} active members'),trailing:Text('${day['visits']} visits')),
      ]));
    }),
  );
}
