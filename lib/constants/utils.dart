import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/temp_image.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<TempImage>> pickImages() async {
  List<TempImage> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        Uint8List fileBytes = files.files[i].bytes!;
        String fileName = files.files[i].name;        
        images.add(TempImage(fileName, fileBytes));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future<TempImage?> pickProfileImages() async {
  TempImage? image;
  try {
    var results = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (results != null && results.files.isNotEmpty) {
      var bytes = results.files.single.bytes;
      var name = results.files.single.name;
      if (bytes != null){
        image = TempImage(name, bytes);
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return image;
}
