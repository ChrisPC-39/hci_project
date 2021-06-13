import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/setup_screens/language_screen.dart';
import 'package:hci_project/setup_screens/region_screen.dart';
import 'package:hci_project/setup_screens/theme_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("settings").getAt(0) as Setup;
        final bool isEn = setup.lang == "en";

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Text(isEn ? "Settings" : "Settingso"), backgroundColor: Color(setup.color)),
            body: ListView(
              children: [
                SizedBox(height: 300, child: ThemeScreen()),

                Divider(thickness: 1),

                SizedBox(height: 300, child: LanguageScreen()),

                Divider(thickness: 1),

                SizedBox(height: 300, child: RegionScreen())
              ]
            )
          )
        );
      },
    );
  }
}