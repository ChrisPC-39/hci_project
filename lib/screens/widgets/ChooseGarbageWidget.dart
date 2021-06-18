import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class ChooseGarbageWidget extends StatefulWidget {
  final void Function(int index, String title) callback;

  const ChooseGarbageWidget({Key? key, required this.callback}) : super(key: key);

  @override
  _ChooseGarbageWidgetState createState() => _ChooseGarbageWidgetState();
}

class _ChooseGarbageWidgetState extends State<ChooseGarbageWidget> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          _buildCheckboxTile(0, !isEn ? "Plástico" : "Plastic"),
          _buildCheckboxTile(1, !isEn ? "Cartón" : "Carton"),
          _buildCheckboxTile(2, !isEn ? "Medicamentos" : "General waste"),
          _buildCheckboxTile(3, !isEn ? "Metal" : "Metal"),
          _buildCheckboxTile(4, !isEn ? "Medicamentos" : "Drugs"),
          _buildCheckboxTile(5, !isEn ? "Otro" : "Other"),
        ]
      )
    );
  }

  Widget _buildCheckboxTile(int index, String title) {
    final setup = Hive.box("set").getAt(0) as Setup;

    return CheckboxListTile(
      title: GestureDetector(
        onTap: () => widget.callback(index, title),
        child: Text(title, style: TextStyle(fontSize: setup.fontSize + 5))
      ),
      value: select.checkedTrash[index],
      onChanged: (value) => widget.callback(index, "")
    );
  }
}