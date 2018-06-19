import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshop/data/ShoppingItem.dart';
import 'package:snapshop/main.dart';
import 'package:snapshop/screens/item/DetailsScreen.dart';
import 'package:snapshop/util/path.dart';

const String TEXT_SCANNER = 'TEXT_SCANNER';
const String BARCODE_SCANNER = 'BARCODE_SCANNER';

class NewItemScreen extends StatefulWidget {
  NewItemScreen({Key key, this.item, this.items}) : super(key: key);

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

  Image _image;
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
      centerTitle: true,
      title: Text(
        widget.item != null ? 'Edit Item' : 'New Item',
        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () async {
            File _file = await fileFromImage(_image);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(_file, _selectedScanner)),
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Card(
                      child: _image != null
                          ? _image
                          : Container(
                              color: kShrinePink50,
                              width: double.infinity,
                              child: Column(children: <Widget>[
                                const SizedBox(height: 20.0),
                                Text(
                                  "Image",
                                  style: TextStyle(fontSize: 22.0),
                                ),
                                const SizedBox(height: 18.0),
                                RaisedButton(
                                  color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    showModalDialog(context);
                                    //onPickImageSelected(CAMERA_SOURCE);
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Theme
                                          .of(context)
                                          .primaryTextTheme
                                          .button
                                          .color,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text("or"),
                                const SizedBox(height: 8.0),
                                RaisedButton(
                                  color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    onPickImageSelected(GALLERY_SOURCE);
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    child: Icon(
                                      Icons.image,
                                      color: Theme
                                          .of(context)
                                          .primaryTextTheme
                                          .button
                                          .color,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                              ]))),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                    child: TextFormField(
                      onSaved: (val) => _title = val,
                      initialValue:
                          widget.item != null ? widget.item.name : null,
                      validator: (val) =>
                          val.isNotEmpty ? null : "Title must not be empty",
                      style: TextStyle(
                          fontSize: 22.0, color: Theme.of(context).buttonColor),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(25.0, 25.0, 15.0, 10.0),
                        labelText: 'Title',
                        //prefixIcon: Icon(Icons.title,
                        //    color: Theme.of(context).buttonColor),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 4.0),
                          child: TextFormField(
                            onSaved: (val) => _price = double.parse(val),
                            initialValue: widget.item != null
                                ? widget.item.price.toString()
                                : null,
                            validator: (val) => val.isNotEmpty
                                ? null
                                : "Price must not be empty",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            style: new TextStyle(
                                fontFamily: 'StTransmission',
                                fontSize: 22.0,
                                color: Theme.of(context).buttonColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 0.0, top: 35.0),
                              border: OutlineInputBorder(),
                              labelText: 'Price',
                              labelStyle: TextStyle(
                                  fontFamily: "Arial",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22.0),
                              prefixIcon: Icon(Icons.attach_money,
                                  color: Theme.of(context).buttonColor),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 4.0),
                          child: TextFormField(
                            onSaved: (val) => _count = double.parse(val),
                            initialValue: widget.item != null
                                ? widget.item.count.toString()
                                : "1.0",
                            validator: (val) => val.isNotEmpty
                                ? null
                                : "Count must not be empty",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            style: new TextStyle(
                                fontFamily: 'StTransmission',
                                fontSize: 22.0,
                                color: Theme.of(context).buttonColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 0.0, top: 35.0),
                              border: OutlineInputBorder(),
                              labelText: 'Count',
                              labelStyle: TextStyle(
                                  fontFamily: "Arial",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22.0),
                              prefixIcon: Icon(Icons.unfold_more,
                                  color: Theme.of(context).buttonColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                    child: TextFormField(
                      //onSaved: (val) => _description = val,
                      style: TextStyle(
                          fontSize: 18.0, color: Theme.of(context).buttonColor),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(25.0, 25.0, 15.0, 10.0),
                        border: OutlineInputBorder(),
                        labelText: 'Descriptions',
                        //prefixIcon: Icon(Icons.description,
                        //    color: Theme.of(context).buttonColor),
                      ),
                    ),
                  ),
                  //buildSelectImageColumnWidget(context),
                  buildBottom(context),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildBottom(BuildContext context) {
    RaisedButton doneButton = RaisedButton(
      color: Theme.of(context).buttonColor,
      onPressed: () => _submit(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.save,
                size: 35.0,
                color: Theme.of(context).primaryTextTheme.button.color),
            const SizedBox(width: 10.0),
            Text(
              "Done",
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.button.color,
                  fontSize: 28.0),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: doneButton,
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
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
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
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
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

  Widget buildImageRow(BuildContext context, File file) {
    return SizedBox(
        height: 500.0,
        child: Image.file(
          file,
          fit: BoxFit.fitWidth,
        ));
  }

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
      final File file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('File is not available');
      }

      _image = Image.file(file);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(file, _selectedScanner)),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  showModalDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Card(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                    onPickImageSelected(GALLERY_SOURCE);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Icon(
                      Icons.image,
                      color: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0)
              ],
            ),
          );
        });
  }
}
