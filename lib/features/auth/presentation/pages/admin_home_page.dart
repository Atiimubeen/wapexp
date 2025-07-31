import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/auth/domain/entities/user_entity.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_event.dart';

class AdminHomePage extends StatelessWidget {
  final UserEntity user;
  const AdminHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogOutButtonPressed());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.name}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(user.email),
          ],
        ),
      ),
    );
  }
}
