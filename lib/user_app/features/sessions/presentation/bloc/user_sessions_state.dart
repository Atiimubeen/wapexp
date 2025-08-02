import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';

abstract class UserSessionsState extends Equatable {
  const UserSessionsState();
  @override
  List<Object> get props => [];
}

class UserSessionsInitial extends UserSessionsState {}

class UserSessionsLoading extends UserSessionsState {}

class UserSessionsLoaded extends UserSessionsState {
  final List<SessionEntity> sessions;
  const UserSessionsLoaded({required this.sessions});
  @override
  List<Object> get props => [sessions];
}

class UserSessionsFailure extends UserSessionsState {
  final String message;
  const UserSessionsFailure({required this.message});
}
