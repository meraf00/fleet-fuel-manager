import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/presentation/screens/login_screen.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/report_detail.dart';
import 'presentation/screens/reports_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'theme/app_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 866),
      builder: (_, child) => MaterialApp(
        title: 'Fuel Tracker',
        theme: AppTheme.themeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/fuel-tracking': (context) => const ReportListScreen(),
        },
      ),
    );
  }
}
