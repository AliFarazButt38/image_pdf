import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator extends StatefulWidget {
  @override
  _PdfGeneratorState createState() => _PdfGeneratorState();
}

class _PdfGeneratorState extends State<PdfGenerator> {
  Future<void> _saveAsPdf() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String documentPath = directory.path;

    File imageFile = File('assets/images/screenshot.png');

    final pdf = pw.Document();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
          child: pw.Image(pw.MemoryImage(imageFile.readAsBytesSync())));
    }));

    File pdfFile = File('$documentPath/pdf.pdf');
    await pdfFile.writeAsBytes(await pdf.save());


    if (await pdfFile.exists()) {
      print('PDF file created successfully!');
    } else {
      print('PDF file creation failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _saveAsPdf,
          child: Text('Save as PDF'),
        ),
      ),
    );
  }
}
