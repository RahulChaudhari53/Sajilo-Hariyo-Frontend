import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_hariyo/features/forgot_password/domain/usecase/reset_password_usecase.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_event.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_state.dart';

class ResetPasswordViewModel
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordViewModel(this._resetPasswordUseCase)
    : super(ResetPasswordState.initial()) {
    on<SubmitResetPasswordEvent>(_onSubmitResetPassword);
    on<NavigateToLoginEvent>(_navigateToLogin);
  }

  Future<void> _onSubmitResetPassword(
    SubmitResetPasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        email: event.email,
        otp: event.otp,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        if (event.context.mounted) {
          MySnackBar.showError(
            context: event.context,
            message: failure.message,
          );
        }
      },
      (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        if (event.context.mounted) {
          MySnackBar.showSuccess(
            context: event.context,
            message: "Password Reset Successful",
          );
          add(NavigateToLoginEvent(context: event.context));
        }
      },
    );
  }

  void _navigateToLogin(
    NavigateToLoginEvent event,
    Emitter<ResetPasswordState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ), // Correct reference to Login
        (route) => false,
      );
    }
  }
}
