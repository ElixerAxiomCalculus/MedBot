import 'package:flutter/material.dart';
import 'msg_bubble.dart';
import 'chat_input.dart';

class ChatWidget extends StatelessWidget {
  final List<Map<String, dynamic>> msgs;
  final TextEditingController ctl;
  final void Function() onSend;

  ChatWidget({required this.msgs, required this.ctl, required this.onSend});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: msgs.length,
            itemBuilder: (ctx, i) {
              final m = msgs[msgs.length - 1 - i];
              return MsgBubble(msg: m["m"], isUser: m["u"]);
            },
          ),
        ),
        ChatInput(ctl: ctl, onSend: onSend),
      ],
    );
  }
}
