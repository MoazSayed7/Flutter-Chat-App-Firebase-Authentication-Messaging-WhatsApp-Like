import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdatesTab extends StatelessWidget {
  const UpdatesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset('assets/lottie/soon.json'));
  }
}
