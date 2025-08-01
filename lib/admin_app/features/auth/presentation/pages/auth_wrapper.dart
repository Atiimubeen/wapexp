import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/admin_home_page.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Agar user login hai to Admin Home Page dikhao
          return AdminHomePage(user: state.user);
        } else if (state is Unauthenticated || state is AuthFailure) {
          // Agar user login nahi hai ya koi error hai to Login Page dikhao
          return const LoginPage();
        }
        // Jab app shuru ho rahi ho to loading indicator dikhao
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
