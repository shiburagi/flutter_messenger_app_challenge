import 'package:flutter/material.dart';
import 'package:flutter_messager_app_challenge/pages/chat.dart';
import 'package:flutter_messager_app_challenge/pages/home.dart';

class RoutePath {
  static const landing = "/";
  static const chat = "/chat";
}

Map<String, WidgetBuilder> routes = {
  RoutePath.landing: (context) => HomePage(),
  RoutePath.chat: (context) => ChatPage(
        senderId: context.arguments as String,
      ),
};

extension RouteBuildContextExt on BuildContext {
  dynamic get arguments => ModalRoute.of(this)?.settings.arguments;
  NavigatorState get navigator => Navigator.of(this);
  Future toChat(String senderId) =>
      navigator.pushNamed(RoutePath.chat, arguments: senderId);
}
