import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/screens/main_bottom_nav_screen.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameTE = TextEditingController();
  final _addressTE = TextEditingController();
  final _cityTE = TextEditingController();
  final _postalTE = TextEditingController();
  final _phoneTE = TextEditingController();
  String _paymentMethod = 'ssl';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameTE,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v!.trim().isEmpty ? 'Enter full name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressTE,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v!.trim().isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityTE,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (v) => v!.trim().isEmpty ? 'Enter city' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _postalTE,
                decoration: const InputDecoration(labelText: 'Postal Code'),
                validator: (v) => v!.trim().isEmpty ? 'Enter postal code' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneTE,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => v!.trim().isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 16),
              RadioListTile(
                title: const Text('Online Payment (SSLCommerz)'),
                value: 'ssl',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              RadioListTile(
                title: const Text('Cash on Delivery (COD)'),
                value: 'cod',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 20),
              GetBuilder<OrderController>(
                builder: (controller) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.inProgress
                          ? null
                          : () async {
                        if (!_formKey.currentState!.validate()) return;
                        final ok = await controller.createOrder(
                          paymentMethod: _paymentMethod,
                          fullName: _nameTE.text.trim(),
                          address: _addressTE.text.trim(),
                          city: _cityTE.text.trim(),
                          postalCode: _postalTE.text.trim(),
                          phone: _phoneTE.text.trim(),
                        );
                        if (ok) {
                          await Get.find<CartController>().getCartList();
                          Get.snackbar('Success', 'Order placed successfully!');
                          Get.offAll(() => const MainBottomNavScreen());
                        } else {
                          Get.snackbar('Failed', controller.errorMessage ?? 'Order failed');
                        }
                      },
                      child: controller.inProgress
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Confirm Order & Pay'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}