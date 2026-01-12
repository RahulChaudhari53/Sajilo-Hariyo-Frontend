import 'package:flutter/material.dart';

@immutable
sealed class ResetPasswordEvent {}

class SubmitResetPasswordEvent extends ResetPasswordEvent {
  final BuildContext context;
  final String email;
  final String otp;
  final String password;

  SubmitResetPasswordEvent({
    required this.context,
    required this.email,
    required this.otp,
    required this.password,
  });
}

class NavigateToLoginEvent extends ResetPasswordEvent {
  final BuildContext context;
  NavigateToLoginEvent({required this.context});
}