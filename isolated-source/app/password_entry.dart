import 'package:flutter/material.dart';
class PasswordEntry extends StatefulWidget {
 final TextEditingController controller;final bool enabled;final String label;final String? helperText;
 const PasswordEntry({super.key,required this.controller,this.enabled=true,this.label='Password',this.helperText});
 @override State<PasswordEntry> createState()=>_PasswordEntryState();
}
class _PasswordEntryState extends State<PasswordEntry>{
 bool visible=false;
 @override Widget build(BuildContext context)=>TextField(controller:widget.controller,enabled:widget.enabled,obscureText:!visible,autocorrect:false,enableSuggestions:false,decoration:InputDecoration(labelText:widget.label,helperText:widget.helperText,suffixIcon:IconButton(tooltip:'${visible?'Hide':'Show'} ${widget.label.toLowerCase()}',onPressed:widget.enabled?()=>setState(()=>visible=!visible):null,icon:Icon(visible?Icons.visibility_off_outlined:Icons.visibility_outlined))));
}
