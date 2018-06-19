import 'package:flutter/material.dart';
import 'package:snapshop/screens/shoppinglists/ShoppingListsScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: buildDarkTheme(),
      home: new ShoppingListsScreen(title: 'SnapShop'),
    );
  }
}

/*
primarySwatch: Colors.red,
        backgroundColor: Colors.grey.shade900,
 */
//const kBlackHalf = const Color(0xFF212121);
//const kBlackLight = const Color(0xFF484848);
//const kBlack = const Color(0xFF000000);
//const kYellow = const Color(0xFFffd600);
//const kYellowLight = const Color(0xFFffff52);
//const kYellowDark = const Color(0xFFc7a500);
//const kWhite = Colors.white;

const kShrinePink50 = const Color(0xFFFEEAE6);
const kShrinePink100 = const Color(0xFFFEDBD0);
const kShrinePink300 = const Color(0xFFFBB8AC);

const kShrineBrown900 = const Color(0xFF442B2D);

const kShrineErrorRed = const Color(0xFFC5032B);

const kShrineTextOnAccent = const Color(0xFF282828);
const kShrineTextOnAccentLighter = const Color(0xFF383838);
const kShrineSurfaceWhite = const Color(0xFFFFFBFA);

const kShrineBackgroundWhite = Colors.white;
//const kShrineBackground = const Color(0xFF787878);
const kShrineBackground = const Color(0xFF383838);

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrinePink100,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink300,
    //scaffoldBackgroundColor: kShrineBackgroundWhite,
    scaffoldBackgroundColor: kShrineBackground,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,

    accentTextTheme: buildTextTheme(base.textTheme, kShrineTextOnAccent),
    primaryTextTheme:
        buildTextTheme(base.primaryTextTheme, kShrineTextOnAccent),
    primaryIconTheme: base.iconTheme.copyWith(color: kShrineTextOnAccent),

    iconTheme: buildIconTheme(base.iconTheme, kShrinePink300),
    accentIconTheme: buildIconTheme(base.iconTheme, kShrineTextOnAccent),

    errorColor: kShrineErrorRed,

    hintColor: kShrinePink300,

    //TODO: Add the text themes (103)
    //TODO: Add the icon themes (103)
    //TODO: Decorate the inputs (103)

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0))),
      labelStyle: TextStyle(color: kShrinePink300, fontSize: 20.0),
      hintStyle: TextStyle(color: kShrinePink300),
    ),
  );
}

TextTheme buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    body1: base.headline.copyWith(color: color, fontSize: 16.0),
    caption: base.headline.copyWith(color: color),
    display1: base.headline.copyWith(color: color),
    button: base.headline.copyWith(color: color),
    headline: base.headline.copyWith(color: color),
    title: base.title.copyWith(color: color),
  );
}

IconThemeData buildIconTheme(IconThemeData base, Color color) {
  return IconThemeData(color: color);
}
