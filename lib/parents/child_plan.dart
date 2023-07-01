import 'package:flutter/material.dart';
import 'package:ravand/parents/parents_model.dart';
import 'package:ravand/theme.dart';
import 'package:timelines/timelines.dart';

class ChildPlan extends StatefulWidget {
  ChildPlan({super.key, required this.childEmail});
  String childEmail;
  @override
  State<ChildPlan> createState() => _ChildPlanState();
}

class _ChildPlanState extends State<ChildPlan> {
  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(title: const Text('برنامه امروز فرزند شما')),
        body: FutureBuilder(
            future: getChildPlans(widget.childEmail),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final List data = snapshot.data?.data;
                print('PLAN$data');
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
                if (data.isNotEmpty) {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
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
                                          numberToPersian(
                                              '${data[index]['from']}'
                                              ' تا '
                                              '${data[index]['to']}'),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data[index]['name'],
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
                                  itemCount: data.length,
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
      ),
    );
  }
}
