// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LogInUseCase _logInUseCase;
  final LogOutUseCase _logOutUseCase;
  final GetUserStreamUseCase _getUserStreamUseCase;
  StreamSubscription? _userSubscription;

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
    // Use the now public UserChanged event
    on<UserChanged>(_onUserChanged);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _userSubscription?.cancel();
      _userSubscription = _getUserStreamUseCase().listen(
        // Add the public UserChanged event
        (user) => add(UserChanged(user)),
      );
    } catch (error) {
      print("App start error: $error");
      emit(
        const Unauthenticated(message: "Failed to initialize authentication"),
      );
    }
  }

  // Use the public UserChanged event type in the handler signature
  void _onUserChanged(UserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(user: event.user!));
    } else {
      // This is the core logic fix:
      // Only transition to a blank Unauthenticated state if we aren't already in one.
      // This preserves any existing error messages.
      if (state is! Unauthenticated) {
        emit(const Unauthenticated());
      }
    }
  }

  // ... (The rest of your BLoC methods like _onSignUp, _onLogIn, etc., remain the same)
  Future<void> _onSignUp(
    SignUpButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      final result = await _signUpUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
        image: event.image,
      );
      result.fold(
        (failure) => emit(Unauthenticated(message: failure.message)),
        (_) {}, // On success, do nothing. The stream will handle it.
      );
    } catch (error) {
      emit(Unauthenticated(message: "Signup failed: ${error.toString()}"));
    }
  }

  Future<void> _onLogIn(
    LogInButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      final result = await _logInUseCase(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(Unauthenticated(message: failure.message)),
        (_) {}, // On success, do nothing. The stream will handle it.
      );
    } catch (error) {
      emit(Unauthenticated(message: "Login failed: ${error.toString()}"));
    }
  }

  Future<void> _onLogOut(
    LogOutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _logOutUseCase();
    } catch (error) {
      print("Logout error: $error");
      emit(
        const Unauthenticated(
          message: "Logout failed, but you've been signed out locally",
        ),
      );
    }
  }

  void _onClearAuthMessage(ClearAuthMessage event, Emitter<AuthState> emit) {
    if (state is Unauthenticated) {
      emit(const Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
