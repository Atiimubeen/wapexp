import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:wapexp/admin_app/features/auth/presentation/widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : null,
                      child: _image == null
                          ? Icon(Icons.camera_alt, color: Colors.grey[800])
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    // Yahan bhi navigation ki zaroorat nahi
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Sign Up',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          SignUpButtonPressed(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                            image: _image,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
