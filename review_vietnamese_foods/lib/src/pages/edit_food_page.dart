import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common_widgets/button_not_icon.dart';
import '../dialogs/loading_dialog.dart';
import '../dialogs/msg_dilog.dart';

class EditFoodPage extends StatefulWidget {
  final QueryDocumentSnapshot food;
  const EditFoodPage({Key? key, required this.food}) : super(key: key);

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  TextEditingController foodNameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<File?> _listFile = [null, null, null, null];
  List<String> _listUrl = ["", "", "", ""];
  String dropdownValue = 'Rice';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState((){
      foodNameController.text = this.widget.food["foodName"];
      priceController.text = this.widget.food["price"];
      descriptionController.text = this.widget.food["description"];
      dropdownValue = this.widget.food["category"];
      _listUrl = [this.widget.food["images"][0], this.widget.food["images"][1], this.widget.food["images"][2],
        this.widget.food["images"][3],];
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
                    foodNameController, "Food Name", TextInputType.text, false),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dropdownTextField(),
                    Container(
                        width: 200,
                        child: _textField(
                            priceController, "Food Price", TextInputType.number,
                            false)
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                _longTextField(descriptionController, "Description about food",
                    TextInputType.text, false),
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
                    context, "Edit Food", Colors.white, Colors.orange, () {
                  _updateFood();
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

  Widget _dropdownTextField() {
    return Container(
      height: 55,
      padding: EdgeInsets.only(left: 20.0, right: 20),
      decoration: BoxDecoration(
          color: Color.fromRGBO(142, 142, 147, 1.2),
          borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward, size: 16,),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 0,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>[
          'Rice',
          'Soup',
          'Noodle',
          'Cake',
          'Fast Food',
          'Fruit',
          'Dessert'
        ]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value, style: TextStyle(color: Colors.black, fontSize: 16),),
          );
        }).toList(),
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

  Widget _longTextField(TextEditingController textEditingController,
      String hintText, TextInputType textInputType, bool isPass) {
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
          "Edit your food",
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

  void _updateFood() async {
    String name = foodNameController.text.toString().trim();
    String price = priceController.text.toString().trim();
    String descr = descriptionController.text.toString().trim();

    if (name.isNotEmpty && price.isNotEmpty && descr.isNotEmpty) {
      if (_formkey.currentState!.validate()) {
        LoadingDialog.showLoadingDialog(context, "Editting...");
        await _uploadImages();
        await FirebaseFirestore.instance.collection("FOOD").doc(this.widget.food["idFood"].toString()).update({
          "foodName": name,
          "price": price,
          "category": dropdownValue,
          "description": descr,
          "images": _listUrl,
        }).then((value) =>
        {
          LoadingDialog.hideLoadingDialog(context),
          MsgDialog.showMsgDialog(
              context, "Edit Success", "Introduce foods for everyone to enjoy"),
        });
      }
    }
    else {
      MsgDialog.showMsgDialog(context, "Edit Failed",
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

        Reference ref = FirebaseStorage.instance.ref().child("FOOD").child(
            this.widget.food["idFood"].toString()).child("food_$filename");

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
        _listFile[nameFile] = File(pickedFile.path);
      });
    }
  }
}
