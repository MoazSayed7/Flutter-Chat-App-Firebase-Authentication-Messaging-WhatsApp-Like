import 'package:flutter/material.dart';

class NewBroadCastScreen extends StatelessWidget {
  const NewBroadCastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New broadcast'),
      ),
      body: Center(
        child: Image.asset('assets/images/soon.gif'),
      ),
    );
  }
}
