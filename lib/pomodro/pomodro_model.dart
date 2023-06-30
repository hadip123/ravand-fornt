import 'package:ravand/calendar/calendar_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future getNow() async {
  final instance = await SharedPreferences.getInstance();

  final List data = await getPlans();

  DateTime currentTime = DateTime.now();
  data.sort((a, b) {
    return DateTime.parse(a['createdAt'])
        .compareTo(DateTime.parse(b['createdAt']));
  });
  final d = data[data.length - 1];
  List<dynamic> items = d["items"];

  for (int i = 0; i < items.length; i++) {
    Map<String, dynamic> item = items[i];
    DateTime start = parseTime(item["from"]);
    DateTime end = parseTime(item["to"]);
    if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
      return '${item['name']} - از ${item['from']} تا ${item['to']}';
    }
  }
}

DateTime parseTime(String timeString) {
  List<String> parts = timeString.split(":");
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);
  return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
      hour, minute);
}
