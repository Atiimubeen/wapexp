// lib/features/auth/presentation/bloc/auth_event.dart

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Event triggered when app starts
class AppStarted extends AuthEvent {}

// Event when user clicks signup button
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

// Event when user clicks login button
class LogInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LogInButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Event when user clicks logout button
class LogOutButtonPressed extends AuthEvent {}

// Event to clear auth error messages
class ClearAuthMessage extends AuthEvent {}

// =================================================================
// THE FIX IS HERE: Made the event public by removing the underscore.
// This event is for internal BLoC use when the auth state stream changes.
// =================================================================
class UserChanged extends AuthEvent {
  final UserEntity? user;

  const UserChanged(this.user);

  @override
  List<Object?> get props => [user];
}
