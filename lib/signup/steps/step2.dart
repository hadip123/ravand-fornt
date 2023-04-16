import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/components/stepper_bottom.dart';
import 'package:taskify/home/home_page.dart';
import 'package:taskify/signup/signup_model.dart';

class SignUpStep2 extends StatefulWidget {
  SignUpStep2({required this.nextStep, required this.pervStep, super.key});

  void Function() nextStep;
  void Function() pervStep;

  @override
  State<SignUpStep2> createState() =>
      _SignUpStep2State(nextStep: nextStep, pervStep: pervStep);
}

class _SignUpStep2State extends State<SignUpStep2> {
  _SignUpStep2State({required this.nextStep, required this.pervStep});
  void Function() nextStep;
  void Function() pervStep;
  final TextEditingController _verificationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Expanded(
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('تایید ایمیل'),
                SizedBox(
                  width: size.width * .7,
                  height: 40,
                  child: TextField(
                    controller: _verificationController,
                    decoration: const InputDecoration(
                        hintText: 'کد تایید',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(),
                        filled: true),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final uuid = (await SharedPreferences.getInstance())
                              .getString('uuid') ??
                          '';
                      final verificationCode = _verificationController.text;

                      final res = await verifyEmail({
                        "token": uuid,
                        "ipass": verificationCode,
                      });

                      print(res.statusCode);
                      print(res.body);

                      if (res.statusCode == 201) {
                        final data = jsonDecode(res.body);
                        if (data['stat'] == 1) {
                          SnackBar snackBar = const SnackBar(
                              content: Text('دوباره امتحان کنید'));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          pervStep();
                          return;
                        }
                        if (data['stat'] == 3) {
                          SnackBar snackBar = const SnackBar(
                              content: Text(
                                  'مهلت کد تایید تمام شد. دوباره امتحان کنید'));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          pervStep();
                          return;
                        }

                        await (await SharedPreferences.getInstance())
                            .setString('token', data['jwt']);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Home()));
                      }
                    },
                    child: const Text('تایید'))
              ],
            ),
          )),
          StepperBottom(nextStep: nextStep, pervStep: pervStep),
        ],
      ),
    );
  }
}
