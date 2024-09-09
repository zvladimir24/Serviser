import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc_event.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repository/sign_up_repository.dart';

class SignUpBloc extends Bloc<SignUpBlocEvent, SignUpBlocState> {
  final supabaseClient = GetIt.instance<SupabaseClient>();
  final signUpRepository = GetIt.instance<SignUpRepository>();

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpInButtonPressed>((event, emitter) => _signingIn(event, emitter));
  }
  Future<void> _signingIn(
      SignUpInButtonPressed event, Emitter<SignUpBlocState> emitter) async {
    try {
      debugPrint('***** Sign-Up Event Triggered: $event');
      emitter(SignUpInProgress());

      // Call the signUp method in the repository
      await signUpRepository.signUp(
        email: event.email,
        password: event.password,
        username: event.username,
        fullname: event.fullname,
      );

      debugPrint('***** Sign-Up Success');
      emitter(SignUpSuccess());
    } catch (e) {
      debugPrint('***** Sign-Up Failure: $e');
      emitter(SignUpFail());
    }
  }
}
