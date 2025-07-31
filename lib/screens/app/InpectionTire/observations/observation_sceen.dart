import 'package:flutter/material.dart';

class ObservationScreen extends StatefulWidget {
  const ObservationScreen({super.key});

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Observaciones"),
      ),
      body: const Center(
        child: Text("Aquí van las observaciones"),
      ),
    );
  }
}