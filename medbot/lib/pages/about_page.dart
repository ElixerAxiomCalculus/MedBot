import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class AboutPage extends StatelessWidget {
  final String doc = """
# MedBot – The Future of Trustworthy Medical AI

MedBot is an AI-powered medical assistant designed to provide instant, transparent, and reliable information from trusted government, institutional, and peer-reviewed sources worldwide.

---

## Our Aim

To democratize high-quality health information and make medical knowledge accessible, transparent, and verifiable for everyone.

---

## How It Works

1. **User Query:** You ask any medical question via our chatbot interface.
2. **Context Retrieval (RAG):** The system instantly searches thousands of curated, government-authorized, and peer-reviewed medical sources for contextually relevant information.
3. **Data Extraction:** Top trusted information snippets are extracted from these sources in real-time.
4. **AI Reasoning:** The curated evidence and your question are sent to a GenAI model, which generates a detailed, natural language answer.
5. **Transparency:** Every workflow step is shown, including sources referenced and model activity.
6. **Continuous Improvement:** User feedback and reviewed public links help MedBot improve accuracy and coverage. All personal data is private.

---

## Patch Notes – v1

- New landing page with animated workflow
- Animated chat demo with smooth appearance
- Sidebar with “Return to Home”
- Modern About page, improved typography
- Better markdown rendering and division

---

<center>
[aisayak.in](https://www.aisayak.in)

_Powered by GenAI • RAG Search • MongoDB_
</center>
""";

  @override
  Widget build(BuildContext context) {
    final thm = Provider.of<ThmPrvdr>(context);

    return Scaffold(
      backgroundColor: thm.bg(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 820),
          margin: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 26,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.black12, width: 1.1),
          ),
          child: Markdown(
            data: doc,
            styleSheet: MarkdownStyleSheet(
              h1: thm.mHeading,
              h2: thm.mSubheading,
              p: thm.mPara,
              listBullet: thm.mList.copyWith(fontWeight: FontWeight.bold),
              code: thm.mList.copyWith(fontFamily: 'monospace', color: thm.pri),
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
              ),
              textAlign: WrapAlignment.start,
            ),
          ),
        ),
      ),
    );
  }
}
