import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final thm = Provider.of<ThmPrvdr>(context);
    return Container(
      color: thm.bg(),
      child: ListView(
        padding: EdgeInsets.all(22),
        children: [
          Text("Settings", style: thm.hdFnt),
          SizedBox(height: 18),
          SwitchListTile(
            value: thm.dark,
            onChanged: (val) => thm.setDark(val),
            title: Text("Dark Theme", style: thm.fnt),
            activeColor: thm.pri,
          ),
          // Add more settings as needed
        ],
      ),
    );
  }
}
