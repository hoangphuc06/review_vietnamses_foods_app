import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/common_widgets/button_icon.dart';
import 'package:tflite_flutter_plugin_example/src/pages/login_page.dart';

import '../common_widgets/button_not_icon.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/bg/bg_banhmi.jpg'))),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    'WELCOME TO VIETNAMESE FOODS',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 45.0
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 30.0),
                  child: Text(
                    'Discover, enjoy and share Vietnamese foods to all foreign tourists.',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: buttonNotIcon(context, "Login with your account", Colors.white, Colors.orange, (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: buttonIcon(context, "Login with Facebook", Colors.white, Color.fromRGBO(0, 122, 255, 1.0), AssetImage('assets/images/ic/ic_fb.png'),(){
                    print('goToFacebook');
                  }),
                ),
                SizedBox(height: 100,)
              ],
            )
          ],
        )
    );
  }
}
