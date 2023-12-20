import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuel_tracker/features/fuel_tracking/fuel_tracking_model.dart';
import 'package:fuel_tracker/features/fuel_tracking/repository.dart';
import 'package:fuel_tracker/presentation/widgets/custom_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../injection_container.dart' as di;

class RefillUploadScreen extends StatefulWidget {
  const RefillUploadScreen({super.key});

  @override
  State<RefillUploadScreen> createState() => _RefillUploadScreenState();
}

class _RefillUploadScreenState extends State<RefillUploadScreen> {
  final odometerReadingController = TextEditingController();
  Position? _currentPosition;
  XFile? _image;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable it.'),
          ),
        );
      }

      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
      }

      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Location permissions are denied (actual value: $permission).'),
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    final isGranted = await _handleLocationPermission();

    if (isGranted) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              CustomTextFormField(
                  controller: odometerReadingController,
                  labelText: "Odometer reading"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  setState(() {
                    _image = image;
                  });
                },
                child: const Text('Take a picture'),
              ),
              const SizedBox(height: 16),
              if (_image != null)
                Image.file(
                  File(_image!.path),
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final odometerReading = odometerReadingController.text;
                  final longitude = _currentPosition?.longitude.toString();
                  final latitude = _currentPosition?.latitude.toString();
                  final image = _image;

                  await _getCurrentLocation();

                  if (longitude == null || latitude == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enable location services'),
                        ),
                      );
                    }
                    return;
                  }

                  if (odometerReading.isEmpty || image == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                    }
                    return;
                  }

                  final fuelTracking = FuelTracking(
                    id: '',
                    driverId: '',
                    odometerReading: odometerReading,
                    odometerImage: image.path,
                    longitude: longitude,
                    latitude: latitude,
                  );

                  final isSuccess = await di
                      .serviceLocator<FuelTrackingRepository>()
                      .createFuelTracking(fuelTracking);

                  if (isSuccess) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully added fuel tracking'),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to add fuel tracking'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
