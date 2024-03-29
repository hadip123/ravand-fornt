import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ravand/components/login_input.dart';
import 'package:ravand/login/login_model.dart';
import 'package:ravand/signup/signup_page.dart';
import 'package:ravand/start/start_page.dart';
import 'package:ravand/theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Center(
          child: SizedBox(
            width: size.width - 80,
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 60,
                      child: SvgPicture.asset('assets/Group 4.svg')),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'هوشمند برنامه‌ریزی کن',
                    style: TextStyle(color: darkNord3),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                LoginInput(
                    size: size,
                    type: TextInputType.emailAddress,
                    hint: 'example@gmail.com',
                    controller: _email,
                    label: 'ایمیل شما',
                    isHidden: false),
                const SizedBox(
                  height: 16,
                ),
                LoginInput(
                    size: size,
                    type: TextInputType.visiblePassword,
                    hint: 'Password',
                    controller: _password,
                    label: 'رمز عبور',
                    isHidden: true),
                const SizedBox(
                  height: 40,
                ),
                buildContinueButton(size),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text('یا')),
                buildSignUpButton(size)
              ],
            ),
          ),
        )),
      ),
    );
  }

  ElevatedButton buildContinueButton(Size size) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final res = await login(_email.text, _password.text);
          await (await SharedPreferences.getInstance())
              .setString('token', res.data['jwt']);
          if (res.statusCode == 200) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Start()));
          }
        } on DioError catch (e) {
          print(e);
          if (e.error.runtimeType == SocketException) {
            return;
          }
          final res = e.response!;
          if (res.statusCode == 404) {
            SnackBar snackBar =
                const SnackBar(content: Text('کاربر وجود ندارد'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          if (res.statusCode == 403) {
            SnackBar snackBar =
                const SnackBar(content: Text('رمز عبور اشتباه است'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          if (res.statusCode == 400) {
            SnackBar snackBar =
                const SnackBar(content: Text('اطلاعات را دوباره بررسی کنید'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
        }
      },
      style: ElevatedButton.styleFrom(
          fixedSize: Size(size.width - 100, 45),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: const Row(
        children: [
          Icon(Icons.chevron_left),
          Spacer(),
          Text(
            'ورود',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Spacer(),
        ],
      ),
    );
  }

  TextButton buildSignUpButton(Size size) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Signup()));
      },
      style: TextButton.styleFrom(
          backgroundColor: lightNord1,
          fixedSize: Size(size.width - 100, 35),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: const Text(
        'ثبت نام کنید',
        style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
      ),
    );
  }
}
