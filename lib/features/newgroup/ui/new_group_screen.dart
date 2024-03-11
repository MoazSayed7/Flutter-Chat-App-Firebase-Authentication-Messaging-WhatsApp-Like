import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewGroupScreen extends StatelessWidget {
  const NewGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: Center(
        child: Lottie.asset('assets/lottie/soon.json'),
      ),
    );
  }
}
