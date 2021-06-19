import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:utils/utils.dart';

class UserBloc extends Cubit<User?> {
  UserBloc() : super(null);

  update(User sender) {
    emit(sender);
  }

  bool isMe(String senderId) {
    log("isMe $senderId ${state?.mobileNumber}", name: "UserBloc");
    return state?.mobileNumber == senderId;
  }
}
