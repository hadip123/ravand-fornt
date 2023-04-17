import 'package:flutter/material.dart';
import 'package:taskify/calendar/calendar_page.dart';
import 'package:taskify/theme.dart';
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
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: darkNord2,
            foregroundColor: Colors.white,
            onPressed: () {
              Map data = {};
              print(blockedTimes);
              print(tasks);
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
                                              onRangeCompleted: (range) =>
                                                  setState(() => setState(() {
                                                        if (range != null) {
                                                          timeRangeResult =
                                                              range;
                                                        }
                                                      })),
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
