import 'package:choreapp_frontend/clients/group_client.dart';
import 'package:choreapp_frontend/models/group.dart';
import 'package:choreapp_frontend/models/user.dart';
import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  
  const GroupView({super.key});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  Future<List<User>>? usersList;
  
  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)?.settings.arguments as Group;
    GroupClient groupClient = GroupClient();
    usersList = groupClient.getGroupUsers(group.id!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () => {Navigator.pushReplacementNamed(context, "/home")} , icon: const Icon(Icons.keyboard_return, color: Colors.white )),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder<List<User>>(
            future: usersList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: SelectableText(
                        'Error loading users: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found'));
              } else {
                return Center(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        title: Text(user.name,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0))),
                        subtitle: Text(user.email!),
                        onTap: () {
                          
                        },
                      );
                    },
                  ),
                );
              }
            })
    );
  }
}