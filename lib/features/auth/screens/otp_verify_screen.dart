import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../app/app_colors.dart';
import '../../home/screens/main_bottom_nav_screen.dart';
import '../controllers/auth_state_controller.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpTE = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP Code')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A 4-digit OTP code has been sent to ${widget.email} (Use: 1234)'),
            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _otpTE,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                activeColor: AppColors.themeColor,
                selectedColor: AppColors.themeColor,
                inactiveColor: Colors.grey,
              ),
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
                      final ok = await controller.verifyOtp(widget.email, _otpTE.text.trim());
                      if (ok) {
                        Get.offAll(() => const MainBottomNavScreen());
                      } else {
                        Get.snackbar('Failed', controller.errorMessage ?? 'Invalid OTP');
                      }
                    },
                    child: controller.inProgress
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verify & Continue'),
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