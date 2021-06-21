import 'package:flutter/material.dart';
import 'package:hci_project/database/setup.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class ArrowForwardButton extends StatefulWidget {
  final int currPage;
  final int targetPage;
  final Function(int currPage) callback;

  const ArrowForwardButton({Key? key, required this.currPage, required this.callback, required this.targetPage}) : super(key: key);

  @override
  _ArrowForwardButtonState createState() => _ArrowForwardButtonState();
}

class _ArrowForwardButtonState extends State<ArrowForwardButton> {
  @override
  Widget build(BuildContext context) {
    final setup = Hive.box("set").getAt(0) as Setup;
    final bool isEn = setup.lang.contains("en");

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 5, 10),
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        child: widget.currPage != 1 || !select.canSendReport
          ? Icon(Icons.arrow_forward_ios_rounded, size: 35, color: Colors.black)
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => speak(isEn ? "Send" : "Enviar"),
                  child: Text(isEn ? "Send" : "Enviar", style: TextStyle(color: Colors.black, fontSize: setup.fontSize + 5))
                ),
                Icon(Icons.send, size: 35, color: Colors.black)
              ],
            ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          backgroundColor: MaterialStateProperty.all(Color(setup.color))
          //backgroundColor: MaterialStateProperty.all(widget.currPage == 1 && select.canSendReport ? Color(setup.color) : Colors.white)
        ),
        onPressed: () {
          if(widget.currPage == widget.targetPage) widget.callback(0);
          else if (widget.currPage < widget.targetPage) widget.callback(widget.currPage + 1);
        }
      )
    );
  }
}