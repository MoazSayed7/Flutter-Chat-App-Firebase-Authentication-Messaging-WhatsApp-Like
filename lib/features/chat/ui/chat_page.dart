import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_text_form_field.dart';
import '../../../helpers/notifications.dart';
import '../../../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receivedUserName;
  final String receivedUserID;
  final String receivedMToken;
  final String active;
  final String? receivedUserProfilePic;
  const ChatScreen({
    super.key,
    required this.receivedUserName,
    required this.receivedUserID,
    required this.receivedMToken,
    required this.active,
    required this.receivedUserProfilePic,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _chatService = ChatService();
  final _auth = FirebaseAuth.instance;
  final _scrollController = ScrollController();

  late String? token;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 85.w,
        leading: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Gap(10.w),
              Icon(Icons.arrow_back_ios, size: 25.sp),
              widget.receivedUserProfilePic != null &&
                      widget.receivedUserProfilePic != ''
                  ? Hero(
                      tag: widget.receivedUserProfilePic!,
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading.gif',
                          image: widget.receivedUserProfilePic!,
                          fit: BoxFit.cover,
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/user.png',
                      height: 50.h,
                      width: 50.w,
                      fit: BoxFit.cover,
                    ),
            ],
          ),
        ),
        toolbarHeight: 70.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.receivedUserName),
            Text(
              widget.active == 'true' ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color.fromARGB(255, 179, 178, 178),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      scrollTo(
        _scrollController.position.maxScrollExtent,
      );
      await HelperNotification.initialize(flutterLocalNotificationsPlugin);
    });
    getToken();
    // listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        HelperNotification.showNotification(
          message.notification!.title!,
          message.notification!.body!,
          flutterLocalNotificationsPlugin,
        );
      },
    );
  }

  bool isArabic(String text) {
    bool bidi = Bidi.hasAnyRtl(text);
    return bidi;
  }

  void scrollTo(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    late String message;
    if (_messageController.text.isNotEmpty) {
      message = _messageController.text;
      _messageController.clear();
      await _chatService.sendMessage(
        message,
        widget.receivedUserID,
      );
      scrollTo(
        _scrollController.position.maxScrollExtent + 70.h,
      );
      await _chatService.sendPushMessage(
        widget.receivedMToken,
        token!,
        message,
        _auth.currentUser!.displayName!,
        _auth.currentUser!.uid,
        _auth.currentUser!.photoURL,
      );
    }
  }

  Widget _buildMessageInput() {
    return SizedBox(
      height: 70.h,
      child: Row(
        children: [
          Expanded(
            child: AppTextFormField(
              hint: 'Message',
              controller: _messageController,
              validator: (_) {},
            ),
          ),
          Gap(8.w),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff00A884),
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 25,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot,
      DocumentSnapshot? previousMessage, DocumentSnapshot? nextMessage) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // Check if the current message is from a different day than the previous one
    bool isNewDay = previousMessage == null ||
        !_isSameDay(
            data['timestamp'].toDate(), previousMessage['timestamp'].toDate());
    bool isNewSender =
        nextMessage == null || data['senderID'] != nextMessage['senderID'];
    return Column(
      children: [
        if (isNewDay)
          DateChip(
            date: data['timestamp'].toDate(),
            color: const Color(0x558AD3D5),
          ),
        BubbleSpecialThree(
          text: data['message'],
          color: const Color(0xff273443),
          textAlign:
              isArabic(data['message']) ? TextAlign.right : TextAlign.left,
          sendTime: DateFormat("h:mm a").format(
            data['timestamp'].toDate(),
          ),
          tail: isNewSender ? true : false,
          isSender: data['senderID'] == _auth.currentUser!.uid,
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    late Stream<QuerySnapshot<Object?>> allMessages =
        _chatService.getMessages(widget.receivedUserID, _auth.currentUser!.uid);

    return StreamBuilder(
      stream: allMessages,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        List<DocumentSnapshot> messageDocs = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          itemCount: messageDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot currentMessage = messageDocs[index];
            DocumentSnapshot? previousMessage =
                index > 0 ? messageDocs[index - 1] : null;
            DocumentSnapshot? nextMessage =
                index < messageDocs.length - 1 ? messageDocs[index + 1] : null;

            return _buildMessageItem(
                currentMessage, previousMessage, nextMessage);
          },
        );
      },
    );
  }

  bool _isSameDay(DateTime timestamp1, DateTime timestamp2) {
    return timestamp1.year == timestamp2.year &&
        timestamp1.month == timestamp2.month &&
        timestamp1.day == timestamp2.day;
  }
}
