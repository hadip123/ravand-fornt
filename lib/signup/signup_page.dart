import 'package:flutter/material.dart';
import 'package:ravand/components/shake_widget.dart';
import 'package:ravand/signup/steps/step1.dart';
import 'package:ravand/signup/steps/step2.dart';
import 'package:ravand/signup/steps/step3.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  int _step = 0;
  final _lastStepNumber = 2;
  late ShakeController _shakeController;
  late List<Widget> pages;

  @override
  void initState() {
    _shakeController = ShakeController(vsync: this);
    pages = [
      SignUpStep3(
        nextStep: nextStep,
        pervStep: pervStep,
      ),
      SignUpStep1(
        nextStep: nextStep,
        pervStep: pervStep,
      ),
      SignUpStep2(
        nextStep: nextStep,
        pervStep: pervStep,
      ),
    ];
    super.initState();
  }

  void nextStep() {
    if (_step < _lastStepNumber) {
      setState(() {
        _step++;
      });
      print(_step);
    } else {
      _shakeController.shake(false);
      //TODO: Send data by API
    }
  }

  void pervStep() {
    print(_step);
    if (_step >= 1) {
      print('Enter');
      setState(() {
        _step--;
      });
    } else {
      //TODO: Shake call
      _shakeController.shake(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ShakeWidget(
        controller: _shakeController,
        child: pages[_step],
      )),
    );
  }
}
