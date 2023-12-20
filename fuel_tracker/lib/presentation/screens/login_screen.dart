import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/features/auth/repository.dart';
import 'package:fuel_tracker/presentation/widgets/custom_text_field.dart';
import 'package:fuel_tracker/injection_container.dart' as di;

import '../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _login(context) async {
    final authRepo = di.serviceLocator<AuthenticationRepository>();
    final isLoggedIn = await authRepo.login(
      _emailController.text,
      _passwordController.text,
    );

    if (isLoggedIn) {
      Navigator.pushNamed(context, '/fuel-tracking');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
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
                  controller: _emailController,
                  labelText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                //
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login(context);
                    }
                  },
                  child: const Text('Login'),
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
      ),
    );
  }
}
