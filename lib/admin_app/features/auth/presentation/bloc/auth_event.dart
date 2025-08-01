import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Event jab user signup button par click karega
class SignUpButtonPressed extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final File? image;

  const SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.password,
    this.image,
  });

  @override
  List<Object?> get props => [name, email, password, image];
}

// Event jab user login button par click karega
class LogInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LogInButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Event jab user logout button par click karega
class LogOutButtonPressed extends AuthEvent {
  const LogOutButtonPressed();
}

// Event jo app start hone par user ka status check karega
class AuthStateChanged extends AuthEvent {
  final dynamic user; // Can be UserEntity or null
  const AuthStateChanged({this.user});

  @override
  List<Object?> get props => [user];
}
