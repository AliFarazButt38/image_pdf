import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfw;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Image? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      final image = img.decodeImage(imageBytes)!;
      final imagePng = img.encodePng(image);
      final pdfImage = PdfImage.file(
        pdfDocument.document,
        bytes: imagePng,
      );
      final pdf = pdfw.Document();
      pdf.addPage(pdfw.Page(
        build: (context) {
          return pdfw.Center(
            child: pdfw.Image(pdfImage),
          );
        },
      ));
      final pdfBytes = await pdf.save();
      setState(() {
        _image = Image.memory(pdfBytes.buffer.asUint8List());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) ...[
              _image!,
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select an image'),
            ),
          ],
        ),
      ),
    );
  }

  final pdfDocument = PdfDocument();
}
