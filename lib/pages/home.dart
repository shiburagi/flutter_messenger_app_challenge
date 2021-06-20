import 'package:chat_logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_messager_app_challenge/views/chat_list.dart';
import 'package:flutter_messager_app_challenge/views/home.dart';
import 'package:utils/models/user.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final userBloc = context.read<UserBloc>();
    listenTo(userBloc.state);
    userBloc.stream.listen((event) {
      listenTo(event);
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
