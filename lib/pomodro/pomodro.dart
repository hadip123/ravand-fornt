import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ravand/pomodro/see_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ravand/pomodro/change_background.dart';
import 'package:ravand/theme.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class PomodroPage extends StatefulWidget {
  const PomodroPage({super.key});

  @override
  State<PomodroPage> createState() => _PomodroPageState();
}

class _PomodroPageState extends State<PomodroPage> {
  String bg = 'assets/bg1.jpg';
  double opacity = 0.3;
  Timer? _timer;
  Duration duration = const Duration(minutes: 25);
  Duration initDuration = const Duration(minutes: 25);
  Timer? timer;
  int wheelChooserValue = 25;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        this.timer = timer;
        opacity = opacity == 0.05 ? 0.25 : 0.05;
      });
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        bg = value.getString('bg') ?? bg;
      });
    });
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

  getTime(Duration duration) {
    final min = duration.inMinutes;
    final sec = duration.inSeconds - duration.inMinutes * 60;
    var correctedMin = '$min';
    var correctedSec = '$sec';
    if (min.toString().length == 1) {
      correctedMin = '0$min';
    }
    if (sec.toString().length == 1) {
      correctedSec = '0$sec';
    }
    return numberToPersian('$correctedMin:$correctedSec');
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        print(duration.inSeconds);
        if (duration.inSeconds >= 1) {
          setState(() {
            duration = Duration(seconds: duration.inSeconds - 1);
          });
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        timer?.cancel();
        print('Timer Canceled ${timer?.isActive}');
        return true;
      },
      child: Scaffold(
        backgroundColor: lightNord1,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover,
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: size.width / 1.7,
                    height: size.width / 1.7,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(colors: [
                          darkNord4.withOpacity(0.7),
                          lightNord4.withOpacity(opacity),
                        ]),
                        shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      getTime(duration),
                      style: const TextStyle(fontSize: 60, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (_timer?.isActive != true) {
                        startTimer();
                      } else {
                        _timer?.cancel();
                        setState(() {
                          duration = initDuration;
                        });
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            lightNord3.withOpacity(0.2),
                            lightNord4.withOpacity(0.2)
                          ])),
                      child: Center(
                        child: Text(
                          _timer?.isActive != true ? 'شروع' : 'پایان',
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if ((_timer?.isActive == true))
                    InkWell(
                      onTap: () {
                        _timer?.cancel();
                      },
                      child: Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: [
                              lightNord3.withOpacity(0.2),
                              lightNord4.withOpacity(0.2)
                            ])),
                        child: const Center(
                          child: Text(
                            'توقف',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ChangeBackground()));
                          SharedPreferences.getInstance().then((value) {
                            setState(() {
                              bg = value.getString('bg') ?? bg;
                            });
                          });
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.image, color: Colors.white),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'پس‌زمینه',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          AlertDialog dialog = AlertDialog(
                            title: const Text(
                              'انتخاب زمان (دقیقه)',
                              textAlign: TextAlign.center,
                            ),
                            titlePadding: const EdgeInsets.all(18),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, wheelChooserValue);
                                  },
                                  child: const Text('ثبت'))
                            ],
                            content: SizedBox(
                                height: 50,
                                width: 40,
                                child: WheelChooser.integer(
                                  onValueChanged: (v) {
                                    wheelChooserValue = v;
                                  },
                                  initValue: wheelChooserValue,
                                  maxValue: 900,
                                  horizontal: true,
                                  selectTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  minValue: 5,
                                  step: 5,
                                )),
                          );
                          final result = await showDialog(
                              context: context, builder: (_) => dialog);

                          setState(() {
                            initDuration = Duration(minutes: result ?? 25);
                            duration = initDuration;
                          });
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.settings, color: Colors.white),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'تنظیمات',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SeePlan()));
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.task_alt, color: Colors.white),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'برنامه',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
