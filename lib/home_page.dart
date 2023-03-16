import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaf_tech/details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  //final String _docType = "Rice Brown Spot";
  late String _docType;
  late List precaution, pesticides;
  bool loader = true;
  late var info = "";

  _fetchData() async {
    Random random = Random();
    int num = random.nextInt(2);
    (num == 0) ? _docType = "Leaf Smut" : _docType = "Rice Brown Spot";
    var tempInfo = "";
    List tempPrecaution = [], tempPesticides = [];
    var collection = FirebaseFirestore.instance
        .collection("Rice Leaf");
    var db = await collection.doc(_docType).get();
    if (db.exists) {
      Map<String, dynamic>? data = db.data();
      tempInfo = data?['Information'];
      tempPrecaution = data?['Precaution'];
      tempPesticides = data?['Pesticides'];
    }else{
      tempInfo = "No data";
      tempPrecaution = ["No data"];
      tempPesticides = ["No data"];
    }

    setState(() {
      info = tempInfo;
      precaution = tempPrecaution;
      pesticides = tempPesticides;
      loader = false;
      _showResult(context);
    });
  }

  _openGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imageTemp = File(image!.path);
    setState(() {
      _image = imageTemp;
    });
    Navigator.of(context).pop();
  }

  _openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    final imageTemp = File(image!.path);
    setState(() {
      _image = imageTemp;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showResult(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                              info: info,
                              precaution: precaution,
                              pesticides: pesticides,
                            )));
                  },
                  child: const Text("More Detail")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("close"))
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
            title: const Text("Result"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _decideImageView(),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text('Type: $_docType',style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.deepOrange),),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Make a choice"),
          content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text("Gallery"),
                    onTap: () {
                      _openGallery();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: const Text("Camera"),
                    onTap: () {
                      _openCamera();
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget _decideImageView() {
    if (_image == null) {
      return const Text("No Image to Display");
    } else {
      return Image.file(
        _image!,
        width: 200,
        height: 200,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: const Icon(Icons.energy_savings_leaf),
        title: const Text("Leaf Tech"),
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _decideImageView(),
              const SizedBox(height: 16.0,),
              (_image == null)
                  ? ElevatedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: const Text("Select Image"),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _fetchData();
                    },
                    child: const Text("Generate Result"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: const Text("Remove Image"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
