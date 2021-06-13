import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/phone_main_screen.dart';
import 'package:hci_project/screens/web_main_screen.dart';
import 'package:hci_project/setup_screens/language_screen.dart';
import 'package:hci_project/setup_screens/region_screen.dart';
import 'package:hci_project/setup_screens/theme_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int currPage = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("settings").getAt(0) as Setup;
        final bool isEn = setup.lang == "en";

        return Scaffold(
          appBar: AppBar(title: Text(isEn ? "Set up" : "Set up in Spanish"), backgroundColor: Color(setup.color)),
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
                    ThemeScreen(),
                    RegionScreen()
                    // QuestionsScreen(),
                    // TimePicker()
                  ]
                )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    opacity: currPage > 0 ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.06,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 10),
                      child: ElevatedButton(
                        child: Icon(Icons.arrow_back_ios_rounded,
                          size: 35,
                          color: Colors.black
                        ),
                        style: ButtonStyle(
                          //minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.white)
                        ),
                        onPressed: () {
                          if (currPage > 0) currPage -= 1;
                          pageController.animateToPage(
                            currPage,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInBack
                          );
                        }
                      )
                    )
                  ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.06,
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 10),
                      child: ElevatedButton(
                        child: Icon(currPage != 2
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.check,
                            size: 35,
                            color: Colors.black
                        ),
                        style: ButtonStyle(
                          //minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          if (currPage == 2) {
                            final setup = Hive.box("settings").getAt(0) as Setup;
                            Hive.box("settings").putAt(0, Setup(false, setup.lang, setup.color, setup.isLobitos));

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) =>
                              kIsWeb ? WebMainScreen() : PhoneMainScreen())
                            );

                            return;
                          }

                          if (currPage < 2) currPage += 1;
                          pageController.animateToPage(
                            currPage,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInBack
                          );

                          setState(() {});
                      }
                    )
                  )
                ]
              )
            ]
          )
        );
      }
    );
  }

  Widget _buildTitle() {
    final setup = Hive.box("settings").getAt(0) as Setup;

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            setup.lang == "en" ? "Let's begin by setting up your preferences" : "Hola",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19
            )
          )
        )
      )
    );
  }
}