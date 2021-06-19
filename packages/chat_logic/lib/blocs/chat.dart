import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:repositories/repositories.dart';
import 'package:utils/resources/storage.dart';
import 'package:utils/utils.dart';

class ChatBloc extends Cubit<ChatState> {
  ChatBloc() : super(ChatState());

  removeListen() {
    emit(ChatState());
  }

  listenSenders(User user) async {
    AppStorage.instance.streamChats().listen((event) {
      Map<String, Sender> senders = state.senders ?? {};

      final sender = Sender(
        senderId: event.key,
        name: event.key,
      );
      final lastMessage = event.value.firstWhere((element) {
        return true;
      }, orElse: () => null);

      final senderInfo = event.value.firstWhere((element) {
        Chat chat = Chat.fromJson(element as Map<String, dynamic>);
        return chat.senderId != user.mobileNumber;
      }, orElse: () => null);

      if (senderInfo == null) return;
      if (lastMessage != null) {
        Chat info = Chat.fromJson(senderInfo as Map<String, dynamic>);
        Chat chat = Chat.fromJson(lastMessage as Map<String, dynamic>);
        sender.name = info.senderName;
        sender.updatedMillis = chat.createdMillis;
        sender.lastMessage = chat.message;
      }

      senders[event.key] = sender;
      if (event.key == state.senderId)
        emit(state.copyWith(
          senders: {...senders},
          chats: toChats(event.value),
        ));
      else
        emit(state.copyWith(
          senders: {...senders},
        ));
    });
  }

  Future listenMessages(String senderId) async {
    final records = await AppStorage.instance.getMessages(senderId);
    emit(state.copyWith(senderId: senderId, chats: toChats(records ?? [])));
  }

  Future removeSender() async {
    emit(state.copyWith(senderId: "", chats: []));
  }

  List<Chat> toChats(List<Object?> records) {
    return records.map((e) {
      return Chat.fromJson(e as Map<String, dynamic>);
    }).toList();
  }

  Future pushMessage(User user, String senderId, String text) async {
    Chat chat = Chat(
        message: text,
        createdMillis: DateTime.now().millisecondsSinceEpoch,
        senderId: user.mobileNumber,
        senderName: user.name);

    try {
      final response = await Repositories.instance.sendMessage(senderId, chat);
      // log("$response", name: "ChatBloc");

      if (state.senderId != null) {
        await AppStorage.instance.addMessage(state.senderId!, chat.toJson());
        await listenMessages(state.senderId!);
        await listenSenders(user);
      }
    } on DioError catch (e) {
      log("$e", name: "ChatBloc");
    }
  }
}

class ChatState {
  ChatState({this.senderId, this.chats, this.senders});
  final String? senderId;
  final List<Chat>? chats;
  final Map<String, Sender>? senders;

  ChatState copyWith({
    String? senderId,
    List<Chat>? chats,
    Map<String, Sender>? senders,
  }) =>
      ChatState(
        senderId: senderId ?? this.senderId,
        chats: chats ?? this.chats,
        senders: senders ?? this.senders,
      );
}
