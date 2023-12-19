import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/features/fuel_tracking/fuel_tracking_model.dart';
import 'package:fuel_tracker/theme/app_colors.dart';

class ReportDetailScreen extends StatelessWidget {
  final FuelTracking tracking;

  const ReportDetailScreen(this.tracking, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Tile(
              title: "Odometer Reading",
              value: tracking.odometerReading,
            ),
            SizedBox(height: 20.h),
            Tile(
              title: "Longitude",
              value: tracking.longitude,
            ),
            SizedBox(height: 20.h),
            Tile(
              title: "Latitude",
              value: tracking.latitude,
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String title;
  final String value;

  const Tile({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(245, 215, 221, 235),
            blurRadius: 1.0,
            spreadRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 20.sp)),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
