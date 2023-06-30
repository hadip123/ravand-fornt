import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeBackground extends StatefulWidget {
  const ChangeBackground({super.key});

  @override
  State<ChangeBackground> createState() => _ChangeBackgroundState();
}

enum Backgrounds { bg1, bg2, bg3 }

class _ChangeBackgroundState extends State<ChangeBackground> {
  Backgrounds bg = Backgrounds.bg1;
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        final v = value.getString('bg');
        if (v == 'assets/bg1.jpg') {
          setState(() {
            bg = Backgrounds.bg1;
          });
        }
        if (v == 'assets/bg2.jpg') {
          setState(() {
            bg = Backgrounds.bg2;
          });
        }
        if (v == 'assets/bg3.jpg') {
          setState(() {
            bg = Backgrounds.bg3;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تغییر پس زمینه')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 0.52,
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            'assets/bg1.jpg',
                            fit: BoxFit.cover,
                          ))),
                  Radio(
                      value: Backgrounds.bg1,
                      groupValue: bg,
                      onChanged: (v) async {
                        setState(() {
                          bg = v ?? Backgrounds.bg1;
                        });
                        (await SharedPreferences.getInstance())
                            .setString("bg", 'assets/bg1.jpg');
                      }),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            'assets/bg2.jpg',
                            fit: BoxFit.cover,
                          ))),
                  Radio(
                      value: Backgrounds.bg2,
                      groupValue: bg,
                      onChanged: (v) async {
                        setState(() {
                          bg = v ?? Backgrounds.bg2;
                        });
                        (await SharedPreferences.getInstance())
                            .setString("bg", 'assets/bg2.jpg');
                      }),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            'assets/bg3.jpg',
                            fit: BoxFit.cover,
                          ))),
                  Radio(
                      value: Backgrounds.bg3,
                      groupValue: bg,
                      onChanged: (v) async {
                        setState(() {
                          bg = v ?? Backgrounds.bg3;
                        });
                        (await SharedPreferences.getInstance())
                            .setString("bg", 'assets/bg3.jpg');
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
