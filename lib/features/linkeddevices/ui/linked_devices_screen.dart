import 'package:flutter/material.dart';

class LinkedDevicesScreen extends StatelessWidget {
  const LinkedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linked devices'),
      ),
      body: Center(
        child: Image.asset('assets/images/soon.gif'),
      ),
    );
  }
}
