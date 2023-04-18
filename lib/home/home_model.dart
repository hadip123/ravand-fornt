import 'package:dio/dio.dart';

Future<Response> getTodayNote() async {
  return await Dio().get('http://bodyb.hipoo.ir:1221/note/today');
}
