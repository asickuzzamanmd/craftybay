import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/urls.dart';
import '../../../core/services/network_caller.dart';

class OrderController extends GetxController {
  bool inProgress = false;
  String? errorMessage;

  Future<bool> createOrder({
    required String paymentMethod, // "ssl" or "cod"
    required String fullName,
    required String address,
    required String city,
    required String postalCode,
    required String phone,
  }) async {
    inProgress = true;
    update();

    final res = await NetworkCaller.postRequest(
      Urls.createOrderUrl,
      body: {
        "payment_method": paymentMethod,
        "shipping_address": {
          "full_name": fullName,
          "address": address,
          "city": city,
          "postal_code": postalCode,
          "phone": phone,
        },
        "redirect_url": "https://jsonplaceholder.typicode.com/posts",
      },
    );

    inProgress = false;
    if (res.isSuccess) {
      // Jodi payment_method "ssl" hoy, tahole gateway URL open hobe
      final paymentUrl = res.responseData['data']?['payment_url'] ??
          res.responseData['data']?['GatewayPageURL'];

      if (paymentMethod == 'ssl' && paymentUrl != null) {
        final uri = Uri.parse(paymentUrl);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      update();
      return true;
    } else {
      errorMessage = res.errorMessage;
      update();
      return false;
    }
  }
}