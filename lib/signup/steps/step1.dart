import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/components/login_input.dart';
import 'package:taskify/components/stepper_bottom.dart';
import 'package:taskify/home/home_page.dart';
import 'package:taskify/signup/signup_model.dart';
import 'package:taskify/theme.dart';

class SignUpStep1 extends StatefulWidget {
  SignUpStep1({required this.nextStep, required this.pervStep, super.key});

  void Function() nextStep;
  void Function() pervStep;

  @override
  State<SignUpStep1> createState() =>
      _SignUpStep1State(nextStep: nextStep, pervStep: pervStep);
}

class _SignUpStep1State extends State<SignUpStep1> {
  _SignUpStep1State({required this.nextStep, required this.pervStep});
  void Function() nextStep;
  void Function() pervStep;
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  String verCode = '';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            ...buildTop(size),
            Column(
              children: [
                const SizedBox(
                  height: 383,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ListView(
                      children: [
                        const Text(
                          'کد تایید',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        OtpPinField(
                            maxLength: 6,
                            fieldWidth: size.width / 6 - 30,
                            fieldHeight: 50,
                            onSubmit: (submit) {
                              setState(() {
                                verCode = submit;
                              });
                            },
                            otpPinFieldDecoration:
                                OtpPinFieldDecoration.defaultPinBoxDecoration,
                            onChange: (value) {}),
                        LoginInput(
                            size: size,
                            type: TextInputType.name,
                            dir: TextDirection.rtl,
                            controller: _nameController,
                            hint: '',
                            label: 'نام',
                            isHidden: false),
                        const SizedBox(
                          height: 10,
                        ),
                        LoginInput(
                            size: size,
                            type: TextInputType.name,
                            dir: TextDirection.rtl,
                            controller: _lastNameController,
                            hint: '',
                            label: 'نام خانوادگی',
                            isHidden: false),
                        const SizedBox(
                          height: 10,
                        ),
                        LoginInput(
                            size: size,
                            type: TextInputType.visiblePassword,
                            hint: '',
                            controller: _passwordController,
                            label: 'رمز عبور',
                            isHidden: true)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StepperBottom(
                    nextStep: () async {
                      Map data = {
                        'fn': _nameController.text,
                        'ln': _lastNameController.text,
                        'password': _passwordController.text,
                        'ipass': verCode,
                        'token': (await SharedPreferences.getInstance())
                            .getString('mob_token'),
                      };
                      print(data);
                      if (!validatePassword(_passwordController.text)) {
                        SnackBar snackBar = const SnackBar(
                            content: Text(
                                'رمز عبور باشد شامل شرایط زیر باشد:\nحداقل شامل ۶ کاراکتر'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      if (_nameController.text.isEmpty ||
                          _lastNameController.text.isEmpty) {
                        SnackBar snackBar = const SnackBar(
                            content: Text('نام و نام خانوادگی اجباری است'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      try {
                        final result = await completeSignUp(data);

                        await (await SharedPreferences.getInstance())
                            .setString('token', result.data['jwt']);

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Home()));
                      } on DioError catch (e) {
                        if (e.response!.statusCode == 404) {
                          SnackBar snackBar = const SnackBar(
                              content: Text('دوباره امتحان کنید'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (e.response!.statusCode == 403) {
                          SnackBar snackBar = const SnackBar(
                              content: Text('کد تایید اشتباه است'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        return;
                      }
                    },
                    pervStep: pervStep),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List buildTop(Size size) {
    return [
      Positioned(
        top: -30,
        left: -100,
        child: Container(
          width: size.width + 200,
          height: 293,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(900)),
              color: darkNord1),
          child: Column(
            children: [
              const Spacer(),
              Transform.translate(
                offset: const Offset(0, 90),
                child: const CircleAvatar(
                  radius: 110,
                  backgroundColor: darkNord4,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/man-smiling.png',
                    ),
                    radius: 96,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ثبت نام در',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Image.asset(
                  'assets/logo-splash.png',
                  width: 40,
                )
              ],
            ),
          ],
        ),
      )
    ];
  }
}
