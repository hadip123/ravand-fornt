import 'package:flutter/material.dart';
import 'package:ravand/theme.dart';

class ParentsPage extends StatefulWidget {
  const ParentsPage({super.key});

  @override
  State<ParentsPage> createState() => _ParentsPageState();
}

class _ParentsPageState extends State<ParentsPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: darkNord1,
          child: const Icon(
            Icons.add_box,
            color: Colors.white,
          ),
          onPressed: () async {
            AlertDialog alertDialog = AlertDialog(
              title: const Text(
                'ایمیل فرزند',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              titlePadding: const EdgeInsets.all(10),
              actions: [
                ElevatedButton(
                    onPressed: () {}, child: const Text('فرستادن درخواست')),
              ],
              content: SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'example@email.com',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            );

            showDialog(context: context, builder: (_) => alertDialog);
          },
        ),
        appBar: AppBar(
          title: const Text('مدیریت فرزند'),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bubble_chart,
                color: darkNord3,
                size: 70,
              ),
              Text(
                'فرزندی ندارید...',
                style:
                    TextStyle(color: lightNord4, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
