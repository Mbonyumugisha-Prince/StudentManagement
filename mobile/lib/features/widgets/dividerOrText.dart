import 'package:flutter/material.dart';

class DividerOrText extends StatelessWidget {
  final String text;

  const DividerOrText({this.text = 'Or login with'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}