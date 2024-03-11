import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StarredMessagesScreen extends StatelessWidget {
  const StarredMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred messages'),
      ),
      body: Center(
        child: Lottie.asset('assets/lottie/soon.json'),
      ),
    );
  }
}
