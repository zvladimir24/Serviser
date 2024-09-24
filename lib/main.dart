import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/bloc/friends_bloc/friends_bloc.dart';
import 'package:serviser/bloc/login_bloc/login_bloc.dart';
import 'package:serviser/bloc/my_profile_bloc/my_profile_bloc.dart';
import 'package:serviser/bloc/search_bloc/search_bloc.dart';
import 'package:serviser/bloc/sign_out_bloc/sign_out_bloc.dart';
import 'package:serviser/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:serviser/bloc/users_bloc/users_bloc.dart';
import 'package:serviser/getIt/service_locator.dart';
import 'package:serviser/presentation/home_screen.dart';
import 'package:serviser/presentation/login_screen.dart';
import 'package:serviser/presentation/my_profile_screen.dart';
import 'package:serviser/presentation/search_result_screen.dart';
import 'package:serviser/presentation/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  debugPrint('Loading .env file...');
  await dotenv.load(fileName: ".env");
  debugPrint('Loaded .env file successfully.');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  setupLocator();

  final initialRoute = await _getInitialRoute();

  // Run the app
  runApp(MyApp(initialRoute: initialRoute));
  FlutterNativeSplash.remove();
}

Future<String> _getInitialRoute() async {
  final supabase = GetIt.instance<SupabaseClient>();
  final session = supabase.auth.currentSession;

  // Delay for showing splash screen (optional)
  await Future.delayed(const Duration(seconds: 3));

  // Decide the route
  if (session != null) {
    return '/home_screen';
  } else {
    return '/login';
  }
}

void initSupabase() async {
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  final client = SupabaseClient(supabaseUrl, supabaseAnonKey);

  debugPrint('***** Supabase init completed: $client');
  debugPrint('***** Supabase URL: $supabaseUrl');
  debugPrint('***** Supabase API Key: $supabaseAnonKey');
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleEmailConfirmation(context);
    });
  }

  Future<void> handleEmailConfirmation(BuildContext context) async {
    final supabase = GetIt.instance<SupabaseClient>();
    final prefs = await SharedPreferences.getInstance();
    bool isEmailConfirmationPending =
        prefs.getBool('isEmailConfirmationPending') ?? false;

    supabase.auth.onAuthStateChange.listen((AuthState state) async {
      final session = state.session;

      if (isEmailConfirmationPending &&
          session != null &&
          session.user.emailConfirmedAt != null) {
        await supabase.auth.signOut();

        await prefs.setBool('isEmailConfirmationPending', false);

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please confirm your email'),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<LoginBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<SignUpBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<SignOutBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<SearchBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<MyProfileBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<FriendsBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<UsersBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Service App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
        routes: {
          '/sign_up': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/home_screen': (context) => HomeScreen(),
          '/search_result_screen': (context) => const SearchResultScreen(),
          '/my_profile_screen': (context) => const MyProfileScreen(),
        },
        initialRoute: widget.initialRoute,
      ),
    );
  }
}
