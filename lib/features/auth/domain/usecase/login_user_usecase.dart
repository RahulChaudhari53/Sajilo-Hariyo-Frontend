import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';

class LoginUserParams extends Equatable {
  final String phone;
  final String password;

  const LoginUserParams({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

class LoginUserUseCase implements UsecaseWithParams<UserEntity, LoginUserParams> {
  final IAuthRepository repository;

  LoginUserUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(LoginUserParams params) async {
    return await repository.loginUser(params.phone, params.password);
  }
}
