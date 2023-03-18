import 'package:flutter/material.dart';
import 'package:taskify/home/home_page.dart';
import 'package:taskify/theme.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkNord1,
      body: Center(
        child: Hero(tag: 'logo', child: Image.asset('assets/logo-splash.png')),
      ),
    );
  }
}
