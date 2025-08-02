import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/admin_injection_container.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/auth_wrapper.dart';

import 'package:wapexp/user_app/user_injection_container.dart' as user_di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupAdminDependencies();
  await user_di.setupUserDependencies();
  runApp(const WapexpApp());
}

class WapexpApp extends StatelessWidget {
  const WapexpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      // **THE FIX IS HERE:** Jaise hi BLoC bane, usko AppStarted event bhejo
      create: (context) => getIt<AuthBloc>()..add(AppStarted()),
      child: MaterialApp(
        title: 'Wapexp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(/* ... Light Theme ... */),
        darkTheme: ThemeData(/* ... Dark Theme ... */),
        themeMode: ThemeMode.dark,
        // App hamesha AuthWrapper se shuru hogi, jo ke gatekeeper hai.
        home: const AuthWrapper(),
      ),
    );
  }
}
