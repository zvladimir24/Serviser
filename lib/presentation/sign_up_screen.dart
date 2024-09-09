import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc_event.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<SignUpBloc, SignUpBlocState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign up successful!'),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is SignUpFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign up failed'),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Username Field
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),

                // Full Name Field
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),

                // Repeat Password Field
                TextField(
                  controller: _repeatPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Repeat Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text ==
                        _repeatPasswordController.text) {
                      debugPrint('***** Sign-Up Button Pressed');
                      debugPrint('***** Username: ${_usernameController.text}');
                      debugPrint('***** Email: ${_emailController.text}');
                      debugPrint(
                          '***** Full Name: ${_fullNameController.text}');

                      context.read<SignUpBloc>().add(SignUpInButtonPressed(
                            username: _usernameController.text,
                            fullname: _fullNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ));

                      _usernameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _repeatPasswordController.clear();
                      _fullNameController.clear();
                    } else {
                      debugPrint('***** Passwords do not match');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match.'),
                          behavior: SnackBarBehavior.floating,
                          showCloseIcon: true,
                        ),
                      );
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }
}
