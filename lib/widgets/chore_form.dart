import 'dart:async';

import 'package:choreapp_frontend/clients/chore_client.dart';
import 'package:choreapp_frontend/models/chore.dart';
import 'package:choreapp_frontend/models/group.dart';
import 'package:choreapp_frontend/models/user.dart';
import 'package:choreapp_frontend/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatTime(TimeOfDay time) {
  final hour = time.hour.toString();
  final minute = time.minute.toString();
  return '$hour:$minute';
}

class ChoreFormPopup extends StatefulWidget {
  final VoidCallback onSave;
  final Chore? chore;
  final DateTime? selectedDay;
  final Group group;
  const ChoreFormPopup({
    super.key,
    this.chore,
    required this.selectedDay,
    required this.onSave,
    required this.group,
  });
  @override
  ChoreFormPopupState createState() => ChoreFormPopupState();
}

class ChoreFormPopupState extends State<ChoreFormPopup> {
  final _nameController = TextEditingController();
  late DateTime date;
  late String dateString = "";
  late bool done;
  late List<User> users = [];
  User? selectedUser;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    _initialize();
  }
  Future<void> _initialize() async {
    if (widget.chore != null) {
      _nameController.text = widget.chore!.name;
      done = widget.chore!.done;
    } else {
      done = false;
    }

    date = widget.selectedDay!;
    users = await groupClient.getGroupUsers(widget.group.id!); // Await the user retrieval

    _selectedTime = TimeOfDay(hour: date.hour, minute: date.minute);
    dateString = formatDate(date);
    setState(() {
      
    });
  }
  Future<void> _submitForm(ChoreClient choreClient) async {
    final name = _nameController.text;
    DateTime submitDate = DateTime(date.year, date.month, date.day,
        _selectedTime.hour, _selectedTime.minute);
    Chore chore = Chore(
        name: name, deadline: submitDate, done: done, id: widget.chore?.id, groupId: widget.group.id,);
    Response response;

    try {
      if (widget.chore == null) {
        response = await choreClient.postChore(chore, widget.group.id);
      } else {
        response = await choreClient.putChore(chore, selectedUser);
      }
      print(response.body);
      if (response.statusCode == 200 && response.statusCode == 204) {
        print(response.body);
      } else {}
    } catch (e) {
      print(e);
    }
    widget.onSave.call();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _commitDelete(ChoreClient client) async {
    await client.deleteChore(widget.chore!);
    widget.onSave.call();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final choreClient = Provider.of<ChoreClient>(context);
    List<DropdownMenuEntry<User>> dropdownMenuEntries = users.map((user) {
      return DropdownMenuEntry<User>(
        value: user, // Assign the User object as the value
        label: user.name, // Display the User name as the label (or any property you want)
      );
    }).toList(); // Convert the Iterable to a List
    return AlertDialog(
      title: Text(widget.chore == null ? 'Create Chore' : 'Edit Chore'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('New chore on: $dateString'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  formatTime(_selectedTime),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: const Text('Select Time'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Status'),
              const Spacer(), // Pushes the Switch to the right
              Switch(
                value: done,
                onChanged: (bool value) {
                  setState(() {
                    done = value;
                  });
                },
              ),
            ],
          ),
          Row(children: [
            const Text("Assign member!"),
            const Spacer(),
            DropdownMenu(
            dropdownMenuEntries: dropdownMenuEntries,
            label: const Text("User"),
            onSelected: (User? user){
              setState(() {
                selectedUser = user;
                
              });
            },
            ),
          ],)
          
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            if (widget.chore != null)
              TextButton(
                onPressed: () => _commitDelete(choreClient),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red, // Set the text color to red
                ),
                child: const Text('Delete'),
              ),
            const Spacer(), // Pushes the "Cancel" and "Save" buttons to the right
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              onPressed: () => _submitForm(choreClient),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
