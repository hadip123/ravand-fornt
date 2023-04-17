import 'package:dio/dio.dart';
import 'package:taskify/universal/universal.dart';

Future<Response> login(String email, String password) async {
  return await Dio().post(getUrl('/auth/signin'),
      data: {"email": email, "password": password});
}
