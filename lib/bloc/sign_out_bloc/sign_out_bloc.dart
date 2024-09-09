import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc_event.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc_state.dart';
import 'package:serviser/data/repository/sign_out_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignOutBloc extends Bloc<SignOutBlocEvent, SignOutBlocState> {
  final supabaseClient = GetIt.instance<SupabaseClient>();
  final signOutRepository = GetIt.instance<SignOutRepository>();

  SignOutBloc() : super(SignOutInitial()) {
    on<SignOutButtonPressed>((event, emitter) => _signingOut(event, emitter));
  }
  Future<void> _signingOut(
      SignOutButtonPressed event, Emitter<SignOutBlocState> emitter) async {
    try {
      debugPrint('***** SignOut Event Triggered: $event');
      emitter(SignOutInProgress());

      // Call the signUp method in the repository
      await signOutRepository.signOutWithSupaBase();

      debugPrint('***** SignOut Success');
      emitter(SignOutSuccess());
    } catch (e) {
      debugPrint('***** SignOut Failure: $e');
      emitter(SignOutFail());
    }
  }
}
