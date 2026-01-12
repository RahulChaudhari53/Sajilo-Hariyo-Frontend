import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/core/common/my_snackbar.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_base_view.dart';
import 'package:sajilo_hariyo/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view/register_view.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/user_cubit/user_cubit.dart';
import 'package:sajilo_hariyo/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view/send_otp_view.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_viewmodel.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase _loginUserUseCase;
  final UserCubit _userCubit;

  LoginViewModel({
    required LoginUserUseCase loginUserUseCase,
    required UserCubit userCubit,
  })  : _loginUserUseCase = loginUserUseCase,
        _userCubit = userCubit,
        super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_navigateToRegisterView);
    on<NavigateToDashboardViewEvent>(_navigateToDashboardView);
    on<NavigateToForgotPasswordViewEvent>(_navigateToForgotPasswordView);
    on<LoginUserEvent>(_loginWithPhoneAndPassword);
  }

  void _navigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => locator<RegisterViewModel>(),
            child: const RegisterView(),
          ),
        ),
      );
    }
  }

  void _navigateToDashboardView(
    NavigateToDashboardViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    }
  }

  void _navigateToForgotPasswordView(
    NavigateToForgotPasswordViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => locator<SendOtpViewModel>(),
            child: const SendOtpView(),
          ),
        ),
      );
    }
  }

  Future<void> _loginWithPhoneAndPassword(
    LoginUserEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loginUserUseCase(
      LoginUserParams(phone: event.phone, password: event.password),
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
      (user) {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        // Update UserCubit with logged-in user
        _userCubit.updateUser(user);

        if (event.context.mounted) {
          // Route based on role
          if (user.role?.toLowerCase() == 'admin') {
            Navigator.pushReplacement(
              event.context,
              MaterialPageRoute(builder: (_) => const AdminBaseView()),
            );
          } else {
            add(NavigateToDashboardViewEvent(context: event.context));
          }
        }
      },
    );
  }
}
