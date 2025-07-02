import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MsgBubble extends StatelessWidget {
  final String msg;
  final bool isUser;
  MsgBubble({required this.msg, required this.isUser});

  @override
  Widget build(BuildContext ctx) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        constraints: BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: isUser ? Color(0xFFF24E4E) : Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(19),
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Text(
          msg,
          style: isUser
              ? GoogleFonts.lexend(color: Colors.white)
              : GoogleFonts.lexend(color: Colors.black87),
        ),
      ),
    );
  }
}
