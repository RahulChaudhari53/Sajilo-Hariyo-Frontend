import 'package:equatable/equatable.dart';

class SendOtpState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const SendOtpState({required this.isLoading, required this.isSuccess});

  factory SendOtpState.initial() =>
      const SendOtpState(isLoading: false, isSuccess: false);

  SendOtpState copyWith({bool? isLoading, bool? isSuccess}) {
    return SendOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
}
