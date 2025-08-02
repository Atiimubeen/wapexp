import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Shuruaati state

    on<AppStarted>(_onAppStarted);
    on<SignUpButtonPressed>(_onSignUp);
    on<LogInButtonPressed>(_onLogIn);
    on<LogOutButtonPressed>(_onLogOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    // Jaise hi app shuru ho, user ke status ko sunna shuru kar do
    await emit.forEach(
      _getUserStreamUseCase(),
      onData: (user) {
        if (user != null) {
          return Authenticated(user: user);
        } else {
          return Unauthenticated();
        }
      },
      onError: (_, __) => Unauthenticated(),
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
    result.fold(
      (failure) {
        // Error aane par, wapas Unauthenticated state mein jao taake UI theek ho jaye
        emit(AuthFailure(message: failure.message));
        emit(Unauthenticated());
      },
      (
        _,
      ) {}, // Kamyab hone par kuch nahi karna, stream khud state update karegi
    );
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
    result.fold(
      (failure) {
        emit(AuthFailure(message: failure.message));
        emit(Unauthenticated());
      },
      (
        _,
      ) {}, // Kamyab hone par kuch nahi karna, stream khud state update karegi
    );
  }

  Future<void> _onLogOut(
    LogOutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    await _logOutUseCase();
    // Logout ke baad Unauthenticated state bhejne ki zaroorat nahi, stream khud handle karegi
  }
}
