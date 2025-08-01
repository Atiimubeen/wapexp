import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';

abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionActionSuccess extends SessionState {
  final String message;
  const SessionActionSuccess({required this.message});
}

class SessionsLoaded extends SessionState {
  final List<SessionEntity> sessions;
  const SessionsLoaded({required this.sessions});
}

class SessionFailure extends SessionState {
  final String message;
  const SessionFailure({required this.message});
}
