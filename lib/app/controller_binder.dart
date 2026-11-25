import 'package:get/get.dart';
import '../features/auth/controllers/auth_state_controller.dart';
import '../features/cart/controllers/cart_controller.dart';
import '../features/cart/controllers/order_controller.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/product/controllers/product_controller.dart';
import '../features/wishlist/controllers/wishlist_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthStateController());
    Get.put(HomeController());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(WishlistController());
    Get.put(OrderController());
  }
}