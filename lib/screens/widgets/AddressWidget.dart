import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class AddressWidget extends StatefulWidget {
  final Function(String text) callback;

  const AddressWidget({Key? key, required this.callback}) : super(key: key);

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Column(
      children: [
        Align(
          alignment: Alignment(0.0, -1.0),
          child: TextField(
            controller: ctrl.addressController,
            onChanged: (value) {},
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              labelText: isEn ? "Address" : "Direccion"
            )
          )
        ),

        SizedBox(height: 15),

        Container(
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(setup.color))),
            onPressed: () => widget.callback(""),
            child: Center(child: GestureDetector(
              onTap: () => widget.callback(isEn ? "Confirm address" : "Dirección de confismo"),
              child: Text(
                isEn ? "Confirm address" : "Dirección de confismo",
                style: TextStyle(fontSize: setup.fontSize))
            ))
          )
        )
      ]
    );
  }
}