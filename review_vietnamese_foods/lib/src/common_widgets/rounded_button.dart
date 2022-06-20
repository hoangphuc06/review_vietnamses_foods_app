import 'package:flutter/material.dart';

const shape = StadiumBorder();

Widget createButton({
  BuildContext? context,
  double width = 350.0,
  double height = 45.0,
  double radius = 20.0,
  bool isWithIcon = false,
  ImageProvider<Object>? icon,
  String? labelButton,
  Color labelButtonColor = Colors.white,
  Color buttonColor = Colors.orange,
  double labelFontSize = 15.0,
  OutlinedBorder? shape = shape,
  Function? func,
}) {
  return Container(
    width: width,
    height: height,
    margin: EdgeInsets.only(top: 20.0),
    child: isWithIcon
        ? _raiseButtonWithIcon(radius, icon!, labelButton!, labelButtonColor,
            labelFontSize, buttonColor, func, shape!)
        : _raiseButtonNotIcon(radius, labelButton!, buttonColor, labelFontSize,
            labelButtonColor, func, shape!),
  );
}

Widget _raiseButtonWithIcon(
  double radius,
  ImageProvider<Object> icon,
  String labelButton,
  Color labelButtonColor,
  double labelFontSize,
  Color color,
  func,
  OutlinedBorder shape,
) {
  return ElevatedButton(
    onPressed: func,
    style: ElevatedButton.styleFrom(
      shape: shape,
      primary: color,
      elevation: 0.5,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: icon,
          height: 20.0,
          width: 20.0,
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
            labelButton,
            style: TextStyle(
              color: labelButtonColor,
              fontWeight: FontWeight.bold,
              fontSize: labelFontSize
            ),
          )
        )
      ],
    ),
  );
}

Widget _raiseButtonNotIcon(
  double radius,
  String labelButton,
  Color color,
  double labelFontSize,
  Color labelButtonColor,
  func,
  OutlinedBorder shape,
) {
  return ElevatedButton(
    onPressed: func,
    style: ElevatedButton.styleFrom(
      shape: shape,
      primary: color,
      elevation: 0.5,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
            labelButton,
            style: TextStyle(
                color: labelButtonColor,
                fontWeight: FontWeight.bold,
                fontSize: labelFontSize
            ),
          )
        )
      ],
    ),
  );
}
