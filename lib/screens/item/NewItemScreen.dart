import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshop/data/ShoppingItem.dart';
import 'package:snapshop/main.dart';
import 'package:snapshop/screens/item/DetailsScreen.dart';
import 'package:snapshop/util/ui.dart';
import 'package:snapshop/widgets/ColorSchemas.dart';
import 'package:snapshop/widgets/SpecialDialog.dart';
import 'package:snapshop/widgets/SpecialShadow.dart';

const String TEXT_SCANNER = 'TEXT_SCANNER';
const String BARCODE_SCANNER = 'BARCODE_SCANNER';

class NewItemScreen extends StatefulWidget {
  NewItemScreen({Key key, this.item, this.items, this.baseColor = Colors.deepPurpleAccent})
      : super(key: key);

  final Color baseColor;
  final ShoppingItem item;
  final List<ShoppingItem> items;

  @override
  State<StatefulWidget> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //File _file;
  String _selectedScanner = TEXT_SCANNER;

  ui.Image _image;
  String _title;
  //String _description;
  double _count;
  double _price;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _title = widget.item.name;
      _price = widget.item.price;
      _count = widget.item.count;
      _image = widget.item.image;
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (widget.item != null) {
        widget.item.name = _title;
        widget.item.price = _price;
        widget.item.count = _count;
        widget.item.image = _image;
        widget.item.created = DateTime.now();
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        widget.item != null ? 'Edit Item' : 'New Item',
        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () async {
            ByteData _byteData = await _image.toByteData(format: ui.ImageByteFormat.png);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(_byteData.buffer.asUint8List(), _selectedScanner)),
            );
          },
          child: Icon(
            Icons.refresh,
            size: 32.0,
          ),
        ),
        const SizedBox(
          width: 10.0,
        )
      ],
    );
    return Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  _image != null
                      ? RawImage(image: _image)
                      : Align(
                          alignment: Alignment.centerRight,
                          child: SpecialShadowWidget(
                            color: Colors.white,
                            shadowColor: Colors.grey,
                            child: GestureDetector(
                              onTap: () async {
//                                Image data =
//                                    await Navigator.of(context).push(new MaterialPageRoute<Image>(
//                                        builder: (BuildContext context) {
//                                          return new Dialog();
//                                        },
//                                        fullscreenDialog: true));
//
//                                setState(() {
//                                  print("Done");
//                                });
                                switch (await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SpecialAlertDialog(
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Text("ARE YOU SURE?",
                                                  style: TextStyle(
                                                      color: Colors.red.shade700, fontSize: 20.0)),
                                              SizedBox(height: 20.0),
                                              Text(
                                                  "Do you want to continue to exit from the application?",
                                                  textAlign: TextAlign.center),
                                              SizedBox(height: 20.0),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context, 'A');
                                                      },
                                                      child: const Icon(Icons.close),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context, 'B');
                                                      },
                                                      child: Icon(Icons.check,
                                                          color: Colors.red.shade200),
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      );
                                    })) {
                                  case 'A':
                                    // Let's go.
                                    // ...
                                    print("A");
                                    break;
                                  case 'B':
                                    // ...
                                    print("B");
                                    break;
                                }
                              },
                              onLongPress: () {},
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: widget.baseColor.withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                                  width: 200.0,
                                  height: 200.0,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.0),
                                    child: Icon(
                                      Icons.photo_camera,
                                      size: 75.0,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                  SizedBox(height: 10.0),
                  SpecialShadowWidget(
                    color: Colors.white,
                    shadowColor: Colors.grey,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 35.0, right: 35.0, top: 10.0, bottom: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: TextFormField(
                              onSaved: (val) => _title = val,
                              initialValue: widget.item != null ? widget.item.name : null,
                              validator: (val) => val.isNotEmpty ? null : "Title must not be empty",
                              style:
                                  TextStyle(fontSize: 22.0, color: Theme.of(context).primaryColor),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Title',
                                contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
                                labelStyle: TextStyle(
                                    fontFamily: "Arial",
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22.0),
                                //prefixIcon: Icon(Icons.title,
                                //    color: Theme.of(context).buttonColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: TextFormField(
                                    onSaved: (val) => _price = double.parse(val),
                                    initialValue:
                                        widget.item != null ? widget.item.price.toString() : null,
                                    validator: (val) =>
                                        val.isNotEmpty ? null : "Price must not be empty",
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                    ],
                                    style: new TextStyle(
                                        fontFamily: 'StTransmission',
                                        fontSize: 22.0,
                                        color: Theme.of(context).primaryColor,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900),
                                    decoration: InputDecoration(
                                      border: Theme.of(context).inputDecorationTheme.border,
                                      labelText: 'Price',
                                      labelStyle: TextStyle(
                                          fontFamily: "Arial",
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22.0),
                                      contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
                                      icon: Icon(Icons.attach_money,
                                          color: Theme.of(context).buttonColor),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_count > 0.0) _count -= 1.0;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 3.0),
                                          child: Container(
                                            decoration: new BoxDecoration(
                                              shape: BoxShape
                                                  .circle, // You can use like this way or like the below line
                                              boxShadow: [
                                                new BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                    offset: Offset(1.3, 1.3)),
                                              ],
                                              //borderRadius: new BorderRadius.circular(30.0),
                                              color: kShrinePink100,
                                            ),
                                            child: Icon(Icons.remove,
                                                color: Theme.of(context).primaryColor, size: 30.0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 7.0),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Container(
                                          width: 60.0,
                                          child: Center(
                                            child: Text(
                                              _count.round().toString() + "x",
                                              style: new TextStyle(
                                                  fontFamily: 'StTransmission',
                                                  fontSize: 28.0,
                                                  color: Theme.of(context).primaryColor,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 7.0),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (_count < 999.0) _count += 1.0;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 3.0),
                                          child: Container(
                                            decoration: new BoxDecoration(
                                              shape: BoxShape
                                                  .circle, // You can use like this way or like the below line
                                              boxShadow: [
                                                new BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2.0,
                                                    offset: Offset(1.3, 1.3)),
                                              ],
                                              //borderRadius: new BorderRadius.circular(30.0),
                                              color: kShrinePink100,
                                            ),
                                            child: Icon(Icons.add,
                                                color: Theme.of(context).primaryColor, size: 30.0),
                                          ),
                                        ),
                                      ),
                                    ]),
                              )),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: TextFormField(
                              //onSaved: (val) => _description = val,
                              style:
                                  TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
                              //keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: Theme.of(context).inputDecorationTheme.border,
                                labelText: 'Descriptions',
                                contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
                                labelStyle: TextStyle(
                                    fontFamily: "Arial",
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22.0),
                                //prefixIcon: Icon(Icons.description,
                                //    color: Theme.of(context).buttonColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SpecialShadowWidget(
                    color: ColorSchemas.Lilac,
                    shiny: true,
                    child: GestureDetector(
                      onTap: () {
                        _submit();
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                              child: Text(
                            "SAVE",
                            style: TextStyle(fontSize: 18.0, color: ColorSchemas.FadedWhite),
                          )),
                        ),
                        width: double.infinity,
                      ),
                    ),
                    radius: 50.0,
                  )
                  //buildSelectImageColumnWidget(context),
                  //buildBottom(context),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: buildCandyButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Save",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.grey.shade900.withOpacity(0.95)),
              ),
            ),
          ),
          color: kShrinePink200, //Color(0xFFddf8ff),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50.0),
          candify: false,
          onTap: () {
            print("test");
          }),
    );
  }

  Widget buildRowTitle(BuildContext context, String title) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  Widget buildSelectImageColumnWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: RaisedButton(
              color: Theme.of(context).buttonColor,
              //textColor: Colors.white,
              //splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelected(CAMERA_SOURCE);
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Scan with Camera',
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              )),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: RaisedButton(
              color: Theme.of(context).buttonColor,
              //textColor: Colors.white,
              //splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelected(GALLERY_SOURCE);
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Choose from Gallery',
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              )),
        ))
      ],
    );
  }

  Widget buildSelectScannerRowWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: RadioListTile<String>(
          title: Text('Text Recognition'),
          groupValue: _selectedScanner,
          value: TEXT_SCANNER,
          onChanged: onScannerSelected,
        )),
        Expanded(
          child: RadioListTile<String>(
            title: Text('Barcode Scanner'),
            groupValue: _selectedScanner,
            value: BARCODE_SCANNER,
            onChanged: onScannerSelected,
          ),
        )
      ],
    );
  }

//  Widget buildImageRow(BuildContext context, File file) {
//    return SizedBox(
//        height: 500.0,
//        child: Image.file(
//          file,
//          fit: BoxFit.fitWidth,
//        ));
//  }

//  Widget buildDeleteRow(BuildContext context) {
//    return Center(
//      child: Padding(
//        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//        child: RaisedButton(
//            color: Colors.red,
//            textColor: Colors.white,
//            onPressed: () {
//              setState(() {
//                _file = null;
//              });
//            },
//            child: Text('Delete Image')),
//      ),
//    );
//  }

  void onScannerSelected(String scanner) {
    setState(() {
      _selectedScanner = scanner;
    });
  }

  void onPickImageSelected(String source) async {
    var imageSource;
    if (source == CAMERA_SOURCE) {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    try {
      //File file = await ImagePicker.pickImage(source: imageSource);
      var file = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600.0);
      if (file == null) {
        throw Exception('File is not available');
      }

      //_image = Image.file(file);
      final ui.Codec codec = await ui.instantiateImageCodec(file.readAsBytesSync());
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      _image = frameInfo.image;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(file.readAsBytesSync(), _selectedScanner)),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  showModalDialog(BuildContext context) {
//    showModalBottomSheet(
//        context: context,
//        builder: (context) {
//          return Card(
//            color: Colors.grey.withOpacity(1.0),
//            child: Column(
//              children: <Widget>[
//                RaisedButton(
//                  color: Theme.of(context).buttonColor,
//                  onPressed: () {
//                    onPickImageSelected(GALLERY_SOURCE);
//                  },
//                  child: Padding(
//                    padding: EdgeInsets.symmetric(vertical: 15.0),
//                    child: Icon(
//                      Icons.image,
//                      color: Theme.of(context).primaryTextTheme.button.color,
//                    ),
//                  ),
//                ),
//                const SizedBox(height: 8.0)
//              ],
//            ),
//          );
//        });
  }
}
