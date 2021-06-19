# flutter_messengger_app_challenge

An application develop for Uplabs Messengger Challenge
https://www.uplabs.com/challenges/messenger-app-challenge/landing

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Theme
This project support **light & dark** theme, there are 3 options :
- Always Light  : `themeMode: ThemeMode.light`
- Always Dark   : `themeMode: ThemeMode.dark`
- System-based  : `themeMode: ThemeMode.system`


## Setup
This project used *Firebase Cloud Messaging*, therefore:
- need **create** a project at Firebase.
- download **google-services.json**
- move *google-services.json* to `/android/app` folder

**[Testing Purpose only]** To allow the app send the message to other device, create `/assets` folder and then, create `firebase_secret.json`. 
Copy & paste this code into `firebase_secret.json` file.
```json
{
  "app_id":"FIREBASE_APP_ID",
  "access_token":"FIREBASE_TOKEN_ID",
}
```

please refer to this link for app id and token, 
- https://firebase.google.com/docs/cloud-messaging/migrate-v1
- https://apoorv487.medium.com/testing-fcm-push-notification-http-v1-through-oauth-2-0-playground-postman-terminal-part-2-7d7a6a0e2fa0


### To change user's phone no & name, please view this line
https://github.com/shiburagi/flutter_messenger_app_challenge/blob/4b5568a92738fd4ca0e1ad3aafd8a0cd4603f83e/lib/main.dart#L35


