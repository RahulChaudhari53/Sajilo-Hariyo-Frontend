import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/profile/domain/repository/user_repository.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/change_password_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository userRepository;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  ProfileBloc({
    required this.userRepository,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  }) : super(const ProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await userRepository.getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(status: ProfileStatus.failure, message: failure.message),
      ),
      (user) => emit(
        state.copyWith(status: ProfileStatus.success, user: user),
      ),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    // The usecase expects UpdateProfileParams. 
    // We need to check how the usecase is defined.
    // Assuming UpdateProfileUseCase.call takes UpdateProfileParams(user, image)
    
    final result = await updateProfileUseCase(
      UpdateProfileParams(user: event.user, image: event.imageFile),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ProfileStatus.failure, message: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          user: user,
          message: "Profile updated successfully",
        ),
      ),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    
    result.fold(
      (failure) => emit(
        state.copyWith(status: ProfileStatus.failure, message: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          message: "Password changed successfully",
        ),
      ),
    );
  }
}
