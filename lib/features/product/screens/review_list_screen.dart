import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../controllers/product_controller.dart';

class ReviewListScreen extends StatefulWidget {
  final String productId;
  const ReviewListScreen({super.key, required this.productId});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final _commentTE = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    Get.find<ProductController>().getReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.reviews.isEmpty) {
            return const Center(child: Text('No reviews yet. Be the first!'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final review = controller.reviews[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.themeColor,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${review.rating}'),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(review.comment),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        onPressed: _showAddReviewDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: _rating,
              decoration: const InputDecoration(labelText: 'Rating'),
              items: [1, 2, 3, 4, 5]
                  .map((r) => DropdownMenuItem(value: r, child: Text('$r Stars')))
                  .toList(),
              onChanged: (v) => _rating = v ?? 5,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentTE,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final ok = await Get.find<ProductController>().createReview(
                productId: widget.productId,
                comment: _commentTE.text.trim(),
                rating: _rating,
              );
              _commentTE.clear();
              if (mounted) Navigator.pop(ctx);
              Get.snackbar(ok ? 'Success' : 'Error', ok ? 'Review added!' : 'Login required');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}