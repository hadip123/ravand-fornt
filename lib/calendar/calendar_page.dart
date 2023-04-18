import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:taskify/calendar/calendar_model.dart';
import 'package:taskify/generatePlan/generatePlan_page.dart';
import 'package:taskify/theme.dart';
import 'package:timelines/timelines.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
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

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => const GeneratePlan()));

          print(result);
        },
        label: const Text('ساخت برنامه'),
        icon: const Icon(Icons.create_sharp),
        backgroundColor: darkNord2,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getPlans(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final List data = snapshot.data!;
              print(data);
              if (data.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bubble_chart,
                        size: 100,
                        color: darkNord3,
                      ),
                      Text(
                        'پلن وجود ندارد... بسازید!',
                        style: TextStyle(fontSize: 20, color: darkNord3),
                      )
                    ],
                  ),
                );
              }
              data.sort((a, b) {
                return DateTime.parse(a['createdAt'])
                    .compareTo(DateTime.parse(b['createdAt']));
              });
              final d = data[data.length - 1];
              final date = DateTime.parse(data[data.length - 1]['createdAt']);
              Jalali jl = Jalali.fromGregorian(date.toGregorian());
              if (data.isNotEmpty) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        numberToPersian(
                            'برنامه ${jl.year}/${jl.month}/${jl.day}'),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            FixedTimeline.tileBuilder(
                              theme: TimelineThemeData(
                                  color: darkNord3,
                                  indicatorPosition: 0.4,
                                  indicatorTheme:
                                      const IndicatorThemeData(size: 30)),
                              builder: TimelineTileBuilder.connectedFromStyle(
                                contentsAlign: ContentsAlign.alternating,
                                oppositeContentsBuilder: (context, index) =>
                                    Padding(
                                  padding: const EdgeInsets.all(19.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        numberToPersian(d['items'][index]
                                                ['from'] +
                                            ' تا ' +
                                            d['items'][index]['to']),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        d['items'][index]['name'],
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                ),
                                connectorStyleBuilder: (context, index) =>
                                    ConnectorStyle.dashedLine,
                                indicatorStyleBuilder: (context, index) =>
                                    IndicatorStyle.dot,
                                itemCount: d['items'].length,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            if (snapshot.hasError) {}
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
