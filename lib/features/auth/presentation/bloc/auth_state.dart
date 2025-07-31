import 'package:equatable/equatable.dart';
import 'package:wapexp/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

// Initial state, jab app shuru hoti hai
class AuthInitial extends AuthState {}

// Loading state, jab koi process ho raha ho (e.g., login)
class AuthLoading extends AuthState {}

// Authenticated state, jab user successfully login ho jaye
class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

// Unauthenticated state, jab user login na ho
class Unauthenticated extends AuthState {}

// Failure state, jab koi error aaye
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
