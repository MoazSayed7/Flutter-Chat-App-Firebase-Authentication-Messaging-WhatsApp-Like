import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image: data['profilePic'],
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
            tileColor: const Color(0xff111B21),
            title: Text(
              data['name'],
              style: const TextStyle(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              data['isOnline'] ? 'Online' : 'Offline',
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
          return const Text('Something went wrong');
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
