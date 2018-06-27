import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mlkit/mlkit.dart';
import 'package:snapshop/screens/item/NewItemScreen.dart';

class DetailScreen extends StatefulWidget {
  final Uint8List _image;
  final String _scannerType;

  DetailScreen(this._image, this._scannerType);

  @override
  State<StatefulWidget> createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen> {
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  FirebaseVisionBarcodeDetector barcodeDetector =
      FirebaseVisionBarcodeDetector.instance;
  Map<VisionText, bool> _currentTextLabels = new Map<VisionText, bool>();
  Map<VisionBarcode, bool> _currentBarcodeLabels =
      new Map<VisionBarcode, bool>();

  //List<VisionText> _currentTextLabels = <VisionText>[];
  //List<VisionBarcode> _currentBarcodeLabels = <VisionBarcode>[];

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 1000), () {
      this.analyzeLabels();
    });
  }

  void analyzeLabels() async {
    try {
      var currentLabels;
      if (widget._scannerType == TEXT_SCANNER) {
        List<VisionText> currentLabels =
            await textDetector.detectFromBinary(widget._image);
        setState(() {
          _currentTextLabels = Map.fromIterable(currentLabels,
              key: (item) => item, value: (_) => false);
        });
      } else {
        currentLabels = await barcodeDetector.detectFromBinary(widget._image);
        setState(() {
          _currentBarcodeLabels = currentLabels;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget._scannerType == TEXT_SCANNER
              ? 'Text Recognition'
              : 'Barcode Scanner'),
        ),
        body: Column(
          children: <Widget>[
            buildImage(context),
            buildTextList(_currentTextLabels),
            buildBottom(context)
//            widget._scannerType == TEXT_SCANNER
//                ? buildTextList(_currentTextLabels)
//                : buildBarcodeList(_currentBarcodeLabels)
          ],
        ));
  }

  Widget buildBottom(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: new RaisedButton(
              color: Theme.of(context).buttonColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: new Text(
                    "Done",
                    style: new TextStyle(
                        color: Theme.of(context).primaryTextTheme.button.color,
                        fontSize: 22.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: widget._image == null
                ? Text('No Image')
                : FutureBuilder<Size>(
                    future: _getImageSize(
                        Image.memory(widget._image, fit: BoxFit.fitWidth)),
                    builder:
                        (BuildContext context, AsyncSnapshot<Size> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            foregroundDecoration:
                                (widget._scannerType == TEXT_SCANNER)
                                    ? TextDetectDecoration(
                                        _currentTextLabels, snapshot.data)
                                    : BarcodeDetectDecoration(
                                        _currentBarcodeLabels, snapshot.data),
                            child: GestureDetector(
                                onTapDown: (details) {
                                  _currentTextLabels.forEach((text, value) {
                                    RenderBox getBox =
                                        context.findRenderObject();
                                    var offset =
                                        getBox.localToGlobal(Offset.zero);

                                    Size _originalImageSize = snapshot.data;
                                    Size configuration = getBox.size;

                                    final _heightRatio =
                                        _originalImageSize.height /
                                            configuration.height;
                                    final _widthRatio =
                                        _originalImageSize.width /
                                            configuration.width;

                                    final _rect = Rect.fromLTRB(
                                        offset.dx +
                                            text.rect.left / _widthRatio,
                                        offset.dy +
                                            text.rect.top / _heightRatio,
                                        offset.dx +
                                            text.rect.right / _widthRatio,
                                        offset.dy +
                                            text.rect.bottom / _heightRatio);

                                    if (_rect
                                        .contains(details.globalPosition)) {
                                      setState(() {
                                        print(_currentTextLabels[text]);
                                        if (_currentTextLabels[text]) {
                                          _currentTextLabels[text] = false;
                                        } else {
                                          _currentTextLabels[text] = true;
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Image.memory(widget._image,
                                    fit: BoxFit.fitWidth)));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
          )),
    );
  }

  Widget buildBarcodeList(Map<VisionBarcode, bool> barcodes) {
    if (barcodes.length == 0) {
      return Expanded(
        flex: 1,
        child: Center(
          child: Text('No barcode detected',
              style: Theme.of(context).textTheme.subhead),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: barcodes.length,
            itemBuilder: (context, i) {
              final barcodeElem = barcodes.entries.elementAt(i);
              var text = barcodeElem.key.rawValue;
              return _buildTextRow(barcodes, barcodeElem, text);
            }),
      ),
    );
  }

  Widget buildTextList(Map<VisionText, bool> texts) {
    if (texts.length == 0) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Text('No text detected',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: texts.length,
            itemBuilder: (context, i) {
              final textElem = texts.entries.elementAt(i);
              var text = textElem.key.text;
              return _buildTextRow(texts, textElem, text);
            }),
      ),
    );
  }

  Widget _buildTextRow(
      Map<dynamic, bool> items, MapEntry<dynamic, bool> item, String text) {
    return ListTile(
      leading: new Checkbox(
          value: items[item.key],
          onChanged: (value) {
            setState(() {
              items[item.key] = value;
            });
          }),
      title: Text(
        "$text",
        style: new TextStyle(fontSize: 22.0),
      ),
      dense: true,
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }
}

//******************************************************************************
// Decorator helpers
//******************************************************************************

/*
  This code uses the example from azihsoyn/flutter_mlkit
  https://github.com/azihsoyn/flutter_mlkit/blob/master/example/lib/main.dart
*/

class BarcodeDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final Map<VisionBarcode, bool> _barcodes;

  BarcodeDetectDecoration(
      Map<VisionBarcode, bool> barcodes, Size originalImageSize)
      : _barcodes = barcodes,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _BarcodeDetectPainter(_barcodes, _originalImageSize);
  }
}

class _BarcodeDetectPainter extends BoxPainter {
  final Map<VisionBarcode, bool> _barcodes;
  final Size _originalImageSize;
  _BarcodeDetectPainter(barcodes, originalImageSize)
      : _barcodes = barcodes,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;

    _barcodes.forEach((barcode, selected) {
      final _rect = Rect.fromLTRB(
          offset.dx + barcode.rect.left / _widthRatio,
          offset.dy + barcode.rect.top / _heightRatio,
          offset.dx + barcode.rect.right / _widthRatio,
          offset.dy + barcode.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    });
    canvas.restore();
  }
}

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final Map<VisionText, bool> _texts;
  TextDetectDecoration(Map<VisionText, bool> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _TextDetectPainter(_texts, _originalImageSize);
  }
}

class _TextDetectPainter extends BoxPainter {
  final Map<VisionText, bool> _texts;
  final Size _originalImageSize;
  _TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 1.0
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
    final paintSelected = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    _texts.forEach((text, selected) {
      final _rect = Rect.fromLTRB(
          offset.dx + text.rect.left / _widthRatio,
          offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio,
          offset.dy + text.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, selected ? paintSelected : paint);
    });
    canvas.restore();
  }
}
