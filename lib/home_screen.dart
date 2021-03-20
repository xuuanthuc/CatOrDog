import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  File _images;

  List _outPut;

  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _outPut = output;
      _isLoading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      _images = File(image.path);
    });
    classifyImage(_images);
  }

  takeImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    setState(() {
      _images = File(image.path);
    });
    classifyImage(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Detect Dogs or Cats',
                style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: _isLoading
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: double.infinity,
                            child: Image.asset('assets/images/dogcat.png'),
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  child: Image.file(_images),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _outPut != null
                                  ? Text(
                                      'This is a ${_outPut[0]['label']}',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  : Container(
                                      child: Text('Đây chả là con gì cả :D'),
                                    ),
                            ],
                          ),
                        ),
                ),
              ),
              GestureDetector(
                onTap: () => takeImage(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amberAccent),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 15),
                    child: Text(
                      'Take a photo',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => pickImage(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amberAccent),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 15),
                    child: Text(
                      'Camera Roll',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
