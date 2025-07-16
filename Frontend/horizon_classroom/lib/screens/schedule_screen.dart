import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule Screen")),
      body: Center(
        child: Text(
          'Scheduled Classes',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
