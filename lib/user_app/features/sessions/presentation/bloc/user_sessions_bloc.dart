import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/sessions/domain/usecases/get_sessions_usecase.dart';
import 'user_sessions_event.dart';
import 'user_sessions_state.dart';

class UserSessionsBloc extends Bloc<UserSessionsEvent, UserSessionsState> {
  final GetSessionsUseCase _getSessionsUseCase;

  UserSessionsBloc({required GetSessionsUseCase getSessionsUseCase})
    : _getSessionsUseCase = getSessionsUseCase,
      super(UserSessionsInitial()) {
    on<LoadUserSessions>(_onLoadSessions);
  }

  Future<void> _onLoadSessions(
    LoadUserSessions event,
    Emitter<UserSessionsState> emit,
  ) async {
    emit(UserSessionsLoading());
    await emit.forEach(
      _getSessionsUseCase(),
      onData: (result) => result.fold(
        (failure) => UserSessionsFailure(message: failure.message),
        (sessions) => UserSessionsLoaded(sessions: sessions),
      ),
      onError: (error, stackTrace) =>
          const UserSessionsFailure(message: 'An error occurred.'),
    );
  }
}
