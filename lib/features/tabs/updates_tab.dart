import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({super.key});

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset('assets/lottie/soon.json'));
  }
}
