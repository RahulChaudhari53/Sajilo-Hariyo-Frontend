import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? user;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
