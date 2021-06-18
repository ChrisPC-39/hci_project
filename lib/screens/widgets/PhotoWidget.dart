import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class PhotoWidget extends StatefulWidget {
  final double size;
  final Function(String text) callback;

  const PhotoWidget({Key? key, required this.callback, required this.size}) : super(key: key);

  @override
  _PhotoWidgetState createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            height: 50,
            width: widget.size + 100,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(setup.color))),
              onPressed: () => widget.callback(""),
              child: Center(child: GestureDetector(
                onTap: () => widget.callback(isEn ? "Select a photo" : "Seleccione una foto"),
                //onTap: () => speak(isEn ? "Select a photo" : "Seleccione una foto"),
                child: Text(
                  isEn ? "Select a photo" : "Seleccione una foto",
                  style: TextStyle(fontSize: setup.fontSize)),
              ))
            )
          ),

          Container(height: 15),

          Visibility(
            visible: select.selectedImage,
            child: Image.network("https://picsum.photos/id/1052/${widget.size + 100}/${widget.size}")
          ),

          Visibility(
            visible: !select.selectedImage,
            child: Container(width: widget.size + 100, height: widget.size, child: Placeholder())
          )
        ]
      )
    );
  }
}