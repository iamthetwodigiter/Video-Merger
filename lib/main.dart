import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_merger/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storageStatus = await Permission.storage.request();
  var manageStorageStatus = await Permission.manageExternalStorage.request();

  if (storageStatus.isGranted || manageStorageStatus.isGranted) {
    runApp(const MyApp());
  } else {
    openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Merger',
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.blue,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
