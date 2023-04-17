import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:taskify/theme.dart';

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
            const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                  color: darkNord2,
                )),
          ],
        ));
  }
}
