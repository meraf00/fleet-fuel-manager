import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/presentation/widgets/custom_text_field.dart';
import 'package:fuel_tracker/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
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
                controller: TextEditingController(),
                labelText: 'First name',
              ),
              //
              CustomTextFormField(
                controller: TextEditingController(),
                labelText: 'Last name',
              ),
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
    );
  }
}
