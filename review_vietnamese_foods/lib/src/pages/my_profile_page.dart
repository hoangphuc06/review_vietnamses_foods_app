import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  final Map<String, dynamic> userMap;
  const MyProfilePage({Key? key, required this.userMap}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
