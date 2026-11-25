import 'package:get/get.dart';
import '../../../app/urls.dart';
import '../../../core/services/network_caller.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  List<SliderModel> sliders = [];
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  Future<void> loadHomeData() async {
    isLoading = true;
    update();

    await Future.wait([
      _fetchSliders(),
      _fetchCategories(),
      _fetchProducts(),
    ]);

    isLoading = false;
    update();
  }

  Future<void> _fetchSliders() async {
    final res = await NetworkCaller.getRequest(Urls.slidesUrl);
    if (res.isSuccess) {
      final list = res.responseData['data']?['results'] ?? res.responseData['data'] ?? [];
      sliders = (list as List).map((e) => SliderModel.fromJson(e)).toList();
    }
  }

  Future<void> _fetchCategories() async {
    final res = await NetworkCaller.getRequest(Urls.categoriesUrl);
    if (res.isSuccess) {
      final list = res.responseData['data']?['results'] ?? res.responseData['data'] ?? [];
      categories = (list as List).map((e) => CategoryModel.fromJson(e)).toList();
    }
  }

  Future<void> _fetchProducts() async {
    final res = await NetworkCaller.getRequest(Urls.productsUrl);
    if (res.isSuccess) {
      final list = res.responseData['data']?['results'] ?? res.responseData['data'] ?? [];
      products = (list as List).map((e) => ProductModel.fromJson(e)).toList();
    }
  }
}