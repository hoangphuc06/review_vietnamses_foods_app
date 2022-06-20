import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/common_widgets/button_not_icon.dart';
import 'package:tflite_flutter_plugin_example/src/pages/signup_page.dart';

import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                SizedBox(height: 50,),
                _textField(emailController,"Email", TextInputType.emailAddress, false),
                SizedBox(height: 10,),
                _textField(passController, "Password", TextInputType.text, true),
                SizedBox(height: 10,),
                buttonNotIcon(context, "Login", Colors.white, Colors.orange, (){
                  _login();
                }),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot password /",
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Text(
                        "Reset",
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
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100,),
        Text(
          "Hey,",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        Text(
          "Login Now.",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        SizedBox(height: 20,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "If you are new /",
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
            SizedBox(width: 5,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
              },
              child: Text(
                "Create New",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _textField(TextEditingController textEditingController, String hintText, TextInputType textInputType, bool isPass) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(142, 142, 147, 1.2),
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isPass,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  void _login() async {
    String email = emailController.text.toString().trim();
    String pass = passController.text.toString().trim();

    if (email.isNotEmpty && pass.isNotEmpty) {
      if(_formkey.currentState!.validate()) {

        LoadingDialog.showLoadingDialog(context, "Signing in...");

        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: pass
          );

          FirebaseFirestore.instance.collection("USER").doc(userCredential.user!.uid).get().then((value) => {
            if (value["role"]=="guest") {
              print("Đăng nhập guest thành công")
            }
            else {
              print("Đăng nhập owner thành công")
            }
          });

        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {

            LoadingDialog.hideLoadingDialog(context);

            MsgDialog.showMsgDialog(context, "Login failed", "This account is not registered yet");

          } else if (e.code == 'wrong-password') {

            LoadingDialog.hideLoadingDialog(context);

            MsgDialog.showMsgDialog(context, "Login failed", "Password is incorrect");

          }
        }
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Login failed", "Please enter full information");
    }
  }
}
