import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String result = '';
  File? image;
  ImagePicker? imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  pickImageFromGallery() async {
    final pickedFile = await imagePicker!.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {
        performImageLabelling();
      });
    }
  }

  pickImageFromCamera() async {
    final pickedFile = await imagePicker!.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {
        performImageLabelling();
      });
    }
  }

  performImageLabelling() async {
    final inputImage = InputImage.fromFile(image!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    result = '';

    setState(() {
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          result += "${line.text} ";
        }
        result += "\n\n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(width: 100),
            Container(
              height: 280,
              width: 250,
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/note.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/pin.png',
                      height: 240,
                      width: 240,
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: pickImageFromGallery,
                      onLongPress: pickImageFromCamera,
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: image != null
                            ? Image.file(
                          image!,
                          width: 140,
                          height: 192,
                          fit: BoxFit.fill,
                        )
                            : SizedBox(
                          width: 240,
                          height: 200,
                          child: const Icon(
                            Icons.camera_enhance_sharp,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
