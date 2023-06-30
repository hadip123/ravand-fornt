import 'package:flutter/material.dart';

class ChildPlan extends StatefulWidget {
  ChildPlan({super.key, required this.childEmail});
  String childEmail;
  @override
  State<ChildPlan> createState() => _ChildPlanState();
}

class _ChildPlanState extends State<ChildPlan> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('برنامه امروز فرزند شما')),
      ),
    );
  }
}
