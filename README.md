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
   
6. Run the app:

```bash
flutter run
```
