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
        if (state is AuthLoading) {
          return const SplashPage();
        }
        if (state is Authenticated) {
          // Schedule navigation cleanup for the next frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          });

          if (state.user.isAdmin) {
            return AdminHomePage(user: state.user);
          } else {
            return const HomePage();
          }
        }
        return const WelcomePage();
      },
    );
  }
}
