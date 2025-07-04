import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map> msgs = [];
  final ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool loading = false;
  int workflowStep = 0;

  final workflow = [
    "Enter question",
    "Save to DB",
    "RAG retrieval",
    "Top 3 sources",
    "Prepare for Gemini",
    "Send to Gemini",
    "Gemini response",
    "Log answer",
    "Delivered!",
  ];

  @override
  void dispose() {
    ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void sendMsg() async {
    if (ctrl.text.trim().isEmpty || loading) return;
    String q = ctrl.text;
    setState(() {
      msgs.add({"u": "me", "m": q});
      loading = true;
      workflowStep = 0;
      ctrl.clear();
    });
    await Future.delayed(Duration(milliseconds: 10));
    _scrollToBottom();

    for (var i = 1; i < workflow.length - 2; i++) {
      await Future.delayed(Duration(milliseconds: 320));
      setState(() => workflowStep = i);
    }

    final history = msgs.map((m) => {"u": m["u"], "m": m["m"]}).toList();

    final r = await http.post(
      Uri.parse('https://medbot-hrkk.onrender.com/chat/gemini'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"q": q, "history": history}),
    );

    String a = '';
    try {
      a = json.decode(r.body)['a'] ?? '';
    } catch (_) {
      a = "No response";
    }

    setState(() => workflowStep = workflow.length - 2);
    await Future.delayed(Duration(milliseconds: 350));
    setState(() => workflowStep = workflow.length - 1);
    await Future.delayed(Duration(milliseconds: 180));
    setState(() {
      msgs.add({"u": "bot", "m": a});
      loading = false;
    });
    await Future.delayed(Duration(milliseconds: 10));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent + 80,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  Widget workflowBar(ThmPrvdr thm) {
    final isDark = thm.dark;
    final doneClr = Colors.green;
    final curClr = thm.pri;
    final futClr = isDark ? Colors.white30 : Colors.black26;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(workflow.length, (i) {
            final bool isDone = i < workflowStep;
            final bool isCur = i == workflowStep && loading;
            return Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isDone ? doneClr : isCur ? curClr : futClr,
                        shape: BoxShape.circle,
                        border: isCur ? Border.all(color: curClr, width: 3) : null,
                      ),
                      child: Center(
                        child: isDone
                            ? Icon(Icons.check, size: 14, color: Colors.white)
                            : Text(
                                "${i + 1}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 70,
                      child: Text(
                        workflow[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDone
                              ? doneClr
                              : isCur
                                  ? curClr
                                  : futClr,
                          fontWeight: isCur ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
                if (i != workflow.length - 1)
                  Container(
                    width: 30,
                    height: 2,
                    color: isDone ? doneClr : futClr,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thm = Provider.of<ThmPrvdr>(context);
    final isDark = thm.dark;
    return Container(
      color: isDark ? thm.bg() : thm.bg(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 22),
          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.medical_services_rounded, color: thm.pri, size: 30),
    SizedBox(width: 8),
    Text("MedBot", style: thm.hdFnt),
    SizedBox(width: 8),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.orange.shade700 : Colors.orange.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "BETA",
        style: TextStyle(
          color: isDark ? Colors.white : Colors.orange.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1,
        ),
      ),
    ),
  ],
),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              reverse: false,
              itemCount: msgs.length,
              itemBuilder: (c, i) {
                final m = msgs[i];
                final isMe = m['u'] == "me";
                final bubbleColor = isMe
                    ? (isDark ? Colors.red.shade900 : Colors.red.shade100)
                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade200);
                final txtColor = isDark ? Colors.white : Colors.black87;
                final radius = BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 20 : 4),
                  topRight: Radius.circular(isMe ? 4 : 20),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                );

                return Container(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 22),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(maxWidth: 460),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: radius,
                    ),
                    child: m['u'] == "bot"
                        ? MarkdownBody(
                            data: m['m'] ?? '',
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                fontSize: 16,
                                color: txtColor,
                                fontFamily: 'Lexend',
                              ),
                              h1: TextStyle(
                                fontSize: 24,
                                color: txtColor,
                                fontWeight: FontWeight.bold,
                              ),
                              h2: TextStyle(
                                fontSize: 20,
                                color: txtColor,
                                fontWeight: FontWeight.bold,
                              ),
                              h3: TextStyle(
                                fontSize: 18,
                                color: txtColor,
                                fontWeight: FontWeight.bold,
                              ),
                              code: TextStyle(
                                fontSize: 15,
                                color: isDark ? Colors.pink[200] : Colors.red[900],
                                backgroundColor: isDark ? Colors.black26 : Colors.grey[200],
                                fontFamily: 'FiraMono',
                              ),
                              blockquote: TextStyle(
                                color: isDark ? Colors.cyan[200] : Colors.cyan[900],
                              ),
                              strong: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: txtColor,
                              ),
                              listBullet: TextStyle(
                                color: txtColor,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Text(
                            m['m'] ?? '',
                            style: TextStyle(
                                fontSize: 16,
                                color: txtColor,
                                fontFamily: 'Lexend'),
                          ),
                  ),
                );
              },
            ),
          ),
          if (loading)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 3, color: thm.pri)),
                    SizedBox(width: 10),
                    Text(
                      "Thinking...",
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16),
                    ),
                  ],
                ),
                workflowBar(thm),
              ],
            ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 24, left: 24, right: 24, top: loading ? 2 : 22),
            child: Row(
              children: [
                Icon(Icons.local_hospital,
                    color: isDark ? Colors.red.shade200 : Colors.red.shade200),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: "Type your medical question...",
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => sendMsg(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: thm.pri),
                  onPressed: sendMsg,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
