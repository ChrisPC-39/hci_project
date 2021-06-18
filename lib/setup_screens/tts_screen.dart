import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../globals.dart';

class TTSScreen extends StatefulWidget {
  @override
  _TTSScreenState createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 1),
        _buildSelectTTS(),
        Spacer(flex: 1)
      ]
    );
  }

  Widget _buildSelectTTS() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");
    final bool isTTS = setup.lang.contains("v");

    return Column(
      children: [
        GestureDetector(
          onTap: () => speak(isEn ? "Enable text-to-speech" : "Habilitar texto-a-voz"),
          child: Text(
            isEn ? "Enable text-to-speech" : "Habilitar texto-a-voz",
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
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                forceSpeak(isEn ? "Press on any string of text to listen to it!" : "¡Presiona cualquier cadena de texto para escucharlo!");
                Hive.box("set").putAt(0, Setup(setup.isFirstTime, isEn ? "ven" : "ves", setup.color, setup.isLobitos, setup.fontSize));
              },
              icon: Icon(Icons.record_voice_over, size: 40, color: !isTTS ? Colors.black : Color(setup.color)),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () { Hive.box("set").putAt(0, Setup(setup.isFirstTime, isEn ? "en" : "es", setup.color, setup.isLobitos, setup.fontSize)); },
              icon: Icon(Icons.voice_over_off, size: 40, color: isTTS ? Colors.black : Color(setup.color)),
            ),
            SizedBox(width: 20)
          ]
        ),

        SizedBox(height: 20),

        Visibility(
          visible: isTTS,
          child: GestureDetector(
            onTap: () => speak(isEn ? "Press on any string of text to listen to it!" : "¡Presiona cualquier cadena de texto para escucharlo!"),
            child: Text(
              isEn ? "Press on any string of text to listen to it!" : "¡Presiona cualquier cadena de texto para escucharlo!",
              style: TextStyle(fontSize: setup.fontSize)
            )
          )
        )
      ]
    );
  }
}