import 'package:flutter/material.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({super.key});

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  bool showColumns = true;

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/soon.gif'));
  }
}
