import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../classifier.dart';
import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class EditReviewPage extends StatefulWidget {
  final QueryDocumentSnapshot review;
  const EditReviewPage({Key? key, required this.review}) : super(key: key);

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  TextEditingController reviewController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Classifier _classifier;
  Map<String, dynamic>? store, food;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _classifier = Classifier();
    loadData();
  }

  void loadData() async {
    await FirebaseFirestore.instance.collection('FOOD').where("idFood", isEqualTo: this.widget.review["idFood"]).get().then((value) {
      setState(() {
        food = value.docs[0].data();
      });
    });
    await FirebaseFirestore.instance.collection('STORE').where("idStore", isEqualTo: food!["idStore"]).get().then((value) {
      setState(() {
        store = value.docs[0].data();
      });
    });
    setState(() {
      reviewController.text = this.widget.review["content"];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading? Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ) : SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              SizedBox(height: 10,),
              _longTextField(reviewController, "Your review", TextInputType.text, false),
              SizedBox(height: 30,),
              buttonNotIcon(context, "Edit your review", Colors.white, Colors.orange, (){
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
        LoadingDialog.showLoadingDialog(context, "Editing...");
        final prediction = _classifier.classify(review);
        if (prediction[1] > prediction[0]) {
          if (this.widget.review["tag"] == "positive") {
            await FirebaseFirestore.instance.collection("REVIEW").doc(this.widget.review["idReview"].toString()).update({
              "content": review,
            }).then((value) => {
              LoadingDialog.hideLoadingDialog(context),
              MsgDialog.showMsgDialog(context, "Edit Review Success", "Thanks for your review"),
            });
          }
          else {
            await FirebaseFirestore.instance.collection("REVIEW").doc(this.widget.review["idReview"].toString()).update({
              "content": review,
              "tag": "positive"
            });
            await FirebaseFirestore.instance.collection("FOOD").doc(food!["idFood"].toString()).update({
              "positive": food!["positive"] + 1,
              "negative": food!["negative"] - 1,
            });
            await FirebaseFirestore.instance.collection("STORE").doc(store!["idStore"].toString()).update({
              "positive": store!["positive"] + 1,
              "negative": store!["negative"] - 1,
            }).then((value) => {
              LoadingDialog.hideLoadingDialog(context),
              MsgDialog.showMsgDialog(context, "Edit Review Success", "Thanks for your review"),
            });
          }
        }
        else {
          if (this.widget.review["tag"] == "negative") {
            await FirebaseFirestore.instance.collection("REVIEW").doc(this.widget.review["idReview"].toString()).update({
              "content": review,
            }).then((value) => {
              LoadingDialog.hideLoadingDialog(context),
              MsgDialog.showMsgDialog(context, "Edit Review Success", "Thanks for your review"),
            });
          }
          else {
            await FirebaseFirestore.instance.collection("REVIEW").doc(this.widget.review["idReview"].toString()).update({
              "content": review,
              "tag": "negative"
            });
            await FirebaseFirestore.instance.collection("FOOD").doc(food!["idFood"].toString()).update({
              "positive": food!["positive"] - 1,
              "negative": food!["negative"] + 1,
            });
            await FirebaseFirestore.instance.collection("STORE").doc(store!["idStore"].toString()).update({
              "positive": store!["positive"] - 1,
              "negative": store!["negative"] + 1,
            }).then((value) => {
              LoadingDialog.hideLoadingDialog(context),
              MsgDialog.showMsgDialog(context, "Edit Review Success", "Thanks for your review"),
            });
          }
        }
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Edit Review Failed", "Please enter your review");
    }
  }
}
