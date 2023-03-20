import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/components/bottom_navigation_bar.dart';
import 'package:taskify/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String name;

  @override
  void initState() {
    name = 'هادی';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: buildHeader(context),
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: darkNord2,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 67,
                            height: 67,
                            decoration: BoxDecoration(
                                color: darkNord4,
                                borderRadius: BorderRadius.circular(20)),
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
                              Text(
                                '۱۰:۰۰ - ۱۰:۲۵ ق.ظ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'خوندن درس عربی',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: darkNord4,
                                foregroundColor: Colors.white,
                                fixedSize: const Size(190, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () {},
                            child: const Text(
                              'شروع کن!',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/home-ill.png',
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سلام $name، خوش برگشتی :)',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: darkNord2),
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
    );
  }
}
