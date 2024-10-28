import 'package:choreapp_frontend/models/chore.dart';
import 'package:choreapp_frontend/models/user.dart';

class Group {
  final int? id;
  final String name;
  final List<Chore>? chores;
  final List<User>? users;
  const Group({this.id, required this.name, this.chores, this.users});
  factory Group.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
      } =>
        Group(id: id, name: name),
      _ => throw const FormatException('Failed to load json')
    };
  }
}
