import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_tracker/features/auth/repository.dart';
import 'package:fuel_tracker/features/fuel_tracking/fuel_tracking_model.dart';
import 'package:fuel_tracker/features/fuel_tracking/repository.dart';
import '../../injection_container.dart' as di;
import 'report_detail.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  List<FuelTracking> reports = [];
  String authToken = '';

  Future<void> loadReports() async {
    authToken =
        await di.serviceLocator<AuthenticationRepository>().getAuthToken() ??
            '';

    final fuelRepo = di.serviceLocator<FuelTrackingRepository>();
    final r = await fuelRepo.getFuelTrackings();

    setState(() {
      reports = r ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Reports")),
      body: ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final tracking = reports[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReportDetailScreen(tracking, authToken)));
              },
              child: ListTile(
                title: Text('${tracking.odometerReading} KM',
                    style: Theme.of(context).textTheme.displayMedium),
                subtitle: Text("${tracking.latitude} ${tracking.longitude}",
                    style: Theme.of(context).textTheme.bodySmall),
                leading: SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: CachedNetworkImage(
                      imageUrl: tracking.odometerImage,
                      httpHeaders: {'token': authToken}),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-report');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
