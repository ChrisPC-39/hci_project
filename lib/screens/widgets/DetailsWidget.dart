import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class DetailsWidget extends StatefulWidget {
  @override
  _DetailsWidgetState createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Column(
      children: [
        Align(
          alignment: Alignment(0.0, -1.0),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              maxLines: null,
              controller: ctrl.detailsController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                labelText: isEn ? "Details" : "Detalles"
              )
            )
          )
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(setup.color))),
              onPressed: () { FocusScope.of(context).unfocus(); },
              child: Center(child: GestureDetector(
                onTap: () {
                  speak(isEn ? "Confirm details" : "Confirmar detalles");
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  isEn ? "Confirm details" : "Confirmar detalles",
                  style: TextStyle(fontSize: setup.fontSize))
              ))
            )
          ),
        )
      ]
    );
  }
}