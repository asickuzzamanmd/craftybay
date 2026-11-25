import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../../home/screens/main_bottom_nav_screen.dart';
import '../controllers/auth_state_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTE = TextEditingController();
  final _passwordTE = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.shopping_bag, size: 70, color: AppColors.themeColor),
              const SizedBox(height: 16),
              const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(controller: _emailTE, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordTE,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              GetBuilder<AuthStateController>(
                builder: (controller) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.inProgress
                          ? null
                          : () async {
                        final ok = await controller.login(
                          _emailTE.text.trim(),
                          _passwordTE.text.trim(),
                        );
                        if (ok) {
                          Get.offAll(() => const MainBottomNavScreen());
                        } else {
                          Get.snackbar('Login Failed', controller.errorMessage ?? 'Invalid credentials');
                        }
                      },
                      child: controller.inProgress
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.to(() => const SignUpScreen()),
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}