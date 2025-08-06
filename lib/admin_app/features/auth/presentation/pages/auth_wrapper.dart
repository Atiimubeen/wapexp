import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/admin_home_page.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:wapexp/splash_page.dart';
import 'package:wapexp/user_app/presentation/pages/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show splash only during initial state
        if (state is AuthInitial) {
          return const SplashPage();
        }

        // User is authenticated
        if (state is Authenticated) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.user.isAdmin
                ? AdminHomePage(user: state.user)
                : const HomePage(),
          );
        }

        // User is not authenticated or there's an error
        if (state is Unauthenticated) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: const WelcomePage(),
          );
        }

        // Loading state during login/signup operations
        if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Please wait...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        // Fallback to splash (should rarely happen)
        return const SplashPage();
      },
    );
  }
}
