import 'dart:convert';

import '../helpers/access_token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

import '../features/chat/data/model/message.dart';

class ChatService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var logger = Logger();
  final _fireStore = FirebaseFirestore.instance;

  // Get Messages from firestore
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> sortedIDs = [userID, otherUserID];
    sortedIDs.sort();
    String chatRoomID = sortedIDs.join('_');
    return _fireStore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // SEND MESSAGE
  Future<void> sendMessage(String message, String receiverID) async {
    // get current user info
    final currentUserID = _auth.currentUser!.uid;
    final currentUserName = _auth.currentUser!.displayName;
    final timestamp = Timestamp.now();
    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderName: currentUserName!,
      message: message,
      receiverID: receiverID,
      timestamp: timestamp,
    );
    // construct chat room id from current user id and recvier id (Sorted to ensure uniqueness)
    List<String> sortedIDs = [currentUserID, receiverID];
    sortedIDs.sort();
    String chatRoomID = sortedIDs.join('_');

    // add message to database
    await _fireStore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .add(
          newMessage.toMap(),
        );
  }

  Future<void> sendPushMessage(
    String receiverMToken,
    String senderMToken,
    String message,
    String senderName,
    String senderID,
    String? senderUserProfilePic,
  ) async {
    AccessToken accessToken = AccessToken();
    String token = await accessToken.getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var data = json.encode({
      "message": {
        "token": receiverMToken,
        "notification": {"body": message, "title": senderName},
        'data': {
          'name': senderName,
          'uid': senderID,
          'mtoken': senderMToken,
          'profilePic': senderUserProfilePic
        }
      }
    });
    var dio = Dio();
    var response = await dio.request(
      'https://fcm.googleapis.com/v1/projects/chatappmoaz/messages:send',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      logger.d(json.encode(response.data));
    } else {
      logger.e(response.statusMessage);
    }
  }
}
