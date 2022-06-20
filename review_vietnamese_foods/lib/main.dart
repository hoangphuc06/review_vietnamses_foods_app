import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/classifier.dart';
import 'package:tflite_flutter_plugin_example/src/pages/login_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/splash_page.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: ThemeData(
          primarySwatch: Colors.orange
      ),
    );
  }
}

