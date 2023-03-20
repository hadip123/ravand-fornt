import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final double _profileRadius = 78;
  late String name;
  late String lastName;

  @override
  void initState() {
    super.initState();
    name = 'محمدهادی';
    lastName = 'پهلوان';
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
            buildProfileBar(),
            const SizedBox(
              height: 30,
            ),
            buildName(),
            const SizedBox(
              height: 20,
            ),
            buildSettingsList(),
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
        onPressed: () {},
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

  ListView buildSettingsList() {
    return ListView(
      shrinkWrap: true,
      children: [
        SetttingsItem(
          title: "اهداف",
          icon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/goal.svg',
              color: Colors.orange[800],
            ),
          ),
          color: Colors.orange,
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        SetttingsItem(
          title: "آمار من",
          icon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/PersonSimpleRun.svg',
              color: Colors.deepPurple[800],
            ),
          ),
          color: Colors.deepPurple,
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        SetttingsItem(
          title: "پلن های ذخیره شده",
          icon: Icon(
            Icons.save,
            color: Colors.red[900],
          ),
          color: Colors.red,
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        SetttingsItem(
          title: "تنظیمات",
          icon: Icon(
            Icons.settings,
            color: Colors.blue[900],
          ),
          color: Colors.blue,
          onTap: () {},
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
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'تاریخ عضویت',
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            Text(
              '۳ ماه پیش',
              style: TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        )
      ],
    );
  }
}

class SetttingsItem extends StatelessWidget {
  SetttingsItem({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.title,
  });

  String title;
  Widget icon;
  MaterialColor color;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: Container(
          width: 50,
          decoration: BoxDecoration(color: color[50], shape: BoxShape.circle),
          height: 50,
          child: icon),
      trailing: Container(
        width: 50,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(10)),
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Transform.rotate(
            angle: 3.15,
            child: SvgPicture.asset(
              'assets/Chevron Right.svg',
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required double profileRadius,
  }) : _profileRadius = profileRadius;

  final double _profileRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _profileRadius * 2,
      height: _profileRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularPercentIndicator(
            radius: _profileRadius,
            lineWidth: 4,
            percent: 0.67,
            backgroundColor: Colors.transparent,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: Image.network(
                // 'https://picsum.photos/191/191?random=${Random().nextInt(1000)}',
                'https://i.pravatar.cc/200?img=11',
                width: _profileRadius + 110.0 - 68.0,
                height: _profileRadius + 110.0 - 68.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
