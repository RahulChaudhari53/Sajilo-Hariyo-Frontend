import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/shared_pref/user_shared_pref.dart';
import 'package:sajilo_hariyo/core/enums/user_role.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';

// States
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoaded extends UserState {
  final UserEntity user;
  final UserRole role;

  const UserLoaded({required this.user, required this.role});

  @override
  List<Object?> get props => [user, role];
}

class UserNotLoaded extends UserState {
  const UserNotLoaded();
}

// Cubit
class UserCubit extends Cubit<UserState> {
  final UserSharedPref _userSharedPref;

  UserCubit(this._userSharedPref) : super(const UserInitial()) {
    loadUser();
  }

  Future<void> loadUser() async {
    final result = await _userSharedPref.getUser();
    result.fold((failure) => emit(const UserNotLoaded()), (user) {
      final role = UserRole.fromString(user.role);
      emit(UserLoaded(user: user, role: role));
    });
  }

  void updateUser(UserEntity user) {
    final role = UserRole.fromString(user.role);
    _userSharedPref.saveUser(user);
    emit(UserLoaded(user: user, role: role));
  }

  Future<void> clearUser() async {
    await _userSharedPref.clearUser();
    emit(const UserNotLoaded());
  }

  UserRole? getCurrentRole() {
    return _userSharedPref.getStoredRole();
  }
}
