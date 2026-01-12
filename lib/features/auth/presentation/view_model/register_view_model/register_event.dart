import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

// when user clicks register button
class RegisterUserEvent extends RegisterEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterUserEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, phone, password];
}
