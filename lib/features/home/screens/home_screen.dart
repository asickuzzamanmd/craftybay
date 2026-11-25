import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../../../core/services/auth_controller.dart';
import '../../auth/screens/login_screen.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../product/screens/product_details_screen.dart';
import '../../product/screens/product_list_by_category_screen.dart';
import '../controllers/home_controller.dart';
import '../models/home_models.dart';
import 'category_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentSlide = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    Get.find<HomeController>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CraftyBay',
          style: TextStyle(color: AppColors.themeColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.themeColor),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await AuthController.clearToken();
              Get.offAll(() => const LoginScreen());
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: controller.loadHomeData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  if (controller.sliders.isNotEmpty) _buildCarousel(controller.sliders),
                  const SizedBox(height: 20),
                  _sectionHeader('All Categories', () => Get.to(() => const CategoryListScreen())),
                  const SizedBox(height: 12),
                  _buildCategoryList(controller.categories),
                  const SizedBox(height: 20),
                  _sectionHeader('Popular', () {}),
                  const SizedBox(height: 12),
                  _buildHorizontalProductList(controller.products),
                  const SizedBox(height: 20),
                  _sectionHeader('Special', () {}),
                  const SizedBox(height: 12),
                  _buildHorizontalProductList(controller.products.reversed.toList()),
                  const SizedBox(height: 20),
                  _sectionHeader('New', () {}),
                  const SizedBox(height: 12),
                  _buildHorizontalProductList(controller.products),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCarousel(List<SliderModel> sliders) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 170,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, _) => _currentSlide.value = index,
          ),
          items: sliders.map((slide) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(10),
                image: slide.photoUrl.isNotEmpty
                    ? DecorationImage(image: NetworkImage(slide.photoUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.25),
                ),
                alignment: Alignment.bottomLeft,
                child: Text(
                  slide.description,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<int>(
          valueListenable: _currentSlide,
          builder: (_, current, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(sliders.length, (i) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: current == i ? AppColors.themeColor : Colors.grey.shade300,
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All', style: TextStyle(color: AppColors.themeColor)),
        ),
      ],
    );
  }

  Widget _buildCategoryList(List<CategoryModel> categories) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final cat = categories[index];
          return InkWell(
            onTap: () => Get.to(
                  () => ProductListByCategoryScreen(categoryId: cat.id, categoryName: cat.title),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.themeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: cat.icon.isNotEmpty
                      ? Image.network(
                    cat.icon,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.category, color: AppColors.themeColor),
                  )
                      : const Icon(Icons.category, color: AppColors.themeColor),
                ),
                const SizedBox(height: 6),
                Text(cat.title, style: const TextStyle(fontSize: 12, color: AppColors.themeColor)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalProductList(List<ProductModel> products) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) => SizedBox(
          width: 155,
          child: _productCard(products[index]),
        ),
      ),
    );
  }

  Widget _productCard(ProductModel product) {
    final imageUrl = product.photos.isNotEmpty ? product.photos.first : '';
    return InkWell(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.themeColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                )
                    : const Icon(Icons.shopping_bag, size: 40, color: AppColors.themeColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '৳${product.currentPrice}',
                        style: const TextStyle(
                          color: AppColors.themeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final ok = await Get.find<CartController>().addToCart(product.id);
                          Get.snackbar(
                            ok ? 'Added' : 'Error',
                            ok ? '${product.title} added to cart' : 'Please login first',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.themeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}