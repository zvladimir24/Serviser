import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc_event.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc_state.dart';
import 'package:serviser/data/repository/my_profile_repository.dart';

class MyProfileBloc extends Bloc<MyProfileBlocEvent, MyProfileBlocState> {
  final profileRepository = GetIt.instance<MyProfileRepository>();
  MyProfileBloc() : super(MyProfileBlocInitalState()) {
    on<FatchUserDataEvent>((event, emitter) => _fatchUserData(event, emitter));
  }

  Future<void> _fatchUserData(
      FatchUserDataEvent event, Emitter<MyProfileBlocState> emitter) async {
    try {
      emitter(MyProfileBlocInProgressState());

      final profileData =
          await profileRepository.fatchProfileData(event.userId);

      emitter(MyProfileBlocDataFatchedState(profileData));
    } catch (e) {
      debugPrint('***** Data Fatching Failure: $e');
      emitter(MyProfileBlocFaildDataFatchingState());
    }
  }
}
