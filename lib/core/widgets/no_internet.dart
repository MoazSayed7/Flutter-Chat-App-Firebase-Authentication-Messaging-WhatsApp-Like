import 'package:flutter/material.dart';

class BuildNoInternet extends StatelessWidget {
  const BuildNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/no-internet.png',
      ),
    );
  }
}
