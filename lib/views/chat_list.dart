import 'dart:developer';

import 'package:auto_animated/auto_animated.dart';
import 'package:chat_logic/blocs/firebase.dart';
import 'package:chat_logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_messager_app_challenge/routes.dart';
import 'package:localization/localization.dart';
import 'package:uikit/uikit.dart';
import 'package:utils/models/sender.dart';
import 'package:utils/resources/storage.dart';
import 'package:utils/utils.dart';

class ChatListView extends StatefulWidget {
  ChatListView({Key? key}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView>
    with WidgetsBindingObserver {
  final options = LiveOptions(
    showItemInterval: Duration(milliseconds: 150),
    showItemDuration: Duration(milliseconds: 200),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
    FirebaseBloc().startListen((chat) {
      final user = context.read<UserBloc>().state;
      if (user != null) context.read<ChatBloc>().listenSenders(user);
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
        if (userBloc.state != null)
          context.read<ChatBloc>().listenSenders(userBloc.state!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final senders =
              state.senders?.entries.map((e) => e.value).toList() ?? [];

          senders.sort((sender1, sender2) {
            return (sender2.updatedMillis ?? 0) - (sender1.updatedMillis ?? 0);
          });
          log("new state : ${senders.length}", name: "ChatListView");

          return LiveList.options(
              // padding: EdgeInsets.only(top: 8),
              itemBuilder: (context, index, animation) {
                final sender = senders[index];
                return FadeSlideAnimationContainer(
                  animation: animation,
                  child: ChatItem(sender: sender),
                );
              },
              itemCount: senders.length,
              options: options);
        },
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.sender,
  }) : super(key: key);

  final Sender sender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4, 6, 4, 0),
      child: InkWell(
        onTap: () {
          context.toChat(sender.senderId!);
        },
        child: Card(
          elevation: 3,
          shape: MessageBoxShape(),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildIndicator(context),
                Flexible(
                  child: buildDetails(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context) {
    final color = ColorUtils.stringToColor(sender.name ?? "");

    final textColor =
        color.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
      width: 60,
      child: Text(
        sender.name?.substring(0, 1) ?? "",
        style: Theme.of(context)
            .primaryTextTheme
            .headline6
            ?.copyWith(color: textColor),
      ),
    );
  }

  Container buildDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                sender.name ?? "",
                style: AppTextStyle.medium(),
              )),
              Text(
                sender.updatedMillis?.userTimeOrDate ?? "",
                style: AppTextStyle.regular()
                    .colorDisabled(context)
                    .copyWith(fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            sender.lastMessage ?? S.of(context).nomessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.regular().colorHint(context),
          ),
        ],
      ),
    );
  }
}
