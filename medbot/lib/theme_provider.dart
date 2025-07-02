import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThmPrvdr extends ChangeNotifier {
  bool dark = false;
  Color pri = Colors.red.shade400;
  Color sec = Colors.grey.shade200;
  Color bg() => dark ? Colors.grey[900]! : Colors.white;
  Color msgSelf() => Colors.red.shade100;
  Color msgBot() => Colors.grey.shade200;
  Color chatInputBg() => dark ? Colors.grey[850]! : Colors.grey[100]!;

  // Text
  Color txt() => dark ? Colors.white : Colors.black87;

  TextStyle get fnt => GoogleFonts.lexend(fontSize: 16, color: txt());
  TextStyle get msgFnt => GoogleFonts.quicksand(fontSize: 16, color: txt());
  TextStyle get hdFnt => GoogleFonts.museoModerno(
      fontWeight: FontWeight.bold, fontSize: 26, color: pri);
  TextStyle get subFnt =>
      GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.w600, color: pri);

  // For markdown
  TextStyle get mHeading =>
      GoogleFonts.museoModerno(fontWeight: FontWeight.bold, fontSize: 28, color: pri);
  TextStyle get mSubheading =>
      GoogleFonts.museoModerno(fontWeight: FontWeight.bold, fontSize: 20, color: pri);
  TextStyle get mPara => GoogleFonts.lexend(fontSize: 16, color: txt());
  TextStyle get mList => GoogleFonts.quicksand(fontSize: 16, color: txt());

  void setDark(bool val) {
    dark = val;
    notifyListeners();
  }
}
