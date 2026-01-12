import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/app/shared_pref/token_shared_pref.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_hariyo/features/onboarding/presentation/view_model/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final TokenSharedPref _tokenSharedPref;

  OnboardingCubit(this._tokenSharedPref) : super(OnboardingState.initial());

  void onPageChanged(int index) {
    emit(state.copyWith(index: index));
  }

  Future<void> navigateToLogin(BuildContext context) async {
    // 1. Save the flag so onboarding doesn't show again
    await _tokenSharedPref.saveFirstTime();

    // 2. Direct Navigation
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }
}
