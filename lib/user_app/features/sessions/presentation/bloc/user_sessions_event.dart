import 'package:equatable/equatable.dart';

abstract class UserSessionsEvent extends Equatable {
  const UserSessionsEvent();
  @override
  List<Object> get props => [];
}

class LoadUserSessions extends UserSessionsEvent {}
