import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/pages/login_page.dart';

import '../common_widgets/rounded_button.dart';

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
                createButton(
                    context: context,
                    func: () {
                      //Navigator.pushNamed(context, 'login');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    labelButton: 'Login with your account',
                    buttonColor: Colors.orange,
                ),
                createButton(
                    context: context,
                    func: () => print('goToFacebook'),
                    isWithIcon: true,
                    labelButton: 'Login with facebook',
                    buttonColor: Color.fromRGBO(0, 122, 255, 1.0),
                    icon: AssetImage('assets/images/ic/ic_fb.png')
                ),
                SizedBox(height: 100,)
              ],
            )
          ],
        )
    );
  }
}
