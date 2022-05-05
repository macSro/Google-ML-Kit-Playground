import 'package:flutter/material.dart';
import 'package:lab3/screens/object_detector_screen.dart';
import 'package:lab3/screens/text_recognizer_screen.dart';

import 'image_labeler_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _customCard(
                title: 'Image Labeler',
                icon: Icons.image_rounded,
                color: Colors.green,
                context: context,
                navigator: (context) => const ImageLabelerScreen(),
              ),
              const SizedBox(height: 16),
              _customCard(
                title: 'Text Recognizer',
                icon: Icons.text_snippet_rounded,
                color: Colors.amber,
                context: context,
                navigator: (context) => const TextRecognizerScreen(),
              ),
              const SizedBox(height: 16),
              _customCard(
                title: 'Object Detector',
                icon: Icons.select_all_rounded,
                color: Colors.cyan,
                context: context,
                navigator: (context) => const ObjectDetectorScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _customCard({
    required String title,
    required IconData icon,
    required Color color,
    required BuildContext context,
    required Widget Function(BuildContext) navigator,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        leading: Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: navigator,
          ),
        ),
      ),
    );
  }
}
