import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, phone, password];
}

class RegisterUserUseCase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUserUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    final userEntity = UserEntity(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      role: 'customer',
    );

    return repository.registerUser(userEntity);
  }
}
