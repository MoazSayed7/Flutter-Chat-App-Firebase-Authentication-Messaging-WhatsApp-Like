import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderName;
  final String message;
  final String receiverID;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.senderName,
      required this.message,
      required this.receiverID,
      required this.timestamp});
  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderName': senderName,
      'message': message,
      'receiverID': receiverID,
      'timestamp': timestamp
    };
  }
}
