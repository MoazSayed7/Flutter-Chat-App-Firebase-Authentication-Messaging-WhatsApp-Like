import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/extensions.dart';
import '../../../helpers/notifications.dart';
import '../../../router/routes.dart';
import '../../../services/database.dart';
import '../../../services/notification_service.dart';
import '../../../themes/colors.dart';
import '../../../themes/styles.dart';

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
  final _chatService = NotificationService();
  final _auth = FirebaseAuth.instance;
  final _scrollController = ScrollController();
  late String? token;
  TextAlign textAlign = TextAlign.start;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _picker = ImagePicker();

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
              widget.active == 'true'
                  ? context.tr('online')
                  : context.tr('offline'),
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color.fromARGB(255, 179, 178, 178),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/chat_backgrond.png"),
            opacity: 0.1,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              Expanded(
                child: _buildMessagesList(),
              ),
              MessageBar(
                messageBarHitText: context.tr('message'),
                messageBarHintStyle: TextStyles.font14Grey400Weight,
                messageBarTextStyle: TextStyles.font18White500Weight.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                messageBarColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 7.h,
                ),
                paddingTextAndSendButton: context.locale.toString() == 'en'
                    ? EdgeInsets.only(left: 4.w)
                    : EdgeInsets.only(right: 4.w),
                onSend: (message) async {
                  await DatabaseMethods.sendMessage(
                    message,
                    widget.receivedUserID,
                  );
                  scrollToDown();
                  await _chatService.sendPushMessage(
                    widget.receivedMToken,
                    token!,
                    message,
                    _auth.currentUser!.displayName!,
                    _auth.currentUser!.uid,
                    _auth.currentUser!.photoURL,
                  );
                },
                actions: [
                  Padding(
                    padding: context.locale.toString() == 'ar'
                        ? EdgeInsets.only(left: 4.w)
                        : EdgeInsets.only(right: 4.w),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff00a884),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: () => showOptions(),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (!mounted) return;

      context.pushNamed(Routes.displayPictureScreen, arguments: [
        pickedFile,
        token!,
        widget.receivedMToken,
        widget.receivedUserID,
      ]);
    }
  }

//Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!mounted) return;
      context.pushNamed(Routes.displayPictureScreen, arguments: [
        pickedFile,
        token!,
        widget.receivedMToken,
        widget.receivedUserID,
      ]);
    }
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
      scrollToDown();
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

  void scrollToDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 90.h,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(context.tr('photoGallery')),
            onPressed: () {
              context.pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(context.tr('camera')),
            onPressed: () {
              context.pop();
              getImageFromCamera();
            },
          ),
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
            color: const Color(0xff273443),
            dateColor: ColorsManager.gray400,
          ),
        if (data['message'].contains('https://'))
          BubbleNormalImage(
            id: data['timestamp'].toDate().toString(),
            isArabicApp: context.locale.toString() == 'ar' ? true : false,
            tail: isNewSender,
            isSender: data['senderID'] == _auth.currentUser!.uid ? true : false,
            color: data['senderID'] == _auth.currentUser!.uid
                ? const Color.fromARGB(255, 0, 107, 84)
                : const Color(0xff273443),
            image: CachedNetworkImage(
              imageUrl: data['message'],
              placeholder: (context, url) =>
                  Image.asset('assets/images/loading.gif'),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error_outline_rounded),
            ),
          ),
        if (!data['message'].contains('https://'))
          BubbleSpecialThree(
            text: data['message'],
            color: data['senderID'] == _auth.currentUser!.uid
                ? const Color.fromARGB(255, 0, 107, 84)
                : const Color(0xff273443),
            textAlign:
                isArabic(data['message']) ? TextAlign.right : TextAlign.left,
            sendTime: DateFormat("h:mm a").format(
              data['timestamp'].toDate(),
            ),
            tail: isNewSender,
            isSender: data['senderID'] == _auth.currentUser!.uid
                ? context.locale.languageCode == 'ar'
                    ? false
                    : true
                : context.locale.languageCode == 'ar'
                    ? true
                    : false,
          ),
      ],
    );
  }

  Widget _buildMessagesList() {
    late Stream<QuerySnapshot<Object?>> allMessages =
        DatabaseMethods.getMessages(
            widget.receivedUserID, _auth.currentUser!.uid);

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
