import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:utils/utils.dart';

class Repositories {
  static final Repositories instance = Repositories._();
  Repositories._() : dio = Dio();

  initialize(String projectId, String token) {
    this.projectId = projectId;
    this.token = token;
  }

  String projectId = "";
  String token = "";

  final Dio dio;
  Future<Response> sendMessage(String senderId, Chat chat) {
    log(jsonEncode(chat.toJson()));
    return dio.post(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send",
        data: {
          "message": {
            "topic": "tel_$senderId",
            "notification": {"body": chat.senderName, "title": chat.message},
            "data": chat.toJson(),
          }
        },
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }));
  }
}
