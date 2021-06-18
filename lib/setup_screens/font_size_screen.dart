import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../globals.dart';

class FontSizeScreen extends StatefulWidget {
  @override
  _FontSizeScreenState createState() => _FontSizeScreenState();
}

class _FontSizeScreenState extends State<FontSizeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 1),
        _buildFontChange(),
        Spacer(flex: 1)
      ]
    );
  }

  Widget _buildFontChange() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final isEn = setup.lang.contains("en");

    return Column(
      children: [
        GestureDetector(
          onTap: () => speak(isEn ? "Select your preferred font size" : "Seleccione su tamaño de fuente preferido"),
          child: Text(
            isEn ? "Select your preferred font size" : "Seleccione su tamaño de fuente preferido",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: setup.fontSize //was 18
            )
          ),
        ),

        SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if(setup.fontSize > 20)
                  Hive.box("set").putAt(0, Setup(
                    setup.isFirstTime,
                    setup.lang,
                    setup.color,
                    setup.isLobitos,
                    setup.fontSize - 1
                  ));

                setState(() {});
              },
              icon: Icon(Icons.zoom_out, size: 40, color: setup.fontSize == 20 ? Colors.grey : Colors.black)
            ),

            Container(width: 20),

            GestureDetector(
              onTap: () => speak(isEn ? "Normal text" : "Texto normal"),
              child: Text(isEn ? "Normal text" : "Texto normal", style: TextStyle(fontSize: setup.fontSize))
            ),

            Container(width: 20),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if(setup.fontSize < 35)
                  Hive.box("set").putAt(0, Setup(
                    setup.isFirstTime,
                    setup.lang,
                    setup.color,
                    setup.isLobitos,
                    setup.fontSize + 1
                  ));

                setState(() {});
              },
              icon: Icon(Icons.zoom_in, size: 40, color: setup.fontSize == 35 ? Colors.grey : Colors.black)
            ),
          ]
        )
      ]
    );
  }
}