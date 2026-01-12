import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../repository/user_repository.dart';

class UpdateProfileParams extends Equatable {
  final UserEntity user;
  final File? image;

  const UpdateProfileParams({required this.user, this.image});

  @override
  List<Object?> get props => [user, image];
}

class UpdateProfileUseCase
    implements UsecaseWithParams<UserEntity, UpdateProfileParams> {
  final IUserRepository repository;
  UpdateProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.user, image: params.image);
  }
}
