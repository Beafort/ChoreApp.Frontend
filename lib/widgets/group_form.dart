import 'package:choreapp_frontend/clients/group_client.dart';
import 'package:choreapp_frontend/models/group.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GroupForm extends StatefulWidget {
  final VoidCallback onSave;
  const GroupForm({super.key, required this.onSave});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _nameController = TextEditingController();
  final groupCLient = GroupClient();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create new Group"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          )
        ],
      ),
      actions: [
        ElevatedButton(onPressed: _submitForm, child: const Text("Save"))
      ],
    );
  }

  void _submitForm() async {
    final name = _nameController.text;
    Group group = Group(name: name);
    Response response;
    try {
      response = await groupCLient.postGroup(group);
    } catch (e) {
      print(e);
    }
    widget.onSave.call();
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
