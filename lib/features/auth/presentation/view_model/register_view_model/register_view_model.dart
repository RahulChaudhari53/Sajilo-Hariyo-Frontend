import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase _registerUserUseCase;

  RegisterViewModel({required RegisterUserUseCase registerUserUseCase})
    : _registerUserUseCase = registerUserUseCase,
      super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterEvent);
  }

  Future<void> _onRegisterEvent(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final params = RegisterUserParams(
      name: event.name,
      email: event.email,
      phone: event.phone,
      password: event.password,
    );

    final result = await _registerUserUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(isLoading: false, isSuccess: true, errorMessage: null),
        );
      },
    );
  }
}
