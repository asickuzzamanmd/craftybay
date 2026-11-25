import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/models/home_models.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.photos.isNotEmpty ? product.photos.first : '';
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    color: AppColors.themeColor.withOpacity(0.1),
                    child: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : const Icon(Icons.shopping_bag, size: 80, color: AppColors.themeColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(
                          product.description.isNotEmpty ? product.description : 'No description available.',
                          style: const TextStyle(color: Colors.black54, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.themeColor.withOpacity(0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price', style: TextStyle(fontSize: 12)),
                    Text(
                      '৳${product.currentPrice}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.themeColor),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ok = await Get.find<CartController>().addToCart(product.id);
                    Get.snackbar(ok ? 'Added' : 'Error', ok ? 'Added to cart!' : 'Please login first');
                  },
                  child: const Text('Add To Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}