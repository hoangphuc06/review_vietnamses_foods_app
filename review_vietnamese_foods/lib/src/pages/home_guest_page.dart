
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:tflite_flutter_plugin_example/src/pages/food_guest_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/look_up_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/store_guest_page.dart';

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
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
              stream: _firestore.collection("USER").where("uid", isEqualTo: _auth.currentUser!.uid.toString()).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return Container(
                    padding: EdgeInsets.only(left: 8),
                    width: double.infinity,
                    color: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50,),
                        Text(
                          "Hi " + snapshot.data!.docs[0]["name"] + ",",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LookUpPage()));
              },
              child: Container(
                color: Colors.orange,
                padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    //color: Color.fromRGBO(142, 142, 147, 1.2),
                    color: Colors.white,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8, top: 12),
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
                    Container(
                      height: 225,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 8, top: 10),
                      child: StreamBuilder(
                        stream: _firestore.collection("STORE").orderBy("positive", descending: true).limit(5).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, i) {
                                  QueryDocumentSnapshot x = snapshot.data!.docs[i];
                                  return storeCard(context, x);
                                });
                          } else {
                            return Center(child: Text("No Data"));
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                            child: Text(
                              "Best Food",
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
                    StreamBuilder(
                      stream: _firestore.collection("FOOD").orderBy("positive", descending: true).limit(5).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, i) {
                                  QueryDocumentSnapshot x = snapshot.data!.docs[i];
                                  return foodCard(context, x);
                                }),
                          );
                        } else {
                          return Center(child: Text("No Data"));
                        }
                      },
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget storeCard(BuildContext context,  QueryDocumentSnapshot store) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreGuestPage(store: store,)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(store["images"][0], height: 150, width: 200, fit: BoxFit.cover,),
            SizedBox(height: 10,),
            Text(
              store["storeName"],
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              store["address"],
              style: TextStyle(
                color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget foodCard(BuildContext context, QueryDocumentSnapshot food) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodGuestPage(food: food,)));
      },
      child: Container(
        height: 100,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.only(top: 8, left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(food["images"][0], height: 84, width: 84, fit: BoxFit.cover,),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: _firestore.collection("STORE").where("idStore", isEqualTo: food["idStore"]).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return Text(
                        food["foodName"] + " - " + snapshot.data!.docs[0]["storeName"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(height: 5,),
                Text(
                  "Price: " + food["price"] + " VND",
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
                SizedBox(height: 5,),
                StreamBuilder(
                  stream: _firestore.collection("REVIEW").where("idFood", isEqualTo: food["idFood"]).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return Text(
                        "Reviews: " + snapshot.data!.docs.length.toString(),
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
