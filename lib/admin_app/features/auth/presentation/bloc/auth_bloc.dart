import 'dart:async';
import 'dart:io';
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
  late StreamSubscription _userSubscription;

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
    // User ke authentication status ko musalsal sunna
    _userSubscription = _getUserStreamUseCase().listen((user) {
      add(AuthStateChanged(user: user));
    });

    on<AuthStateChanged>((event, emit) {
      if (event.user != null) {
        emit(Authenticated(user: event.user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignUpButtonPressed>(_onSignUpButtonPressed);
    on<LogInButtonPressed>(_onLogInButtonPressed);
    on<LogOutButtonPressed>(_onLogOutButtonPressed);
  }

  Future<void> _onSignUpButtonPressed(
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
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => null, // Success is handled by the AuthStateChanged stream
    );
  }

  Future<void> _onLogInButtonPressed(
    LogInButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logInUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => null, // Success is handled by the AuthStateChanged stream
    );
  }

  Future<void> _onLogOutButtonPressed(
    LogOutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    await _logOutUseCase();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
