import 'dart:convert';

import 'package:http/http.dart';
import 'package:taskify/universal/universal.dart';

Future<Response> signUp(Map data) async {
  print(jsonEncode(data));
  return await post(Uri.parse(getUrl('/auth/signup')), body: data);
}

Future<Response> verifyEmail(Map data) async {
  return await post(Uri.parse(getUrl('/auth/signup/f')), body: data);
}
