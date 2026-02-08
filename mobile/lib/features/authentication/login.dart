import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../widgets/cutomButton.dart';
import '../widgets/forgot_password_dialog.dart';
import 'signup.dart';
import '../widgets/customTextField.dart';
import '../widgets/headerText.dart';
import '../widgets/rememberMeForgotPassword.dart';
import '../widgets/signUpLink.dart';
import '../widgets/backgroundWithPattern.dart';
import '../services/StudentStore.dart';
import '../dashboard/dashboard_page.dart';
import '../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Get all saved students
    final students = Studentstore.instance.getAll();

    // Check if email and password match any saved student
    final matchedStudent = students.firstWhereOrNull(
      (student) =>
          student.email == _emailController.text.trim() &&
          student.password == _passwordController.text,
    );

    if (matchedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: AppColors.error,
        ),
      );
      debugPrint('Login failed - Invalid credentials');
      return;
    }

    debugPrint('Login successful for: ${matchedStudent.email}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome back, ${matchedStudent.first_name}!',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate to Dashboard
    final displayName =
        '${matchedStudent.first_name} ${matchedStudent.last_name}'.trim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          displayName: displayName.isEmpty ? 'User' : displayName,
          firstName: matchedStudent.first_name,
          lastName: matchedStudent.last_name,
          email: matchedStudent.email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundWithPattern(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HeaderText(
                      title: 'Welcome Back',
                      subtitle: 'Login to your account to continue',
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 28),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'Invalid email'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        showToggleIcon: true,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      RememberMeForgotPassword(
                        rememberMe: _rememberMe,
                        onRememberMeChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        onForgotPasswordTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const ForgotPasswordDialog(),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Login',
                        onPressed: _login,
                        textColor: AppColors.primaryWhite,
                        backgroundColor: AppColors.primaryDark,
                      ),
                      const SizedBox(height: 12),
                      SignUpLink(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}