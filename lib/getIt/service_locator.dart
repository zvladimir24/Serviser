import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/login_bloc/login_bloc.dart';
import 'package:serviser/bloc/search_bloc/search_bloc.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:serviser/data/api/dio_client.dart';
import 'package:serviser/data/repository/login_repository.dart';
import 'package:serviser/data/repository/search_repository.dart';
import 'package:serviser/data/repository/sign_out_repository.dart';
import 'package:serviser/data/repository/sign_up_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register Supabase client
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  getIt.registerSingleton<SignUpRepository>(
    SignUpRepository(),
  );
  getIt.registerSingleton<LoginRepository>(
    LoginRepository(),
  );
  getIt.registerSingleton<SignOutRepository>(
    SignOutRepository(),
  );
  getIt.registerSingleton<DioClient>(
    DioClient(),
  );

  getIt.registerSingleton<SearchRepository>(
    SearchRepository(),
  );

  getIt.registerFactory(() => SignUpBloc());
  getIt.registerFactory(() => LoginBloc());
  getIt.registerFactory(() => SignOutBloc());
  getIt.registerFactory(() => SearchBloc());
}
