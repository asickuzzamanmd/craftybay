import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network_caller.dart';

class WishlistItemModel {
  final String id;
  final String productId;
  final String title;
  final String image;
  final num price;

  WishlistItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final prod = json['product'] is Map ? json['product'] : {};
    final photos = prod['photos'] as List? ?? [];
    return WishlistItemModel(
      id: json['_id'] ?? '',
      productId: prod['_id'] ?? '',
      title: prod['title'] ?? 'Product',
      image: photos.isNotEmpty ? photos.first.toString() : '',
      price: prod['current_price'] ?? 0,
    );
  }
}

class WishlistController extends GetxController {
  bool isLoading = false;
  List<WishlistItemModel> wishlistItems = [];

  Future<void> getWishlist() async {
    isLoading = true;
    update();

    final res = await NetworkCaller.getRequest(Urls.wishlistUrl);
    if (res.isSuccess) {
      final list = res.responseData['data']?['results'] ?? res.responseData['data'] ?? [];
      wishlistItems = (list as List).map((e) => WishlistItemModel.fromJson(e)).toList();
    }

    isLoading = false;
    update();
  }

  Future<bool> addToWishlist(String productId) async {
    final res = await NetworkCaller.postRequest(
      Urls.wishlistUrl,
      body: {"product": productId},
    );
    if (res.isSuccess) {
      await getWishlist();
      return true;
    }
    return false;
  }

  Future<void> removeFromWishlist(String wishlistItemId) async {
    final res = await NetworkCaller.deleteRequest(Urls.wishlistItemUrl(wishlistItemId));
    if (res.isSuccess) {
      wishlistItems.removeWhere((e) => e.id == wishlistItemId);
      update();
    }
  }
}