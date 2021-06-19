import 'package:flutter/material.dart';

export 'models/chat.dart';
export 'models/sender.dart';
export 'models/user.dart';

export 'utils/formatter.dart';

Future<String> getFileData(BuildContext context, String path) async {
  return await DefaultAssetBundle.of(context).loadString(path);
}
