import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc_event.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc_event.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc_state.dart';
import 'package:serviser/bloc/users_bloc/users_bloc.dart'; // Import your UsersBloc
import 'package:serviser/bloc/users_bloc/users_bloc_event.dart'; // Import your UsersBloc event
import 'package:serviser/bloc/users_bloc/users_bloc_state.dart'; // Import your UsersBloc state
import 'package:serviser/presentation/my_profile_screen.dart';
import 'package:serviser/presentation/widgets/my_search_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  final supabaseClient = GetIt.instance<SupabaseClient>();
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(FetchUsersData());
  }

  @override
  Widget build(BuildContext context) {
    // Get current user ID
    final currentUser = widget.supabaseClient.auth.currentUser;
    final currentUserId = currentUser?.id;
    debugPrint('THIS IS CURRENT ID $currentUserId');
    return Scaffold(
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
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<SignOutBloc>().add(SignOutButtonPressed());
                },
                child: const Text('Log Out'),
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint('THIS IS GETTING PASSED $currentUserId');
                  BlocProvider.of<MyProfileBloc>(context)
                      .add(FatchUserDataEvent(currentUserId!));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfileScreen(
                        userId: currentUserId,
                      ),
                    ),
                  );
                },
                child: const Text('My Profile'),
              ),
              const SizedBox(height: 20),
              BlocBuilder<UsersBloc, UsersBlocState>(
                builder: (context, state) {
                  if (state is UsersFetchedState) {
                    return Column(
                      children: [
                        const Text(
                          'Add Friends',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.usersList.length,
                          itemBuilder: (context, index) {
                            final user = state.usersList[index];
                            final userId = user['id'];
                            final userName = user['full_name'];

                            return ListTile(
                              title: Text(userName),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyProfileScreen(
                                      userId: userId,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is UsersFaildState) {
                    return const Center(child: Text('Failed to fetch users.'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
