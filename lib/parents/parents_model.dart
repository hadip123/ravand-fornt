import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ravand/universal/universal.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> sendRequest(String childEmail) async {
  return Dio().post(getUrl('/users/childreq'),
      data: {
        'email': childEmail,
      },
      options: Options(headers: {
        'Authorization':
            'Bearer ${(await SharedPreferences.getInstance()).getString('token')}'
      }));
}

Future<Response> getChildPlans(String childEmail) async {
  return Dio().post(getUrl('/plan/child'),
      data: {
        'email': childEmail,
      },
      options: Options(headers: {
        'Authorization':
            'Bearer ${(await SharedPreferences.getInstance()).getString('token')}'
      }));
}

Future<Response> getChildren() async {
  return Dio().post(getUrl('/users/getchilds'),
      options: Options(headers: {
        'Authorization':
            'Bearer ${(await SharedPreferences.getInstance()).getString('token')}'
      }));
}

AlertDialog successAlert = const AlertDialog(
  content: Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_box,
          size: 70,
          color: Colors.green,
        ),
        Text(
          'تایید شد!',
          style: TextStyle(
              fontSize: 16, color: Colors.green, fontWeight: FontWeight.w900),
        ),
        Text('ایمیل تایید برای فرزند شما ارسال شد.',
            textAlign: TextAlign.center),
      ],
    ),
  ),
);
AlertDialog someThingWentWrong = const AlertDialog(
  content: Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wifi_tethering_error_sharp,
          size: 70,
          color: Colors.red,
        ),
        Text(
          'مشکلی پیش آمد',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.w900),
        ),
        Text('اختلالی رخ داد. اگر مشکل ضروری است، با پشتیبانی ارتباط بگیرید',
            textAlign: TextAlign.center),
      ],
    ),
  ),
);
AlertDialog notFound = const AlertDialog(
  content: Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          size: 70,
          color: Colors.amber,
        ),
        Text(
          'یافت نشد',
          style: TextStyle(
              fontSize: 16, color: Colors.amber, fontWeight: FontWeight.w900),
        ),
        Text('ایمیلی که وارد کردید در برنامه یافت نشد',
            textAlign: TextAlign.center),
      ],
    ),
  ),
);
AlertDialog emailSent = const AlertDialog(
  content: Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.person,
          size: 70,
          color: Colors.teal,
        ),
        Text(
          'این فرزند موجود می باشد',
          style: TextStyle(
              fontSize: 16, color: Colors.teal, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  ),
);

AlertDialog notAllowed = const AlertDialog(
  content: Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.face_retouching_off_rounded,
          size: 70,
          color: Colors.deepPurple,
        ),
        Text(
          'مجاز نیست',
          style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w900),
        ),
        Text('شما مجاز به اضافه کردن خود به فرزندان خود نیستید :)',
            textAlign: TextAlign.center),
      ],
    ),
  ),
);
