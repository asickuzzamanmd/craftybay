import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network_caller.dart';

class ReviewModel {
  final String id;
  final String userName;
  final String comment;
  final num rating;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map ? json['user'] : {};
    final first = user['first_name'] ?? '';
    final last = user['last_name'] ?? '';
    final fullName = '$first $last'.trim();
    return ReviewModel(
      id: json['_id'] ?? '',
      userName: fullName.isNotEmpty ? fullName : 'Customer',
      comment: json['comment'] ?? '',
      rating: num.tryParse(json['rating'].toString()) ?? 5,
    );
  }
}

class ProductController extends GetxController {
  bool isLoading = false;
  List<ReviewModel> reviews = [];

  Future<void> getReviews(String productId) async {
    isLoading = true;
    update();

    final res = await NetworkCaller.getRequest(Urls.reviewsByProduct(productId));
    if (res.isSuccess) {
      final list = res.responseData['data']?['results'] ?? res.responseData['data'] ?? [];
      reviews = (list as List).map((e) => ReviewModel.fromJson(e)).toList();
    }

    isLoading = false;
    update();
  }

  Future<bool> createReview({
    required String productId,
    required String comment,
    required int rating,
  }) async {
    isLoading = true;
    update();

    final res = await NetworkCaller.postRequest(
      Urls.createReviewUrl,
      body: {
        "product": productId,
        "comment": comment,
        "rating": rating.toString(),
      },
    );

    isLoading = false;
    if (res.isSuccess) {
      await getReviews(productId);
      return true;
    }
    update();
    return false;
  }
}