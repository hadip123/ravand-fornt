import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/login/login_page.dart';
import 'package:taskify/theme.dart';

class FirstStart extends StatefulWidget {
  const FirstStart({super.key});

  @override
  State<FirstStart> createState() => _FirstStartState();
}

class _FirstStartState extends State<FirstStart> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * .3 + 100,
              decoration: const BoxDecoration(
                  color: darkNord1,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(130))),
              child: Column(
                children: [
                  const Spacer(),
                  Transform.translate(
                    offset: const Offset(0, 60),
                    child: Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Transform.scale(
                            scale: 1.2,
                            child: SvgPicture.asset('assets/logo.svg'))),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            const Text(
              'روند',
              style: TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 43, color: darkNord2),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                'با روند، وظایف رو به طور موثر سازماندهی و زمان رو بهینه کن',
                textAlign: TextAlign.center,
                style: TextStyle(color: lightNord4, fontSize: 15),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  fixedSize: Size(size.width / 1.5, 50)),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Login()));
              },
              child: const Row(
                children: [
                  Icon(Icons.chevron_left),
                  Spacer(),
                  Text(
                    'رایگان شروع کن',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Spacer(),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
