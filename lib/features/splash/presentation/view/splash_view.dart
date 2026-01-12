import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/splash/presentation/view_model/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Trigger the Context-Aware Logic
    context.read<SplashCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3ED), // Cream BG
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/logo/app_logo.png',
              ), // Adjusted path to match previous steps
            ),
            const SizedBox(height: 20),
            // Spinner
            const CircularProgressIndicator(
              color: Color(0xFF3A7F5F), // Primary Green
            ),
          ],
        ),
      ),
    );
  }
}
