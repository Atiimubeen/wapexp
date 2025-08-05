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
        if (state is Authenticated) {
          // Agar user login hai, to role check karo
          if (state.user.isAdmin) {
            return AdminHomePage(user: state.user);
          } else {
            return const HomePage();
          }
        }
        if (state is Unauthenticated) {
          // Agar user login nahi hai, to WelcomePage dikhao
          return const WelcomePage();
        }
        // Jab tak state confirm na ho (AuthInitial) ya loading ho rahi ho, SplashPage dikhao
        return const SplashPage();
      },
    );
  }
}
