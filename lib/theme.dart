import 'package:flutter/material.dart';

enum ThemeType {Default, Protanopia, Tritanopia}

Theme curr = defaultTheme as Theme;

class Theme {
  late ThemeData theme;
}

// ThemeData theme = defaultTheme;
//
// class ThemeModel extends ChangeNotifier {
//   ThemeData currTheme = defaultTheme;
//   ThemeType _themeType = ThemeType.Default;
//
//   void switchThemeTo(ThemeType themeType) {
//
//   }
//
//   toggleTheme() {
//     if (_themeType == ThemeType.Default) {
//       currTheme = defaultTheme;
//       _themeType = ThemeType.Default;
//       return notifyListeners();
//     }
//
//     if (_themeType == ThemeType.Protanopia) {
//       currTheme = protanopiaTheme;
//       _themeType = ThemeType.Protanopia;
//     }
//
//     if(_themeType == ThemeType.Tritanopia) {
//       currTheme = tritanopiaTheme;
//       _themeType = ThemeType.Tritanopia;
//       return notifyListeners();
//     }
//   }
// }

ThemeData defaultTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xff1f655d),
  accentColor: Color(0xff40bf7a),
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.black),
    subtitle2: TextStyle(color: Colors.grey[600]),
    subtitle1: TextStyle(color: Colors.green)),
  appBarTheme: AppBarTheme(color: Colors.blue));

ThemeData protanopiaTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xfff5f5f5),
  accentColor: Color(0xff40bf7a),
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.black54),
    subtitle2: TextStyle(color: Colors.grey),
    subtitle1: TextStyle(color: Colors.white)),
  appBarTheme: AppBarTheme(
    color: Color(0xff1f655d),
    actionsIconTheme: IconThemeData(color: Colors.white))
  );

ThemeData tritanopiaTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xfff5f5f5),
  accentColor: Color(0xff40bf7a),
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.black54),
    subtitle2: TextStyle(color: Colors.grey),
    subtitle1: TextStyle(color: Colors.white)),
  appBarTheme: AppBarTheme(
    color: Colors.red,
    actionsIconTheme: IconThemeData(color: Colors.white))
);
