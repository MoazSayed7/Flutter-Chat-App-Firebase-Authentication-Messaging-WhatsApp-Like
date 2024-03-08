# 📱 Flutter WhatsApp-like Chat App

## Overview

This Flutter project is a chat application inspired by WhatsApp. The app features a familiar interface with a functional chat page, a Local Auth Screen, and user registration using email/password or Google Account.


## Features

- **User Authentication:**
  - Email/Password registration with placeholder image.
  - Google Account registration with profile image.
  
- **Chat Functionality:**
  - Display all registered users on the home page.
  - Clicking on a user tile opens the chat page.
  - Chat page displays saved messages from Firebase store.
  - Input text field and send button for sending messages.
  - Real-time updates using Firebase Cloud Firestore.
  - Push notifications using Firebase Cloud Messaging.

- **Notification Handling:**
  - Display notifications when the app is in the foreground using `flutter_local_notifications` package.
  - Open the chat with the sender when the app is in the background or terminated.

- **Security:**
  - App lock feature using fingerprint or face ID with `local_auth` package.
  - Fingerprint/face ID attempts limited to prevent unauthorized access.
  - Lock screen request after multiple unsuccessful attempts.

- **Settings:**
  - Accessible from the home page's three dots menu.
  - Option to enable/disable app lock with a Cupertino switch.

- **Camera Integration:**
  - Capture high-quality photos using the device's camera.
  - Save pictures on the device.

## Dependencies

- `awesome_dialog`: Provides versatile dialogs for various use cases.
- `camera`: Enables camera interaction and image capture.
- `chat_bubbles`: Simplifies chat message UI creation.
- `cloud_firestore`: Integrates with Firebase Firestore for data storage and retrieval.
- `cupertino_icons`: Offers iOS-style icons for a consistent UI.
- `dio`: HTTP client for making API requests.
- `eva_icons_flutter`: Provides additional icons beyond the core Flutter icons.
- `firebase_auth`: Manages user authentication with Firebase.
- `firebase_core`: Initializes the Firebase connection.
- `firebase_messaging`: Enables FCM for notifications.
- `flutter_local_notifications`: Presents local notifications when the app is in the foreground.
- `flutter_offline`: Handles offline connectivity scenarios.
- `flutter_screenutil`: Adapts UI elements to different screen sizes.
- `gap`: Simplifies spacing management in layouts.
- `google_sign_in`: Facilitates Google Sign-In authentication.
- `googleapis_auth`: Obtain Access credentials for Google services using OAuth 2.0.
- `intl`: Internationalization and localization support.
- `local_auth`: Enables fingerprint and Face ID authentication.
- `logger`: Assists with logging messages for debugging.
- `shared_preferences`: Stores simple data locally on the device.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/MoazSayed7/Flutter-Chat-App-Firebase-Authentication-Messaging-WhatsApp-Like.git
```

2. Navigate to the project directory:

```bash
cd Flutter-Chat-App-Firebase-Authentication-Messaging-WhatsApp-Like
```

3. Install dependencies:

```bash
flutter pub get
```
4. Configure Firebase:
   - Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
   - Enable the required Firebase services for your app, including Firestore, Authentication, and Cloud Messaging.

5. Set up Firebase for your project by following the [Using Firebase CLI](https://firebase.google.com/docs/flutter/setup).

6. ### Customized `chat_bubbles` Package

I have made custom modifications to the `chat_bubbles` package to enhance the text alignment feature. Specifically, I have added the ability to dynamically set the text alignment within the chat bubbles.

1. Added a new parameter to the `BubbleSpecialThree` class:

   ```dart
   final TextAlign textAlign;
   ```

2. Initialized the `textAlign` parameter in the constructor:

   ```dart
   this.textAlign = TextAlign.left;
   ```

3. Applied the dynamic text alignment in the widget tree in line 97 (line 97 before making the above edits) :

   ```dart
   textAlign: textAlign
   ```

 #### Implementation Details

The changes are made in the `bubble_special_three.dart` file located in the following path:

```
%LocalAppData%\Pub\Cache\hosted\pub.dev\chat_bubbles-1.5.0\lib\bubbles\bubble_special_three.dart
```

Users can find the modified file in this location and review the changes made for better understanding.

7. Run the app:

```bash
flutter run
```
