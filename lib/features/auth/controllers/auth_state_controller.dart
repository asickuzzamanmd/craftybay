import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/auth_controller.dart';
import '../../../core/services/network_caller.dart';

class AuthStateController extends GetxController {
  bool inProgress = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    inProgress = true;
    update();

    final res = await NetworkCaller.postRequest(
      Urls.loginUrl,
      body: {"email": email, "password": password},
    );

    inProgress = false;
    if (res.isSuccess) {
      final token = res.responseData['data']['token'];
      await AuthController.saveToken(token);
      update();
      return true;
    } else {
      errorMessage = res.errorMessage;
      update();
      return false;
    }
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String city,
  }) async {
    inProgress = true;
    update();

    final res = await NetworkCaller.postRequest(
      Urls.signupUrl,
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "city": city,
      },
    );

    inProgress = false;
    errorMessage = res.isSuccess ? null : res.errorMessage;
    update();
    return res.isSuccess;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    inProgress = true;
    update();

    final res = await NetworkCaller.postRequest(
      Urls.verifyOtpUrl,
      body: {"email": email, "otp": otp}, // Static OTP "1234"
    );

    inProgress = false;
    if (res.isSuccess) {
      final token = res.responseData['data']?['token'];
      if (token != null) await AuthController.saveToken(token);
      update();
      return true;
    } else {
      errorMessage = res.errorMessage;
      update();
      return false;
    }
  }
}