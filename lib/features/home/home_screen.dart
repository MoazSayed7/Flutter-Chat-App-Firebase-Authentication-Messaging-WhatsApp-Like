import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../../helpers/extensions.dart';
import '../../router/routes.dart';
import '../../themes/colors.dart';
import '../tabs/calls_tab.dart';
import '../tabs/chat_tab.dart';
import '../tabs/updates_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.message,
            color: Colors.black,
          ),
        ),
        appBar: AppBar(
          title: const Text('ChatApp'),
          bottom: TabBar(
            indicatorColor: ColorsManager.greenPrimary,
            indicatorWeight: 3.5,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: ColorsManager.greenPrimary,
            unselectedLabelColor: const Color(0xffffffff).withOpacity(0.5),
            tabs: const [
              Tab(text: 'Chats'),
              Tab(text: 'Updates'),
              Tab(text: 'Calls'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              color: Colors.white,
              onPressed: () async {
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                if (!context.mounted) return;
                context.pushNamed(
                  Routes.takePictureScreen,
                  arguments: firstCamera,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {},
            ),
            _buildPopMenu(),
          ],
        ),
        body: const TabBarView(
          children: [
            ChatsTab(),
            UpdatesTab(),
            CallsTab(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'isOnline': 'true',
          },
        );
        await setupInteractedMessage();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'isOnline': 'true',
          },
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'isOnline': 'false',
          },
        );
        break;
      default:
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'isOnline': 'false',
          },
        );
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _goToNotificationChatPage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_goToNotificationChatPage);
  }

  PopupMenuButton _buildPopMenu() {
    return PopupMenuButton(
      color: const Color.fromARGB(255, 41, 52, 59),
      icon: const Icon(Icons.more_vert),
      elevation: 8,
      position: PopupMenuPosition.under,
      iconColor: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            context.pushNamed(Routes.newGroupScreen);
          },
          child: const Text(
            'New group',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            context.pushNamed(Routes.newBroadCastScreen);
          },
          child: const Text(
            'New broadcast',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            context.pushNamed(Routes.linkedDevicesScreen);
          },
          child: const Text(
            'Linked devices',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            context.pushNamed(Routes.starredMessagesScreen);
          },
          child: const Text(
            'Starred messages',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            context.pushNamed(Routes.settingsScreen);
          },
          child: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            try {
              await GoogleSignIn().disconnect();
            } catch (e) {
              logger.e(e.toString());
            } finally {
              await _auth.signOut();
              // ignore: control_flow_in_finally
              if (!context.mounted) return;
              context.pushNamedAndRemoveUntil(
                Routes.loginScreen,
                predicate: (route) => false,
              );
            }
          },
          child: const Text(
            'Signout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _goToNotificationChatPage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      context.pushNamed(Routes.chatScreen, arguments: message.data);
    } else if (message.data['type'] == 'update') {
      context.pushReplacementNamed(Routes.updateScreen);
    } else {
      context.pushReplacementNamed(Routes.homeScreen);
    }
  }
}
