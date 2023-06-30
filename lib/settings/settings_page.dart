import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ravand/parents/parents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:ravand/components/profile.dart';
import 'package:ravand/components/setings_item.dart';
import 'package:ravand/start/start_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final double _profileRadius = 78;
  late String name;
  late String lastName;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    name = 'در حال بارگذاری';
    lastName = 'درحال بارگذاری';
    SharedPreferences.getInstance().then((value) {
      setState(() {
        isLoading = false;
      });
      name = value.getString('fname') ?? 'یه اسم';
      lastName = value.getString('lname') ?? 'یه اسم';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? SkeletonLoader(builder: buildProfileBar())
                : buildProfileBar(),
            const SizedBox(
              height: 30,
            ),
            isLoading ? SkeletonLoader(builder: buildName()) : buildName(),
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? SkeletonLoader(builder: buildSettingsList())
                : buildSettingsList(),
            const Spacer(),
            buildSignOutButton()
          ],
        ),
      )),
    );
  }

  TextButton buildSignOutButton() {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.blueGrey[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: () async {
          final instance = await SharedPreferences.getInstance();
          await instance.setString('token', 'value');
          await instance.setString('plans', '[]');

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Start()));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.exit_to_app,
              color: Colors.pink[600],
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('خروج'),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  Widget buildSettingsList() {
    final Size size = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      children: [
        SetttingsItem(
          title: "آرشیو برنامه های من",
          icon: Icon(
            Icons.archive,
            color: Colors.red[900],
          ),
          color: Colors.red,
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        SetttingsItem(
            icon: Icon(
              Icons.child_care,
              color: Colors.teal[900],
            ),
            color: Colors.teal,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ParentsPage()));
            },
            title: 'افزودن فرزند'),
        const SizedBox(
          height: 20,
        ),
        SetttingsItem(
          title: "درباره ما",
          icon: Icon(
            Icons.info,
            color: Colors.blue[900],
          ),
          color: Colors.blue,
          onTap: () {
            final dialog = AboutDialog(
              applicationIcon: SvgPicture.asset(
                'assets/logo.svg',
                width: 70,
                height: 70,
              ),
              applicationName: 'Ravand',
              applicationVersion: '0.1 beta',
              children: const [
                Text(
                  'Hipoo™',
                  style: TextStyle(fontSize: 30),
                ),
                Text('Developers:\nM.Hadi Pahlevan, Mohammad Langari'),
                Text('Website: ravand.hipoo.ir'),
                Text('School: Shahid-Beheshti HighSchool'),
                Text('Copyright © 2023 Hipoo! All right Reserved')
              ],
            );

            showDialog(context: context, builder: (_) => dialog);
          },
        ),
      ],
    );
  }

  Column buildName() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        Transform.translate(
          offset: const Offset(0, -13),
          child: Text(
            lastName,
            style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 30),
          ),
        ),
      ],
    );
  }

  Row buildProfileBar() {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Profile(
          profileRadius: _profileRadius,
        ),
        SizedBox(
          width: size.width * .1,
        ),
        Container(
          width: 1,
          height: 110,
          color: const Color.fromARGB(255, 240, 236, 236),
        ),
        SizedBox(
          width: size.width * .1,
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('کاربر عادی روند')],
        )
      ],
    );
  }
}
