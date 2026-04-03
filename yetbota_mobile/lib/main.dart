import 'package:flutter/material.dart';
import 'package:yetbota_mobile/app/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(await bootstrap());
}
