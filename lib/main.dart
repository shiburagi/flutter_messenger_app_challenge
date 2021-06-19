import 'dart:convert';
import 'dart:developer';

import 'package:chat_logic/blocs/firebase.dart';
import 'package:chat_logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_messager_app_challenge/routes.dart';
import 'package:localization/localization.dart';
import 'package:utils/resources/storage.dart';
import 'package:utils/utils.dart';
import 'package:repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialiseFirebase();
  await AppStorage.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final chatBloc = ChatBloc();
  final userBloc = UserBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getFileData(context, "assets/firebase_secret.json").then((value) {
      final map = jsonDecode(value);
      Repositories.instance.initialize(map["app_id"], map["access_token"]);
    });
    final user = User(name: "Alex", mobileNumber: "60132233445");
    userBloc.update(user);

    FirebaseBloc().subscibe("tel_${user.mobileNumber}");
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: chatBloc),
        BlocProvider.value(value: userBloc),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          fontFamily: "MavenPro",
          primaryColor: Color(0xFF2ecc71),
          primaryColorDark: Color(0xFF27ae60),
          accentColor: Color(0xFF34495e),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: "MavenPro",
          canvasColor: Color(0xff2c3e50),
          bottomAppBarColor: Color(0xff34495e),
          cardColor: Color(0xff34495e),
          primaryColor: Color(0xFF2ecc71),
          primaryColorDark: Color(0xFF27ae60),
          accentColor: Color(0xFF34495e),
        ),
        routes: routes,
      ),
    );
  }
}
