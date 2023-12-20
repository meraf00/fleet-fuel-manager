import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/presentation/widgets/custom_text_field.dart';
import 'package:fuel_tracker/theme/app_colors.dart';
import 'package:fuel_tracker/features/auth/repository.dart';
import 'package:fuel_tracker/injection_container.dart' as di;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _register(context) async {
    final authRepo = di.serviceLocator<AuthenticationRepository>();
    final success = await authRepo.register(_fnameController.text,
        _lnameController.text, _emailController.text, _passwordController.text);

    if (success) {
      Navigator.pushNamed(context, '/fuel-tracking');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to register user'),
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
                  controller: _fnameController,
                  labelText: 'First name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                //
                CustomTextFormField(
                  controller: _lnameController,
                  labelText: 'Last name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
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
                      _register(context);
                    }
                  },
                  child: const Text('Register'),
                ),

                SizedBox(height: 20.h),

                const Divider(
                  color: AppColors.gray200,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Login',
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
