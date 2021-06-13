import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
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
    final setup = Hive.box("settings").getAt(0) as Setup;

    return Column(
      children: [
        Text(
          setup.lang == "en" ? "Select your preferred language" : "Hola mundo",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          )
        ),

        SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  child: Image(image: AssetImage('assets/uk.png'), width: 90, height: 90),
                  //child: Icon(Icons.ac_unit, size: 35, color: Colors.black),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  onPressed: () => setState(() {
                    Hive.box("settings").putAt(0, Setup(setup.isFirstTime, "en", setup.color, setup.isLobitos));
                  })
                ),

                Container(height: 20),
                Text("ENGLISH", style: TextStyle(fontWeight: FontWeight.bold))
              ]
            ),

            Column(
              children: [
                ElevatedButton(
                  child: Image(image: AssetImage('assets/spain.png'), width: 90, height: 90),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  onPressed: () => setState(() {
                    Hive.box("settings").putAt(0, Setup(setup.isFirstTime, "es", setup.color, setup.isLobitos));
                  })
                ),

                Container(height: 20),
                Text("ESPANOL", style: TextStyle(fontWeight: FontWeight.bold))
              ]
            ),

            SizedBox(width: 20),
          ]
        ),

        // ElevatedButton(
        //   child: Icon(
        //     Icons.phone_android,
        //     size: 35,
        //     color: Colors.white
        //   ),
        //   onPressed: () => setState(() {}),
        //   style: ButtonStyle(
        //     minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
        //     shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
        //     backgroundColor: MaterialStateProperty.resolveWith<Color>(
        //       (Set<MaterialState> states) { return Colors.white; }
        //     )
        //   )
        // )
      ]
    );
  }
}