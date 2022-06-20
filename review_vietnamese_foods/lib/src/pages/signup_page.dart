import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController rePassController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  bool isGuest = true;
  bool isOwner = false;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                _textField(nameController, "Name", TextInputType.text, false),
                SizedBox(height: 10,),
                _textField(emailController,"Email", TextInputType.emailAddress, false),
                SizedBox(height: 10,),
                _textField(passController, "Password", TextInputType.text, true),
                SizedBox(height: 10,),
                _textField(rePassController, "Re-Password", TextInputType.text, true),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: (size.width - 32*2 - 10)/2,
                      decoration: BoxDecoration(
                        color: isGuest? Colors.orange : Color.fromRGBO(142, 142, 147, 1.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          setState((){
                            isGuest = true;
                            isOwner = false;
                          });
                        },
                        child: Center(
                          child: Text(
                            "Guest",
                            style: TextStyle(
                              color: isGuest? Colors.white : Colors.black,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      height: 50,
                      width: (size.width - 32*2 - 10)/2,
                      decoration: BoxDecoration(
                        color: isOwner? Colors.orange : Color.fromRGBO(142, 142, 147, 1.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          setState((){
                            isGuest = false;
                            isOwner = true;
                          });
                        },
                        child: Center(
                          child: Text(
                            "Owner",
                            style: TextStyle(
                                color: isOwner? Colors.white : Colors.black,
                                fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                buttonNotIcon(context, "Sign up", Colors.white, Colors.orange, (){
                  _signUp();
                }),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have account /",
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
          "Sign up Now.",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        SizedBox(height: 20,),
        Text(
          "Sign up now to discover Vietnamese foods",
          style: TextStyle(
              color: Colors.grey
          ),
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
            hintStyle: TextStyle(
              color: Colors.black
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  void _signUp() async {
    String name = nameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String pass = passController.text.toString().trim();
    String rePass = rePassController.text.toString().trim();
    String role = isGuest? "guest" : "owner";

    if (name.isNotEmpty && pass.isNotEmpty && rePass.isNotEmpty && email.isNotEmpty) {
      if(_formkey.currentState!.validate()) {
        LoadingDialog.showLoadingDialog(context, "Sign up...");
        if (pass==rePass) {
          try {
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: pass
            );

            FirebaseAuth.instance.signOut();

            FirebaseFirestore.instance.collection("USER").doc(userCredential.user!.uid.toString()).set({
              "uid": userCredential.user!.uid.toString(),
              "email": email,
              "name": name,
              "role": role,
              "avatar": ""
            });

            nameController.clear();
            emailController.clear();
            passController.clear();
            rePassController.clear();
            setState((){
              isGuest = true;
              isOwner = false;
            });

            LoadingDialog.hideLoadingDialog(context);

            MsgDialog.showMsgDialog(context, "Sign up success", "Please login to continue using.");

          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {

              LoadingDialog.hideLoadingDialog(context);

              MsgDialog.showMsgDialog(context, "Sign up failed", "Password is too weak.");

            } else if (e.code == 'email-already-in-use') {

              LoadingDialog.hideLoadingDialog(context);

              MsgDialog.showMsgDialog(context, "Sign up failed", "Account already exists.");

            }
          } catch (e) {
            print(e);
          }
        }
        else {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, "Sign up failed", "Confirmation password does not match.");
        }
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Sign up failed", "Please enter full information");
    }
  }
}