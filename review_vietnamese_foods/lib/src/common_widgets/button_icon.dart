import 'package:flutter/material.dart';

Widget buttonIcon( BuildContext? context, String? labelButton, Color labelButtonColor, Color buttonColor, ImageProvider<Object>? icon, func,) {
  return Container(
    height: 55,
    width: double.infinity,
    decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10.0)),
    child: Center(
      child: FlatButton(
        onPressed: func,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: icon!,
              height: 20.0,
              width: 20.0,
            ),
            SizedBox(width: 5,),
            Text(
              labelButton!,
              style: TextStyle(
                  color: labelButtonColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    ),
  );
}