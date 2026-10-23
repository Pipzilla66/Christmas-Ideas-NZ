import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail = '', required this.sendReset});
  final String initialEmail;
  final Future<void> Function(String) sendReset;
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final email = TextEditingController(text: widget.initialEmail);
  bool busy = false;
  bool sent = false;
  String? error;
  @override
  void dispose() { email.dispose(); super.dispose(); }
  Future<void> send() async {
    final address = email.text.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(address)) {
      setState(() => error = 'Enter a valid email address.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      await widget.sendReset(address);
      if (mounted) setState(() => sent = true);
    } catch (_) {
      if (mounted) setState(() => error = 'Could not request a reset email. Please wait a moment and try again.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reset password')),
    body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Enter the email address you used for your Christmas Ideas NZ account.'),
        const SizedBox(height: 20),
        TextField(controller: email, enabled: !busy && !sent, keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email], decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 16),
        if (sent) const Text('If an account uses this address, you’ll receive a password reset link. Check your inbox and junk folder, then open the link to choose a new password.')
        else FilledButton(onPressed: busy ? null : send, child: Text(busy ? 'Sending…' : 'Send reset link')),
        if (error != null) Padding(padding: const EdgeInsets.only(top: 16), child: Text(error!)),
      ]),
    ))),
  );
}
