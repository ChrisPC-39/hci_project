import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/settings_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'account_screen.dart';
import 'info_screen.dart';

class WebMainScreen extends StatefulWidget {
  @override
  _WebMainScreenState createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  List<bool> filledForms = List.filled(5, false);
  List<bool?> checkedTrash = List.filled(6, false);
  int indexToRender = -1;
  bool selectedAddress = false;
  bool selectedImage = false;
  bool selectedMap = false;

  bool canSendReport = false;

  Random random = Random();
  FocusNode addressFocusNode = FocusNode();
  TextEditingController addressController = TextEditingController();
  TextEditingController extraDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    addressFocusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("settings").getAt(0) as Setup;
        final bool isEn = setup.lang == "en";

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
      child: _matchIndexToRender()
    );
  }

  Widget _matchIndexToRender() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    switch(indexToRender) {
      case 0: return _buildAddress();
      case 1: return _buildTakePhoto();
      //case 2: return _buildSelectLocation();
      case 2: return _buildSelectTrash();
      case 3: return _buildExtraDetails();

      case 5: return InfoScreen();
      case 6: return AccountScreen();
      case 7: return SettingsScreen();

      default: return Center(child: Text(
          isEn ? "Nothing to see here yet" : "Muchos gracias",
          style: TextStyle(fontSize: 20)
        )
      );
    }
  }

  Widget _buildQuestions() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Divider(thickness: 1),
              Text(isEn ? "REQUIRED" : "REQUIRMENTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Container(height: 15),

              _buildListTile(0, isEn ? "Enter address" : "Ingresa la direccion"),
              //_buildListTile(2, isEn ? "Select location" : "Seleccionar ubicación"),

              Container(height: 15),
              Divider(thickness: 1),
              Text(isEn ? "OPTIONAL" : "OPTIONALOS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Container(height: 15),

              _buildListTile(1, isEn ? "Take a photo" : "Toma una foto"),
              _buildListTile(2, isEn ? "What type of trash?" : "¿Qué tipo de basura?"),
              _buildListTile(3, isEn ? "Extra details" : "Extra details but in Spanish"),
            ]
          ),

          GestureDetector(
            child: Container(
              color: canSendReport ? Color(setup.color) : Colors.grey,
              height: 60,
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEn ? "SEND REPORT" : "SENDO REPORTO", style: TextStyle(fontSize: 30, color: Colors.white)),
                    Icon(Icons.send, size: 30, color: Colors.white)
                  ]
                )
              )
            ),

            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Text(selectedAddress || selectedMap
                    ? isEn ? "Report sent!" : "¡Reporte enviado!"
                    : isEn ? "Fill in at least one form to send!" :"¡Complete al menos un formulario para enviar un informe!",
                  style: TextStyle(fontSize: 20),
                )
              ));

              setState(() {
                filledForms.fillRange(0, filledForms.length, false);
                checkedTrash.fillRange(0, checkedTrash.length, false);
                canSendReport = false;
                selectedAddress = false;
                selectedImage = false;
                selectedMap = false;
                extraDetailsController.text = "";
                addressController.text = "";
              });
            }
          )
        ]
      )
    );
  }

  Color? matchColor(int index) {
    canSendReport = true;
    if(index == 0 && selectedAddress) return matchColorSettings(300);
    //if(index == 1 && selectedImage) return matchColorSettings(400);
    if(index == 2 && selectedMap) return matchColorSettings(300);

    if(!selectedAddress && !selectedMap)
      canSendReport = false;

    return index % 2 == 0 ? Colors.white : Colors.grey[200];
  }

  Color? matchColorSettings(int colorCode) {
    final setup = Hive.box("settings").getAt(0) as Setup;

    if(setup.color == 0xFF2196f3) return Colors.green[colorCode];             //DEFAULT
    if(setup.color == 0xFFffbc02d) return Colors.purple[colorCode - 100];     //PROTANOPIA
    if(setup.color == 0xFFffef5350) return Colors.lightBlue[colorCode];       //TRITANOPIA
  }

  Widget _buildListTile(int index, String title) {
    return Container(
      color: matchColor(index),
      height: 60,
      child: Center(
        child: ListTile(
          onTap: () => setState(() => indexToRender = index),
          title: Text(title, style: TextStyle(fontSize: 30)),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 30),
        )
      )
    );
  }

  Widget _buildSideBar() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Container(
      color: Color(setup.color),
      width: 65,
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
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
          ]
        ),
      )
    );
  }

  Widget _buildExtraDetails() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Align(
      alignment: Alignment(0.0, -1.0),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: TextField(
          maxLines: null,
          controller: extraDetailsController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            labelText: isEn ? "Details" : "Details but in Spanish"
          )
        )
      )
    );
  }

  Widget _buildSelectTrash() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          _buildCheckboxTile(0, !isEn ? "Plástico" : "Plastic"),
          _buildCheckboxTile(1, !isEn ? "Cartón" : "Carton"),
          _buildCheckboxTile(2, !isEn ? "Basura" : "General waste"),
          _buildCheckboxTile(3, !isEn ? "Metal" : "Metal"),
          _buildCheckboxTile(4, !isEn ? "Drogas" : "Drugs"),
          _buildCheckboxTile(5, !isEn ? "Otro" : "Other"),
        ]
      )
    );
  }

  Widget _buildCheckboxTile(int index, String title) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(fontSize: 25)),
      value: checkedTrash[index],
      onChanged: (value) => setState(() {
        checkedTrash[index] = value;
      })
    );
  }

  Widget _buildSelectLocation() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: [
          Container(
            height: 500,
            width: 400,
            child: Stack(
              children: [
                GestureDetector(
                  child: Image(image: AssetImage("assets/peruMap.png"), width: 400, height: 500),
                  onTap: () => setState(() {
                    selectedMap = true;
                    canSendReport = true;
                    filledForms[2] = true;
                  })
                ),

                Align(
                  alignment: Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0),
                  child: Visibility(
                    visible: selectedMap,
                    child: Icon(Icons.pin_drop, color: Colors.red[400])
                  )
                )
              ]
            )
          ),

          Container(height: 15),

          TextButton(
            onPressed: () => setState(() {
              selectedMap = true;
              canSendReport = true;
              filledForms[2] = true;
            }),
            child: Text(
              !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25)
            )
          ),
        ]
      )
    );
  }

  Widget _buildTakePhoto() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Visibility(
            visible: selectedImage,
            child: Image.network("https://picsum.photos/id/1052/600/500")
          ),

          Visibility(
            visible: !selectedImage,
            child: Container(width: 600, height: 500, child: Placeholder())
          ),

          Container(height: 15),

          IconButton(
            onPressed: () => setState(() {
              selectedImage = true;
              //canSendReport = true;
              //filledForms[1] = true;
            }),
            padding: EdgeInsets.only(top: 2),
            icon: Icon(Icons.image, size: 40)
          )
        ]
      )
    );
  }

  Widget _buildAddress() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
            alignment: Alignment(0.0, -1.0),
            child: TextField(
              controller: addressController,
              onChanged: (value) {
                if(addressController.text == "") return;

                selectedAddress = true;
                canSendReport = true;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                labelText: isEn ? "Address" : "Direccion"
              )
            ),
          ),

          Align(
            alignment: Alignment(-1.0, 0.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    width: 400,
                    child: Stack(
                      children: [
                        GestureDetector(
                          child: Image(image: AssetImage(setup.isLobitos ?  "assets/lobitos.png" : "assets/piedritas.png"), width: 600, height: 600),
                          onTap: () => setState(() {
                            selectedAddress = true;
                            canSendReport = true;
                            filledForms[0] = true;
                          })
                        ),

                        Container(
                          height: 400,
                          width: 400,
                          child: Align(
                            alignment: Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0),
                            child: Visibility(
                              visible: selectedAddress,
                              child: Icon(Icons.pin_drop, color: Colors.red[400])
                            )
                          ),
                        )
                      ]
                    )
                  ),

                  Container(height: 15),

                  TextButton(
                    onPressed: () => setState(() {
                      selectedAddress = true;
                      canSendReport = true;
                      filledForms[0] = true;
                    }),
                    child: Text(
                      !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25)
                    )
                  ),
                ]
              )
            ),
          )
        ],
      )
    );
  }
}