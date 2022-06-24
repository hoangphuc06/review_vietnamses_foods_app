import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/pages/edit_profile_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/splash_page.dart';

class MyProfilePage extends StatefulWidget {
  final Map<String, dynamic> userMap;
  const MyProfilePage({Key? key, required this.userMap}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: _firestore.collection("USER").where("uid", isEqualTo: _auth.currentUser!.uid.toString()).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data != null) {
                return Container(
                  color: Colors.orange,
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      snapshot.data!.docs[0]["avatar"] != ""?
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:NetworkImage(snapshot.data!.docs[0]["avatar"]),
                                fit: BoxFit.cover)),
                      ) :
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                        ),
                        child: Icon(Icons.person, color: Colors.orange, size: 30,),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            snapshot.data!.docs[0]["name"],
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            snapshot.data!.docs[0]["email"],
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
            title: Text("Edit your profile"),
            trailing: Icon(Icons.arrow_right),
          ),
          Divider(),
          ListTile(
            onTap: () {

            },
            title: Text("About us"),
            trailing: Icon(Icons.arrow_right),
          ),
          Divider(),
          ListTile(
            onTap: () {

            },
            title: Text("Change Password"),
            trailing: Icon(Icons.arrow_right),
          ),
          Divider(),
          ListTile(
            onTap: () {
                FirebaseAuth.instance.signOut().then((value) => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => SplashPage()),
                    (Route<dynamic> route) => false),
                });
            },
            title: Text("Log Out"),
            trailing: Icon(Icons.arrow_right),
          ),
          Divider(),
        ],
      ),
    );
  }
}
