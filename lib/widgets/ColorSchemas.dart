import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';

class ColorSchemas {
  static final Peach = const Color(0xFFFFA69E);
  static final Pink = const Color(0xFFFE737A);
  static final Lilac = const Color(0xFF7970C2);
  static final Green = const Color(0xFF3E9FA7);
  static final Blue = const Color(0xFF3DA3F4);
  static final Turquise = const Color(0xFF04B5D5);

  static final FadedWhite = const Color(0xFFEEEEF9);
  static final FadedBlack = const Color(0xFF808085);

  static Color getColor() {
    return _colors[Random().nextInt(_colors.length)];
  }

  static final List<Color> _colors = [Peach, Pink, Lilac, Green, Blue, Turquise];
}

enum ContrastPreference {
  none,
  light,
  dark,
}

class ColorHelper {
  static int fromHexString(String argbHexString) {
    String useString = argbHexString;
    if (useString.startsWith("#")) {
      useString = useString.substring(1); // trim the starting '#'
    }
    if (useString.length < 8) {
      useString = "FF" + useString;
    }
    if (!useString.startsWith("0x")) {
      useString = "0x" + useString;
    }
    return int.parse(useString);
  }

  static final double _kMinContrastModifierRange = 0.35;
  static final double _kMaxContrastModifierRange = 0.65;

  /// Returns black or white depending on whether the source color is darker
  /// or lighter. If darker, will return white. If lighter, will return
  /// black. If the color is within 35-65% of the spectrum and a prefer
  /// value is specified, then white or black will be preferred.
  static Color blackOrWhiteContrastColor(Color sourceColor,
      {ContrastPreference prefer = ContrastPreference.none}) {
    // Will return a value between 0.0 (black) and 1.0 (white)
    double value =
        (((sourceColor.red * 299.0) + (sourceColor.green * 587.0) + (sourceColor.blue * 114.0)) /
                1000.0) /
            255.0;
    if (prefer != ContrastPreference.none) {
      if (value >= _kMinContrastModifierRange && value <= _kMaxContrastModifierRange) {
        return prefer == ContrastPreference.light ? Color(0xFFFFFFFF) : Color(0xFF000000);
      }
    }
    return value > 0.6 ? Color(0xFF000000) : Color(0xFFFFFFFF);
  }

  static Color getColorFromAnyString(String data) {
    List<int> content = Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    HSLColor _color =
        HSLColor.fromColor(Color(int.parse("0xFFF${hex.encode(digest.bytes).substring(0, 5)}")))
            .withSaturation(0.7)
            .withLightness(0.47);
    //.withHue(hash(data, 360).toDouble());

    //return _color.toColor();
    return _color
        .withHue((_color.hue + hash(data, 360).toDouble()) % 360)
        .withLightness(0.55)
        .toColor();
  }

  static int hash(String s, int tableSize) {
    int sum = 0;
    for (int i = 0; i < s.length; i++)
      sum += s.codeUnitAt(i) * 71; //<- * 3 being my salt to the hash

    return sum % tableSize;
  }
}
