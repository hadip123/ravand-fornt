
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
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
      ),
    );
  }
}
