import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/pages/add_food_page.dart';

import 'edit_store_page.dart';

class StoreOwnerPage extends StatefulWidget {
  final QueryDocumentSnapshot store;
  const StoreOwnerPage({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreOwnerPage> createState() => _StoreOwnerPageState();
}

class _StoreOwnerPageState extends State<StoreOwnerPage> {
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
            actions: [
              IconButton(icon: Icon(Icons.settings, color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditStorePage(store: this.widget.store,)));
                },
              ),
            ],
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
                        Image.network(snapshot.data!.docs[0]["images"][0], fit: BoxFit.cover, height: 250, width: size.width,),
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
            SingleChildScrollView(
              child: StreamBuilder(
                stream: _firestore.collection("FOOD").where("idStore", isEqualTo: this.widget.store["idStore"]).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context ,i) {
                          QueryDocumentSnapshot store = snapshot.data!.docs[i];
                          //return cardFood(store, context);
                          return _foodItem(store, context);
                        }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFoodPage(idStore: this.widget.store["idStore"],)));
        },
        label: Text("Add Food"),
        foregroundColor: Colors.white,
        icon: Container(
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _foodItem(QueryDocumentSnapshot food, BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(

            color: Colors.white,
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                image: NetworkImage(food["images"][0]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            food["foodName"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20
                            ),
                          ),
                        ],
                      )),
                  Row(
                    children: [
                      Container(
                        //alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 7.0),
                        child: Text(
                          food["price"] + " VNĐ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


