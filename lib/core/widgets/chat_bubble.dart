import 'package:flutter/material.dart';

import '../../themes/styles.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final TextAlign textAlign;
  const ChatBubble({super.key, required this.message, required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff273443),
      ),
      child: Text(
        message,
        textAlign: textAlign,
        style: TextStyles.font16White600Weight,
      ),
    );
  }
}
