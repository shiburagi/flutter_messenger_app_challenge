import 'package:auto_animated/auto_animated.dart';
import 'package:chat_logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_messager_app_challenge/views/chat.dart';
import 'package:localization/l10n.dart';
import 'package:uikit/uikit.dart';
import 'package:utils/utils.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.senderId}) : super(key: key);

  final String senderId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final options = LiveOptions(
    showItemInterval: Duration(milliseconds: 150),
    showItemDuration: Duration(milliseconds: 200),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );

  final _controller = ScrollController();

  bool showNewMessageToggle = false;
  @override
  void initState() {
    context.read<ChatBloc>().listenMessages(widget.senderId);
    _controller.addListener(() {
      if (showNewMessageToggle && _controller.offset < 15) {
        setState(() {
          showNewMessageToggle = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    context.read<ChatBloc>().removeSender();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        context,
        title: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          return Text(state.senders?[widget.senderId]?.name ?? widget.senderId);
        }),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: BlocBuilder<UserBloc, User?>(builder: (context, user) {
              return BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) {
                  if (current.chats?.isNotEmpty == true &&
                      current.chats?[0].senderId == user?.mobileNumber)
                    _controller.jumpTo(0);
                  else if (_controller.offset > 15) {
                    setState(() {
                      showNewMessageToggle = true;
                    });
                  }
                  return true;
                },
                builder: (context, state) {
                  return LiveList.options(
                    controller: _controller,
                    padding: EdgeInsets.only(bottom: 72),
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index, animation) {
                      final chat = state.chats![index];

                      return FadeSlideAnimationContainer(
                        key: Key("$chat.createdMillis"),
                        animation: animation,
                        child: MessageView(
                          chat: chat,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      final chat = state.chats![index];
                      final nextChat = index + 1 < state.chats!.length
                          ? state.chats![index + 1]
                          : null;

                      final date = chat.createdMillis?.userShortDate;
                      final nextChatDate =
                          nextChat?.createdMillis?.userShortDate;

                      return date != nextChatDate
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Text(
                                date ?? "",
                                style:
                                    AppTextStyle.regular().colorHint(context),
                              ),
                            )
                          : SizedBox();
                    },
                    itemCount: state.chats?.length ?? 0,
                    options: options,
                  );
                },
              );
            }),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Column(
              children: [
                buildNewMessageToggle(context),
                EditorPane(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Visibility buildNewMessageToggle(BuildContext context) {
    return Visibility(
      visible: showNewMessageToggle,
      child: InkWell(
        onTap: () {
          _controller.animateTo(0,
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          setState(() {
            showNewMessageToggle = false;
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Theme.of(context).primaryColor,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.arrow_downward_outlined,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(right: 8, bottom: 4),
                  child: Text(S.of(context).newmessage,
                      style: AppTextStyle.semiBold()
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  const MessageView({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;
  @override
  Widget build(BuildContext context) {
    final isMe = context.read<UserBloc>().isMe(chat.senderId ?? "");
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 2,
                    shape: isMe ? MessageBoxShape.invert() : MessageBoxShape(),
                    child: Container(
                      color: isMe
                          ? Theme.of(context).primaryColor.withOpacity(0.5)
                          : null,
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              chat.message ?? "",
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              chat.createdMillis?.userTime ?? "",
                              textAlign: TextAlign.end,
                              style: AppTextStyle.caption(context)
                                  ?.colorHint(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
