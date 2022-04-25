import 'package:flutter/material.dart';

// This code changes the state of the button
class ApproveButton extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Dialog Function(BuildContext) confirmDialog;
  const ApproveButton(this.width, this.height, this.text, this.approveCallback,
      this.confirmCallback, this.confirmDialog);
  //const ApproveButton(double width, double height, String text, {Key? key}) : super(key: key);

  @override
  _ApproveButtonState createState() => _ApproveButtonState();
}

class _ApproveButtonState extends State<ApproveButton> {
  double width = 0;
  double height = 0;
  String text = "";
  bool isApproved = false;
  Color? fillcolor;
  Color? textcolor;
  int currentState = 0;
  Widget? dialog;
  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    text = widget.text;
    fillcolor = Colors.transparent;
    textcolor = Colors.amber;
    currentState = 0;
  }

  void changeButton() {
    //Changes from approve button to confirm
    widget.approveCallback().then((_) {
     setState(() {
        isApproved = true;
        print('ApproveButton widget: Transaction has been approved - $isApproved');
        text = "Confirm";
        fillcolor = Colors.amber;
        textcolor = Colors.black;
      });
    }).catchError((e) {
      print("[Console - Error] $e");
      setState(() {
        isApproved = false;
        text = "Approve";
        fillcolor = Colors.transparent;
        textcolor = Colors.amber;
      });
    });
    // Keep track of how many times the state has changed
    currentState += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        color: fillcolor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: () {
          // Testing to see how the popup will work when the state is changed
          if (isApproved) {
            //Confirm button pressed
            widget.confirmCallback().then((value) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      widget.confirmDialog(context));
            });
          } else {
            //Approve button was pressed
            changeButton();
          }
          //print("Working");
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textcolor,
          ),
        ),
      ),
    );
  }
}
