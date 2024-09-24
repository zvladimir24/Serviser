import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/users_bloc/users_bloc_event.dart';
import 'package:serviser/bloc/users_bloc/users_bloc_state.dart';
import 'package:serviser/data/repository/users_repository.dart';

class UsersBloc extends Bloc<UsersBlocEvent, UsersBlocState> {
  final usersRepository = GetIt.instance<UsersRepository>();
  UsersBloc() : super(UsersIntialState()) {
    on<FetchUsersData>((event, emitter) => _handleUserFetching(event, emitter));
  }

  Future<void> _handleUserFetching(
      UsersBlocEvent event, Emitter<UsersBlocState> emitter) async {
    try {
      emitter(UsersLoadingState());
      final users = await usersRepository.fetchAllUsers();
      emitter(UsersFetchedState(users));
    } catch (e) {
      debugPrint('***** Sign-up Exception: $e');
      throw Exception('Sign-up process encountered an error: $e');
    }
  }
}
