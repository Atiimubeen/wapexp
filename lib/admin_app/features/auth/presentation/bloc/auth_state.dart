import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated({required this.user});
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  // **THE FIX IS HERE:** Ab error message iske andar aayega
  final String? message;
  const Unauthenticated({this.message});
  @override
  List<Object?> get props => [message];
}
