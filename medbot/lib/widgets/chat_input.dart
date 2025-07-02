import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController ctl;
  final void Function() onSend;

  ChatInput({required this.ctl, required this.onSend});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctl,
              style: GoogleFonts.lexend(),
              decoration: InputDecoration(
                hintText: "Ask anything...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFFF24E4E)),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
