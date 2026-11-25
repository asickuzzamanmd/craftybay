import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/services/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.loadToken();
  runApp(const CraftyBayApp());
}