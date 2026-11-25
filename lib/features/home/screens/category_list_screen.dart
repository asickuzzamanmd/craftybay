import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../../product/screens/product_list_by_category_screen.dart';
import '../controllers/home_controller.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, index) {
              final cat = controller.categories[index];
              return InkWell(
                onTap: () => Get.to(
                      () => ProductListByCategoryScreen(
                    categoryId: cat.id,
                    categoryName: cat.title,
                  ),
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
                    Text(
                      cat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.themeColor),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}