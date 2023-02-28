// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  _openGallary() async {
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
                  _openGallary();
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
        title: const Text("Leaf Disease Info"),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _decideImageView(),
              ElevatedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: const Text("Select Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
