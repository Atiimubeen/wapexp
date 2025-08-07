//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wapexp/admin_app/admin_injection_container.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/admin_home_page.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:wapexp/splash_page.dart';
import 'package:wapexp/user_app/presentation/pages/home_page.dart';
import 'package:wapexp/user_app/user_injection_container.dart' as user_di;
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // **THE FIX IS HERE:** Hum Firebase ko uski configuration file ke saath initialize kar rahe hain.
  await Firebase.initializeApp();
  await setupAdminDependencies();
  await user_di.setupUserDependencies();
  runApp(const WapexpApp());
}

// =======================================================================
// === AAPKA PRIMARY GREEN COLOR YAHAN DEFINE KIYA GAYA HAI ===
// Agar aapke paas koi aur green shade ka code hai to yahan change karein
// =======================================================================
const Color primaryGreen = Color(0xFF28a745);

class WapexpApp extends StatelessWidget {
  const WapexpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>()..add(AppStarted()),
      child: MaterialApp(
        title: 'Wapexp',
        debugShowCheckedModeBanner: false,

        // ================= LIGHT THEME (UPDATED TO GREEN) =================
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(
            0xFFF8F9FA,
          ), // Slightly off-white
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryGreen, // <-- CHANGE YAHAN HAI
            primary: primaryGreen, // <-- CHANGE YAHAN HAI
            background: const Color(0xFFF8F9FA),
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFFF5F5F5), // Background se match
            foregroundColor: Colors.black,
            elevation: 0, // Flat design
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              // Jab field select ho
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryGreen, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: primaryGreen, // <-- CHANGE YAHAN HAI
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),

        // ================= DARK THEME (UPDATED TO GREEN) =================
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryGreen, // <-- CHANGE YAHAN HAI
            brightness: Brightness.dark,
            background: const Color(0xFF121212),
            surface: const Color(0xFF1E1E1E),
            onSurface: Colors.white70,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E), // Surface color se match
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              // Jab field select ho
              borderRadius: BorderRadius.circular(12),
              // Dark theme mein seedColor se thora light color use karein
              borderSide: const BorderSide(color: Color(0xFF34C759), width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: primaryGreen, // <-- CHANGE YAHAN HAI
              foregroundColor: Colors.white, // <-- CHANGE YAHAN HAI
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),

        themeMode:
            ThemeMode.system, // System ki light/dark setting istemal karega

        home: const SplashScreenNavigator(),
      ),
    );
  }
}

// Baki ka code (AuthWrapper, SplashScreenNavigator) waisa hi rahega...
// Ismein koi tabdeeli ki zaroorat nahi.

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const SplashPage();
        }
        if (state is Authenticated) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: state.user.isAdmin
                ? AdminHomePage(user: state.user, key: const ValueKey('admin'))
                : const HomePage(key: ValueKey('user')),
          );
        }
        if (state is Unauthenticated) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: const WelcomePage(key: ValueKey('welcome')),
          );
        }
        if (state is AuthLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Please wait...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SplashPage();
      },
    );
  }
}

class SplashScreenNavigator extends StatefulWidget {
  const SplashScreenNavigator({super.key});
  @override
  State<SplashScreenNavigator> createState() => _SplashScreenNavigatorState();
}

class _SplashScreenNavigatorState extends State<SplashScreenNavigator> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}
