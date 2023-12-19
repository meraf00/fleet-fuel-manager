import 'package:flutter/material.dart';
import 'package:fuel_tracker/features/auth/repository.dart';
import '../../injection_container.dart' as di;
import 'dart:developer';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authRepo = di.serviceLocator<AuthenticationRepository>();

  @override
  void initState() {
    super.initState();
    authRepo.isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/fuel-tracking');
      } else {
        Navigator.pushReplacementNamed(context, '/register');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/splashscreen.png'),
      ),
    );
  }
}
