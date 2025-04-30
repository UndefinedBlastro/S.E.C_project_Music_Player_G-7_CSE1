import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:singularity/Screens/Home/home.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final int sdkVersion;
  PermissionStatus storageStatus = PermissionStatus.denied;
  PermissionStatus notificationStatus = PermissionStatus.denied;
  PermissionStatus batteryStatus = PermissionStatus.denied;
  bool isLoading = true;
  bool _navigated = false;

  Permission get storagePermission =>
      sdkVersion >= 33 ? Permission.audio : Permission.storage;

  @override
  void initState() {
    super.initState();
    _initStatuses();
  }

  Future<void> _initStatuses() async {
    final deviceInfo = DeviceInfoPlugin();
    sdkVersion = (await deviceInfo.androidInfo).version.sdkInt;
    storageStatus = await storagePermission.status;
    notificationStatus = await Permission.notification.status;
    batteryStatus = await Permission.ignoreBatteryOptimizations.status;
    setState(() => isLoading = false);
  }

  Future<void> _requestStorage() async {
    final status = await storagePermission.request();
    setState(() => storageStatus = status);
  }

  Future<void> _requestNotification() async {
    final status = await Permission.notification.request();
    setState(() => notificationStatus = status);
  }

  Future<void> _requestBattery() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    setState(() => batteryStatus = status);
  }

  bool get requiredPermissionsGranted =>
      storageStatus.isGranted && notificationStatus.isGranted;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (requiredPermissionsGranted && !_navigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigated = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permissions Required',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PermissionTile(
              title: 'Storage Permission',
              status: storageStatus,
              onRequest: _requestStorage,
            ),
            PermissionTile(
              title: 'Notification Permission',
              status: notificationStatus,
              onRequest: _requestNotification,
            ),
            PermissionTile(
              title: 'Battery Optimization (Optional)',
              status: batteryStatus,
              onRequest: _requestBattery,
              optional: true,
            ),
            const SizedBox(height: 24),
            if (!requiredPermissionsGranted)
              Text(
                'Please grant the required permissions to continue.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}

class PermissionTile extends StatelessWidget {
  final String title;
  final PermissionStatus status;
  final VoidCallback onRequest;
  final bool optional;

  const PermissionTile({
    super.key,
    required this.title,
    required this.status,
    required this.onRequest,
    this.optional = false,
  });

  Color getStatusColor() {
    if (status.isGranted) return Colors.green;
    if (status.isDenied || status.isPermanentlyDenied) return Colors.red;
    return Colors.orange;
  }

  String getStatusText() {
    if (status.isGranted) return 'Granted';
    if (status.isDenied) return 'Denied';
    if (status.isPermanentlyDenied) return 'Permanently Denied';
    return status.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          getStatusText(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: getStatusColor()),
        ),
        trailing: ElevatedButton(
          onPressed: onRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text('Request'),
        ),
      ),
    );
  }
}
