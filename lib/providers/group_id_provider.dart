import 'package:flutter/material.dart';

class GroupIdProvider with ChangeNotifier {
  String? _groupId;

  String? get groupId => _groupId;

  set groupId(String? value) {
    _groupId = value;
    notifyListeners();
  }
}