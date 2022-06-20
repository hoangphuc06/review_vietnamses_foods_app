import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/common_widgets/button_not_icon.dart';
import 'package:tflite_flutter_plugin_example/src/pages/signup_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
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
}
