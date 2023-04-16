import 'package:flutter/material.dart';
import 'package:taskify/theme.dart';

class StepperBottom extends StatelessWidget {
  const StepperBottom({
    super.key,
    required this.nextStep,
    required this.pervStep,
  });

  final void Function() nextStep;
  final void Function() pervStep;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          const SizedBox(
            width: 19,
          ),
          FloatingActionButton(
            onPressed: () {
              nextStep();
            },
            backgroundColor: darkNord1,
            child: const Icon(
              Icons.chevron_left,
              size: 45,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              pervStep();
            },
            backgroundColor: darkNord1,
            child: const Icon(
              Icons.chevron_right,
              size: 45,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 19,
          ),
        ],
      ),
    );
  }
}
