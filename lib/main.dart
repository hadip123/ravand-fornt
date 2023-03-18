import 'package:flutter/material.dart';
import 'package:taskify/start/start_page.dart';
import 'package:taskify/theme.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('fa', 'IR'),
    theme: ThemeData(
        fontFamily: FontSettings.family,
        colorScheme: const ColorScheme.light(primary: darkNord3)),
    home: const Start(),
  ));
}
