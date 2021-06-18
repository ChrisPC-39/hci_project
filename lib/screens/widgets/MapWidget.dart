import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class MapWidget extends StatefulWidget {
  final double size;
  final Alignment pinAlignment;

  final Function callback;

  const MapWidget({Key? key, required this.callback, required this.size, required this.pinAlignment}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    final bool isTrit = setup.color == 0xFFffef5350;
    final bool isDef = setup.color == 0xFF2196f3;

    return Align(
      alignment: Alignment(-1.0, 0.0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: widget.callback(),
                  child: Image(
                    height: widget.size,
                    width: widget.size,
                    image: AssetImage(setup.isLobitos
                        ? isDef ? "assets/lobitos.png" : isTrit ? "assets/lobitos-trit.png" : "assets/lobitos-prot.png"
                        : isDef ? "assets/piedritas.png" : isTrit ? "assets/piedritas-trit.png" : "assets/piedritas-prot.png"
                    )
                  )
                ),

                Container(
                  height: widget.size - 100,
                  width: widget.size - 100,
                  child: Align(
                    alignment: widget.pinAlignment,
                    child: Visibility(
                      visible: select.pinnedMap,
                      child: Icon(Icons.pin_drop, color: Colors.red[400])
                    )
                  )
                )
              ]
            ),

            Container(height: 15),

            TextButton(
              onPressed: widget.callback(),
              child: Text(
                !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: setup.fontSize)
              )
            )
          ]
        )
      )
    );
  }
}