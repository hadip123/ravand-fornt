import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ravand/pomodro/pomodro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ravand/calendar/calendar_page.dart';
import 'package:ravand/components/alert_message.dart';
import 'package:ravand/components/bottom_navigation_bar.dart';
import 'package:ravand/home/home_model.dart';
import 'package:ravand/settings/settings_page.dart';
import 'package:ravand/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late List<Widget> pages;
  bool loading = true;

  @override
  void initState() {
    pages = [const MainPage(), Calendar(), const Settings()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
          white: _selectedIndex == 0 ? false : true,
          changeSelection: (index) => setState(() {
                _selectedIndex = index;
              })),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: pages[_selectedIndex],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String name;
  bool loading = true;
  Map? nowWork;
  List plan = [];
  String note = '';
  @override
  void initState() {
    super.initState();
    name = '';
    getNow().then((value) => setState(() {
          nowWork = value;
          print(nowWork == null);
        }));
    SharedPreferences.getInstance().then((value) async {
      name = value.getString('fname') ?? 'یه اسم';
      plan = jsonDecode(value.getString('plans') ?? '[]');

      final res = await getTodayNote();
      note = res.data;
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'سلام $name، خوش برگشتی :)',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: darkNord2),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'بیا ببینیم چه کاری رو باید انجام بدی',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: lightNord4),
                  )
                ],
              ),
              const Spacer(),
              Hero(
                tag: 'logo',
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  width: 70,
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: darkNord2,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                if (plan.isEmpty)
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'برنامه ای نساختی...',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                if (!loading && nowWork != null) buildToday(context),
                const SizedBox(
                  height: 10,
                ),
                if (!loading) buildTaskName(context),
                const SizedBox(
                  height: 30,
                ),
                if (!loading) buildStartButton(),
                if (loading)
                  const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'در حال بارگذاری',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w100),
                      )),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    var message = AlertMessage(
                        title: 'نکته روز',
                        image: Image.asset('assets/home-ill.png'),
                        caption: note,
                        onOkPressed: () {
                          Navigator.pop(context);
                        });

                    showDialog(context: context, builder: (_) => message);
                  },
                  child: Container(
                    width: size.width * .8,
                    height: 300,
                    decoration: BoxDecoration(
                        color: darkNord3,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: loading
                          ? const Center(
                              child: Text(
                                'در حال بارگذاری...',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            )
                          : Column(
                              children: [
                                const Text(
                                  'نکته امروز',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  note,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      color: lightNord1,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 17),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/home-ill.png',
                                  height: 150,
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
        ))
      ],
    );
  }

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

  Widget buildToday(BuildContext context) {
    return plan.isNotEmpty
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 67,
                height: 67,
                decoration: BoxDecoration(
                    color: darkNord4, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset('assets/Calender.svg'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'امروز',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: lightNord4),
                  ),
                  if (nowWork != null)
                    Text(
                      '${numberToPersian(createTime(TimeOfDay(hour: int.parse(nowWork?['from'].split(':')[0]), minute: int.parse(nowWork?['from'].split(':')[1]))) ?? '')} تا ${numberToPersian(createTime(TimeOfDay(hour: int.parse(nowWork?['to'].split(':')[0]), minute: int.parse(nowWork?['to'].split(':')[1]))) ?? '')}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                ],
              ),
            ],
          )
        : Container();
  }

  Widget buildTaskName(BuildContext context) {
    return plan.isNotEmpty
        ? Text(
            nowWork != null ? '${nowWork?['name']}' : 'کاری برای انجام نیست...',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
          )
        : Container();
  }

  Widget buildStartButton() {
    return plan.isNotEmpty
        ? Align(
            alignment: Alignment.center,
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: darkNord4,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(190, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PomodroPage()));
                },
                child: const Text(
                  'شروع کن!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
          )
        : Container();
  }
}
