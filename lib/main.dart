import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/features/auth/presentation/pages/auth_wrapper.dart';

import 'package:wapexp/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp(
        title: 'Wapexp Admin',
        debugShowCheckedModeBanner: false,

        // ================= LIGHT THEME =================
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green.shade700,
            background: Colors.white,
            onBackground: Colors.black87, // Text color on background
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.green.shade800),
          ),
        ),

        // ================= DARK THEME =================
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
            primary: Colors.green.shade400,
            background: const Color(0xFF121212),
            onBackground: Colors.white70, // Text color on background
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green.shade800,
            foregroundColor: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.green.shade400),
          ),
        ),

        // Yeh device ki setting ke hisab se theme select karega
        themeMode: ThemeMode.system,

        home: const AuthWrapper(),
      ),
    );
  }
}
