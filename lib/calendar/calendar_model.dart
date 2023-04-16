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
  return await Future.delayed(const Duration(milliseconds: 300), () {
    return [
      {
        "name": "روز قشنگ ۱",
        "items": [
          {"start": "10:00", "end": "12:00", "name": "خوندن درس عربی"},
          {"start": "12:00", "end": "13:25", "name": "خوندن درس ریاضی"},
          {"start": "13:25", "end": "14:00", "name": "ناهار خوردن"}
        ],
        "createdDate": DateTime.now().toIso8601String()
      },
      {
        "name": "روز قشنگ ۱",
        "items": [],
        "createdDate":
            DateTime.now().subtract(const Duration(days: 10)).toIso8601String()
      },
    ];
  });
}

Future generatePlan(Plan plan) async {}
