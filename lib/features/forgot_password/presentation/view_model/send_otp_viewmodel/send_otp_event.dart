import 'package:flutter/material.dart';

@immutable
sealed class SendOtpEvent {}

// Triggered when user clicks "Send OTP"
class RequestOtpEvent extends SendOtpEvent {
  final BuildContext context;
  final String email;

  RequestOtpEvent({required this.context, required this.email});
}

// Triggered to navigate to Verify Screen
class NavigateToVerifyOtpViewEvent extends SendOtpEvent {
  final BuildContext context;
  final String email;

  NavigateToVerifyOtpViewEvent({required this.context, required this.email});
}
