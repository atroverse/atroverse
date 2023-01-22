import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Our light/Primary Theme
ThemeData themeData() {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: ColorUtils.kPrimaryColor,
    accentColor: ColorUtils.kAccentLightColor,
    shadowColor: ColorUtils.kShadowColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      secondary: ColorUtils.kSecondaryLightColor,
    ),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: ColorUtils.kBodyTextColorLight),
    accentIconTheme: IconThemeData(color: ColorUtils.kAccentIconLightColor),
    primaryIconTheme: IconThemeData(color: ColorUtils.kPrimaryIconLightColor),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 21,
      ),
      headline3: TextStyle(
        color: Color.fromARGB(255, 234, 234, 234),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headline4: TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      headline5: TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      subtitle2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      headline6: TextStyle(
        fontSize: 40,
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

// Dark Them

AppBarTheme appBarTheme = const AppBarTheme(color: Colors.white, elevation: 0);


class ColorUtils{
  static MaterialColor kPrimaryColor = ColorUtil(0xFFFF97B3).toMaterial();
  static MaterialColor kShadowColor = ColorUtil(0xFFff5252).toMaterial();
  static MaterialColor kSecondaryLightColor = ColorUtil(0xFFE4E9F2).toMaterial();
  static MaterialColor kSecondaryDarkColor = ColorUtil(0xFF404040).toMaterial();
  static MaterialColor kAccentLightColor = ColorUtil(0xFFB3BFD7).toMaterial();
  static MaterialColor kAccentDarkColor = ColorUtil(0xFF4E4E4E).toMaterial();
  static MaterialColor kBackgroundDarkColor = ColorUtil(0xFF1B2430).toMaterial();
  static MaterialColor kSurfaceDarkColor = ColorUtil(0xFF222225).toMaterial();
// Icon Colors
  static MaterialColor kAccentIconLightColor = ColorUtil(0xFFECEFF5).toMaterial();
  static MaterialColor kAccentIconDarkColor = ColorUtil(0xFF303030).toMaterial();
  static MaterialColor kPrimaryIconLightColor = ColorUtil(0xFFECEFF5).toMaterial();
  static MaterialColor kPrimaryIconDarkColor = ColorUtil(0xFF232323).toMaterial();
// Text Colors
  static MaterialColor kBodyTextColorLight = ColorUtil(0xFFA1B0CA).toMaterial();
  static MaterialColor kBodyTextColorDark = ColorUtil(0xFF7C7C7C).toMaterial();
  static MaterialColor kTitleTextLightColor = ColorUtil(0xFF101112).toMaterial();
  static Color kTitleTextDarkColor = Colors.white;
}

class ColorUtil {
  late final Color color;

  ColorUtil([int? colorValue]) {
    if (colorValue is int) {
      color = Color(colorValue);
    }
  }

  MaterialColor toMaterial() {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  factory ColorUtil.fromColor(Color color) {
    return ColorUtil()..color = color;
  }
}