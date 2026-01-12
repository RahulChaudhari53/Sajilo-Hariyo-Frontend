import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sajilo_hariyo/app/app.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  // Lock Orientation (Portrait only is standard for E-commerce)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Customize Status Bar (Top bar with battery/time)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Make status bar transparent so our Cream background goes to the top
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}
