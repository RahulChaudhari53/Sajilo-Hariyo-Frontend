import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UserEntity user;
  final File? imageFile;

  const UpdateProfileEvent({required this.user, this.imageFile});

  @override
  List<Object> get props => [user, imageFile ?? ''];
}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword];
}
