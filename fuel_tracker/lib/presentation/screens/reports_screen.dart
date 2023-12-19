import 'package:flutter/material.dart';
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

  Future<void> loadReports() async {
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
                        builder: (context) => ReportDetailScreen(tracking)));
              },
              child: ListTile(
                title: Text("Reading ${tracking.odometerReading}",
                    style: Theme.of(context).textTheme.displayMedium),
                subtitle: Text("Subtitle $index",
                    style: Theme.of(context).textTheme.bodySmall),
                trailing: const Icon(Icons.arrow_forward),
              ),
            );
          }),
    );
  }
}
