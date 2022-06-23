import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:tflite_flutter_plugin_example/src/pages/edit_food_page.dart';

class FoodOwnerPage extends StatefulWidget {
  final QueryDocumentSnapshot food;
  const FoodOwnerPage({Key? key, required this.food}) : super(key: key);

  @override
  State<FoodOwnerPage> createState() => _FoodOwnerPageState();
}

class _FoodOwnerPageState extends State<FoodOwnerPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, isScolled){
            return [
              SliverAppBar(
                actions: [
                  IconButton(icon: Icon(Icons.settings, color: Colors.white,),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditFoodPage(food: this.widget.food,)));
                    },
                  ),
                ],
                iconTheme: IconThemeData(
                    color: Colors.white
                ),
                backgroundColor: Colors.orange,
                elevation: 0,
                floating: false,
                pinned: true,
                snap: false,
                expandedHeight: 328,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      _imageFoodView(),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder(
                              stream: _firestore.collection("STORE").where("idStore", isEqualTo: this.widget.food["idStore"]).snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                    this.widget.food["foodName"] + " - " + snapshot.data!.docs[0]["storeName"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Price: " + this.widget.food["price"] + " VND",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Category: " + this.widget.food["category"],
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5,),
                            StreamBuilder(
                              stream: _firestore.collection("REVIEW").where("idFood", isEqualTo: this.widget.food["idFood"]).snapshots(),
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
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SliverPersistentHeader(
                delegate: MyDelegate(
                  TabBar(
                    tabs: [
                      Tab(text: 'Information'),
                      Tab(text: 'Reviews'),
                    ],
                    indicatorColor: Colors.orange,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.orange,
                    isScrollable: true,
                  ),
                ),
                floating: false,
                pinned: true,

              )
            ];
          },
          body: TabBarView(
            children: [
              _InformationView(),
              _ReviewsView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _InformationView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
            width: double.infinity,
            child: Text(
              this.widget.food["description"],
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 4, bottom: 4),
            padding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
            width: double.infinity,
            child: StreamBuilder(
              stream: _firestore.collection("STORE").where("idStore", isEqualTo: this.widget.food["idStore"]).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:NetworkImage(snapshot.data!.docs[0]["images"][0]),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.docs[0]["storeName"],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "Address: " + snapshot.data!.docs[0]["address"],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "Phone Number: " + snapshot.data!.docs[0]["phoneNumber"],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
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
                    "Other Foods of Store",
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
            stream: _firestore.collection("FOOD").where("idStore", isEqualTo: this.widget.food["idStore"]).snapshots(),
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
                        if (x["idFood"] != this.widget.food["idFood"])
                          return foodCard(context, x);
                        else
                          return Container();
                      }),
                );
              } else {
                return Center(child: Text("No Data"));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _ReviewsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4,),
          StreamBuilder(
            stream: _firestore.collection("REVIEW").orderBy("timestamp", descending: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[i];
                        if (x["idFood"] == this.widget.food["idFood"])
                          return reviewCard(context, x);
                        else
                          return Container();
                      }),
                );
              } else {
                return Center(child: Text("No Data"));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _imageFoodView() {
    if (this.widget.food["images"][1] == "" && this.widget.food["images"][2] == "" && this.widget.food["images"][3] == "") {
      return Image.network(
        this.widget.food["images"][0],
        height: 250,
        fit: BoxFit.cover,
      );
    }
    else if(this.widget.food["images"][1] != "" && this.widget.food["images"][2] == "" && this.widget.food["images"][3] == "") {
      return ImageSlideshow(
        width: double.infinity,
        height: 250,
        initialPage: 0,
        indicatorColor: Colors.orange,
        indicatorBackgroundColor: Colors.grey,
        onPageChanged: (value) {
          debugPrint('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: [
          Image.network(
            this.widget.food["images"][0],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.food["images"][1],
            fit: BoxFit.cover,
          ),
        ],
      );
    }
    else if(this.widget.food["images"][1] != "" && this.widget.food["images"][2] != "" && this.widget.food["images"][3] == "") {
      return ImageSlideshow(
        width: double.infinity,
        height: 250,
        initialPage: 0,
        indicatorColor: Colors.orange,
        indicatorBackgroundColor: Colors.grey,
        onPageChanged: (value) {
          debugPrint('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: [
          Image.network(
            this.widget.food["images"][0],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.food["images"][1],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.food["images"][2],
            fit: BoxFit.cover,
          ),
        ],
      );
    }
    else {
      return ImageSlideshow(
        width: double.infinity,
        height: 250,
        initialPage: 0,
        indicatorColor: Colors.orange,
        indicatorBackgroundColor: Colors.grey,
        onPageChanged: (value) {
          debugPrint('Page changed: $value');
        },
        autoPlayInterval: 3000,
        isLoop: true,
        children: [
          Image.network(
            this.widget.food["images"][0],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.food["images"][1],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.food["images"][2],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.food["images"][3],
            fit: BoxFit.cover,
          ),
        ],
      );
    }
  }

  Widget reviewCard(BuildContext context, QueryDocumentSnapshot review) {
    return Container(
      color: Colors.white,
      width: 50,
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: _firestore.collection("USER").where("uid", isEqualTo: review["idUser"]).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data!.docs[0]["avatar"] == ""){
                          return Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange
                            ),
                            child: Icon(Icons.person, color: Colors.white, size: 30,),
                          );
                        }
                        else {
                          return Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: Icon(Icons.person, color: Colors.orange, size: 30,),
                          );
                        }
                      }
                      else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(width: 20,),
                  StreamBuilder(
                    stream: _firestore.collection("USER").where("uid", isEqualTo: review["idUser"]).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.docs[0]["name"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(review["timestamp"]).toString(),
                              style: TextStyle(
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        );
                      }
                      else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 60,  right: 4),
            child: Text(
              review["content"],
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget foodCard(BuildContext context, QueryDocumentSnapshot food) {
    return GestureDetector(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => FoodGuestPage(food: food,)));
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

  void _deleteReview(BuildContext context, QueryDocumentSnapshot review) async {
    if (review["tag"] == "positive") {
      await FirebaseFirestore.instance.collection('FOOD').where("idFood", isEqualTo: this.widget.food["idFood"]).get().then((value) {
        FirebaseFirestore.instance.collection("FOOD").doc(this.widget.food["idFood"].toString()).update({
          "positive": value.docs[0].data()["positive"] - 1,
        });
      });
      await FirebaseFirestore.instance.collection('STORE').where("idStore", isEqualTo: this.widget.food["idStore"]).get().then((value) {
        FirebaseFirestore.instance.collection("STORE").doc(this.widget.food["idStore"].toString()).update({
          "positive": value.docs[0].data()["positive"] - 1,
        });
      });
      _firestore.collection("REVIEW").doc(review["idReview"].toString()).delete();
    }
    else {
      await FirebaseFirestore.instance.collection("FOOD").doc(this.widget.food["idFood"].toString()).update({
        "negative": this.widget.food["negative"] - 1,
      });
      await FirebaseFirestore.instance.collection('STORE').where("idStore", isEqualTo: this.widget.food["idStore"]).get().then((value) {
        FirebaseFirestore.instance.collection("STORE").doc(this.widget.food["idStore"].toString()).update({
          "negative": value.docs[0].data()["negative"] - 1,
        });
      });
      _firestore.collection("REVIEW").firestore.doc(review["idReview"].toString()).delete();
    }
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);
  final TabBar tabBar;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}