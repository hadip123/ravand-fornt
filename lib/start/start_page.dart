import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/firstStart/firstStart_page.dart';
import 'package:taskify/home/home_page.dart';
import 'package:taskify/theme.dart';
import 'package:taskify/universal/universal.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  bool hasError = false;
  String errorText = 'Couldn\'t connect, Try again.';
  @override
  void initState() {
    getProfile().then((value) async {
      final instance = await SharedPreferences.getInstance();
      print(value.data);
      await instance.setString('fname', value.data['fName']);
      await instance.setString('lname', value.data['lName']);
      await instance.setString('email', value.data['email']);
      // await instance.setString('plans', '[]');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
    }).onError((error, stackTrace) {
      if (error.runtimeType == DioError) {
        if ((error as DioError).error.runtimeType == SocketException) {
          hasError = true;
          errorText = 'Check your internet';
          setState(() {});
          return;
        }

        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const FirstStart()));
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkNord1,
      body: Center(
        child: Hero(
            tag: 'logo',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo-splash.png'),
                const SizedBox(
                  height: 10,
                ),
                if (hasError)
                  const Text(
                    'Coudn\'t connect, try again',
                    style: TextStyle(color: Colors.white),
                  )
              ],
            )),
      ),
    );
  }
}
