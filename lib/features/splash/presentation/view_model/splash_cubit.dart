import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sajilo_hariyo/app/shared_pref/token_shared_pref.dart';
import 'package:sajilo_hariyo/app/shared_pref/user_shared_pref.dart';
import 'package:sajilo_hariyo/core/enums/user_role.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_base_view.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_hariyo/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:sajilo_hariyo/features/onboarding/presentation/view/onboarding_view.dart';

class SplashCubit extends Cubit<void> {
  final TokenSharedPref _tokenSharedPref;
  final UserSharedPref _userSharedPref;

  SplashCubit(
    this._tokenSharedPref,
    this._userSharedPref,
  ) : super(null);

  Future<void> init(BuildContext context) async {
    // 1. Simulate Splash Delay
    await Future.delayed(const Duration(seconds: 2));

    // 2. Check Logic
    // We assume isFirstTime is true if null (default behavior in SharedPref helper)
    final isFirstTime = _tokenSharedPref.isFirstTime();

    // Check for Token
    final tokenResult = await _tokenSharedPref.getToken();
    final isLoggedIn = tokenResult.fold(
      (failure) => false,
      (token) => token.isNotEmpty,
    );

    // Get user role if logged in
    UserRole? userRole;
    if (isLoggedIn) {
      userRole = _userSharedPref.getStoredRole();
    }

    // 3. Navigate directly using Context
    if (context.mounted) {
      if (isFirstTime) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingView()),
        );
      } else if (isLoggedIn) {
        // Route based on role
        if (userRole == UserRole.admin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminBaseView()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardView()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      }
    }
  }
}
