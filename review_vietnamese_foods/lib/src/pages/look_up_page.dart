import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/pages/food_guest_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/store_guest_page.dart';

class LookUpPage extends StatefulWidget {
  const LookUpPage({Key? key}) : super(key: key);

  @override
  State<LookUpPage> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> {

  TextEditingController lookUpController = new TextEditingController();
  bool isSearching = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.orange,
            padding: EdgeInsets.only(top: 50, left: 8, right: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: TextFormField(
                        controller: lookUpController,
                        decoration: InputDecoration(
                          hintText: "Enter your food's name",
                          hintStyle: TextStyle(
                              color: Colors.black
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        searchFood();
                      },
                      child: Container(
                        width: size.width * 0.15,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                        ),
                        child: Center(
                          child: Icon(Icons.search),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          isSearching? Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //View Food
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, top: 12, bottom: 4),
                          child: Text(
                            "Food",
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
                  SizedBox(height: 4,),
                  StreamBuilder(
                    stream: _firestore.collection("FOOD").orderBy("positive", descending: true).snapshots(),
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
                                if (food["foodName"].toString().toLowerCase().contains(lookUpController.text.toLowerCase()))
                                  return foodCard(context, food);
                                else
                                  return Container();
                                //return foodCard(context, food);
                              }
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),

                  //View Store
                  Container(
                    padding: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4, top: 12, bottom: 4),
                          child: Text(
                            "Store",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: _firestore.collection("STORE").orderBy("positive", descending: true).snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                            if (!snapshot.hasData) {
                              return Center(
                                child: Container(),
                              );
                            }
                            else {
                              List<QueryDocumentSnapshot> stores = snapshot.data!.docs;
                              stores.removeWhere((store) => !store["storeName"].toString().toLowerCase().contains(lookUpController.text.toLowerCase()));

                              return MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                    ),
                                    itemCount: stores.length,
                                    itemBuilder: (context, i) {
                                      return storeCard(context, stores[i]);
                                      // QueryDocumentSnapshot store = snapshot.data!.docs[i];
                                      // if (store["storeName"].toString().toLowerCase().contains(lookUpController.text.toLowerCase()))
                                      //   return storeCard(context, store);
                                      // else
                                      //   return Container(height: 0, width: 0,);
                                    }
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),

                ],
              ),
            )
          ) : Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 50, color: Colors.grey.withOpacity(0.8),),
                  SizedBox(height: 10,),
                  Text("Search your food", style: TextStyle(fontSize: 25, color: Colors.grey),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void searchFood() async {
    if (lookUpController.text == "") {
      setState((){
        isSearching = false;
      });
    }
    else {
      setState((){
        isSearching = true;
      });
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

  Widget storeCard(BuildContext context,  QueryDocumentSnapshot store) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreGuestPage(store: store,)));
      },
      child: Card(
        elevation: 0.2,
        child: Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(store["images"][0], height: 120, width: (size.width - 8 - 4)/2, fit: BoxFit.cover,),
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
      ),
    );
  }
}
