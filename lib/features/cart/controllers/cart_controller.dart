import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network_caller.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String title;
  final String image;
  final num price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final prod = json['product'] is Map ? json['product'] : {};
    final photos = prod['photos'] as List? ?? [];
    return CartItemModel(
      id: json['_id'] ?? '',
      productId: prod['_id'] ?? '',
      title: prod['title'] ?? 'Product',
      image: photos.isNotEmpty ? photos.first.toString() : '',
      price: prod['current_price'] ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
    );
  }
}

class CartController extends GetxController {
  bool isLoading = false;
  List<CartItemModel> cartItems = [];

  num get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> getCartList() async {
    isLoading = true;
    update();

    final res = await NetworkCaller.getRequest(Urls.cartUrl);
    if (res.isSuccess) {
      final list = res.responseData['data']?['results'] ?? res.responseData['data'] ?? [];
      cartItems = (list as List).map((e) => CartItemModel.fromJson(e)).toList();
    }

    isLoading = false;
    update();
  }

  Future<bool> addToCart(String productId) async {
    final res = await NetworkCaller.postRequest(
      Urls.cartUrl,
      body: {"product": productId, "quantity": 1},
    );
    if (res.isSuccess) {
      await getCartList();
      return true;
    }
    return false;
  }

  Future<void> updateQuantity(String cartItemId, int newQty) async {
    if (newQty < 1) return;
    final res = await NetworkCaller.patchRequest(
      Urls.cartItemUrl(cartItemId),
      body: {"quantity": newQty},
    );
    if (res.isSuccess) {
      final index = cartItems.indexWhere((e) => e.id == cartItemId);
      if (index != -1) {
        cartItems[index].quantity = newQty;
        update();
      }
    }
  }

  Future<void> deleteCartItem(String cartItemId) async {
    final res = await NetworkCaller.deleteRequest(Urls.cartItemUrl(cartItemId));
    if (res.isSuccess) {
      cartItems.removeWhere((e) => e.id == cartItemId);
      update();
    }
  }
}