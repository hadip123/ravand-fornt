import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Plan {
  String id;
  String name;
  List<PlanItem> items;

  Plan({required this.id, required this.name, required this.items});
}

class PlanItem {
  String startTime;
  String endTime;
  int minLen;
  int importance;

  PlanItem(
      {required this.startTime,
      required this.endTime,
      required this.minLen,
      required this.importance});

  static PlanItem fromJson(Map json) {
    return PlanItem(
        startTime: json['startTime'],
        endTime: json['endTime'],
        minLen: json['minLen'],
        importance: json['importance']);
  }

  static Map toJson(PlanItem item) {
    return {
      'startTime': item.startTime,
      'endTime': item.endTime,
      'minLen': item.minLen,
      'importance': item.importance
    };
  }
}

Future<List> getPlans() async {
  final shared = await SharedPreferences.getInstance();
  return jsonDecode(shared.getString('plans') ?? '[]');
}