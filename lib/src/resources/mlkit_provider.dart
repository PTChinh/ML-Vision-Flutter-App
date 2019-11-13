import 'dart:io';
import 'dart:async';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MLkitProvider {
  FirebaseVision firebaseVision = FirebaseVision.instance;

  Future<String> getImage(var image) async {
    File _image = image;
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
    final TextRecognizer textRecognizer = firebaseVision.textRecognizer();
    final VisionText visionText = await textRecognizer.detectInImage(visionImage);
    String detectedText = visionText.text;

    return detectedText;
  }

}