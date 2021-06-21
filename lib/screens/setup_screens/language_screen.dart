import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../globals.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  FlutterTts tts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 1),
        _buildChooseLang(),
        Spacer(flex: 1)
      ]
    );
  }

  Widget _buildChooseLang() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final isEn = setup.lang.contains("en");
    final isTTS = setup.lang.contains("v");

    return Column(
      children: [
        GestureDetector(
          onTap: () => speak(isEn ? "Select your preferred language" : "Seleccione su idioma preferido"),
          child: Text(
            isEn ? "Select your preferred language" : "Seleccione su idioma preferido",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: setup.fontSize //was 18
            )
          )
        ),

        SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20),
            Column(
              children: [
                Stack(
                  children: [
                    ElevatedButton(
                      child: Image(image: AssetImage('assets/uk.png'), width: 90, height: 90),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(Colors.white)
                      ),
                      onPressed: () => setState(() {
                        speak(isEn ? "English" : "Inglesa");
                        Hive.box("set").putAt(0, Setup(setup.isFirstTime, isTTS ? "ven" : "en", setup.color, setup.isLobitos, setup.fontSize));
                      })
                    ),

                    Visibility(
                      visible: isEn,
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 90,
                        height: 90,
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5)
                        )
                      )
                    )
                  ]
                ),

                Container(height: 20),
                GestureDetector(
                  onTap: () => speak(isEn ? "English" : "Inglesa"),
                  child: Text("ENGLISH", style: TextStyle(fontWeight: FontWeight.bold))
                )
              ]
            ),

            Column(
              children: [
                Stack(
                  children: [
                    ElevatedButton(
                      child: Image(image: AssetImage('assets/spain.png'), width: 90, height: 90),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(Colors.white)
                      ),
                      onPressed: () => setState(() {
                        speak(isEn ? "Spanish" : "Espanol");
                        Hive.box("set").putAt(0, Setup(setup.isFirstTime, isTTS ? "ves" : "es", setup.color, setup.isLobitos, setup.fontSize));
                      })
                    ),

                    Visibility(
                      visible: !isEn,
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 90,
                        height: 90,
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5)
                        )
                      )
                    )
                  ]
                ),

                Container(height: 20),
                GestureDetector(
                  onTap: () => speak(isEn ? "Spanish" : "Espanol"),
                  child: Text("ESPANOL", style: TextStyle(fontWeight: FontWeight.bold))
                )
              ]
            ),

            SizedBox(width: 20),
          ]
        )
      ]
    );
  }
}