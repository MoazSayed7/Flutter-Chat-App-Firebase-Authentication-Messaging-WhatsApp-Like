import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie/update.json'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog();
    });
  }

  Future<void> showDialog() async {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: context.tr('update'),
      desc: context.tr('updateDesc'),
      btnCancelText: context.tr('exit'),
      btnCancelOnPress: () => SystemNavigator.pop(),
      btnOkText: context.tr('update'),
      btnOkOnPress: () async {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('version')
            .doc('newest')
            .get();
        _launchURL(documentSnapshot['link']);
      },
    ).show();
  }

  Future<void> _launchURL(String myUrl) async {
    final Uri url = Uri.parse(myUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
