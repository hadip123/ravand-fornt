import 'package:flutter/material.dart';
import 'package:taskify/components/stepper_bottom.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text('Step 3'),
          StepperBottom(nextStep: nextStep, pervStep: pervStep),
        ],
      ),
    );
  }
}
