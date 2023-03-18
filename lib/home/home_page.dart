import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
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
