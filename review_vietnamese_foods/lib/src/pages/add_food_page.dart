import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class AddFoodPage extends StatefulWidget {
  final String idStore;
  const AddFoodPage({Key? key, required this.idStore}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  TextEditingController foodNameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<File?> _listFile = [null, null, null, null];
  List<String> _listUrl = ["", "", "", ""];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                _textField(foodNameController, "Food Name", TextInputType.text, false),
                SizedBox(height: 10,),
                _textField(priceController, "Food Price", TextInputType.number, false),
                SizedBox(height: 10,),
                _longTextField(descriptionController, "Description about food", TextInputType.text, false),
                SizedBox(height: 30,),
                Text(
                  "Upload some pictures of your food",
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
                      child: _listFile[0] == null ?
                      Center(
                        child: Container(
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(142, 142, 147, 1.2)
                          ),
                          child: Icon(Icons.image, size: 40,),
                        ),
                      ):
                      Center(
                        child: Container(
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(142, 142, 147, 1.2)
                          ),
                          child: Icon(Icons.image, size: 40,),
                        ),
                      ):
                      Center(
                        child: Container(
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(142, 142, 147, 1.2)
                          ),
                          child: Icon(Icons.image, size: 40,),
                        ),
                      ):
                      Center(
                        child: Container(
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(142, 142, 147, 1.2)
                          ),
                          child: Icon(Icons.image, size: 40,),
                        ),
                      ):
                      Center(
                        child: Container(
                          height: (size.width - 32*2 - 10)/2,
                          width: (size.width - 32*2 - 10)/2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                buttonNotIcon(context, "Create Food", Colors.white, Colors.orange, (){
                  _createFood();
                }),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have food /",
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: (){
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

  Widget _textField(TextEditingController textEditingController, String hintText, TextInputType textInputType, bool isPass) {
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

  Widget _longTextField(TextEditingController textEditingController, String hintText, TextInputType textInputType, bool isPass) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(142, 142, 147, 1.2),
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        minLines: 5,
        maxLines: 10,
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
          "Create your new food",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        SizedBox(height: 20,),
        Text(
          "Please fill in food information",
          style: TextStyle(
              color: Colors.grey
          ),
        )
      ],
    );
  }

  void _createFood() async {
    String name = foodNameController.text.toString().trim();
    String price = priceController.text.toString().trim();
    String descr = descriptionController.text.toString().trim();

    if (name.isNotEmpty && price.isNotEmpty && descr.isNotEmpty && _listFile[0] != null) {
      if(_formkey.currentState!.validate()) {
        LoadingDialog.showLoadingDialog(context, "Creating...");
        await _uploadImages();
        String idFood = DateTime.now().millisecondsSinceEpoch.toString();
        await FirebaseFirestore.instance.collection("FOOD").doc(idFood).set({
          "idStore": this.widget.idStore,
          "idFood": idFood,
          "foodName": name,
          "price": price,
          "description": descr,
          "negative": "0",
          "positive": "0",
          "images": _listUrl,
        }).then((value) => {
          LoadingDialog.hideLoadingDialog(context),
          MsgDialog.showMsgDialog(context, "Create Success", "Add to foods for everyone to enjoy"),

          _listFile = [null, null, null, null],
          _listUrl = ["", "", "", ""],
          foodNameController.clear(),
          priceController.clear(),
          descriptionController.clear(),
        });
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Create Failed", "Please enter full information and have at least 1 picture");
    }
  }

  Future<void> _uploadImages() async {
    for (int i=0; i<4; i++) {
      if (_listFile[i] != null) {

        String filename = DateTime.now().millisecondsSinceEpoch.toString();

        Reference ref = FirebaseStorage.instance.ref().child("FOOD").child(this.widget.idStore).child("food_$filename");

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
      setState((){
        _listFile[nameFile] = File(pickedFile.path);
      });
    }
  }
}
