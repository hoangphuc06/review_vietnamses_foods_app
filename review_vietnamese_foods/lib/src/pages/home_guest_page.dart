
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class HomeGuestPage extends StatefulWidget {
  const HomeGuestPage({Key? key}) : super(key: key);

  @override
  State<HomeGuestPage> createState() => _HomeGuestPageState();
}

class _HomeGuestPageState extends State<HomeGuestPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late PageController _pageController;

  final List<String> images = [
    'assets/images/banner/banner1.png',
    'assets/images/banner/banner2.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        children: [
          StreamBuilder(
            stream: _firestore.collection("USER").where("uid", isEqualTo: _auth.currentUser!.uid.toString()).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data != null) {
                return Container(
                  padding: EdgeInsets.only(left: 8),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50,),
                      Text(
                        "Hi " + snapshot.data!.docs[0]["name"] + ",",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromRGBO(142, 142, 147, 1.2),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey,),
                    SizedBox(width: 5,),
                    Text(
                      "Find your food...",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ImageSlideshow(
            width: double.infinity,
            height: 200,
            initialPage: 0,
            indicatorColor: Colors.orange,
            indicatorBackgroundColor: Colors.grey,
            onPageChanged: (value) {
              debugPrint('Page changed: $value');
            },
            autoPlayInterval: 3000,
            isLoop: true,
            children: [
              Image.asset(
                'assets/images/banner/banner1.png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/banner/banner2.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 8, bottom: 12),
                  child: Text(
                    "Shop",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
