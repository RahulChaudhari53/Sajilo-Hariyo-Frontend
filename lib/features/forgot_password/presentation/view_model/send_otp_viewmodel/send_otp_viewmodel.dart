import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/forgot_password/domain/usecase/send_otp_usecase.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view/verify_otp_view.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_event.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_state.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_viewmodel.dart';

class SendOtpViewModel extends Bloc<SendOtpEvent, SendOtpState> {
  final SendOtpUseCase _sendOtpUseCase;

  SendOtpViewModel(this._sendOtpUseCase) : super(SendOtpState.initial()) {
    on<RequestOtpEvent>(_onRequestOtp);
    on<NavigateToVerifyOtpViewEvent>(_navigateToVerifyView);
  }

  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<SendOtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _sendOtpUseCase(SendOtpParams(email: event.email));

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
            message: "OTP Sent Successfully",
          );
          add(
            NavigateToVerifyOtpViewEvent(
              context: event.context,
              email: event.email,
            ),
          );
        }
      },
    );
  }

  void _navigateToVerifyView(
    NavigateToVerifyOtpViewEvent event,
    Emitter<SendOtpState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => locator<VerifyOtpViewModel>(),
            child: VerifyOtpView(
              email: event.email,
            ), // We need to create this View next
          ),
        ),
      );
    }
  }
}
