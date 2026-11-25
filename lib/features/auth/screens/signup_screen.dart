import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_state_controller.dart';
import 'otp_verify_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameTE = TextEditingController();
  final _lastNameTE = TextEditingController();
  final _emailTE = TextEditingController();
  final _passwordTE = TextEditingController();
  final _phoneTE = TextEditingController();
  final _cityTE = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _firstNameTE, decoration: const InputDecoration(labelText: 'First Name')),
            const SizedBox(height: 12),
            TextField(controller: _lastNameTE, decoration: const InputDecoration(labelText: 'Last Name')),
            const SizedBox(height: 12),
            TextField(controller: _emailTE, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _passwordTE, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 12),
            TextField(controller: _phoneTE, decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 12),
            TextField(controller: _cityTE, decoration: const InputDecoration(labelText: 'City')),
            const SizedBox(height: 20),
            GetBuilder<AuthStateController>(
              builder: (controller) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.inProgress
                        ? null
                        : () async {
                      final ok = await controller.signUp(
                        firstName: _firstNameTE.text.trim(),
                        lastName: _lastNameTE.text.trim(),
                        email: _emailTE.text.trim(),
                        password: _passwordTE.text.trim(),
                        phone: _phoneTE.text.trim(),
                        city: _cityTE.text.trim(),
                      );
                      if (ok) {
                        Get.to(() => OtpVerifyScreen(email: _emailTE.text.trim()));
                      } else {
                        Get.snackbar('Signup Failed', controller.errorMessage ?? 'Try again');
                      }
                    },
                    child: controller.inProgress
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign Up'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}