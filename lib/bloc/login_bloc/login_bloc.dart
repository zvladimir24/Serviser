import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/login_bloc/login_bloc_event.dart';
import 'package:serviser/bloc/login_bloc/login_bloc_state.dart';
import 'package:serviser/data/repository/login_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  final supabaseClient = GetIt.instance<SupabaseClient>();
  final loginRepository = GetIt.instance<LoginRepository>();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emitter) => _loginingIn(event, emitter));
    on<LoginGoogleButtonPressed>(
        (event, emitter) => _loginWithGoogle(event, emitter));
  }
  Future<void> _loginingIn(
      LoginButtonPressed event, Emitter<LoginBlocState> emitter) async {
    try {
      debugPrint('***** Login Event Triggered: $event');
      emitter(LoginInProgress());

      await loginRepository.loginWithSupabase(event.email, event.password);

      debugPrint('***** Login Success');
      emitter(LoginSuccess());
    } catch (e) {
      debugPrint('***** Login Failure: $e');
      emitter(LoginFail());
    }
  }

  Future<void> _loginWithGoogle(
      LoginGoogleButtonPressed event, Emitter<LoginBlocState> emitter) async {
    try {
      debugPrint('***** Login Event Triggered: $event');
      emitter(LoginInProgress());
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await loginRepository.loginWithGoogle();
      } else {
        await loginRepository.loginWithGoogleWeb();
      }

      debugPrint('***** Login Success');
      emitter(LoginSuccess());
    } catch (e) {
      debugPrint('***** Login Failure: $e');
      emitter(LoginFail());
    }
  }
}
