import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditFoodPage extends StatefulWidget {
  final QueryDocumentSnapshot food;
  const EditFoodPage({Key? key, required this.food}) : super(key: key);

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
