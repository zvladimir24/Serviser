import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc_event.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc_state.dart';
import 'package:serviser/presentation/widgets/my_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<SignOutBloc, SignOutBlocState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SignOut successful!'),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is SignOutFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong!'),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: MySearchBar(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text('Welcome to the Home Page!'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SignOutBloc>().add(SignOutButtonPressed());
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
