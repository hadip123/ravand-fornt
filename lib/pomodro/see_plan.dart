import 'package:flutter/material.dart';
import 'package:ravand/calendar/calendar_page.dart';
import 'package:ravand/pomodro/pomodro_model.dart';
import 'package:ravand/theme.dart';

class SeePlan extends StatefulWidget {
  const SeePlan({super.key});

  @override
  State<SeePlan> createState() => _SeePlanState();
}

class _SeePlanState extends State<SeePlan> {
  String nowWork = '';
  @override
  void initState() {
    super.initState();
    getNow().then((value) => setState(() => nowWork = value));
  }

  String numberToPersian(String text) {
    var listStr = text.split('');
    var result = '';
    var numbers = {
      "0": "۰",
      "1": "۱",
      "2": "۲",
      "3": "۳",
      "4": "۴",
      "5": "۵",
      "6": "۶",
      "7": "۷",
      "8": "۸",
      "9": "۹"
    };

    for (final s in listStr) {
      if (numbers.keys.contains(s)) {
        result = '$result${numbers[s]}';
        continue;
      }
      result = '$result$s';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('برنامه'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'الان چه کاری باید انجام بدی؟',
                style:
                    TextStyle(fontWeight: FontWeight.w900, color: Colors.grey),
              ),
              Text(
                numberToPersian(nowWork),
                style: const TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: darkNord4),
              ),
              Expanded(child: Calendar(inSeePlan: true))
            ],
          ),
        ),
      ),
    );
  }
}
