import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/networking/dio_factory.dart';
import '../../../helpers/extensions.dart';
import '../../../helpers/notifications.dart';
import '../../../router/routes.dart';
import '../../../services/database.dart';
import '../../../services/notification_service.dart';
import '../../../themes/colors.dart';
import 'widgets/message_bar.dart';
import 'widgets/url_preview.dart';

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
  late String? token;
  TextAlign textAlign = TextAlign.start;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
              CustomMessageBar(
                onSend: (message) async {
                  await DatabaseMethods.sendMessage(
                    message,
                    widget.receivedUserID,
                  );
                  await _chatService.sendPushMessage(
                    widget.receivedMToken,
                    token!,
                    message,
                    _auth.currentUser!.displayName!,
                    _auth.currentUser!.uid,
                    _auth.currentUser!.photoURL,
                  );
                },
                onShowOptions: showImageOptions,
              ),
            ],
          ),
        ),
      ),
    );
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
      await HelperNotification.initialize(flutterLocalNotificationsPlugin);
      await getToken();
    });
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

  Future showImageOptions() async {
    await showCupertinoModalPopup(
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  BubbleNormalImage _buildImagePreviewer(
      Map<String, dynamic> data, bool isNewSender, String message) {
    return BubbleNormalImage(
      onPressDownload: () async {
        await _downloadImageFromFirebase(
          FirebaseStorage.instance.refFromURL(message),
          message,
        );
      },
      id: data['timestamp'].toDate().toString(),
      isArabicApp: context.locale.toString() == 'ar' ? true : false,
      tail: isNewSender,
      isSender: data['senderID'] == _auth.currentUser!.uid ? true : false,
      color: data['senderID'] == _auth.currentUser!.uid
          ? const Color.fromARGB(255, 0, 107, 84)
          : const Color(0xff273443),
      image: CachedNetworkImage(
        imageUrl: message,
        placeholder: (context, url) => Image.asset('assets/images/loading.gif'),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline_rounded),
      ),
    );
  }

  Align _buildLinkPreviewer(Map<String, dynamic> data, String message) {
    bool isNewSender = data['senderID'] == _auth.currentUser!.uid
        ? context.locale.languageCode == 'ar'
            ? false
            : true
        : context.locale.languageCode == 'ar'
            ? true
            : false;
    return Align(
      alignment: data['senderID'] == _auth.currentUser!.uid
          ? context.locale.languageCode == 'ar'
              ? Alignment.centerLeft
              : Alignment.centerRight
          : context.locale.languageCode == 'ar'
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        margin: isNewSender
            ? const EdgeInsets.fromLTRB(7, 7, 17, 7)
            : const EdgeInsets.fromLTRB(17, 7, 7, 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
          color: data['senderID'] == _auth.currentUser!.uid
              ? const Color.fromARGB(255, 0, 107, 84)
              : const Color(0xff273443),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LinkPreviewWidget(
                message: message,
                onLinkPressed: (link) async {
                  await _launchURL(link);
                },
              ),
              Gap(3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 5.h),
                child: Text(
                  DateFormat("h:mm a").format(
                    data['timestamp'].toDate(),
                  ),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(
      DocumentSnapshot snapshot,
      DocumentSnapshot? previousMessage,
      DocumentSnapshot? nextMessage,
      bool isNewDay) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    bool isNewSender =
        nextMessage == null || data['senderID'] != nextMessage['senderID'];
    String message = data['message'];
    return Column(
      children: [
        if (isNewDay)
          DateChip(
            date: data['timestamp'].toDate(),
            dateColor: ColorsManager.gray400,
            color: const Color(0xff273443),
          ),
        if (message.contains(message.isContainsLink) &&
            message.contains('firebasestorage'))
          _buildImagePreviewer(data, isNewSender, message),
        if (message.contains(message.isContainsLink) &&
            !message.contains('firebasestorage'))
          _buildLinkPreviewer(data, message),
        if (!message.contains(message.isContainsLink))
          _buildTextMessage(message, data, isNewSender),
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
          reverse: true,
          itemCount: messageDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot currentMessage = messageDocs[index];
            DocumentSnapshot? previousMessage =
                index > 0 ? messageDocs[index - 1] : null;
            DocumentSnapshot? nextMessage =
                index < messageDocs.length - 1 ? messageDocs[index + 1] : null;

            // Determine if the current message is from a new day
            bool isNewDay = nextMessage == null ||
                !_isSameDay(currentMessage['timestamp'].toDate(),
                    nextMessage['timestamp'].toDate());

            return _buildMessageItem(
              currentMessage,
              previousMessage,
              nextMessage,
              isNewDay,
            );
          },
        );
      },
    );
  }

  BubbleSpecialThree _buildTextMessage(
      String message, Map<String, dynamic> data, bool isNewSender) {
    return BubbleSpecialThree(
      text: message,
      color: data['senderID'] == _auth.currentUser!.uid
          ? const Color.fromARGB(255, 0, 107, 84)
          : const Color(0xff273443),
      textAlign: isArabic(message) ? TextAlign.right : TextAlign.left,
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
    );
  }

  Future<void> _downloadImageFromFirebase(Reference ref, String url) async {
    _showLoadingDialog();
    // Define the path where you want to save the image
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${ref.name}';

    // Download the image using Dio
    await DioFactory.getDio().download(url, path);

    // Save the file to the gallery
    await GallerySaver.saveImage(
      path,
      albumName: 'ChatChat',
      toDcim: true,
    );
    if (!mounted) return;
    context.pop();

    // Show a snackbar to indicate the download is complete
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image Downloaded')),
    );
  }

  bool _isSameDay(DateTime timestamp1, DateTime timestamp2) {
    return timestamp1.year == timestamp2.year &&
        timestamp1.month == timestamp2.month &&
        timestamp1.day == timestamp2.day;
  }

  Future<void> _launchURL(String myUrl) async {
    if (!myUrl.startsWith('http://') && !myUrl.startsWith('https://')) {
      myUrl = 'https://$myUrl';
    }
    final Uri url = Uri.parse(myUrl);
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorsManager.greenPrimary,
            ),
          ),
        );
      },
    );
  }
}
