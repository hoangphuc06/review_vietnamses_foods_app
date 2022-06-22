
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../classifier.dart';
import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class AddReviewPage extends StatefulWidget {
  final int idFood;
  const AddReviewPage({Key? key, required this.idFood}) : super(key: key);

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {

  TextEditingController reviewController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _classifier = Classifier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              SizedBox(height: 10,),
              _longTextField(reviewController, "Description about food", TextInputType.text, false),
              SizedBox(height: 30,),
              buttonNotIcon(context, "Create Food", Colors.white, Colors.orange, (){
                _addReview();
              }),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't review /",
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Return",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50,),
        Text(
          "Your review about food",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        SizedBox(height: 20,),
        Text(
          "Your reviews will help people better understand the foods and help our store improve the quality of the foods",
          style: TextStyle(
              color: Colors.grey
          ),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }

  Widget _longTextField(TextEditingController textEditingController, String hintText, TextInputType textInputType, bool isPass) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(142, 142, 147, 1.2),
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        minLines: 20,
        maxLines: 30,
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isPass,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.black
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  void _addReview() async {
    String review = reviewController.text.toString().trim();
    if (review.isNotEmpty) {
      if(_formkey.currentState!.validate()) {
        LoadingDialog.showLoadingDialog(context, "Adding...");

        String tag;
        final prediction = _classifier.classify(review);
        if (prediction[1] > prediction[0])
          tag = "positive";
        else
          tag = "negative";

        int idReview = DateTime.now().millisecondsSinceEpoch;
        await FirebaseFirestore.instance.collection("REVIEW").doc(idReview.toString()).set({
          "idReview": idReview,
          "idFood": this.widget.idFood,
          "idUser": _auth.currentUser!.uid.toString(),
          "timestamp": idReview,
          "content": review,
          "tag": ""
        }).then((value) => {
          LoadingDialog.hideLoadingDialog(context),
          MsgDialog.showMsgDialog(context, "Add Review Success", "Add to foods for everyone to enjoy"),
          reviewController.clear(),
        });
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Add Review Failed", "Please enter your review");
    }
  }
}
