import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LogInUseCase _logInUseCase;
  final LogOutUseCase _logOutUseCase;
  final GetUserStreamUseCase _getUserStreamUseCase;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required LogInUseCase logInUseCase,
    required LogOutUseCase logOutUseCase,
    required GetUserStreamUseCase getUserStreamUseCase,
  }) : _signUpUseCase = signUpUseCase,
       _logInUseCase = logInUseCase,
       _logOutUseCase = logOutUseCase,
       _getUserStreamUseCase = getUserStreamUseCase,
       super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpButtonPressed>(_onSignUp);
    on<LogInButtonPressed>(_onLogIn);
    on<LogOutButtonPressed>(_onLogOut);
    on<ClearAuthMessage>(_onClearAuthMessage);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    await emit.forEach(
      _getUserStreamUseCase(),
      onData: (user) {
        print("User stream updated: ${user?.email}");
        return user != null
            ? Authenticated(user: user)
            : const Unauthenticated();
      },
      onError: (error, _) {
        print("User stream error: $error");
        return const Unauthenticated();
      },
    );
  }

  Future<void> _onSignUp(
    SignUpButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signUpUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
      image: event.image,
    );

    // **THE FIX IS HERE:** We only handle the failure case.
    // On success, the stream listener in _onAppStarted will handle the state change.
    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => throw Exception());
      emit(Unauthenticated(message: failure.message));
    }
  }

  Future<void> _onLogIn(
    LogInButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logInUseCase(
      email: event.email,
      password: event.password,
    );

    // **THE FIX IS HERE:** We only handle the failure case.
    // On success, the stream listener in _onAppStarted will handle the state change.
    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => throw Exception());
      emit(Unauthenticated(message: failure.message));
    }
  }

  // **REMOVE THIS:** This method is no longer needed.
  // Future<void> _handleAuthSuccess(UserEntity user, Emitter<AuthState> emit) async {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   emit(Authenticated(user: user));
  // }

  Future<void> _onLogOut(
    LogOutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _logOutUseCase();
    // The stream listener will also catch this and emit Unauthenticated,
    // but emitting it here directly can make the UI update faster.
    emit(const Unauthenticated());
  }

  void _onClearAuthMessage(ClearAuthMessage event, Emitter<AuthState> emit) {
    if (state is Unauthenticated) {
      emit(const Unauthenticated());
    }
  }
}
