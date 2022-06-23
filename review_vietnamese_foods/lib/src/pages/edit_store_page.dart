import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class EditStorePage extends StatefulWidget {
  final QueryDocumentSnapshot store;
  const EditStorePage({Key? key, required this.store}) : super(key: key);

  @override
  State<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  TextEditingController storeNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<File?> _listFile = [null, null, null, null];
  List<String> _listUrl = ["", "", "", ""];

  @override
  initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    setState((){
      storeNameController.text = this.widget.store["storeName"];
      addressController.text = this.widget.store["address"];
      phoneNumberController.text = this.widget.store["phoneNumber"];
      _listUrl = [this.widget.store["images"][0], this.widget.store["images"][1], this.widget.store["images"][2],
                      this.widget.store["images"][3],];
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                SizedBox(height: 10,),
                _textField(
                    storeNameController, "Store Name", TextInputType.text,
                    false),
                SizedBox(height: 10,),
                _textField(
                    addressController, "Address", TextInputType.emailAddress,
                    false),
                SizedBox(height: 10,),
                _textField(
                    phoneNumberController, "Phone Number", TextInputType.text,
                    false),
                SizedBox(height: 30,),
                Text(
                  "Upload some pictures of your store",
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectImage(0);
                      },
                      child: _listUrl[0] != "" ?
                      Center(
                        child: Container(
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(_listUrl[0]),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ): _listFile[0] == null?
                      Center(
                        child: Container(
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
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
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              image: DecorationImage(
                                  image: FileImage(_listFile[0]!),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        _selectImage(1);
                      },
                      child: _listFile[1] == null ?
                      Center(
                        child: Container(
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
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
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              image: DecorationImage(
                                  image: FileImage(_listFile[1]!),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectImage(2);
                      },
                      child: _listFile[2] == null ?
                      Center(
                        child: Container(
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
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
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              image: DecorationImage(
                                  image: FileImage(_listFile[2]!),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        _selectImage(3);
                      },
                      child: _listFile[3] == null ?
                      Center(
                        child: Container(
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
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
                          height: (size.width - 32 * 2 - 10) / 2,
                          width: (size.width - 32 * 2 - 10) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              image: DecorationImage(
                                  image: FileImage(_listFile[3]!),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                buttonNotIcon(
                    context, "Edit Your Store", Colors.white, Colors.orange, () {
                  _updateStore();
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
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50,),
        Text(
          "Edit your store",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        SizedBox(height: 20,),
        Text(
          "Please fill in store information",
          style: TextStyle(
              color: Colors.grey
          ),
        )
      ],
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

  void _updateStore() async {
    String storeName = storeNameController.text.toString().trim();
    String address = addressController.text.toString().trim();
    String phoneNumber = phoneNumberController.text.toString().trim();

    if (storeName.isNotEmpty && address.isNotEmpty && phoneNumber.isNotEmpty) {
      if (_formkey.currentState!.validate()) {
        LoadingDialog.showLoadingDialog(context, "Editing...");
        await _uploadImages();
        await FirebaseFirestore.instance.collection("STORE").doc(this.widget.store["idStore"].toString()).update({
          "storeName": storeName,
          "address": address,
          "phoneNumber": phoneNumber,
          "images": _listUrl,
        }).then((value) =>
        {
          LoadingDialog.hideLoadingDialog(context),
          MsgDialog.showMsgDialog(
              context, "Update Success", "Turn back and introduce foods for everyone to enjoy"),

        });
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Update Failed",
          "Please enter full information and have at least 1 picture");
    }
  }

  Future<void> _uploadImages() async {
    for (int i = 0; i < 4; i++) {
      if (_listFile[i] != null) {
        String filename = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();

        Reference ref = FirebaseStorage.instance.ref().child("STORE").child(
            FirebaseAuth.instance.currentUser!.uid).child("store_$filename");

        await ref.putFile(_listFile[i]!);

        _listUrl[i] = await ref.getDownloadURL();

        print(_listUrl[i]);
      }
    }
  }

  void _selectImage(int nameFile) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _listUrl[nameFile] = "";
        _listFile[nameFile] = File(pickedFile.path);
      });
    }
  }
}
