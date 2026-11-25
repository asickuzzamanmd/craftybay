import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../../../core/services/auth_controller.dart';
import '../../home/screens/main_bottom_nav_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (AuthController.isLoggedIn) {
        Get.offAll(() => const MainBottomNavScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 80, color: AppColors.themeColor),
            SizedBox(height: 12),
            Text(
              'CraftyBay',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.themeColor),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.themeColor),
          ],
        ),
      ),
    );
  }
}