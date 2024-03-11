import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewBroadCastScreen extends StatelessWidget {
  const NewBroadCastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New broadcast'),
      ),
      body: Center(
        child: Lottie.asset('assets/lottie/soon.json'),
      ),
    );
  }
}
