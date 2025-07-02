import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'pages/chat_page.dart';
import 'pages/about_page.dart';
import 'pages/improve_page.dart';
import 'pages/settings_page.dart';
import 'widgets/sidebar.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThmPrvdr(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thm = Provider.of<ThmPrvdr>(context);
    return MaterialApp(
      title: 'MedBot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: thm.dark ? Brightness.dark : Brightness.light,
        primaryColor: thm.pri,
        scaffoldBackgroundColor: thm.bg(),
        fontFamily: 'Lexend',
        appBarTheme: AppBarTheme(
          backgroundColor: thm.bg(),
          iconTheme: IconThemeData(color: thm.pri),
          titleTextStyle: thm.hdFnt,
        ),
      ),
      home: RootMedBot(),
    );
  }
}

class RootMedBot extends StatefulWidget {
  @override
  State<RootMedBot> createState() => _RootMedBotState();
}

class _RootMedBotState extends State<RootMedBot> {
  bool chatStarted = false;
  int idx = 0;
  bool expanded = false;

  final pages = [
    ChatPage(),
    AboutPage(),
    ImprovePage(),
    SettingsPage(),
  ];
  final navLabels = ['Chat', 'About', 'Improve', 'Settings'];
  final navIcons = [
    Icons.chat_bubble_outline,
    Icons.info_outline,
    Icons.lightbulb_outline,
    Icons.settings_outlined,
  ];

  void startChat() => setState(() => chatStarted = true);

  void returnToLanding() => setState(() => chatStarted = false);

  void toggleSidebar() => setState(() => expanded = !expanded);

  @override
  Widget build(BuildContext context) {
    if (!chatStarted) {
      return LandingPage(onStartChat: startChat);
    }
    return Scaffold(
      body: Row(
        children: [
          SideBar(
            icons: navIcons,
            labels: navLabels,
            selected: idx,
            expanded: expanded,
            onTap: (i) => setState(() => idx = i),
            onMenu: toggleSidebar,
            onHome: returnToLanding, // <--- FIX: Add this line!
          ),
          Expanded(child: pages[idx]),
        ],
      ),
    );
  }
}
