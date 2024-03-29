import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ravand/theme.dart';

class MyBottomNavigationBar extends StatefulWidget {
  void Function(int index) changeSelection;
  bool white;
  MyBottomNavigationBar(
      {super.key, required this.changeSelection, required this.white});

  @override
  _MyBottomNavigationBarState createState() =>
      _MyBottomNavigationBarState(changeSelection, white);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;
  bool white;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Search'),
    Text('Profile'),
  ];

  _MyBottomNavigationBarState(this.changeSelection, this.white);

  void Function(int index) changeSelection;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    changeSelection(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _selectedIndex != 0 ? Colors.white : darkNord2,
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: darkNord4,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () => _onItemTapped(0),
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(
                      0.0,
                      _selectedIndex == 0 ? 0.0 : 5.0,
                      0.0,
                    ),
                    child: SvgPicture.asset('assets/Home 1.svg'),
                  ),
                ),
                IconButton(
                  enableFeedback: false,
                  onPressed: () => _onItemTapped(1),
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(
                      0.0,
                      _selectedIndex == 1 ? 0.0 : 5.0,
                      0.0,
                    ),
                    child: SvgPicture.asset('assets/Calender 1.svg'),
                  ),
                ),
                IconButton(
                  enableFeedback: false,
                  onPressed: () => _onItemTapped(2),
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(
                      0.0,
                      _selectedIndex == 2 ? 0.0 : 5.0,
                      0.0,
                    ),
                    child: SvgPicture.asset('assets/Setting.svg'),
                  ),
                )
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: (MediaQuery.of(context).size.width / 3) *
                      (_selectedIndex + 1) -
                  (MediaQuery.of(context).size.width / 6) -
                  4,
              bottom: 10,
              child: Container(
                width: 8,
                height: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
