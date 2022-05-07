import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/home_screen.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML Kit',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
