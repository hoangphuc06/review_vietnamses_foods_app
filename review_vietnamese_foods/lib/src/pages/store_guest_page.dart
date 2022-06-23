import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:tflite_flutter_plugin_example/src/pages/food_guest_page.dart';

class StoreGuestPage extends StatefulWidget {
  final QueryDocumentSnapshot store;
  const StoreGuestPage({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreGuestPage> createState() => _StoreGuestPageState();
}

class _StoreGuestPageState extends State<StoreGuestPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(
                color: Colors.white
            ),
            elevation: 0.5,
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: 216.5,
            flexibleSpace: FlexibleSpaceBar(
              background: StreamBuilder(
                stream: _firestore.collection("STORE").where("idStore", isEqualTo: this.widget.store["idStore"]).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return Stack(
                        children: [
                          _imageFoodView(),
                         Container(
                            height: 250, width: size.width,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      this.widget.store["storeName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Address: " + snapshot.data!.docs[0]["address"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Phone Number: " + snapshot.data!.docs[0]["phoneNumber"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    ),
                                    SizedBox(height: 20,)]
                              )
                          )
                        ]);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            SizedBox(height: 4,),
            SingleChildScrollView(
              child: StreamBuilder(
                stream: _firestore.collection("FOOD").where("idStore", isEqualTo: this.widget.store["idStore"]).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context ,i) {
                            QueryDocumentSnapshot food = snapshot.data!.docs[i];
                            //return cardFood(store, context);
                            return foodCard(context, food);
                          }
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ]))
        ],
      ),
    );
  }

  Widget _imageFoodView() {
    if (this.widget.store["images"][1] == "" && this.widget.store["images"][2] == "" && this.widget.store["images"][3] == "") {
      return Image.network(
        this.widget.store["images"][0],
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    else if(this.widget.store["images"][1] != "" && this.widget.store["images"][2] == "" && this.widget.store["images"][3] == "") {
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
            this.widget.store["images"][0],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.store["images"][1],
            fit: BoxFit.cover,
          ),
        ],
      );
    }
    else if(this.widget.store["images"][1] != "" && this.widget.store["images"][2] != "" && this.widget.store["images"][3] == "") {
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
            this.widget.store["images"][0],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.store["images"][1],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.store["images"][2],
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
            this.widget.store["images"][0],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.store["images"][1],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.store["images"][2],
            fit: BoxFit.cover,
          ),
          Image.network(
            this.widget.store["images"][3],
            fit: BoxFit.cover,
          ),
        ],
      );
    }
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
