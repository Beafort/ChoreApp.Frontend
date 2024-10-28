import 'package:choreapp_frontend/clients/chore_client.dart';
import 'package:choreapp_frontend/clients/user_client.dart';
import 'package:choreapp_frontend/models/group.dart';

import 'chore.dart';

class User {
  final String? id;
  final String name;
  final String? email;
  final List<Chore>? chores;
  const User(
      {this.id, required this.name, this.email, this.chores});
  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'email': String email,
        
      } =>
        User(id: id, name: name, email: email),
      _ => throw const FormatException('Failed to load json')
    };
  }
  Future<List<Chore>> getChores(List<int> choreIds) async {
    List<Chore> returnList = [];
    ChoreClient choreClient = ChoreClient();
    for (var choreId in choreIds) {
      Chore chore = await choreClient.getChoreById(choreId);
      returnList.add(chore);
    }
    return returnList;
  }
  Future<List<Group>> getGroups() async {
    List<Group> returnList = [];
    UserClient userClient = UserClient();
    returnList = await userClient.getUserGroups();
    return returnList;
  }
}
