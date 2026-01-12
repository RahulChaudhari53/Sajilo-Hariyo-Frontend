import 'package:equatable/equatable.dart';

class VerifyOtpState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const VerifyOtpState({required this.isLoading, required this.isSuccess});

  factory VerifyOtpState.initial() =>
      const VerifyOtpState(isLoading: false, isSuccess: false);

  VerifyOtpState copyWith({bool? isLoading, bool? isSuccess}) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
}
