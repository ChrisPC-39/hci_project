import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../globals.dart';
import 'setup_screens/font_size_screen.dart';
import 'setup_screens/language_screen.dart';
import 'setup_screens/region_screen.dart';
import 'setup_screens/theme_screen.dart';
import 'setup_screens/tts_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("set").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("set").getAt(0) as Setup;
        final bool isEn = setup.lang.contains("en");

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: GestureDetector(
              onTap: () => speak(isEn ? "Settings" : "Configuraciones"),
              child: Text(isEn ? "Settings" : "Configuraciones")), backgroundColor: Color(setup.color)
            ),
            body: ListView(
              children: [
                SizedBox(height: 300, child: FontSizeScreen()),

                Divider(thickness: 1),

                SizedBox(height: 300, child: TTSScreen()),

                Divider(thickness: 1),

                SizedBox(height: 300, child: ThemeScreen()),

                Divider(thickness: 1),

                SizedBox(height: 300, child: LanguageScreen()),

                Divider(thickness: 1),

                SizedBox(height: 300, child: RegionScreen())
              ]
            )
          )
        );
      }
    );
  }
}