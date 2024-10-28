import 'package:choreapp_frontend/clients/user_client.dart';
import 'package:choreapp_frontend/models/group.dart';
import 'package:choreapp_frontend/widgets/group_form.dart';
import 'package:flutter/material.dart';
class GroupSelect extends StatefulWidget {
  const GroupSelect({super.key});

  @override
  State<GroupSelect> createState() => _GroupSelectState();
}

class _GroupSelectState extends State<GroupSelect> {
  Future<List<Group>>? groupsList;
  Future<void> _refresh() async {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final groupClient = UserClient();
    groupsList = groupClient.getUserGroups();
    return Scaffold(
        floatingActionButton: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => GroupForm(
                  onSave: _refresh,
                ),
              );
            },
            child: const Text("Create New Group")),
        body: FutureBuilder<List<Group>>(
            future: groupsList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: SelectableText(
                        'Error loading chores: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No chores found'));
              } else {
                return Center(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final group = snapshot.data![index];
                      return ListTile(
                        title: Text(group.name,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0))),
                        onTap: () {
                          chooseGroup(group.id);
                        },
                      );
                    },
                  ),
                );
              }
            }));
  }

  void chooseGroup(int? id) async {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home',
        arguments: id); //and change the groupId variable of the home to be id
  }

  void createGroup() async {
    if (!mounted) return;
  }
}
