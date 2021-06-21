import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';


class RegionScreen extends StatefulWidget {
  @override
  _RegionScreenState createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final isEn = setup.lang.contains("en");

    return Column(
      children: [
        Spacer(flex: 1),
        _buildChooseRegion(),
        Container(height: 30),
        GestureDetector(
          onTap: () => speak(isEn
              ? "Your current region is ${setup.isLobitos ? "LOBITOS" : "PIEDRITAS"}"
              : "Tu región actual es ${setup.isLobitos ? "LOBITOS" : "PIEDRITAS"}"),
          child: Text(isEn
              ? "Your current region is ${setup.isLobitos ? "LOBITOS" : "PIEDRITAS"}"
              : "Tu región actual es ${setup.isLobitos ? "LOBITOS" : "PIEDRITAS"}",
            style: TextStyle(fontSize: setup.fontSize),
          ),
        ),
        Spacer(flex: 1)
      ]
    );
  }

  Widget _buildChooseRegion() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final isEn = setup.lang.contains("en");
    final isLob = setup.isLobitos;

    final bool isTrit = setup.color == 0xFFffef5350;
    final bool isProt = setup.color == 0xFFFFBC02D;
    final bool isDef = setup.color == 0xFF2196f3;

    return Column(
      children: [
        GestureDetector(
          onTap: () => speak(isEn ? "Select your region" : "Seleccione su región"),
          child: Text(
            isEn ? "Select your region" : "Seleccione su región",
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image(image: AssetImage(isDef ? "assets/lobitos.png" : isTrit ? "assets/lobitos-trit.png" : "assets/lobitos-prot.png"),
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill
                        )
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(Colors.white)
                      ),
                      onPressed: () => setState(() {
                        speak("Lobitos");
                        Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, setup.color, true, setup.fontSize));
                      })
                    ),

                    Visibility(
                      visible: isLob,
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
                  onTap: () => speak("Lobitos"),
                  child: Text("LOBITOS", style: TextStyle(fontWeight: FontWeight.bold))
                )
              ]
            ),

            Column(
              children: [
                Stack(
                  children: [
                    ElevatedButton(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image(image: AssetImage(isDef ? "assets/piedritas.png" : isTrit ? "assets/piedritas-trit.png" : "assets/piedritas-prot.png"),
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill
                        )
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size.square(60)),
                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(Colors.white)
                      ),
                      onPressed: () => setState(() {
                        speak("Piedritas");
                        Hive.box("set").putAt(0, Setup(setup.isFirstTime, setup.lang, setup.color, false, setup.fontSize));
                      })
                    ),

                    Visibility(
                      visible: !isLob,
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
                  onTap: () => speak("Piedritas"),
                  child: Text("PIEDRITAS", style: TextStyle(fontWeight: FontWeight.bold))
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