import 'package:flutter/material.dart';

class RememberMeForgotPassword extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onForgotPasswordTap;

  const RememberMeForgotPassword({
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: onRememberMeChanged,
          activeColor: const Color(0xFF1E293B),
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Colors.black26),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        const Text('Remember me'),
        const Spacer(),
        TextButton(
          onPressed: onForgotPasswordTap,
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}
