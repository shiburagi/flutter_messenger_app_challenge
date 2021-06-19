import 'package:chat_logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/l10n.dart';

class ChatAppBar extends AppBar {
  ChatAppBar(BuildContext context, {required Widget title})
      : super(
          elevation: 0,
          shape: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor)),
          title: title,
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Theme.of(context).primaryColor,
          iconTheme: Theme.of(context).iconTheme,
          textTheme: Theme.of(context).textTheme,
        );
}

class EditorPane extends StatefulWidget {
  const EditorPane({
    Key? key,
  }) : super(key: key);

  @override
  _EditorPaneState createState() => _EditorPaneState();
}

class _EditorPaneState extends State<EditorPane> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Flexible(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                        icon: Icon(Icons.attach_file_outlined),
                        onPressed: () {}),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      width: 1,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Theme.of(context)
                                .dividerColor
                                .withOpacity(0.05),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "${S.of(context).hello}?",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            return FloatingActionButton(
                child: Icon(
                  Icons.send,
                  size: 24,
                  color: Colors.white,
                ),
                heroTag: "action",
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  final user = context.read<UserBloc>().state;
                  if (user != null && state.senderId != null) {
                    context
                        .read<ChatBloc>()
                        .pushMessage(user, state.senderId!, controller.text);
                    controller.clear();
                  }
                });
          }),
          // Card(
          //   elevation: 4,
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
          //   color: Theme.of(context).primaryColor,
          //   child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
          //     return IconButton(
          //       icon: Icon(
          //         Icons.send,
          //         size: 16,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {
          //         final user = context.read<UserBloc>().state;
          //         if (user != null && state.senderId != null) {
          //           context
          //               .read<ChatBloc>()
          //               .pushMessage(user, state.senderId!, controller.text);
          //           controller.clear();
          //         }
          //       },
          //     );
          //   }),
          // )
        ],
      ),
    );
  }
}
