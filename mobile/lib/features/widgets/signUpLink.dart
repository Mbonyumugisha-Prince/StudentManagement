import 'package:flutter/material.dart';

class SignUpLink extends StatelessWidget {
  final VoidCallback onTap;
  final String leadingText;
  final String linkText;

  const SignUpLink({
    required this.onTap,
    this.leadingText = "Don't have an account? ",
    this.linkText = 'Sign Up',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText),
        TextButton(
          onPressed: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
