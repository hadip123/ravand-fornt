import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ravand/universal/universal.dart';

Future<Response> generatePlan(Map data) async {
  return Dio().post(getUrl('/plan/create'),
      data: data,
      options: Options(headers: {
        'Authorization':
            'Bearer ${(await SharedPreferences.getInstance()).getString('token')}'
      }));
}
