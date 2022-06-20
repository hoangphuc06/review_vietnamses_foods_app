import 'package:flutter/material.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              color: Color(0xffffffff),
              height: 100,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    msg,
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
