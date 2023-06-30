import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ravand/pomodro/see_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ravand/pomodro/change_background.dart';
import 'package:ravand/theme.dart';

class PomodroPage extends StatefulWidget {
  const PomodroPage({super.key});

  @override
  State<PomodroPage> createState() => _PomodroPageState();
}

class _PomodroPageState extends State<PomodroPage> {
  String bg = 'assets/bg1.jpg';
  double opacity = 0.3;
  Timer? timer;
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
                    child: const Center(
                        child: Text(
                      '۲۵:۰۰',
                      style: TextStyle(fontSize: 60, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {},
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
                          'شروع',
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
                      const Column(
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
