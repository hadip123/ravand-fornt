import 'package:flutter/material.dart';
import 'package:taskify/components/stepper_bottom.dart';

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
                    onPressed: () async {}, child: const Text('تایید'))
              ],
            ),
          )),
          StepperBottom(nextStep: nextStep, pervStep: pervStep),
        ],
      ),
    );
  }
}
