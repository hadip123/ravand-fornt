import 'package:flutter/material.dart';
import 'package:taskify/components/shake_widget.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  int _step = 0;
  final _lastStepNumber = 3;
  late ShakeController _shakeController;

  @override
  void initState() {
    _shakeController = ShakeController(vsync: this);
    super.initState();
  }

  void nextStep() {
    if (_step >= _lastStepNumber) {
      setState(() {
        _step++;
      });
    } else {
      //TODO: Send data by API
    }
  }

  void pervStep() {
    if (_step <= 0) {
      setState(() {
        _step--;
      });
    } else {
      //TODO: Shake call
      _shakeController.shake(false);
    }
  }

  final List<Widget> pages = [
    
  ];

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

