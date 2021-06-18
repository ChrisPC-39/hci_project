import 'package:flutter/foundation.dart';
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

//We extend a StatefulWidget because we want to refresh the screen
//in order to show different data (e.g. change color of a button)
//dynamically, depending on user input. A StatefulWidget basically allows
//the screen to be rebuilt during use.
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
    select.selectedMap = false;
    select.selectedAddress = false;
    ctrl.detailsController.text = "";
    ctrl.addressController.text = "";

    final String msg = select.selectedAddress || select.selectedMap
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

  //This is the main class of the page. This is where rendering starts.
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
    if(index == 0 && select.selectedAddress) return matchColorSettings(300);
    if(index == 1 && select.selectedImage) return matchColorSettings(400);
    if(index == 2 && select.selectedMap) return matchColorSettings(300);

    if(!select.selectedAddress && !select.selectedImage && !select.selectedMap)
      select.canSendReport = false;

    return index % 2 == 0 ? Colors.white : Colors.grey[200];
  }

  Color? matchColorSettings(int colorCode) {
    final setup = Hive.box("set").getAt(0) as Setup;

    if(setup.color == 0xFF2196f3) return Colors.green[colorCode];             //DEFAULT
    if(setup.color == 0xFFffbc02d) return Colors.purple[colorCode - 100];     //PROTANOPIA
    if(setup.color == 0xFFffef5350) return Colors.lightBlue[colorCode];       //TRITANOPIA
  }

  // Widget _buildExtraDetails() {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //   final bool isEn = setup.lang.contains("en");
  //
  //   return Padding(
  //     padding: EdgeInsets.all(15),
  //     child: TextField(
  //       maxLines: null,
  //       controller: ctrl.detailsController,
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  //         labelText: isEn ? "Details" : "Detalles"
  //       )
  //     )
  //   );
  // }
  //
  // Widget _buildSelectTrash() {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //   final bool isEn = setup.lang.contains("en");
  //
  //   return Padding(
  //     padding: EdgeInsets.all(15),
  //     child: Column(
  //       children: [
  //         _buildCheckboxTile(0, !isEn ? "Plástico" : "Plastic"),
  //         _buildCheckboxTile(1, !isEn ? "Cartón" : "Carton"),
  //         _buildCheckboxTile(2, !isEn ? "Residuos generales" : "General waste"),
  //         _buildCheckboxTile(3, !isEn ? "Metal" : "Metal"),
  //         _buildCheckboxTile(4, !isEn ? "Medicamentos" : "Drugs"),
  //         _buildCheckboxTile(5, !isEn ? "Otro" : "Other"),
  //       ]
  //     )
  //   );
  // }

  // Widget _buildCheckboxTile(int index, String title) {
  //   final setup = Hive.box("set").getAt(0) as Setup;
  //
  //   return CheckboxListTile(
  //     title: GestureDetector(
  //       onTap: () {
  //         speak(title);
  //         setState(() => select.checkedTrash[index] = !select.checkedTrash[index]!);
  //       },
  //       child: Text(title, style: TextStyle(fontSize: setup.fontSize))
  //     ),
  //     value: select.checkedTrash[index],
  //     onChanged: (value) => setState(() {
  //       select.checkedTrash[index] = value;
  //     })
  //   );
  // }

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
          // GestureDetector(
          //   onTap: () => speak(isEn ? "Upload a photo" : "Sube una foto"),
          //   child: Text(
          //     isEn ? "Upload a photo" : "Sube una foto",
          //     style: TextStyle(fontSize: setup.fontSize)
          //   )
          // ),
          // Container(height: 10),
          // Column(
          //   children: [
          //     Visibility(
          //       visible: select.selectedImage,
          //       child: Image.network("https://picsum.photos/id/1052/300/200")
          //     ),
          //
          //     Visibility(
          //       visible: !select.selectedImage,
          //       child: Container(width: 300, height: 200, child: Placeholder())
          //     ),
          //
          //     Container(height: 10),
          //
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         IconButton(
          //           onPressed: () => setState(() {
          //             select.selectedImage = true;
          //             select.canSendReport = true;
          //             select.filledForms[1] = true;
          //           }),
          //           padding: EdgeInsets.only(top: 2),
          //           icon: Icon(Icons.image, size: 40)
          //         ),
          //
          //         Container(width: 20),
          //
          //         IconButton(
          //           onPressed: () => setState(() {
          //             if(kIsWeb) return;
          //             select.selectedImage = true;
          //             select.canSendReport = true;
          //             select.filledForms[1] = true;
          //           }),
          //           padding: EdgeInsets.zero,
          //           icon: Icon(Icons.add_a_photo, size: 40, color: kIsWeb ? Colors.grey : Colors.black)
          //         )
          //       ]
          //     )
          //   ]
          // ),
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
    // return Align(
    //   alignment: Alignment(0.0, -1.0),
    //   child: Padding(
    //     padding: EdgeInsets.all(15),
    //     child: GestureDetector(
    //       onTap: () => FocusScope.of(context).unfocus(),
    //       child: ListView(
    //         children: [
    //           Center(child: GestureDetector(
    //             onTap: () => speak(isEn ? "REQUIRED" : "REQUERIDO"),
    //             child: Text(
    //               isEn ? "REQUIRED" : "REQUERIDO",
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: setup.fontSize + 5)),
    //           )),
    //           Container(height: 10),
    //
    //           Padding(
    //             padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
    //             child: Column(
    //               children: [
    //                 Container(
    //                   height: 300,
    //                   width: 300,
    //                   child: Stack(
    //                     children: [
    //                       GestureDetector(
    //                         child: Image(image: AssetImage(
    //                         setup.isLobitos ? isDef ? "assets/lobitos.png" : isTrit ? "assets/lobitos-trit.png" : "assets/lobitos-prot.png"
    //                                         : isDef ? "assets/piedritas.png" : isTrit ? "assets/piedritas-trit.png" : "assets/piedritas-prot.png"),
    //                           width: 300,
    //                           height: 300
    //                         ),
    //                         onTap: () => setState(() {
    //                           select.selectedMap = true;
    //                           select.canSendReport = true;
    //                           select.filledForms[0] = true;
    //                         })
    //                       ),
    //
    //                       Container(
    //                         height: 300,
    //                         width: 300,
    //                         child: Align(
    //                           alignment: Alignment(random.nextDouble() * (-1.0 - 1.0) + 1.0, random.nextDouble() * (-1.0 - 1.0) + 1.0),
    //                           child: Visibility(
    //                             visible: select.selectedMap,
    //                             child: Icon(Icons.pin_drop, color: Colors.red[400])
    //                           )
    //                         ),
    //                       )
    //                     ]
    //                   )
    //                 ),
    //
    //                 TextButton(
    //                   onPressed: () => setState(() {
    //                     select.selectedMap = true;
    //                     select.canSendReport = true;
    //                     select.filledForms[0] = true;
    //                   }),
    //                   child: Text(
    //                     !isEn ? "Establecer desde las coordenadas actuales" : "Set from current coordinates",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(fontSize:  setup.fontSize),
    //                   )
    //                 )
    //               ]
    //             )
    //           ),
    //
    //           //AddressFieldWidget(isEn: isEn),
    //
    //           SizedBox(height: 15),
    //           Container(
    //             height: 50,
    //             child: ElevatedButton(
    //               style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(setup.color))),
    //               onPressed: () => setState(() {
    //                 select.selectedAddress = true;
    //                 select.canSendReport = true;
    //                 select.filledForms[0] = true;
    //               }),
    //               child: Center(child: GestureDetector(
    //                 onTap: () => speak(isEn ? "Confirm address" : "Dirección de confismo"),
    //                 child: Text(
    //                   isEn ? "Confirm address" : "Dirección de confismo",
    //                   style: TextStyle(fontSize: setup.fontSize)),
    //               ))
    //             )
    //           )
    //         ]
    //       )
    //     )
    //   )
    // );
  }
}