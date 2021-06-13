import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

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
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Column(
      children: [
        Text(
          isEn ? "Select your preferred theme" : "Hola",          //TODO SPANISH
          textAlign: TextAlign.center,

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          )
        ),

        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20),
            ElevatedButton(
              child: Text(isEn ? "TRITANOPIA" : "Trit spanish", style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size.square(100)),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                backgroundColor: MaterialStateProperty.all(Color(0xFFffef5350))
              ),
              onPressed: () => setState(() {
                Hive.box("settings").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFFffef5350, setup.isLobitos));
                setSystemChrome();
              })
            ),

            ElevatedButton(
              child: Text(isEn ? "PROTANOPIA" : "Prot spanish", style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size.square(100)),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                backgroundColor: MaterialStateProperty.all(Color(0xFFFFBC02D))
              ),
              onPressed: () => setState(() {
                Hive.box("settings").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFFFFBC02D, setup.isLobitos));
                setSystemChrome();
              })
            ),

            SizedBox(width: 20),
            ]
        ),

        ElevatedButton(
          child: Text(isEn ? "DEFAULT" : "Def spanish", style: TextStyle(color: Colors.black)),
          onPressed: () => setState(() {
            Hive.box("settings").putAt(0, Setup(setup.isFirstTime, setup.lang, 0xFF2196f3, setup.isLobitos));
            setSystemChrome();
          }),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size.square(100)),
            shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Color(0xFF2196f3))
          )
        )
      ]
    );
  }

  void setSystemChrome() {
    final setup = Hive.box("settings").getAt(0) as Setup;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Color(setup.color),
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(setup.color)
    ));
  }
}