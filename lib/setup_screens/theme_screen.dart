import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../globals.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 1),
        _buildChooseTheme(),
        Spacer(flex: 1)
      ]
    );
  }

  Widget _buildChooseTheme() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    final bool isTrit = setup.color == 0xFFffef5350;
    final bool isProt = setup.color == 0xFFFFBC02D;
    final bool isDef = setup.color == 0xFF2196f3;

    return Column(
      children: [
        GestureDetector(
          onTap: () => speak(isEn ? "Select your preferred theme" : "Seleccione su tema preferido"),
          child: Text(
            isEn ? "Select your preferred theme" : "Seleccione su tema preferido",
            textAlign: TextAlign.center,

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: setup.fontSize //was 18
            )
          )
        ),

        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20),

            Column(
              children: [
                ElevatedButton(
                  child: Container(),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(isTrit ? 110 : 100)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Color(0xFFffef5350)),
                    //side: MaterialStateProperty.all(BorderSide(color: isTrit ? Colors.lightBlue : Colors.transparent, width: 3))
                  ),
                  onPressed: () => setState(() {
                    speak(isEn ? "Tritanopia" : "Tritanopia");
                    Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFFffef5350, setup.isLobitos, setup.fontSize));
                    setSystemChrome();
                  })
                ),

                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => speak(isEn ? "TRITANOPIA" : "TRITANOPÍA"),
                  child: Text(isEn ? "TRITANOPIA" : "TRITANOPÍA", style: TextStyle(fontWeight: FontWeight.bold))
                )
              ]
            ),

            Column(
              children: [
                ElevatedButton(
                  child: Container(),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(isProt ? 110 : 100)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Color(0xFFFFBC02D)),
                    //side: MaterialStateProperty.all(BorderSide(color: isProt ? Colors.purple : Colors.transparent, width: 3))
                  ),
                  onPressed: () => setState(() {
                    speak(isEn ? "Protanopia" : "Protanopia");
                    Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFFFFBC02D, setup.isLobitos, setup.fontSize));
                    setSystemChrome();
                  })
                ),

                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => speak(isEn ? "PROTANOPIA" : "PROTANOPIA"),
                  child: Text(isEn ? "PROTANOPIA" : "PROTANOPIA", style: TextStyle(fontWeight: FontWeight.bold))
                )
              ]
            ),

            SizedBox(width: 20)
            ]
        ),

        Column(
          children: [
            ElevatedButton(
              child: Container(),
              onPressed: () => setState(() {
                speak(isEn ? "Default" : "Defecto");
                Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFF2196f3, setup.isLobitos, setup.fontSize));
                setSystemChrome();
              }),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size.square(isDef ? 110 : 100)),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                backgroundColor: MaterialStateProperty.all(Color(0xFF2196f3)),
                //side: MaterialStateProperty.all(BorderSide(color: isDef ? Colors.green : Colors.transparent, width: 3))
              )
            ),

            SizedBox(height: 5),
            GestureDetector(
              onTap: () => speak(isEn ? "DEFAULT" : "DEFECTO"),
              child: Text(isEn ? "DEFAULT" : "DEFECTO", style: TextStyle(fontWeight: FontWeight.bold))
            )
          ],
        )
      ]
    );
  }

  void setSystemChrome() {
    final setup = Hive.box("set").getAt(0) as Setup;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Color(setup.color),
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(setup.color)
    ));
  }
}