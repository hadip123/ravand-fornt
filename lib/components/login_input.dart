import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  const LoginInput(
      {super.key,
      required this.size,
      required this.type,
      required this.hint,
      required this.controller,
      required this.label,
      this.dir = TextDirection.ltr,
      required this.isHidden});

  final Size size;
  final TextInputType type;
  final String label;
  final String hint;
  final bool isHidden;
  final TextDirection dir;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width - 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: controller,
                obscureText: isHidden,
                keyboardType: type,
                textDirection: dir,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontSize: 12),
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.blueGrey),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
