import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/components/login_input.dart';
import 'package:taskify/components/stepper_bottom.dart';
import 'package:taskify/signup/signup_model.dart';

class SignUpStep3 extends StatefulWidget {
  SignUpStep3({required this.nextStep, required this.pervStep, super.key});

  void Function() nextStep;
  void Function() pervStep;

  @override
  State<SignUpStep3> createState() =>
      _SignUpStep3State(nextStep: nextStep, pervStep: pervStep);
}

class _SignUpStep3State extends State<SignUpStep3> {
  _SignUpStep3State({required this.nextStep, required this.pervStep});
  void Function() nextStep;
  void Function() pervStep;
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/login.jpeg',
                      width: 200,
                    ),
                  ),
                  LoginInput(
                      size: size,
                      type: TextInputType.emailAddress,
                      hint: 'example@example.com',
                      controller: _emailController,
                      label: 'ایمیل',
                      isHidden: false),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
            StepperBottom(
                nextStep: () async {
                  if (!validateEmail(_emailController.text)) {
                    return;
                  }
                  try {
                    final result = await startSignUp(_emailController.text);
                    print(result);
                    if (result.statusCode == 200) {
                      await (await SharedPreferences.getInstance()).setString(
                        'mob_token',
                        result.data['token'] ?? '',
                      );
                      nextStep();
                      return;
                    }
                  } on DioError catch (e) {
                    if (e.response!.statusCode == 409) {
                      SnackBar snackBar =
                          const SnackBar(content: Text('کاربر وجود دارد'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                  }
                },
                pervStep: pervStep),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
