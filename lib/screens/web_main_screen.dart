import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/settings_screen.dart';
import 'package:hci_project/screens/widgets/ChooseGarbageWidget.dart';
import 'package:hci_project/screens/widgets/DetailsWidget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../globals.dart';
import 'account_screen.dart';
import 'info_screen.dart';
import 'widgets/AddressWidget.dart';
import 'widgets/MapWidget.dart';
import 'widgets/PhotoWidget.dart';

class WebMainScreen extends StatefulWidget {
  @override
  _WebMainScreenState createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  int indexToRender = -1;

  Random random = Random();
  Alignment pinAlignment = Alignment(0.0, 0.0);


  void writtenAddress(String text) {
    setState(() {
      select.filledForms[0] = true;
      select.writtenAddress = true;
      select.canSendReport = true;
      speak(text);
    });
  }

  void pinnedMap() {
    setState(() {
      select.filledForms[0] = true;
      select.pinnedMap = true;
      select.canSendReport = true;
      pinAlignment = Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0);
    });
  }

  void tookPhoto(String text) {
    setState(() {
      select.selectedImage = true;
      speak(text);
    });
  }

  void selectGarbage(int index, String title) {
    setState(() => select.checkedTrash[index] = !select.checkedTrash[index]);
    speak(title);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("set").listenable(),
      builder: (context, setupBox, _) {
        return Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSideBar(),

              _buildQuestions(),

              Container(width: 10, color: Colors.grey[200], height: MediaQuery.of(context).size.height),

              _buildContent(),
            ]
          )
        );
      }
    );
  }

  Widget _buildContent() {
    return Flexible(
      child: ListView(
        children: [
          Container(
            width: 300,
            height: MediaQuery.of(context).size.height,
            child: _matchIndexToRender()
          )
        ]
      )
    );
  }

  Widget _matchIndexToRender() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    switch(indexToRender) {
      case 0: return _buildAddress();
      case 1: return PhotoWidget(callback: tookPhoto, size: 500);
      case 2: return ChooseGarbageWidget(callback: selectGarbage);
      case 3: return DetailsWidget();

      case 5: return InfoScreen();
      case 6: return AccountScreen();
      case 7: return SettingsScreen();

      default: return Padding(
        padding: EdgeInsets.all(15),
        child: Center(child: GestureDetector(
          onTap: () => speak(isEn ? "Nothing to see here yet" : "No hay nada que ver aquí todavía"),
          child: Text(
              isEn ? "Nothing to see here yet" : "No hay nada que ver aquí todavía",
              style: TextStyle(fontSize: setup.fontSize)
            )
          )
        )
      );
    }
  }

  Widget _buildQuestions() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView(
              children: [
                Divider(thickness: 1),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () => speak(isEn ? "REQUIRED" : "REQUERIDO"),
                    child: Text(isEn ? "REQUIRED" : "REQUERIDO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: setup.fontSize))
                  )
                ),
                Container(height: 15),

                _buildListTile(0, isEn ? "Enter address" : "Ingrese la dirección"),

                Container(height: 15),
                Divider(thickness: 1),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: GestureDetector(
                    onTap: () => speak(isEn ? "OPTIONAL" : "OPCIONAL"),
                    child: Text(isEn ? "OPTIONAL" : "OPCIONAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: setup.fontSize))
                  )
                ),
                Container(height: 15),

                _buildListTile(1, isEn ? "Take a photo" : "Toma una foto"),
                _buildListTile(2, isEn ? "What type of trash?" : "¿Qué tipo de basura?"),
                _buildListTile(3, isEn ? "Extra details" : "Extra detalles"),
              ]
            )
          ),

          GestureDetector(
            child: Container(
              color: select.canSendReport ? Color(setup.color) : Colors.grey,
              height: 60,
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => speak(isEn ? "SEND REPORT" : "ENVIAR EL INFORME"),
                      child: Text(
                        isEn ? "SEND REPORT" : "ENVIAR EL INFORME", style: TextStyle(fontSize: setup.fontSize + 10, color: Colors.white)),
                    ),
                    Icon(Icons.send, size: 30, color: Colors.white)
                  ]
                )
              )
            ),

            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final String msg = select.writtenAddress || select.pinnedMap
                  ? isEn ? "Report sent!" : "¡Informe enviado!"
                  : isEn ? "Fill in the location!" :"¡Complete la ubicación!";

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: GestureDetector(
                  onTap: () => speak(msg),
                  child: Text(msg, style: TextStyle(fontSize: setup.fontSize),
                  )
                )
              ));

              if(select.writtenAddress || select.pinnedMap) {
                setState(() {
                  select.filledForms.fillRange(0, select.filledForms.length, false);
                  select.checkedTrash.fillRange(0, select.checkedTrash.length, false);
                  select.canSendReport = false;
                  select.writtenAddress = false;
                  select.selectedImage = false;
                  select.pinnedMap = false;

                  controller.details.text = "";
                  controller.address.text = "";
                });
              }
            }
          )
        ]
      )
    );
  }

  Color? matchColor(int index) {
    select.canSendReport = true;
    if(index == 0 && (select.writtenAddress || select.pinnedMap)) return matchColorSettings(300);

    if(!select.writtenAddress && !select.pinnedMap)
      select.canSendReport = false;

    return index % 2 != 0 ? Colors.white : Colors.grey[200];
  }

  Color? matchColorSettings(int colorCode) {
    final setup = Hive.box("set").getAt(0) as Setup;

    if(setup.color == 0xFF2196f3) return Colors.green[colorCode];             //DEFAULT
    if(setup.color == 0xFFffbc02d) return Colors.purple[colorCode - 100];     //PROTANOPIA
    if(setup.color == 0xFFffef5350) return Colors.lightBlue[colorCode];       //TRITANOPIA
  }

  Widget _buildListTile(int index, String title) {
    final setup = Hive.box("set").getAt(0) as Setup;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: matchColor(index),
        border: Border.all(color: indexToRender == index ? Colors.black : Colors.transparent, width: 3)
      ),
      child: Center(
        child: ListTile(
          onTap: () => setState(() => indexToRender = index),
          title: GestureDetector(
            onTap: () {
              speak(title);
              setState(() => indexToRender = index);
            },
            child: Text(title, style: TextStyle(fontSize: setup.fontSize + 10))
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 30),
        )
      )
    );
  }

  Widget _buildSideBar() {
    final setup = Hive.box("set").getAt(0) as Setup;

    return Container(
      color: Color(setup.color),
      width: 65,
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: ListView(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => setState(() => indexToRender = 5),
              icon: Icon(Icons.info_outline_rounded, size: 40, color: Colors.white)
            ),

            Container(height: 15),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => setState(() => indexToRender = 6),
              icon: Icon(Icons.account_circle, size: 40, color: Colors.white)
            ),

            Container(height: 15),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => setState(() => indexToRender = 7),
              icon: Icon(Icons.settings, size: 40, color: Colors.white)
            ),

            Container(height: 15),

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
              },
              icon: Icon(Icons.zoom_in, size: 40, color: setup.fontSize == 35 ? Colors.grey : Colors.white)
            ),

            Container(height: 15),

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
              },
              icon: Icon(Icons.zoom_out, size: 40, color: setup.fontSize == 20 ? Colors.grey : Colors.white)
            )
          ]
        )
      )
    );
  }

  Widget _buildAddress() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          AddressWidget(callback: writtenAddress),
          MapWidget(callback: () => pinnedMap, size: 600, pinAlignment: pinAlignment),
        ]
      )
    );
  }
}