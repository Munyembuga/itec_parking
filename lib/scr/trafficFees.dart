import 'package:flutter/material.dart';

class TrafficFinesScreen extends StatelessWidget {
  const TrafficFinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title:
            const Text('Traffic Fines', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Traffic Fines Screen Content'),
      ),
    );
  }
}
