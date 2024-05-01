import 'package:flutter/material.dart';

class TColor{
  static Color get primaryColor1 => const Color(0xff1331c7);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get secondaryColor1 => const Color(0xff162760);
  static Color get secondaryColor2 => const Color(0xff1abb6a);


  static List<Color> get primaryG => [ primaryColor2, primaryColor1 ];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xffDDDADA);
  static Color get darkgray => const Color(0xff232325);
  static Color get darkgray1 => const Color(0xffffffff);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
}