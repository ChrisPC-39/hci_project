import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

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
          onTap: () => speak(isEn ? "Select your type of colorblindness" : "Seleccione su tipo de daltonismo"),
          child: Text(
            isEn ? "Select your type of colorblindness" : "Seleccione su tipo de daltonismo",
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
                Stack(
                  children: [
                    ElevatedButton(
                      child: Container(),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size.square(99)),
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(Color(0xFFffef5350))
                      ),
                      onPressed: () => setState(() {
                        speak(isEn ? "Tritanopia" : "Tritanopia");
                        Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFFffef5350, setup.isLobitos, setup.fontSize));
                        setSystemChrome();
                      })
                    ),

                    _buildOverlay(isTrit)
                  ]
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
                Stack(
                  children: [
                    ElevatedButton(
                      child: Container(),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size.square(99)),
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(Color(0xFFFFBC02D))
                      ),
                      onPressed: () => setState(() {
                        speak(isEn ? "Protanopia" : "Protanopia");
                        Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFFFFBC02D, setup.isLobitos, setup.fontSize));
                        setSystemChrome();
                      })
                    ),

                    _buildOverlay(isProt)
                  ]
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
            Stack(
              children: [
                ElevatedButton(
                  child: Container(),
                  onPressed: () => setState(() {
                    speak(isEn ? "Default" : "Defecto");
                    Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFF2196f3, setup.isLobitos, setup.fontSize));
                    setSystemChrome();
                  }),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(99)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Color(0xFF2196f3))
                  )
                ),

                _buildOverlay(isDef)
              ]
            ),

            SizedBox(height: 5),
            GestureDetector(
              onTap: () => speak(isEn ? "DEFAULT" : "DEFECTO"),
              child: Text(isEn ? "DEFAULT" : "DEFECTO", style: TextStyle(fontWeight: FontWeight.bold))
            )
          ]
        )
      ]
    );
  }

  Widget _buildOverlay(bool isEnabled) {
    return Visibility(
      visible: isEnabled,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 0.5, top: 0.5),
          width: 90,
          height: 90,
          child: Icon(Icons.check, color: Colors.white, size: 30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5)
          )
        ),
      )
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