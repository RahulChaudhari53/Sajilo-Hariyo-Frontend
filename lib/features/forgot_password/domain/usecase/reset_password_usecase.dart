import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  final String email;
  final String otp;
  final String password;

  const ResetPasswordParams({
    required this.email,
    required this.otp,
    required this.password,
  });

  @override
  List<Object?> get props => [email, otp, password];
}

class ResetPasswordUseCase
    implements UsecaseWithParams<void, ResetPasswordParams> {
  final IAuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      params.email,
      params.otp,
      params.password,
    );
  }
}
