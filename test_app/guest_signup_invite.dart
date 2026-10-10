import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestSignupInvite extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final bool Function() isSignedIn;
  final Future<void> Function() onSignUp;
  const GuestSignupInvite({super.key, required this.child, required this.isSignedIn, required this.onSignUp, this.enabled = true});
  @override State<GuestSignupInvite> createState() => _GuestSignupInviteState();
}
class _GuestSignupInviteState extends State<GuestSignupInvite> {
  Timer? timer;
  static const preferenceKey = 'guest_signup_invite_at';
  @override void initState() { super.initState(); timer = Timer(const Duration(seconds: 30), invite); }
  @override void dispose() { timer?.cancel(); super.dispose(); }
  Future<void> invite() async {
    if (!mounted || widget.isSignedIn()) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (!widget.enabled || ModalRoute.of(context)?.isCurrent != true || (lifecycle != null && lifecycle != AppLifecycleState.resumed)) {
      timer = Timer(const Duration(seconds: 5), invite);
      return;
    }
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      final last = prefs.getInt(preferenceKey);
      if (last != null && DateTime.now().millisecondsSinceEpoch - last < const Duration(hours: 24).inMilliseconds) return;
      if (!mounted || widget.isSignedIn()) return;

    } catch (_) { /* A storage error must not interrupt browsing. */ }
    if (!mounted || widget.isSignedIn()) return;
    // A route or account form may have opened while preferences were loading.
    if (!widget.enabled || ModalRoute.of(context)?.isCurrent != true) {
      timer = Timer(const Duration(seconds: 5), invite);
      return;
    }
    final dialog = showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Enjoying the Christmas ideas?'),
      content: const Text('Sign up free to save your favourites, build Christmas boards and share your finds.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep browsing')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sign up free')),
      ],
    ));
    try { await prefs?.setInt(preferenceKey, DateTime.now().millisecondsSinceEpoch); } catch (_) {}
    final signUp = await dialog;
    if (mounted && signUp == true && !widget.isSignedIn()) await widget.onSignUp();
  }
  @override Widget build(BuildContext context) => widget.child;
}
