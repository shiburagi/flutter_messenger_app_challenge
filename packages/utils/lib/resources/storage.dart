import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:utils/utils.dart';

Future createDummy(String senderId, String senderName) {
  return AppStorage.instance.storeChat(
      senderId,
      List.from([
        Chat(
                senderId: senderId,
                senderName: senderName,
                createdMillis: DateTime.now()
                    .add(Duration(days: -1))
                    .millisecondsSinceEpoch,
                message: "Hi...")
            .toJson()
      ]));
}

Future createDummies() async {
  await createDummy("60112233445", "Setsuna");
  await createDummy("60132233445", "Alex");
  await createDummy("60102233235", "Salmosa");
  await createDummy("60124123453", "Lupin");
  await createDummy("60184132142", "Lipin");
}

class AppStorage {
  static final AppStorage instance = AppStorage._();

  AppStorage._();

  Database? _database;

  StoreRef<String, List<Object?>> get chatsRef => StoreRef.main();

  Future initialize() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, 'chat.db');
      _database = await databaseFactoryIo.openDatabase(dbPath);

      if ((await chatsRef.findKeys(_database!)).isEmpty) await createDummies();
    } catch (e) {
      log("$e");
    }
  }

  Future storeChat(String key, List<Object?> messages) async {
    return await chatsRef.record(key).put(_database!, messages);
  }

  Future addMessage(String key, Map<String, dynamic> data) async {
    final messages = await getMessages(key) ?? [];
    log("$messages", name: "AppStorage");
    return await chatsRef.record(key).put(_database!, [data, ...messages]);
  }

  Future<List<String>> getSenders() {
    return chatsRef.findKeys(_database!);
  }

  Stream<RecordSnapshot<String, List<Object?>>> streamChats() {
    return chatsRef.stream(_database!);
  }

  Future<List<Object?>?> getMessages(String key) {
    return chatsRef.record(key).get(_database!);
  }

  Stream<RecordSnapshot<String, List<Object?>>?> streamMessages(String key) {
    return chatsRef.record(key).onSnapshot(_database!);
  }

  Future<Object?> getFirstMessage(String key) async {
    return (await chatsRef.record(key).get(_database!))?.first;
  }
}
