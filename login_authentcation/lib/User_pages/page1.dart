import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class PCOSDetectionPage extends StatefulWidget {
  @override
  _PCOSDetectionPageState createState() => _PCOSDetectionPageState();
}

class _PCOSDetectionPageState extends State<PCOSDetectionPage> {
  File? _image;
  Interpreter? _interpreter;
  String _result = "Upload an image to get a prediction";

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/best_pcos_model.tflite');
      print("✅ Model loaded successfully!");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      print("✅ Image selected: ${pickedFile.path}");
      setState(() {
        _image = File(pickedFile.path);
        _result = "Image selected. Press 'Get Prediction'";
      });
    } else {
      print("❌ No image selected");
    }
  }

  /// Convert image to 4D tensor for model input
  List<List<List<List<double>>>> convertImageToTensor(img.Image image) {
    return [
      List.generate(224, (y) {
        return List.generate(224, (x) {
          img.Pixel pixel = image.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        });
      })
    ];
  }

  Future<void> runModel() async {
    if (_image == null) {
      setState(() {
        _result = "⚠️ Please upload an image first!";
      });
      return;
    }

    if (_interpreter == null) {
      print("❌ Model is not loaded");
      setState(() {
        _result = "⚠️ Model not loaded!";
      });
      return;
    }

    try {
      // image as bytes
      Uint8List imageBytes = await _image!.readAsBytes();
      img.Image? imageInput = img.decodeImage(imageBytes);

      if (imageInput == null) {
        setState(() {
          _result = "⚠️ Failed to process the image.";
        });
        return;
      }
      img.Image resizedImage =
          img.copyResize(imageInput, width: 224, height: 224);

      List<List<List<List<double>>>> input = convertImageToTensor(resizedImage);
      var inputTensor = input
          .map((list) => list
              .map((row) => row
                  .map((pixel) =>
                      pixel.map((value) => value.toDouble()).toList())
                  .toList())
              .toList())
          .toList();

      // Fix output shape
      List<List<double>> output = List.generate(1, (_) => List.filled(1, 0.0));

      // Run inference
      _interpreter!.run(inputTensor, output);

      // Debug Output
      print("🔹 Model Output: $output");

      // Extract probability
      double probability = output[0][0];

      // Result
      setState(() {
        _result =
            probability > 0.5 ? "✅ No PCOS Detected " : "⚠️ PCOS Detected ";
      });

      print("✅ Final Result: $_result");
    } catch (e) {
      print("❌ Error running model: $e");
      setState(() {
        _result = "⚠️ Error processing image.";
      });
    }
  }

  void resetImage() {
    setState(() {
      _image = null;
      _result = "Upload an image to get a prediction";
    });
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade300, Colors.blue.shade600],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Image.asset('assets/prediction.png', fit: BoxFit.cover),
              ),
              SizedBox(height: 20),
              Text(
                _result,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: Icon(Icons.image),
                    label: Text("Gallery"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera),
                    label: Text("Camera"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: runModel,
                icon: Icon(Icons.search),
                label: Text("Get Prediction"),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: resetImage,
                icon: Icon(Icons.refresh),
                label: Text("Reset"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
