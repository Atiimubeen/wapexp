import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/features/auth/presentation/pages/auth_wrapper.dart';

import 'package:wapexp/injection_container.dart';

Future<void> main() async {
  // Ensure Flutter is ready before doing anything else.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated options file.
  await Firebase.initializeApp();

  // Set up our manual dependency injection container.
  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the AuthBloc to the entire widget tree below it.
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp(
        title: 'Wapexp Admin',
        debugShowCheckedModeBanner: false, // Hides the debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.green),
          ),
        ),
        // The AuthWrapper will decide which screen to show based on login state.
        home: const AuthWrapper(),
      ),
    );
  }
}
