import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';

class SendOtpParams extends Equatable {
  final String email;

  const SendOtpParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class SendOtpUseCase implements UsecaseWithParams<void, SendOtpParams> {
  final IAuthRepository repository;

  SendOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.email);
  }
}
