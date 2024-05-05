import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../helpers/extensions.dart';
import '../../router/routes.dart';

class BuildUsersListView extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  BuildUsersListView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var doc = snapshot.data!.docs[index];
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (_auth.currentUser!.email != data['email']) {
          return ListTile(
            leading: data['profilePic'] != null && data['profilePic'] != ''
                ? Hero(
                    tag: data['profilePic'],
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: data['profilePic'],
                        placeholder: (context, url) =>
                            Image.asset('assets/images/loading.gif'),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline_rounded),
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/user.png',
                    height: 50.h,
                    width: 50.w,
                    fit: BoxFit.cover,
                  ),
            tileColor: const Color(0xff111B21),
            title: Text(
              data['name'],
              style: const TextStyle(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              data['isOnline'] == 'true'
                  ? context.tr('online')
                  : context.tr('offline'),
              style: const TextStyle(
                color: Color.fromARGB(255, 179, 178, 178),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            isThreeLine: true,
            titleAlignment: ListTileTitleAlignment.center,
            enableFeedback: true,
            dense: false,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              height: 1.2.h,
            ),
            subtitleTextStyle: TextStyle(
              height: 2.h,
            ),
            horizontalTitleGap: 15.w,
            onTap: () {
              context.pushNamed(Routes.chatScreen, arguments: data);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(context.tr('somethingWentWrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return BuildUsersListView(
          snapshot: snapshot,
        );
      },
    );
  }
}
