import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/phone_main_screen.dart';
import 'package:hci_project/screens/web_main_screen.dart';
import 'package:hci_project/screens/widgets/ArrowBackButton.dart';
import 'package:hci_project/screens/widgets/ArrowForwardButton.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../globals.dart';
import 'setup_screens/font_size_screen.dart';
import 'setup_screens/language_screen.dart';
import 'setup_screens/region_screen.dart';
import 'setup_screens/theme_screen.dart';
import 'setup_screens/tts_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int currPage = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);

  void changePage(int toPage) {
    if(toPage == 5) endSetup();               //Change toPage if more pages are added or deleted
    pageController.animateToPage(
      toPage,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInBack
    );
  }

  void endSetup() {
    final setup = Hive.box("set").getAt(0) as Setup;
    Hive.box("set").putAt(0, Setup(false, setup.lang, setup.color, setup.isLobitos, setup.fontSize));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>
      kIsWeb && MediaQuery.of(context).size.width > 700 ? WebMainScreen() : PhoneMainScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("set").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("set").getAt(0) as Setup;
        final bool isEn = setup.lang.contains("en");

        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () => speak(isEn ? "Set up" : "Configurar"),
              child: Text(isEn ? "Set up" : "Configurar")),
            backgroundColor: Color(setup.color)
          ),
          body: Column(
            children: [
              _buildTitle(),

              Expanded(
                child: PageView(
                  onPageChanged: (index) => setState(() => currPage = index),
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  children: [
                    LanguageScreen(),
                    FontSizeScreen(),
                    TTSScreen(),
                    ThemeScreen(),
                    RegionScreen()
                  ]
                )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ArrowBackButton(currPage: currPage, callback: changePage),
                  ArrowForwardButton(currPage: currPage, callback: changePage, targetPage: 5)
                ]
              )
            ]
          )
        );
      }
    );
  }

  Widget _buildTitle() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final isEn = setup.lang.contains("en");

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: GestureDetector(
            onTap: () => speak(isEn ? "Let's begin by setting up your preferences" : "Comencemos por configurando sus preferencias"),
            child: Text(
              isEn ? "Let's begin by setting up your preferences" : "Comencemos por configurando sus preferencias",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: setup.fontSize - 2
              )
            )
          )
        )
      )
    );
  }
}