import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter_plugin_example/src/dialogs/loading_dialog.dart';
import 'package:tflite_flutter_plugin_example/src/pages/add_store_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/my_profile_page.dart';
import 'package:tflite_flutter_plugin_example/src/pages/store_owner_page.dart';

class HomeOwnerPage extends StatefulWidget {
  const HomeOwnerPage({Key? key}) : super(key: key);

  @override
  State<HomeOwnerPage> createState() => _HomeOwnerPageState();
}

class _HomeOwnerPageState extends State<HomeOwnerPage> {

  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap, store;

  @override
  initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _firestore.collection('USER').where("uid", isEqualTo: _auth.currentUser!.uid.toString()).get().then((value) {
      setState(() {
        userMap = value.docs[0].data();
        print(userMap);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading? Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ) : Column(
        children: [
          Container(
            color: Colors.orange,
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.only(left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                userMap!["avatar"] != ""?
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image:NetworkImage(userMap!["avatar"]),
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
                      "Hi " + userMap!["name"] + ",",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "Manage your stores here",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
            color: Colors.orange,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage(userMap: userMap!

                      )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2)
                    ),
                    height: 35,
                    width: (size.width - 16 - 10) * 3/4,
                    child: Center(
                      child: Text(
                        "Your profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddStorePage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    height: 35,
                    width: (size.width - 16 - 10) * 1/4,
                    child: Center(
                      child: Text(
                        "Add Store",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 4,),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: _firestore.collection("STORE").where("idOwner", isEqualTo: userMap!['uid']).snapshots(),
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
                          QueryDocumentSnapshot store = snapshot.data!.docs[i];
                          return cardStore(store, context);
                        }
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardStore(QueryDocumentSnapshot store, BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoreOwnerPage(store: store,)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4,),
        height: (size.width - 16) * 2/4,
        width: size.width - 16,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(store["images"][0]),
            fit: BoxFit.cover
          )
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    store["storeName"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Address: " + store["address"],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Phone Number: " + store["phoneNumber"],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
