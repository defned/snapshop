import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<String> get _tempPath async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get getTemporaryFile async {
  final path = await _tempPath;
  return new File('$path/${Uuid().v4()}');
}

Future<File> fileFromImage(Image image) async {
  RenderRepaintBoundary s = image.createElement().renderObject;
  ui.Image rawImage = await s.toImage();

  final ByteData byteData = await rawImage.toByteData();
  final Uint8List byteDataList = byteData.buffer.asUint8List();

  // Write the file
  final file = await getTemporaryFile;
  file.writeAsBytesSync(byteDataList);

  return file;
}
