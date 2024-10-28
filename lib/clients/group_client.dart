import 'dart:convert';

import 'package:choreapp_frontend/models/chore.dart';
import 'package:choreapp_frontend/models/group.dart';
import 'package:choreapp_frontend/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

class GroupClient {
  static const baseUrl = "http://localhost:5270/groups";
  Future<Group> getGroupById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return Group.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('There are no group with id of $id');
    }
  }
  Future<List<User>> getGroupUsers(int id) async{
    String? key = await storage.read(key: "accessToken");
    final response = await http.get(
          Uri.parse("$baseUrl/$id/users"),
          headers: <String, String>{
            'Authorization': 'Bearer $key',
            }
          );
    if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => User.fromJson(json)).toList();
    }
    else{return [];}
  }
  Future<List<Chore>> getGroupChoreByDateOnly(
      DateTime date, int? groupId) async {
    print(groupId);
    String? key = await storage.read(key: "accessToken");
    try {
      int year = date.year;
      int month = date.month;
      int day = date.day;
      final response = await http.get(
          Uri.parse("$baseUrl/$groupId/$year-$month-$day"),
          headers: <String, String>{
            'Authorization': 'Bearer $key',
          });
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Chore.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Failed to load chores for date $year-$month-$day: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching chores by date: $e');
    }
  }

  Future<http.Response> postGroup(Group group) async {
    String? key = await storage.read(key: "accessToken");
    return http.post(Uri.parse(baseUrl),
        headers: <String, String>{
          "Authorization": "Bearer $key",
          "content-type": "application/json",
        },
        body: jsonEncode(
          <String, String>{
            'name': group.name,
          },
        )
      );
  }
  Future<http.Response> addUser(Group group, String email) async {
    String? key = await storage.read(key: "accessToken");
    return http.put(Uri.parse("$baseUrl/${group.id}/users"),
        headers: <String, String>{
          "Authorization": "Bearer $key",
          "content-type": "application/json",
        },
        body: jsonEncode(
          <String, String>{
            'name': group.name,
          },
        )
      );
  }
}
