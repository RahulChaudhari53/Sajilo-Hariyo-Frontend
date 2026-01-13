import 'package:flutter/material.dart';

@immutable
sealed class VerifyOtpEvent {}

class SubmitVerifyOtpEvent extends VerifyOtpEvent {
  final BuildContext context;
  final String email;
  final String otp;

  SubmitVerifyOtpEvent({
    required this.context,
    required this.email,
    required this.otp,
  });
}

class NavigateToResetPasswordViewEvent extends VerifyOtpEvent {
  final BuildContext context;
  final String email;
  final String otp;

  NavigateToResetPasswordViewEvent({
    required this.context,
    required this.email,
    required this.otp,
  });
}

class ResendOtpEvent extends VerifyOtpEvent {
  final BuildContext context;
  final String email;

  ResendOtpEvent({
    required this.context,
    required this.email,
  });
}
