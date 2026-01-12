import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/forgot_password/domain/usecase/verify_otp_usecase.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view/reset_password_view.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_viewmodel.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_event.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_state.dart';

class VerifyOtpViewModel extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;

  VerifyOtpViewModel(this._verifyOtpUseCase) : super(VerifyOtpState.initial()) {
    on<SubmitVerifyOtpEvent>(_onSubmitVerifyOtp);
    on<NavigateToResetPasswordViewEvent>(_navigateToResetPassword);
  }

  Future<void> _onSubmitVerifyOtp(
    SubmitVerifyOtpEvent event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(email: event.email, otp: event.otp),
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
            message: "Code Verified",
          );
          add(
            NavigateToResetPasswordViewEvent(
              context: event.context,
              email: event.email,
              otp: event.otp,
            ),
          );
        }
      },
    );
  }

  void _navigateToResetPassword(
    NavigateToResetPasswordViewEvent event,
    Emitter<VerifyOtpState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => locator<ResetPasswordViewModel>(),
            child: ResetPasswordView(email: event.email, otp: event.otp),
          ),
        ),
      );
    }
  }
}
