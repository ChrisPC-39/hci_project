import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String infoTextEN = '''   The aim of this project is to design and build functional prototype front end components for '''
                    '''a rubbish spotting and collection system to be used in Lobitos.''';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("settings").getAt(0) as Setup;
        final bool isEn = setup.lang == "en";

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Text(isEn ? "Information" : "Información"), backgroundColor: Color(setup.color)),
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(isEn ? "Info" : "Informacion", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Container(height: 5),
                  Text(infoTextEN, style: TextStyle(fontSize: 25)),
                ]
              )
            )
          )
        );
      }
    );
  }
}