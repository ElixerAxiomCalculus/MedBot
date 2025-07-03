import 'package:flutter/material.dart';

class PreloaderWidget extends StatelessWidget {
  const PreloaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Or your brand background
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services_rounded, color: Colors.red, size: 56),
            SizedBox(height: 16),
            Text("MedBot", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 22),
            CircularProgressIndicator(color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}
