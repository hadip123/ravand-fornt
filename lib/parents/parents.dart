import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ravand/parents/child_plan.dart';
import 'package:ravand/parents/parents_model.dart';
import 'package:ravand/theme.dart';

class ParentsPage extends StatefulWidget {
  const ParentsPage({super.key});

  @override
  State<ParentsPage> createState() => _ParentsPageState();
}

class _ParentsPageState extends State<ParentsPage> {
  final TextEditingController childEmailCont = TextEditingController();
  bool loading = false;

  List children = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getChildren().then((value) {
      print(value);
      setState(() {
        loading = false;
        children = value.data;
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }

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
                    onPressed: () async {
                      try {
                        print(childEmailCont.text);
                        final response = await sendRequest(childEmailCont.text);

                        Navigator.pop(context, 'success');
                        return;
                      } on DioError catch (e) {
                        if (e.response?.statusCode == 404) {
                          Navigator.pop(context, 'not_found');
                          return;
                        }
                        if (e.response?.statusCode == 407) {
                          Navigator.pop(context, 'email_sent');
                          return;
                        }
                        if (e.response?.statusCode == 405) {
                          Navigator.pop(context, 'not_allowed');
                          return;
                        }

                        print(e);

                        Navigator.pop(context, 'something_went_wrong');
                      }
                    },
                    child: const Text('فرستادن درخواست')),
              ],
              content: SizedBox(
                height: 40,
                child: TextField(
                  controller: childEmailCont,
                  decoration: InputDecoration(
                      hintText: 'example@email.com',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            );

            final res =
                await showDialog(context: context, builder: (_) => alertDialog);
            print(res);

            if (res == 'success') {
              showDialog(context: context, builder: (_) => successAlert);
            } else if (res == 'something_went_wrong') {
              showDialog(context: context, builder: (_) => someThingWentWrong);
            } else if (res == 'not_found') {
              showDialog(context: context, builder: (_) => notFound);
            } else if (res == 'email_sent') {
              showDialog(context: context, builder: (_) => emailSent);
            } else if (res == 'not_allowed') {
              showDialog(context: context, builder: (_) => notAllowed);
            }
          },
        ),
        appBar: AppBar(
          title: const Text('مدیریت فرزند'),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : children.isEmpty
                ? const Center(
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
                          style: TextStyle(
                              color: lightNord4, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      for (final child in children)
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ChildPlan(childEmail: child['email'])));
                          },
                          leading: const Icon(
                            Icons.face,
                            color: Colors.teal,
                          ),
                          title: Text(child['fName'] + ' ' + child['lName']),
                        )
                    ],
                  ),
      ),
    );
  }
}
