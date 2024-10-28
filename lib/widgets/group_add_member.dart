import 'package:choreapp_frontend/clients/group_client.dart';
import 'package:flutter/material.dart';

class GroupAddMember extends StatefulWidget {
  final VoidCallback onSave;
  const GroupAddMember({super.key, required this.onSave});

  @override
  State<GroupAddMember> createState() => _GroupAddMemberState();
}

class _GroupAddMemberState extends State<GroupAddMember> {
  final _emailController = TextEditingController();
  final groupCLient = GroupClient();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add User"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          )
        ],
      ),
      actions: [
        ElevatedButton(onPressed: _submitForm, child: const Text("Send Invite!"))
      ],
    );
  }

  void _submitForm() async {
    final email = _emailController.text;
    
    
    widget.onSave.call();
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}