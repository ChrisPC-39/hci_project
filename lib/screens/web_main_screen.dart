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
      select.selectedAddress = true;
      select.canSendReport = true;
      speak(text);
    });
  }

  void pinnedMap() {
    setState(() {
      select.filledForms[0] = true;
      select.selectedMap = true;
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
    setState(() => select.checkedTrash[index] = !select.checkedTrash[index]!);
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
              final String msg = select.selectedAddress || select.selectedMap
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

              setState(() {
                select.filledForms.fillRange(0, select.filledForms.length, false);
                select.checkedTrash.fillRange(0, select.checkedTrash.length, false);
                select.canSendReport = false;
                select.selectedAddress = false;
                select.selectedImage = false;
                select.selectedMap = false;

                ctrl.detailsController.text = "";
                ctrl.addressController.text = "";
              });
            }
          )
        ]
      )
    );
  }

  Color? matchColor(int index) {
    select.canSendReport = true;
    if(index == 0 && (select.selectedAddress || select.selectedMap)) return matchColorSettings(300);
    //if(index == 1 && selectedImage) return matchColorSettings(400);
    //if(index == 2 && select.selectedMap) return matchColorSettings(300);

    if(!select.selectedAddress && !select.selectedMap)
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

  // Widget _buildExtraDetails() {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //   final bool isEn = setup.lang.contains("en");
  //
  //   return Align(
  //     alignment: Alignment(0.0, -1.0),
  //     child: Padding(
  //       padding: EdgeInsets.all(15),
  //       child: TextField(
  //         maxLines: null,
  //         controller: extraDetailsController,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  //           labelText: isEn ? "Details" : "Detalles"
  //         )
  //       )
  //     )
  //   );
  // }

  // Widget _buildSelectTrash() {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //   final bool isEn = setup.lang.contains("en");
  //
  //   return Padding(
  //     padding: EdgeInsets.all(15),
  //     child: ListView(
  //       children: [
  //         _buildCheckboxTile(0, !isEn ? "Plástico" : "Plastic"),
  //         _buildCheckboxTile(1, !isEn ? "Cartón" : "Carton"),
  //         _buildCheckboxTile(2, !isEn ? "Medicamentos" : "General waste"),
  //         _buildCheckboxTile(3, !isEn ? "Metal" : "Metal"),
  //         _buildCheckboxTile(4, !isEn ? "Medicamentos" : "Drugs"),
  //         _buildCheckboxTile(5, !isEn ? "Otro" : "Other"),
  //       ]
  //     )
  //   );
  // }
  //
  // Widget _buildCheckboxTile(int index, String title) {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //
  //   return CheckboxListTile(
  //     title: GestureDetector(
  //       onTap: () {
  //         setState(() => select.checkedTrash[index] = !select.checkedTrash[index]!);
  //         speak(title);
  //       },
  //       child: Text(title, style: TextStyle(fontSize: setup.fontSize + 5))
  //     ),
  //     value: select.checkedTrash[index],
  //     onChanged: (value) => setState(() {
  //       select.checkedTrash[index] = value;
  //     })
  //   );
  // }

  // Widget _buildTakePhoto() {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //   final bool isEn = setup.lang.contains("en");
  //
  //   return Padding(
  //     padding: EdgeInsets.all(15),
  //     child: ListView(
  //       children: [
  //         Container(
  //           height: 50,
  //           child: ElevatedButton(
  //             style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Color(setup.color))
  //             ),
  //             onPressed: () => setState(() => selectedImage = true),
  //             child: Center(child: GestureDetector(
  //               onTap: () => speak(isEn ? "Select a photo" : "Seleccione una foto"),
  //               child: Text(
  //                 isEn ? "Select a photo" : "Seleccione una foto",
  //                 style: TextStyle(fontSize: setup.fontSize)),
  //             ))
  //           )
  //         ),
  //
  //         Container(height: 15),
  //
  //         Visibility(
  //           visible: selectedImage,
  //           child: Image.network("https://picsum.photos/id/1052/600/500")
  //         ),
  //
  //         Visibility(
  //           visible: !selectedImage,
  //           child: Container(width: 600, height: 500, child: Placeholder())
  //         )
  //       ]
  //     )
  //   );
  // }

  Widget _buildAddress() {
    //final setup = Hive.box("set").getAt(0) as Setup;
    // final bool isEn = setup.lang.contains("en");
    //
    // final bool isTrit = setup.color == 0xFFffef5350;
    // final bool isProt = setup.color == 0xFFFFBC02D;
    // final bool isDef = setup.color == 0xFF2196f3;

    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          AddressWidget(callback: writtenAddress),
          MapWidget(callback: () => pinnedMap, size: 600, pinAlignment: pinAlignment),
          //AddressWidget(callback: () => writtenAddress),

          // SizedBox(height: 15),
          //
          // Container(
          //   height: 50,
          //   child: ElevatedButton(
          //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(setup.color))),
          //     onPressed: () => setState(() {
          //       select.selectedAddress = true;
          //       select.canSendReport = true;
          //       select.filledForms[0] = true;
          //     }),
          //     child: Center(child: GestureDetector(
          //       onTap: () => speak(isEn ? "Confirm address" : "Dirección de confismo"),
          //       child: Text(
          //         isEn ? "Confirm address" : "Dirección de confismo",
          //         style: TextStyle(fontSize: setup.fontSize)),
          //     ))
          //   )
          // ),

          // Align(
          //   alignment: Alignment(-1.0, 0.0),
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          //     child: Column(
          //       children: [
          //         Container(
          //           height: 400,
          //           width: 400,
          //           child: Stack(
          //             children: [
          //               GestureDetector(
          //                 child: Image(image: AssetImage(
          //                   setup.isLobitos ? isDef ? "assets/lobitos.png" : isTrit ? "assets/lobitos-trit.png" : "assets/lobitos-prot.png"
          //                                   : isDef ? "assets/piedritas.png" : isTrit ? "assets/piedritas-trit.png" : "assets/piedritas-prot.png" ),
          //                   width: 600,
          //                   height: 600
          //                 ),
          //                 onTap: () => setState(() {
          //                   select.selectedAddress = true;
          //                   select.canSendReport = true;
          //                   select.filledForms[0] = true;
          //                 })
          //               ),
          //
          //               Container(
          //                 height: 400,
          //                 width: 400,
          //                 child: Align(
          //                   alignment: Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0),
          //                   child: Visibility(
          //                     visible: select.selectedAddress,
          //                     child: Icon(Icons.pin_drop, color: Colors.red[400])
          //                   )
          //                 ),
          //               )
          //             ]
          //           )
          //         ),
          //
          //         Container(height: 15),
          //
          //         TextButton(
          //           onPressed: () => setState(() {
          //             select.selectedAddress = true;
          //             select.canSendReport = true;
          //             select.filledForms[0] = true;
          //           }),
          //           child: Text(
          //             !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(fontSize: setup.fontSize)
          //           )
          //         )
          //       ]
          //     )
          //   )
          // )
        ]
      )
    );
  }
}