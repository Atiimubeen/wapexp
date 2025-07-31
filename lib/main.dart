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

        // ================= LIGHT THEME (IMPROVED) =================
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green.shade700,
            background: const Color(
              0xFFF5F5F5,
            ), // Thora sa off-white background
            onBackground: Colors.black87,
            surface: Colors.white, // Cards ka color
            onSurface: Colors.black87, // Cards par text ka color
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          // Text fields ke liye default theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ), // Hint text ka color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),

        // ================= DARK THEME (IMPROVED) =================
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
            primary: Colors.green.shade400,
            background: const Color(0xFF121212),
            onBackground: Colors.white70,
            surface: const Color(0xFF1E1E1E), // Cards ka color
            onSurface: Colors.white70, // Cards par text ka color
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          // Text fields ke liye default theme (dark)
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade800,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ), // Hint text ka color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade700),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade700),
            ),
          ),
        ),

        themeMode: ThemeMode.dark,
        home: const AuthWrapper(),
      ),
    );
  }
}
