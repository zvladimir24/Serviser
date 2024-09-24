import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/friends_bloc/friends_bloc.dart';
import 'package:serviser/bloc/friends_bloc/friends_bloc_event.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc_event.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfileScreen extends StatelessWidget {
  final String? userId;

  const MyProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: Text('User ID is missing.'));
    }

    // Trigger fetching profile data if userId is available
    context.read<MyProfileBloc>().add(FatchUserDataEvent(userId!));
    final currentUser = GetIt.instance<SupabaseClient>().auth.currentUser;
    final String? currentUserId = currentUser?.id;

    return Scaffold(
      body: BlocBuilder<MyProfileBloc, MyProfileBlocState>(
        builder: (context, state) {
          if (state is MyProfileBlocInProgressState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyProfileBlocDataFatchedState) {
            final profileData = state.profileData;

            final displayName = profileData['full_name'] ?? 'No Name';
            final displayEmail = profileData['email'] ?? 'No Email';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayEmail,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Conditionally display the Add Friend button
                  if (currentUserId != null && currentUserId != userId)
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<FriendsBloc>()
                            .add(SendFriendRequestEvent(userId!));
                      },
                      child: const Text('Add Friend'),
                    ),
                ],
              ),
            );
          } else if (state is MyProfileBlocFaildDataFatchingState) {
            return const Center(child: Text('Error fetching data.'));
          } else {
            return const Center(child: Text('No profile data found.'));
          }
        },
      ),
    );
  }
}
