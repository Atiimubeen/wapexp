import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/sessions/domain/usecases/add_session_usecase.dart';
import 'package:wapexp/features/sessions/domain/usecases/delete_session_usecase.dart';
import 'package:wapexp/features/sessions/domain/usecases/get_sessions_usecase.dart';
import 'package:wapexp/features/sessions/domain/usecases/update_session_usecase.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final AddSessionUseCase _addSessionUseCase;
  final GetSessionsUseCase _getSessionsUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;
  final UpdateSessionUseCase _updateSessionUseCase;

  SessionBloc({
    required AddSessionUseCase addSessionUseCase,
    required GetSessionsUseCase getSessionsUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
    required UpdateSessionUseCase updateSessionUseCase,
  }) : _addSessionUseCase = addSessionUseCase,
       _getSessionsUseCase = getSessionsUseCase,
       _deleteSessionUseCase = deleteSessionUseCase,
       _updateSessionUseCase = updateSessionUseCase,
       super(SessionInitial()) {
    on<AddSessionButtonPressed>(_onAdd);
    on<LoadSessions>(_onLoad);
    on<DeleteSessionButtonPressed>(_onDelete);
    on<UpdateSessionButtonPressed>(_onUpdate);
  }

  Future<void> _onAdd(
    AddSessionButtonPressed event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    final result = await _addSessionUseCase(
      name: event.name,
      date: event.date,
      coverImage: event.coverImage,
      galleryImages: event.galleryImages,
    );
    result.fold(
      (failure) => emit(SessionFailure(message: failure.message)),
      (_) => emit(const SessionActionSuccess(message: 'Session Added!')),
    );
  }

  Future<void> _onLoad(LoadSessions event, Emitter<SessionState> emit) async {
    emit(SessionLoading());
    await emit.forEach(
      _getSessionsUseCase(),
      onData: (result) => result.fold(
        (failure) => SessionFailure(message: failure.message),
        (sessions) => SessionsLoaded(sessions: sessions),
      ),
    );
  }

  Future<void> _onDelete(
    DeleteSessionButtonPressed event,
    Emitter<SessionState> emit,
  ) async {
    final result = await _deleteSessionUseCase(event.session);
    result.fold(
      (failure) => emit(SessionFailure(message: failure.message)),
      (_) => emit(const SessionActionSuccess(message: 'Session Deleted!')),
    );
  }

  Future<void> _onUpdate(
    UpdateSessionButtonPressed event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    final result = await _updateSessionUseCase(event.session);
    result.fold(
      (failure) => emit(SessionFailure(message: failure.message)),
      (_) => emit(const SessionActionSuccess(message: 'Session Updated!')),
    );
  }
}
