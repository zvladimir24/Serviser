import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/home_screen_google_bloc/home_screen_google_bloc_event.dart';
import 'package:serviser/bloc/home_screen_google_bloc/home_screen_google_bloc_state.dart';
import 'package:serviser/data/repository/home_screen_repository_google.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreenGoogleBloc
    extends Bloc<HomeScreenGoogleBlocEvent, HomeScreenGoogleBlocState> {
  final supabaseClient = GetIt.instance<SupabaseClient>();
  final loginRepository = GetIt.instance<HomeScreenGoogleRepository>();

  HomeScreenGoogleBloc() : super(HomeScreenGoogleInitial()) {
    on<FatchGoogleData>((event, emitter) => _fatchingData(event, emitter));
  }
  Future<void> _fatchingData(
      FatchGoogleData event, Emitter<HomeScreenGoogleBlocState> emitter) async {
    try {
      debugPrint('***** Login Event Triggered: $event');
      emitter(HomeScreenGoogleInProgress());

      debugPrint('***** Login Success');
      emitter(HomeScreenGoogleSuccess());
    } catch (e) {
      debugPrint('***** Login Failure: $e');
      emitter(HomeScreenGoogleFail());
    }
  }
}
