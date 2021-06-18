import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/account_screen.dart';
import 'package:hci_project/screens/settings_screen.dart';
import 'package:hci_project/screens/widgets/ArrowBackButton.dart';
import 'package:hci_project/screens/widgets/ArrowForwardButton.dart';
import 'package:hci_project/screens/widgets/ChooseGarbageWidget.dart';
import 'package:hci_project/screens/widgets/DetailsWidget.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:page_transition/page_transition.dart';

import '../globals.dart';
import 'info_screen.dart';
import 'widgets/AddressWidget.dart';
import 'widgets/MapWidget.dart';
import 'widgets/PhotoWidget.dart';

class PhoneMainScreen extends StatefulWidget {
  @override
  _PhoneMainScreenState createState() => _PhoneMainScreenState();
}

class _PhoneMainScreenState extends State<PhoneMainScreen> {
  int currPage = 0;

  Random random = Random();
  Alignment pinAlignment = Alignment(0.0, 0.0);
  final pageController = PageController(initialPage: 0, keepPage: true);

  void writtenAddress(String text) {
    setState(() {
      FocusScope.of(context).unfocus();
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

  void changePage(int toPage) {
    if(toPage == 0) sendReport();
    pageController.animateToPage(
      toPage,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInBack
    );
  }

  void sendReport() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    FocusScope.of(context).unfocus();

    select.filledForms.fillRange(0, select.filledForms.length, false);
    select.checkedTrash.fillRange(0, select.checkedTrash.length, false);
    select.canSendReport = false;
    select.pinnedMap = false;
    select.writtenAddress = false;
    controller.details.text = "";
    controller.address.text = "";

    final String msg = select.writtenAddress || select.pinnedMap
        ? isEn ? "Report sent!" : "¡Informe enviado!"
        : isEn ? "Fill in the location!" :"¡Complete la ubicación!";

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
      content: GestureDetector(
        onTap: () => speak(msg),
        child: Text(msg, style: TextStyle(fontSize: setup.fontSize),
        )
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("set").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("set").getAt(0) as Setup;
        final bool isEn = setup.lang.contains("en");

        return Scaffold(
          appBar: _buildTopBar(),
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (index) => setState(() => currPage = index),
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  children: [
                    _buildAddress(),
                    _buildTakePhoto()
                  ]
                )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ArrowBackButton(currPage: currPage, callback: changePage),
                  ArrowForwardButton(currPage: currPage, targetPage: 1, callback: changePage)
                ]
              )
            ]
          )
        );
      }
    );
  }

  Color? matchColor(int index) {
    select.canSendReport = true;
    if(index == 0 && select.writtenAddress) return matchColorSettings(300);
    if(index == 1 && select.selectedImage) return matchColorSettings(400);
    if(index == 2 && select.pinnedMap) return matchColorSettings(300);

    if(!select.writtenAddress && !select.selectedImage && !select.pinnedMap)
      select.canSendReport = false;

    return index % 2 == 0 ? Colors.white : Colors.grey[200];
  }

  Color? matchColorSettings(int colorCode) {
    final setup = Hive.box("set").getAt(0) as Setup;

    if(setup.color == 0xFF2196f3) return Colors.green[colorCode];             //DEFAULT
    if(setup.color == 0xFFffbc02d) return Colors.purple[colorCode - 100];     //PROTANOPIA
    if(setup.color == 0xFFffef5350) return Colors.lightBlue[colorCode];       //TRITANOPIA
  }

  AppBar _buildTopBar() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return AppBar(
      backgroundColor: Color(setup.color),
      title: GestureDetector(
        onTap: () => speak(isEn ? "Trash Report" : "Informe de basura"),
        child: Text(isEn ? "Trash Report" : "Informe de basura")
      ),
      leading: IconButton(
        icon: Icon(Icons.info_outline, size: 30, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            child: InfoScreen()
          )
        )
      ),

      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.topRight,
                child: AccountScreen()
              )
            )
          )
        ),

        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.settings, size: 30, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.topRight,
                child: SettingsScreen()
              )
            )
          )
        )
      ]
    );
  }

  Widget _buildTakePhoto() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          Center(child: GestureDetector(
            onTap: () => speak(isEn ? "OPTIONAL" : "OPCIONAL"),
            child: Text(
              isEn ? "OPTIONAL" : "OPCIONAL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: setup.fontSize + 5)),
            )
          ),
          Container(height: 10),

          PhotoWidget(callback: tookPhoto, size: 200),
          Divider(thickness: 1),
          Container(height: 15),

          GestureDetector(
            onTap: () => speak(isEn ? "Select type of trash" : "Seleccione tipo de basura"),
            child: Text(
              isEn ? "Select type of trash" : "Seleccione tipo de basura",
              style: TextStyle(fontSize: setup.fontSize)
            )
          ),
          ChooseGarbageWidget(callback: selectGarbage),
          Divider(thickness: 1),

          Container(height: 15),
          GestureDetector(
            onTap: () => speak(isEn ? "Write extra details" : "Escribe extra detalles"),
            child: Text(
              isEn ? "Write extra details" : "Escribe extra detalles",
              style: TextStyle(fontSize: setup.fontSize)
            ),
          ),
          Container(height: 10),
          DetailsWidget()
        ]
      )
    );
  }

  Widget _buildAddress() {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Padding(
      padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Center(child: GestureDetector(
              onTap: () => speak(isEn ? "REQUIRED" : "REQUERIDO"),
              child: Text(
                isEn ? "REQUIRED" : "REQUERIDO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: setup.fontSize + 5)),
            )),
            MapWidget(callback: () => pinnedMap, size: 300, pinAlignment: pinAlignment),
            AddressWidget(callback: writtenAddress)
        ]
      )
    );
  }
}