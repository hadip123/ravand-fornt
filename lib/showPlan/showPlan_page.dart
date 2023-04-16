import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowPlan extends StatefulWidget {
  const ShowPlan({super.key});

  @override
  State<ShowPlan> createState() => _ShowPlanState();
}

class _ShowPlanState extends State<ShowPlan> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('پلن ایجاد شده')),
        body: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final List data =
                    jsonDecode(snapshot.data!.getString('plan') ?? '[]');
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      final DateTime startTime =
                          DateTime.parse(data[index]['start_time']);
                      final DateTime endTime =
                          DateTime.parse(data[index]['end_time']);
                      return ListTile(
                        title: Text(data[index]['name']),
                        subtitle: Text(
                            '${startTime.hour}:${startTime.minute} تا ${endTime.hour}:${endTime.minute}'),
                      );
                    });
              }
              if (snapshot.hasError) {}
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
