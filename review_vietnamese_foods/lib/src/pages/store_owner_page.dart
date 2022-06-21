import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreOwnerPage extends StatefulWidget {
  final QueryDocumentSnapshot store;
  const StoreOwnerPage({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreOwnerPage> createState() => _StoreOwnerPageState();
}

class _StoreOwnerPageState extends State<StoreOwnerPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
