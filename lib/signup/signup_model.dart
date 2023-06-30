import 'package:dio/dio.dart';
import 'package:ravand/universal/universal.dart';

bool validateEmail(String email) {
  final domain = RegExp('@(.+)').firstMatch(email)?.group(1);

  final validEmailDomains = {'hotmail.com', 'outlook.com', 'gmail.com'};

  return validEmailDomains.contains(domain);
}

bool validatePassword(String password) {
  if (password.length < 6) {
    return false;
  }

  return true;
}

Future<Response> startSignUp(String email) async {
  return await Dio().post(getUrl('/auth/signup'), data: {"email": email});
}

Future<Response> completeSignUp(Map data) async {
  return await Dio().post(getUrl('/auth/signup/f'), data: data);
}
