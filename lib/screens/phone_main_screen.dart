import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hci_project/screens/account_screen.dart';
import 'package:hci_project/screens/settings_screen.dart';
import 'package:hci_project/screens/web_main_screen.dart';
import 'package:hci_project/theme.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:page_transition/page_transition.dart';

import 'info_screen.dart';

//We extend a StatefulWidget because we want to refresh the screen
//in order to show different data (e.g. change color of a button)
//dynamically, depending on user input. A StatefulWidget basically allows
//the screen to be rebuilt during use.
class PhoneMainScreen extends StatefulWidget {
  @override
  _PhoneMainScreenState createState() => _PhoneMainScreenState();
}

class _PhoneMainScreenState extends State<PhoneMainScreen> {
  List<bool> filledForms = List.filled(5, false);
  List<bool?> checkedTrash = List.filled(6, false);
  int currPage = 0;
  double dynamicMargin = 0.0;
  bool selectedAddress = false;
  bool selectedImage = false;
  bool selectedMap = false;

  bool canSendReport = false;

  Random random = Random();
  FocusNode addressFocusNode = FocusNode();
  TextEditingController addressController = TextEditingController();
  TextEditingController extraDetailsController = TextEditingController();
  final pageController = PageController(initialPage: 0, keepPage: true);

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

  //This is the main class of the page. This is where rendering starts.
  @override
  Widget build(BuildContext context) {
    //SafeArea ensures that the content of the screen will fit on any device
    //e.g. the virtual buttons (back, home and menu) will not overlap with
    //the content in the app

    return ValueListenableBuilder(
      valueListenable: Hive.box("settings").listenable(),
      builder: (context, setupBox, _) {
        final setup = Hive.box("settings").getAt(0) as Setup;
        final bool isEn = setup.lang == "en";

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(setup.color),
            title: Text(isEn ? "Trash Report" : "Basura Report"),
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

            //This contains the trailing buttons (the ones at the right side of the blue bar)
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
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (index) => setState(() => currPage = index),
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  children: [
                    _buildAddress(),
                    _buildTakePhoto(),
                    //_buildSelectLocation(),
                    // _buildSelectTrash(),
                    // _buildExtraDetails()
                  ]
                )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    opacity: currPage > 0 ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.06,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 10),
                      child: ElevatedButton(
                        child: Icon(Icons.arrow_back_ios_rounded,
                          size: 35,
                          color: Colors.black
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.white)
                        ),
                        onPressed: () {
                          if (currPage > 0) currPage -= 1;
                          pageController.animateToPage(
                            currPage,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInBack
                          );
                        }
                      )
                    )
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 10),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      child: currPage != 1 || !canSendReport
                        ? Icon(Icons.arrow_forward_ios_rounded, size: 35, color: Colors.black)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(isEn ? "Send" : "Sendo", style: TextStyle(color: Colors.black, fontSize: 25)),
                              Icon(Icons.send, size: 35, color: Colors.black)
                            ],
                          ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                        backgroundColor: MaterialStateProperty.all(currPage == 1 && canSendReport ? Color(setup.color) : Colors.white)
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if(currPage == 1) {
                          filledForms.fillRange(0, filledForms.length, false);
                          checkedTrash.fillRange(0, checkedTrash.length, false);
                          extraDetailsController.text = "";
                          addressController.text = "";

                          currPage = 0;

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text(selectedAddress || selectedMap
                                ? isEn ? "Report sent!" : "¡Reporte enviado!"
                                : isEn ? "Fill in the location!" :"¡Complete al locacion!",
                              style: TextStyle(fontSize: 20),
                            )
                          ));

                          canSendReport = false;
                          selectedMap = false;
                          selectedAddress = false;
                        }
                        else if (currPage < 1) currPage += 1; //THIS MUST BE CHANGED IF MORE PAGES ARE ADDED
                        pageController.animateToPage(
                          currPage,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInBack
                        );
                      }
                    )
                  )
                ]
              )
            ],
          )
          // body: Stack(     //All the children of the Stack will show on top of each other
          //   children: [
          //     ListView(
          //       children: [
          //         ExpansionPanelList(
          //           expansionCallback: (i, isOpen) => setState(() {
          //             filledForms[i] = !isOpen;
          //           }),
          //           children: [
          //             _buildTile(0, isEn ? "Enter address" : "Ingresa la direccion", _buildAddress()),
          //             _buildTile(1, isEn ? "Take a photo" : "Toma una foto", _buildTakePhoto()),
          //             _buildTile(2, isEn ? "Select location" : "Seleccionar ubicación", _buildSelectLocation()),
          //             _buildTile(3, isEn ? "What type of trash?" : "¿Qué tipo de basura?", _buildSelectTrash()),
          //             _buildTile(4, isEn ? "Extra details" : "Extra details but in Spanish", _buildExtraDetails()),
          //           ]
          //         )
          //       ]
          //     ),
          //
          //       //This contains the "Send Report" button from the bottom of the screen
          //       Align(
          //         alignment: Alignment(0, 0.95),
          //         child: AnimatedContainer(
          //           duration: Duration(milliseconds: 300),
          //           margin: EdgeInsets.only(bottom: dynamicMargin),
          //           width: MediaQuery.of(context).size.width * 0.55,
          //           height: MediaQuery.of(context).size.height * 0.06,
          //           child: ElevatedButton(
          //             style: ButtonStyle(
          //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
          //               ),
          //               backgroundColor: MaterialStateProperty.all(canSendReport ? Color(setup.color) : Colors.grey)
          //             ),
          //             onPressed: () {
          //               ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //
          //               setState(() => dynamicMargin = 70);   //setState(() {}) forces the page to refresh (check first comment for info)
          //
          //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //                   duration: Duration(seconds: 5),
          //                   content: Text(selectedAddress || selectedImage || selectedMap
          //                       ? isEn ? "Report sent!" : "¡Reporte enviado!"
          //                       : isEn ? "Fill in at least one form to send!" :"¡Complete al menos un formulario para enviar un informe!",
          //                     style: TextStyle(fontSize: 20),
          //                   )
          //               ));
          //
          //               setState(() {
          //                 filledForms.fillRange(0, filledForms.length, false);
          //                 checkedTrash.fillRange(0, checkedTrash.length, false);
          //                 canSendReport = false;
          //                 selectedAddress = false;
          //                 selectedImage = false;
          //                 selectedMap = false;
          //                 extraDetailsController.text = "";
          //                 addressController.text = "";
          //               });
          //
          //               //The code inside the brackets of the Future.delayed will be
          //               //executed after 5.3 seconds
          //               Future.delayed(Duration(milliseconds: 5300), () => setState(() {
          //                 dynamicMargin = 0;
          //               }));
          //             },
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(isEn ? "Send Report" : "Sendo Reporto", style: TextStyle(color: Colors.white, fontSize: 20)),
          //               Icon(Icons.send, color: Colors.white, size: 24)
          //             ]
          //           )
          //         )
          //       )
          //     )
          //   ]
          // )
        );
      },
    );
  }

  Color? matchColor(int index) {
    canSendReport = true;
    if(index == 0 && selectedAddress) return matchColorSettings(300);
    if(index == 1 && selectedImage) return matchColorSettings(400);
    if(index == 2 && selectedMap) return matchColorSettings(300);

    if(!selectedAddress && !selectedImage && !selectedMap)
      canSendReport = false;

    return index % 2 == 0 ? Colors.white : Colors.grey[200];
  }

  Color? matchColorSettings(int colorCode) {
    final setup = Hive.box("settings").getAt(0) as Setup;

    if(setup.color == 0xFF2196f3) return Colors.green[colorCode];             //DEFAULT
    if(setup.color == 0xFFffbc02d) return Colors.purple[colorCode - 100];     //PROTANOPIA
    if(setup.color == 0xFFffef5350) return Colors.lightBlue[colorCode];       //TRITANOPIA
  }

  ExpansionPanel _buildTile(int index, String title, Widget body) {
    //Text(subtitle, style: TextStyle(fontSize: 20, color: Colors.grey[600])),
    return ExpansionPanel(
      backgroundColor: matchColor(index),
      isExpanded: filledForms[index],
      canTapOnHeader: true,
      headerBuilder: (context, isOpen) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Text(title, style: TextStyle(fontSize: 30))
        );
      },
      body: body
    );
  }

  Widget _buildExtraDetails() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        maxLines: null,
        controller: extraDetailsController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          labelText: isEn ? "Details" : "Details but in Spanish"
        )
      )
    );
    // return Padding(
    //   padding: EdgeInsets.all(15),
    //   child: Row(
    //     children: [
    //       Align(
    //         alignment: Alignment(-1.0, 0.0),
    //         child: Container(
    //           width: MediaQuery.of(context).size.width * 0.7,
    //           child: TextField(
    //             maxLines: null,
    //             controller: extraDetailsController,
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    //               labelText: isEn ? "Details" : "Details but in Spanish"
    //             )
    //           )
    //         )
    //       ),
    //
    //     Padding(
    //         padding: EdgeInsets.only(left: 15),
    //         child: IconButton(
    //           icon: Icon(Icons.check),
    //           onPressed: () {
    //             FocusScope.of(context).unfocus();
    //             setState(() {});
    //           }
    //         )
    //       )
    //     ]
    //   ),
    // );
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
      title: Text(title, style: TextStyle(fontSize: 20)),
      //subtitle: Text(subtitle, style: TextStyle(fontSize: 15)),
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
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        children: [
          TextButton(
            onPressed: () => setState(() {
              selectedMap = true;
              canSendReport = true;
              filledForms[2] = true;
            }),
            child: Text(
              !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
              textAlign: TextAlign.center,
            )
          ),

          Container(
            height: 400,
            width: 300,
            child: Stack(
              children: [
                GestureDetector(
                  child: Image(image: AssetImage(setup.isLobitos ?  "assets/lobitos.png" : "assets/piedritas.png"), width: 300, height: 400),
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
          )
        ]
      )
    );
  }

  Widget _buildTakePhoto() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          Center(child: Text(
            isEn ? "OPTIONAL" : "OPTIONALOS",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
          ),
          Container(height: 10),

          Text(
            isEn ? "Upload a photo" : "Upload eine foto",
            style: TextStyle(fontSize: 20)
          ),
          Container(height: 10),
          Column(
            children: [
              Visibility(
                visible: selectedImage,
                child: Image.network("https://picsum.photos/id/1052/300/200")
              ),

              Visibility(
                visible: !selectedImage,
                child: Container(width: 300, height: 200, child: Placeholder())
              ),

              Container(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      selectedImage = true;
                      canSendReport = true;
                      filledForms[1] = true;
                    }),
                    padding: EdgeInsets.only(top: 2),
                    icon: Icon(Icons.image, size: 40)
                  ),

                  Container(width: 20),

                  IconButton(
                    onPressed: () => setState(() {
                      if(kIsWeb) return;
                      selectedImage = true;
                      canSendReport = true;
                      filledForms[1] = true;
                    }),
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.add_a_photo, size: 40, color: kIsWeb ? Colors.grey : Colors.black)
                  )
                ]
              )
            ]
          ),
          Divider(thickness: 1),


          Container(height: 15),
          Text(
            isEn ? "Select type of trash" : "Selecto basura",
            style: TextStyle(fontSize: 20)
          ),
          Container(height: 10),
          _buildSelectTrash(),
          Divider(thickness: 1),

          Container(height: 15),
          Text(
            isEn ? "Write extra details" : "Writo extro detailso",
            style: TextStyle(fontSize: 20)
          ),
          Container(height: 10),
          _buildExtraDetails()
        ]
      )
    );
  }

  Widget _buildAddress() {
    final setup = Hive.box("settings").getAt(0) as Setup;
    final bool isEn = setup.lang == "en";

    return Align(
      alignment: Alignment(0.0, -1.0),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              Center(child: Text(
                isEn ? "REQUIRED" : "HOLA MUNDO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
              ),
              Container(height: 10),

              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: 300,
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: Image(image: AssetImage(setup.isLobitos ?  "assets/lobitos.png" : "assets/piedritas.png"), width: 300, height: 300),
                            onTap: () => setState(() {
                              selectedMap = true;
                              canSendReport = true;
                              filledForms[0] = true;
                            })
                          ),

                          Container(
                            height: 300,
                            width: 300,
                            child: Align(
                              alignment: Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0),
                              child: Visibility(
                                visible: selectedMap,
                                child: Icon(Icons.pin_drop, color: Colors.red[400])
                              )
                            ),
                          )
                        ]
                      )
                    ),

                    TextButton(
                      onPressed: () => setState(() {
                        selectedMap = true;
                        canSendReport = true;
                        filledForms[0] = true;
                      }),
                      child: Text(
                        !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )
                    ),
                  ]
                )
              ),

              TextField(
                controller: addressController,
                onChanged: (value) {
                  if(addressController.text == "") return;

                  filledForms[0] = true;
                  selectedAddress = true;
                  canSendReport = true;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  labelText: isEn ? "Address" : "Direccion"
                )
              )
            ]
          ),
        )
      ),
    );
  }
}