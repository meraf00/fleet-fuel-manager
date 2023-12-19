import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/presentation/widgets/custom_text_field.dart';

import '../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _login() {
    Navigator.pushNamed(context, '/fuel-tracking');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Text(
                    "Welcome to Fuel Tracker",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 40.h),

                  //
                  //
                  CustomTextFormField(
                    controller: TextEditingController(),
                    labelText: 'Email',
                  ),
                  //
                  CustomTextFormField(
                    controller: TextEditingController(),
                    labelText: 'Password',
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/fuel-tracking');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
              SizedBox(height: 90.h),
              const Divider(
                color: AppColors.gray200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Register',
                        style: TextStyle(color: AppColors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
