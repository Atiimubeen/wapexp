import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Event jo app shuru hote hi bheja jayega
class AppStarted extends AuthEvent {}

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
}

// Event jab user login button par click karega
class LogInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LogInButtonPressed({required this.email, required this.password});
}

// Event jab user logout button par click karega
class LogOutButtonPressed extends AuthEvent {}

// Add to your AuthEvent.dart
class ClearAuthMessage extends AuthEvent {}
