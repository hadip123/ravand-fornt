import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ravand/firstStart/firstStart_page.dart';
import 'package:ravand/pomodro/pomodro.dart';
import 'package:ravand/start/start_page.dart';
import 'package:ravand/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdkVersion = androidInfo.version.sdkInt ?? 0;
  final androidOverscrollIndicator = sdkVersion > 30
      ? AndroidOverscrollIndicator.stretch
      : AndroidOverscrollIndicator.glow;
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: darkNord1));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('fa', 'IR'),
    theme: ThemeData(
        // useMaterial3: true,
        androidOverscrollIndicator: androidOverscrollIndicator,
        fontFamily: FontSettings.family,
        colorScheme: const ColorScheme.light(primary: darkNord3)),
    home: const Start(),
  ));
}
