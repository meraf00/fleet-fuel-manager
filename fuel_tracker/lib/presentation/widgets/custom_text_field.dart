import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController controller,
    required this.labelText,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66.h,
      child: TextFormField(
        obscureText: labelText == 'Password' ? true : false,
        controller: _controller,
        cursorColor: AppColors.darkBlue,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide:
                    const BorderSide(color: Color.fromARGB(47, 55, 107, 237))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: const BorderSide(color: AppColors.blue)),
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              color: AppColors.darkBlue,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          color: AppColors.darkBlue,
        ),
      ),
    );
  }
}