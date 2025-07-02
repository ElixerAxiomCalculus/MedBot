import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  final VoidCallback? onStartChat;
  const LandingPage({Key? key, this.onStartChat}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
  final scrollCtrl = ScrollController();
  final chatScrollCtrl = ScrollController();
  int chatIdx = 0;
  List<Map<String, String>> demoMsgs = [
    {"u": "me", "m": "What are the symptoms of malaria?"},
    {"u": "bot", "m": "Malaria symptoms include fever, chills, headache, muscle pain, and fatigue."},
    {"u": "me", "m": "How do I prevent dengue?"},
    {"u": "bot", "m": "Prevent dengue by using mosquito nets, wearing long sleeves, and removing standing water."},
    {"u": "me", "m": "Is paracetamol safe for kids?"},
    {"u": "bot", "m": "Paracetamol is generally safe for children, but use the correct dose and consult a doctor."},
  ];

  @override
  void initState() {
    super.initState();
    animateChat();
  }

  void animateChat() async {
    
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        chatIdx = (chatIdx + 1) % (demoMsgs.length + 1);
      });
      if (chatScrollCtrl.hasClients) {
        chatScrollCtrl.animateTo(
          chatScrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    scrollCtrl.dispose();
    chatScrollCtrl.dispose();
    super.dispose();
  }

  Widget buildChatDemo(BuildContext context, bool dark) {
    final msgsToShow = demoMsgs.take(chatIdx).toList();
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 420,
        minHeight: 220,
        maxHeight: 260,
      ),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF15181E) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Scrollbar(
        controller: chatScrollCtrl,
        thumbVisibility: true,
        radius: const Radius.circular(14),
        thickness: 6,
        child: ListView.builder(
          controller: chatScrollCtrl,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          itemCount: msgsToShow.length + (chatIdx == demoMsgs.length ? 1 : 0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            if (i < msgsToShow.length) {
              final m = msgsToShow[i];
              return Align(
                alignment: m['u'] == 'me' ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                  decoration: BoxDecoration(
                    color: m['u'] == 'me'
                        ? (dark ? Colors.red.shade900 : Colors.red.shade100)
                        : (dark ? Colors.grey.shade800 : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      m['m']!,
                      softWrap: true,
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        color: dark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: dark ? Colors.redAccent : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "MedBot is typing...",
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          color: dark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildSectionTitle(String txt, {Color? color, double sz = 36}) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 28),
      child: Text(
        txt,
        style: GoogleFonts.lexend(
          fontSize: sz,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black87,
          letterSpacing: -1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget featureCard(String title, String desc, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color?.withOpacity(0.09) ?? Colors.grey[100],
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 18, offset: const Offset(0, 10))
        ],
      ),
      width: 340,
      child: Row(
        children: [
          Icon(icon, size: 40, color: color ?? Colors.redAccent),
          const SizedBox(width: 18),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.lexend(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 7),
                Text(desc,
                    style: GoogleFonts.lexend(fontSize: 16, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget animatedWorkflowSection() {
    final steps = [
      {
        "label": "User Query",
        "desc": "User types a health-related question in natural language.",
        "icon": Icons.question_answer,
        "color": Colors.blue,
      },
      {
        "label": "Preprocessing",
        "desc": "Query is preprocessed for medical keywords and intent.",
        "icon": Icons.filter_alt,
        "color": Colors.teal,
      },
      {
        "label": "RAG Search",
        "desc":
            "Retrieval-Augmented Generation (RAG) fetches top medical sources from a curated DB.",
        "icon": Icons.storage_rounded,
        "color": Colors.orange,
      },
      {
        "label": "GenAI Synthesis",
        "desc": "A GenAI model synthesizes a custom response with references.",
        "icon": Icons.smart_toy_rounded,
        "color": Colors.purple,
      },
      {
        "label": "Response Delivery",
        "desc":
            "User receives a clear, readable answer with references and suggestions.",
        "icon": Icons.send_rounded,
        "color": Colors.red,
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 950;
          if (isWide) {
            return Center(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: steps.map((step) => Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (step["color"] as Color).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: step["color"] as Color,
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(step["icon"] as IconData, color: step["color"] as Color, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(step["label"] as String,
                              style: GoogleFonts.lexend(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: step["color"] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(step["desc"] as String,
                        style: GoogleFonts.lexend(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: steps.map((step) => Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (step["color"] as Color).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: step["color"] as Color,
                    width: 1.4,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(step["icon"] as IconData, color: step["color"] as Color, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(step["label"] as String,
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: step["color"] as Color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(step["desc"] as String,
                            style: GoogleFonts.lexend(fontSize: 15, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            );
          }
        },
      ),
    );
  }

  Widget developerSection() {
    return Container(
      color: const Color(0xFFF5F7FF),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      child: Column(
        children: [
          buildSectionTitle("For Developers", color: Colors.teal, sz: 31),
          Text(
            "MedBot uses a modern technical stack:\n"
            "• Flutter Web frontend with advanced state management.\n"
            "• FastAPI backend for secure and scalable API endpoints.\n"
            "• MongoDB for chat history and RAG context storage.\n"
            "• Retrieval-Augmented Generation (RAG) pipeline integrating GenAI and document retrievers.\n"
            "• CORS, JWT, and role-based access in the API layer.\n"
            "• Markdown support, LaTeX rendering, and animated UI.",
            style: GoogleFonts.lexend(fontSize: 18, color: Colors.black87, height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Text(
            "This project is open to contributions. Check out the repository on GitHub to learn more about the codebase and workflow.",
            style: GoogleFonts.lexend(fontSize: 15, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget researchSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      child: Column(
        children: [
          buildSectionTitle("Research Approach", color: Colors.red[700], sz: 31),
          Text(
            "MedBot leverages the latest advances in NLP, retrieval-augmented generation, and GenAI. "
            "The system ensures transparency by providing references for critical answers and combining curated medical content with generative outputs. "
            "We believe in responsible AI—so human oversight and up-to-date datasets are always part of our pipeline.",
            style: GoogleFonts.lexend(fontSize: 18, color: Colors.black87, height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFf3e7e9), const Color(0xFFe6eef8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 22),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.medical_services_rounded,
                          color: Colors.red, size: 34),
                      const SizedBox(width: 12),
                      Text("MedBot",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: Colors.redAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            scrollCtrl.animateTo(
                              560,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOutCubic,
                            );
                          },
                          child: Text("Features",
                              style: GoogleFonts.lexend(
                                  fontSize: 17,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500))),
                      const SizedBox(width: 15),
                      TextButton(
                          onPressed: () {
                            scrollCtrl.animateTo(
                              1160,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOutCubic,
                            );
                          },
                          child: Text("How It Works",
                              style: GoogleFonts.lexend(
                                  fontSize: 17,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500))),
                      const SizedBox(width: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 28),
                          ),
                          onPressed: widget.onStartChat,
                          child: Text("Try the Chatbot",
                              style: GoogleFonts.lexend(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 50, left: 44, right: 44, bottom: 44),
                      child: LayoutBuilder(builder: (context, constraints) {
                        final bool isWide = constraints.maxWidth > 1050;
                        return Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: isWide ? 6 : 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("AI Health Chatbot\nfor Everyone.",
                                      style: GoogleFonts.lexend(
                                          fontSize: 52,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red[800])),
                                  const SizedBox(height: 14),
                                  Text(
                                    "Get instant, trustworthy medical answers powered by GenAI. Ask anything, anytime.",
                                    style: GoogleFonts.lexend(
                                        fontSize: 22, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 38),
                                  ElevatedButton(
                                    onPressed: widget.onStartChat,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18, horizontal: 40),
                                    ),
                                    child: Text("Try MedBot Now",
                                        style: GoogleFonts.lexend(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                            color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: isWide ? 36 : 0, height: isWide ? 0 : 44),
                            Expanded(
                              flex: isWide ? 5 : 0,
                              child: Center(
                                child: buildChatDemo(context, isDark),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Container(
                      color: const Color(0xFFF9FAFB),
                      padding: const EdgeInsets.only(top: 22, bottom: 48),
                      child: Column(
                        children: [
                          buildSectionTitle("Features", color: Colors.redAccent, sz: 38),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              featureCard(
                                "Private & Secure",
                                "All chats are encrypted, your queries are never used for training. Privacy is a top priority.",
                                Icons.lock_rounded,
                                color: Colors.deepPurple,
                              ),
                              featureCard(
                                "24/7 Instant Answers",
                                "MedBot is always awake, giving you reliable, fast responses on your device.",
                                Icons.access_time_filled,
                                color: Colors.blue,
                              ),
                              featureCard(
                                "GenAI + RAG",
                                "Combines Retrieval-Augmented Generation with curated medical sources for transparency.",
                                Icons.science_rounded,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    animatedWorkflowSection(),
                    developerSection(),
                    researchSection(),
                    const SizedBox(height: 56),
                    Center(
                      child: Text("© 2025 MedBot. Built by Sayak Mondal • Powered by Flutter & GenAI",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black38)),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
