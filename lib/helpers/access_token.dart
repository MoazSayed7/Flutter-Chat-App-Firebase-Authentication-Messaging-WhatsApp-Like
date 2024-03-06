import 'package:googleapis_auth/auth_io.dart';

class AccessToken {

  final String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {

    // In the Firebase console, open Settings > Service Accounts.
    // Click Generate New Private Key, then confirm by clicking Generate Key.
    // set data from downloaded file here
    final accountCredentials = ServiceAccountCredentials.fromJson({});

    final client = await clientViaServiceAccount(
      accountCredentials,
      [firebaseMessagingScope],
    );

    return client.credentials.accessToken.data;
  }
}
