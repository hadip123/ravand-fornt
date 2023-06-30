import 'package:flutter/material.dart';
import 'package:ravand/theme.dart';

class AlertMessage extends StatefulWidget {
  final String title;
  final Widget image;
  final String caption;
  final void Function() onOkPressed;

  const AlertMessage({
    Key? key,
    required this.title,
    required this.image,
    required this.caption,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  _AlertMessageState createState() => _AlertMessageState();
}

class _AlertMessageState extends State<AlertMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double _minHeight = 100.0;
  final double _maxHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(
      begin: _minHeight,
      end: _maxHeight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onOkPressed() {
    _animationController.reverse().then((value) {
      widget.onOkPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: _animation.value / screenHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Material(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: darkNord2,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.caption,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      widget.image,
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkNord2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(100, 40),
                        ),
                        onPressed: _onOkPressed,
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
