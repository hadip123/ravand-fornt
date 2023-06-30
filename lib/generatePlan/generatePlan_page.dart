import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ravand/calendar/calendar_page.dart';
import 'package:ravand/generatePlan/generatePlan_model.dart';
import 'package:ravand/theme.dart';
import 'package:time_range/time_range.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class GeneratePlan extends StatefulWidget {
  const GeneratePlan({super.key});

  @override
  State<GeneratePlan> createState() => _GeneratePlanState();
}

class _GeneratePlanState extends State<GeneratePlan> {
  List<Map> data = [];
  List blockedTimes = [];
  List tasks = [];
  String startTime = '';
  String endTime = '';

  final _taskNameCont = TextEditingController();
  int? importance;
  int? minLen;

  bool isBlockOpen = false;
  bool isTasksOpen = false;
  TimeRangeResult? timeRangeResult;
  TimeRangeResult? timeSettingsResult;

  TextEditingController nameController = TextEditingController();

  createTime(TimeOfDay time) {
    String hour = '00';
    String minute = '00';
    String givenHour = time.hour.toString();
    String givenMinute = time.minute.toString();
    if (givenHour.length == 1) {
      hour = '0$givenHour';
    } else {
      hour = givenHour;
    }
    if (givenMinute.length == 1) {
      minute = '0$givenMinute';
    } else {
      minute = givenMinute;
    }
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: darkNord2,
            foregroundColor: Colors.white,
            onPressed: () async {
              for (final task in tasks) {
                print(task);
                task['imp'] = task['importance'];
                task['min'] = task['minLen'];
                task['score'] = null;
              }
              for (final bt in blockedTimes) {
                bt['start'] = createTime(TimeOfDay(
                    hour: int.parse(bt['start'].split(':')[0]),
                    minute: int.parse(bt['start'].split(':')[1])));
                bt['end'] = createTime(TimeOfDay(
                    hour: int.parse(bt['end'].split(':')[0]),
                    minute: int.parse(bt['end'].split(':')[1])));
              }
              try {
                print(jsonEncode({
                  'blocked': blockedTimes,
                  'tasks': tasks,
                  'start': createTime(timeSettingsResult!.start),
                  'end': createTime(timeSettingsResult!.end),
                }));
                final res = await generatePlan({
                  'blocked': blockedTimes,
                  'tasks': tasks,
                  'loop': false,
                  'start': createTime(timeSettingsResult!.start),
                  'end': createTime(timeSettingsResult!.end),
                });
                final instance = await SharedPreferences.getInstance();
                await instance.setString(
                    'plans',
                    jsonEncode([
                      {
                        'createdAt': DateTime.now().toIso8601String(),
                        "items": res.data
                      },
                      ...jsonDecode(instance.getString('plans') ?? '[]')
                    ]));

                Navigator.pop(context, true);
              } on DioError catch (e) {
                print(e.response?.data);
                if (e.response!.statusCode == 400) {}
                if (e.response!.statusCode == 500) {
                  SnackBar snackBar = const SnackBar(
                      content: Text(
                          'خطای سرور، شاید بلاک تایم را باید از ۱ دونه بیشتر کنید'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {});
                  return;
                }
              }
            },
            child: const Icon(Icons.create),
          ),
          appBar: AppBar(title: const Text('ساخت برنامه')),
          body: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: lightNord4,
                    child: Icon(Icons.block)),
                trailing: const Icon(Icons.plus_one),
                onTap: () {
                  setState(() {
                    isBlockOpen = !isBlockOpen;
                  });
                },
                title: const Text('اضافه کردن زمان بلاک شده'),
                subtitle: const Text(
                    'زمانی را که میخواهید از آن در برنامه استفاده نشود اینجا اضافه کنید'),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: isBlockOpen ? 390 : 0,
                child: isBlockOpen
                    ? Column(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: size.width * .9,
                                child: ListView(
                                  children: blockedTimes
                                      .map((e) => ListTile(
                                            title: Text(e['name']),
                                            leading: const CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundColor: darkNord1,
                                                child: Icon(Icons.timelapse)),
                                            iconColor: darkNord3,
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                final int index =
                                                    blockedTimes.indexOf(e);
                                                setState(() {
                                                  blockedTimes.removeAt(index);
                                                });
                                              },
                                            ),
                                            subtitle: Text(numberToPersian(
                                                '${e['start']} تا ${e['end']}')),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ElevatedButton(
                                onPressed: () {
                                  AlertDialog dialog = AlertDialog(
                                    title:
                                        const Text('اضافه کردن زمان بلاک شده'),
                                    content: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            width: 400,
                                            child: TimeRange(
                                              fromTitle: const Text(
                                                'از',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: darkNord1),
                                              ),
                                              toTitle: const Text(
                                                'تا',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: darkNord3),
                                              ),
                                              titlePadding: 20,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black87),
                                              activeTextStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              borderColor: darkNord2,
                                              initialRange: timeRangeResult,
                                              backgroundColor:
                                                  Colors.transparent,
                                              activeBackgroundColor: darkNord4,
                                              firstTime: const TimeOfDay(
                                                  hour: 00, minute: 00),
                                              lastTime: const TimeOfDay(
                                                  hour: 23, minute: 59),
                                              timeStep: 10,
                                              timeBlock: 15,
                                              onFirstTimeSelected: (time) {
                                                final thisTimeDate = DateTime(
                                                    2000,
                                                    10,
                                                    2,
                                                    time.hour,
                                                    time.minute);
                                                for (final a in blockedTimes) {
                                                  final timeA = TimeOfDay(
                                                      hour: int.parse(a['start']
                                                          .split(':')[0]),
                                                      minute: int.parse(
                                                          a['start']
                                                              .split(':')[1]));
                                                  final timeB = TimeOfDay(
                                                      hour: int.parse(a['end']
                                                          .split(':')[0]),
                                                      minute: int.parse(a['end']
                                                          .split(':')[1]));
                                                  if (time.hour >= timeA.hour &&
                                                      time.hour <= timeB.hour &&
                                                      time.minute >=
                                                          timeA.minute &&
                                                      time.minute <=
                                                          timeB.minute) {
                                                    SnackBar snackBar =
                                                        const SnackBar(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                            content: Text(
                                                                'شما قبلا این تایم را بلاک کرده اید'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    setState(() {});
                                                    return;
                                                  }
                                                }
                                              },
                                              onRangeCompleted: (range) {
                                                final thisTimeDate = DateTime(
                                                    2000,
                                                    10,
                                                    2,
                                                    range!.start.hour,
                                                    range.start.minute);
                                                for (final a in blockedTimes) {
                                                  final timeA = TimeOfDay(
                                                      hour: int.parse(a['start']
                                                          .split(':')[0]),
                                                      minute: int.parse(
                                                          a['start']
                                                              .split(':')[1]));
                                                  final timeB = TimeOfDay(
                                                      hour: int.parse(a['end']
                                                          .split(':')[0]),
                                                      minute: int.parse(a['end']
                                                          .split(':')[1]));
                                                  if (range.start.hour >=
                                                          timeA.hour &&
                                                      range.start.hour <=
                                                          timeB.hour &&
                                                      range.start.minute >=
                                                          timeA.minute &&
                                                      range.start.minute <=
                                                          timeB.minute) {
                                                    SnackBar snackBar =
                                                        const SnackBar(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                            content: Text(
                                                                'شما قبلا این تایم را بلاک کرده اید'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    setState(() {});
                                                    return;
                                                  }
                                                }
                                                setState(() => setState(() {
                                                      timeRangeResult = range;
                                                    }));
                                              },
                                            ),
                                          ),
                                          const Text('نام زمان بلاک شده'),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              controller: nameController,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(400, 40)),
                                              onPressed: () {
                                                final thisTimeDate = DateTime(
                                                    2000,
                                                    10,
                                                    2,
                                                    timeRangeResult!.start.hour,
                                                    timeRangeResult!
                                                        .start.minute);
                                                for (final a in blockedTimes) {
                                                  final timeA = TimeOfDay(
                                                      hour: int.parse(a['start']
                                                          .split(':')[0]),
                                                      minute: int.parse(
                                                          a['start']
                                                              .split(':')[1]));
                                                  final timeB = TimeOfDay(
                                                      hour: int.parse(a['end']
                                                          .split(':')[0]),
                                                      minute: int.parse(a['end']
                                                          .split(':')[1]));
                                                  if (timeRangeResult!
                                                              .start.hour >=
                                                          timeA.hour &&
                                                      timeRangeResult!
                                                              .start.hour <=
                                                          timeB.hour) {
                                                    if (timeRangeResult!
                                                                .start.minute >
                                                            timeA.minute &&
                                                        timeRangeResult!
                                                                .start.minute <
                                                            timeB.minute) {
                                                      SnackBar snackBar =
                                                          const SnackBar(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              content: Text(
                                                                  'شما قبلا این تایم را بلاک کرده اید'));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      return;
                                                    }
                                                  }
                                                }
                                                setState(() {
                                                  if (timeRangeResult == null ||
                                                      nameController.text ==
                                                          '') {
                                                    return;
                                                  }
                                                  Map data = {
                                                    'name': nameController.text,
                                                    'start':
                                                        '${timeRangeResult!.start.hour}:${timeRangeResult!.start.minute}',
                                                    'end':
                                                        '${timeRangeResult!.end.hour}:${timeRangeResult!.end.minute}'
                                                  };
                                                  print(data);
                                                  blockedTimes.add(data);
                                                  setState(() {
                                                    nameController.text = '';
                                                    timeRangeResult = null;
                                                  });

                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text('اضافه کردن'))
                                        ],
                                      ),
                                    ),
                                  );

                                  showDialog(
                                      context: context, builder: (_) => dialog);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text('اضافه کردن'),
                                  ],
                                )),
                          )
                        ],
                      )
                    : null,
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: lightNord4,
                    child: Icon(Icons.task)),
                onTap: () {
                  setState(() {
                    isTasksOpen = !isTasksOpen;
                  });
                },
                trailing: const Icon(Icons.plus_one),
                title: const Text('اضافه کردن تسک'),
                subtitle: const Text(
                    'کارهایی را که باید انجام دهید را اینجا اضافه کنید'),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: isTasksOpen ? 390 : 0,
                child: isTasksOpen
                    ? Column(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: size.width * .9,
                                child: ListView(
                                  children: tasks
                                      .map((e) => ListTile(
                                            title: Text(e['name']),
                                            leading: const CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundColor: darkNord1,
                                                child: Icon(Icons.timelapse)),
                                            iconColor: darkNord3,
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                final int index =
                                                    tasks.indexOf(e);
                                                setState(() {
                                                  tasks.removeAt(index);
                                                });
                                              },
                                            ),
                                            subtitle: Text(numberToPersian(
                                                'حداقل زمان مورد نیاز: ${e['minLen']}\nمیزان اهمیت از ۲۰: ${e['importance']}')),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ElevatedButton(
                                onPressed: () {
                                  AlertDialog dialog = AlertDialog(
                                    title: const Text('اضافه کردن تسک'),
                                    content: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('میزان اهمیت'),
                                              const Spacer(),
                                              SizedBox(
                                                  height: 40,
                                                  width: 100,
                                                  child: WheelChooser.integer(
                                                      onValueChanged: (value) {
                                                        setState(() {
                                                          importance = value;
                                                        });
                                                      },
                                                      maxValue: 20,
                                                      horizontal: true,
                                                      minValue: 1)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text('مورد نیاز (دقیقه)'),
                                              const Spacer(),
                                              SizedBox(
                                                  height: 40,
                                                  width: 100,
                                                  child: WheelChooser.integer(
                                                      onValueChanged: (value) {
                                                        setState(() {
                                                          minLen = value;
                                                        });
                                                      },
                                                      maxValue: 900,
                                                      step: 10,
                                                      horizontal: true,
                                                      minValue: 0)),
                                            ],
                                          ),
                                          const Text('نام تسک'),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              controller: nameController,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(400, 40)),
                                              onPressed: () {
                                                setState(() {
                                                  if (nameController
                                                      .text.isEmpty) {
                                                    return;
                                                  }
                                                  Map data = {
                                                    'name': nameController.text,
                                                    'minLen': minLen,
                                                    'importance': importance
                                                  };
                                                  print(data);
                                                  tasks.add(data);
                                                  setState(() {
                                                    nameController.text = '';
                                                    timeRangeResult = null;
                                                  });

                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text('اضافه کردن'))
                                        ],
                                      ),
                                    ),
                                  );

                                  showDialog(
                                      context: context, builder: (_) => dialog);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text('اضافه کردن'),
                                  ],
                                )),
                          )
                        ],
                      )
                    : null,
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: lightNord4,
                    child: Icon(Icons.timelapse)),
                trailing: const Icon(Icons.settings),
                onTap: () {
                  AlertDialog dialog = AlertDialog(
                    title: const Text('تنظیم زمان'),
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: SizedBox(
                        height: 200,
                        width: 400,
                        child: TimeRange(
                          fromTitle: const Text(
                            'از',
                            style: TextStyle(fontSize: 18, color: darkNord1),
                          ),
                          toTitle: const Text(
                            'تا',
                            style: TextStyle(fontSize: 18, color: darkNord3),
                          ),
                          titlePadding: 20,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                          activeTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          borderColor: darkNord2,
                          initialRange: timeSettingsResult,
                          backgroundColor: Colors.transparent,
                          activeBackgroundColor: darkNord4,
                          firstTime: const TimeOfDay(hour: 00, minute: 00),
                          lastTime: const TimeOfDay(hour: 23, minute: 59),
                          timeStep: 10,
                          timeBlock: 15,
                          onRangeCompleted: (range) =>
                              setState(() => setState(() {
                                    if (range != null) {
                                      timeSettingsResult = range;
                                    }
                                  })),
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('ثبت زمان'))
                    ],
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                subtitle: const Text(
                    'تنظیم زمانی که میخواهید برای آن برنامه ریخته شود'),
                title: const Text('تنظیم زمان'),
              ),
            ],
          ),
        ));
  }
}
