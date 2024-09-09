import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:serviser/presentation/home_screen.dart';
import 'package:serviser/presentation/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = GetIt.instance<SupabaseClient>();

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Durations.medium3);
    final session = supabase.auth.currentSession;

    if (!mounted) return;
    if (session != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
      debugPrint('$session');
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      debugPrint('$session');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/png/serviser_ic.png'),
      ),
    );
  }
}
