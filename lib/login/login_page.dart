import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskify/components/login_input.dart';
import 'package:taskify/home/home_page.dart';
import 'package:taskify/login/login_model.dart';
import 'package:taskify/signup/signup_page.dart';
import 'package:taskify/theme.dart';

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
                    isHidden: true),
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
        final res = await login(_email.text, _password.text);

        if (res.statusCode == 404) {
          // User doesn't exist
        }
        if (res.statusCode == 403) {
          // Password doesn't match
        }
        if (res.statusCode == 200) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Home()));
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
