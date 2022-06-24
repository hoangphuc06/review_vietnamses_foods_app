import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  TextEditingController nameController = new TextEditingController();
  File? file = null;
  String linkUrl = "";

  @override
  initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await _firestore.collection('USER').where("uid", isEqualTo: _auth.currentUser!.uid.toString()).get().then((value) {
      setState(() {
        userMap = value.docs[0].data();
        nameController.text = userMap!["name"];
        linkUrl = userMap!["avatar"];
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
      ) : SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 10,),
            _textField(nameController, "Name", TextInputType.text, false),
            SizedBox(height: 30,),
            Text(
              "Upload your avatar",
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                _selectImage(0);
              },
              child: linkUrl != "" ?
              Center(
                child: Container(
                  height: (size.width - 32 * 2 - 10),
                  width: (size.width - 32 * 2 - 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)),
                      image: DecorationImage(
                          image: NetworkImage(linkUrl),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ): file == null?
              Center(
                child: Container(
                  height: (size.width - 32 * 2 - 10),
                  width: (size.width - 32 * 2 - 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)),
                      color: Color.fromRGBO(142, 142, 147, 1.2)
                  ),
                  child: Icon(Icons.image, size: 40,),
                ),
              ) :
              Center(
                child: Container(
                  height: (size.width - 32 * 2 - 10),
                  width: (size.width - 32 * 2 - 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)),
                      image: DecorationImage(
                          image: FileImage(file!),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            buttonNotIcon(context, "Edit Your Profile", Colors.white, Colors.orange, () {
              _editProfile();
            }),
            SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Haven't edit /",
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Return",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController textEditingController,
      String hintText, TextInputType textInputType, bool isPass) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(142, 142, 147, 1.2),
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isPass,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.black
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50,),
        Text(
          "Edit your profile",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        SizedBox(height: 20,),
        Text(
          "Please fill in your information",
          style: TextStyle(
              color: Colors.grey
          ),
        )
      ],
    );
  }

  void _editProfile() async {
    String name = nameController.text.toString().trim();

    if (file == null) {
      if (name.isNotEmpty) {
        LoadingDialog.showLoadingDialog(context, "Update...");
        await FirebaseFirestore.instance.collection("USER").doc(_auth.currentUser!.uid.toString()).update({
          "name": name,
        }).then((value) =>
        {
          LoadingDialog.hideLoadingDialog(context),
          MsgDialog.showMsgDialog(
              context, "Update Success", ""),

        });
      }
      else {
        MsgDialog.showMsgDialog(context, "Update Failed",
            "Please enter your name");
      }
    }
    else {
      if (name.isNotEmpty) {
        LoadingDialog.showLoadingDialog(context, "Update...");
        await _uploadImages();
        await FirebaseFirestore.instance.collection("USER").doc(_auth.currentUser!.uid.toString()).update({
          "name": name,
          "avatar": linkUrl,
        }).then((value) =>
        {
          LoadingDialog.hideLoadingDialog(context),
          MsgDialog.showMsgDialog(
              context, "Update Success", ""),

        });
      }
      else {
        MsgDialog.showMsgDialog(context, "Update Failed",
            "Please enter your name");
      }
    }
  }

  void _selectImage(int nameFile) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        linkUrl = "";
        file = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImages() async {
    if (file != null) {
      String filename = DateTime.now().millisecondsSinceEpoch.toString();

      Reference ref = FirebaseStorage.instance.ref().child("AVATAR").child(
          FirebaseAuth.instance.currentUser!.uid).child("avatar_$filename");

      await ref.putFile(file!);
      linkUrl = await ref.getDownloadURL();
    }
  }
}
