import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';

class VerifyOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class VerifyOtpUseCase implements UsecaseWithParams<void, VerifyOtpParams> {
  final IAuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.email, params.otp);
  }
}
