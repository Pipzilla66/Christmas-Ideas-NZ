import 'package:flutter/material.dart';
import '../data/app_repository.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signUp = false;
  bool _busy = false;
  String? _message;

  Future<void> _submit() async {
    setState(() { _busy = true; _message = null; });
    try {
      if (_signUp) {
        final res = await AppRepository.instance.signUp(email: _email.text.trim(), password: _password.text, displayName: _name.text.trim());
        if (res.session == null) {
          _message = 'Account created. Check your email if Supabase asks you to confirm it, then sign in.';
        } else {
          if (mounted) Navigator.pop(context, true);
        }
      } else {
        await AppRepository.instance.signIn(email: _email.text.trim(), password: _password.text);
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      _message = e.toString().replaceFirst('AuthException(message: ', '').replaceAll(', statusCode: 400, code: invalid_credentials)', '');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_signUp ? 'Create your account' : 'Sign in')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(_signUp ? 'Save boards, submit Christmas finds and keep your lists across devices.' : 'Welcome back 🎄', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 18),
          if (_signUp) ...[
            TextField(controller: _name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
          ],
          TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', helperText: 'Use at least 8 characters.')),
          if (_message != null) Padding(padding: const EdgeInsets.only(top: 14), child: Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 20),
          FilledButton(onPressed: _busy ? null : _submit, child: Padding(padding: const EdgeInsets.symmetric(vertical: 13), child: Text(_busy ? 'Please wait…' : (_signUp ? 'Create account' : 'Sign in')))),
          const SizedBox(height: 8),
          TextButton(onPressed: _busy ? null : () => setState(() => _signUp = !_signUp), child: Text(_signUp ? 'Already have an account? Sign in' : 'New here? Create an account')),
        ],
      ),
    );
  }
}
