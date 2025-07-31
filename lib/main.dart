import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:wapexp/injection_container.dart';

Future<void> main() async {
  // Yeh ensure karta hai ke Flutter bindings initialize ho chuki hain.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ko initialize karna (firebase_options.dart file se)
  await Firebase.initializeApp();

  // Hamara manual Dependency Injection container initialize karna
  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wapexp',
      debugShowCheckedModeBanner: false, // Debug banner ko hatana
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Hum yahan temporary tor par ek screen laga rahe hain
      home: const Scaffold(
        body: Center(
          child: Text(
            'Setup Complete. Ready for UI!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
