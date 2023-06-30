import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getUrl(String route) {
  return 'http://ravand.hipoo.ir:5000$route';
}

Future<Response> getProfile() async {
  return await Dio().get(getUrl('/users/me'),
      options: Options(headers: {
        'Authorization':
            'Bearer ${(await SharedPreferences.getInstance()).getString('token')}'
      }));
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    message,
    textDirection: TextDirection.rtl,
  )));
}
