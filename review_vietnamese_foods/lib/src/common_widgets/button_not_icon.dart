import 'package:flutter/material.dart';

Widget buttonNotIcon( BuildContext? context, String? labelButton, Color labelButtonColor, Color buttonColor, func,) {
  return Container(
    height: 55,
    width: double.infinity,
    decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10.0)),
    child: FlatButton(
      onPressed: func,
      child: Center(
        child: Text(
          labelButton!,
          style: TextStyle(
            color: labelButtonColor,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    ),
  );
}