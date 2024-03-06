import 'package:flutter/material.dart';


class NewGroupScreen extends StatelessWidget {
  const NewGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: Center(
        child: Image.asset('assets/images/soon.gif'),
      ),
    );
  }
}
