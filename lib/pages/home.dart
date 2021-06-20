import 'dart:developer';

import 'package:chat_logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_messager_app_challenge/views/chat_list.dart';
import 'package:flutter_messager_app_challenge/views/home.dart';
import 'package:utils/models/user.dart';
import 'package:utils/resources/storage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
    final userBloc = context.read<UserBloc>();
    listenTo(userBloc.state);
    userBloc.stream.listen((event) {
      listenTo(event);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppStorage.instance.initialize().then((value) {
      if (state == AppLifecycleState.resumed) {
        final userBloc = context.read<UserBloc>();
        listenTo(userBloc.state);
      }
    });
  }

  void listenTo(User? user) {
    final bloc = context.read<ChatBloc>();
    if (user != null)
      bloc.listenSenders(user);
    else
      bloc.removeListen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(context),
      bottomNavigationBar: HomeBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: "action",
        elevation: 8,
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: Container(child: Icon(Icons.create)),
      ),
      body: IndexedStack(
        children: [
          ChatListView(),
        ],
        index: 0,
      ),
    );
  }
}
