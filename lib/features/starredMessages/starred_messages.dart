import 'package:flutter/material.dart';

class StarredMessagesScreen extends StatelessWidget {
  const StarredMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred messages'),
      ),
      body: Center(
        child: Image.asset('assets/images/soon.gif'),
      ),
    );
  }
}
