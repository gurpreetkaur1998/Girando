import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static String appName = "1001 Yemek";

  //Colors for theme
//  Color(0xfffcfcff);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xffdb4b4b);
  static Color darkAccent = Colors.red[400]!;
  static Color lightBG = Color(0xfffcfcff);
  static Color greyBg = Color(0xffeaeaea);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600]!;
  static Color white = Colors.white;
  static Color backgroundColor = Color(0xFFFFFFFF);
  static Color colorBG = Color(0xff161616);
  static Color colorGrey = Color(0xFFe8e9ef);
  static Color colorWhite = Color(0xFFFFFFFF);
  static Color colorlightGrey = Color(0xFFECECEC);
  static Color colorRed = Color(0xFF8B2222);

  static Widget spaceHeight10 = getSizeByHeight(10.00);
  static Widget spaceHeight20 = getSizeByHeight(20.00);
  static Widget spaceHeight30 = getSizeByHeight(30.00);
  static Widget spaceHeight40 = getSizeByHeight(40.00);
  static Widget spaceHeight50 = getSizeByHeight(50.00);
  static Widget spaceWidth10 = getSizeByWidth(10.00);
  static Widget spaceWidth20 = getSizeByWidth(20.00);
  static Widget spaceWidth30 = getSizeByWidth(30.00);
  static Widget spaceWidth40 = getSizeByWidth(40.00);
  static Widget spaceWidth50 = getSizeByWidth(50.00);

  static Widget getSizeByHeight(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget getSizeByWidth(double height) {
    return SizedBox(
      width: height,
    );
  }

  static ThemeData lightTheme = ThemeData(
    backgroundColor: backgroundColor,
    primaryColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: GoogleFonts.lato().fontFamily,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 15),
      bodyText2: TextStyle(fontSize: 17),
      headline1: TextStyle(fontSize: 20),
      headline2: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
    textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent),
  );

  static Widget customButton(String txt, Function f, {color = Colors.black}) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 15),
      child: OutlinedButton(
        child: Text(
          txt.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: Size.fromHeight(40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.only(
            top: 3,
            bottom: 3,
          ),
          elevation: 1,
          primary: Colors.white,
          backgroundColor: color,
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
          shadowColor: Colors.grey.shade500,
        ),
        onPressed: () {
          f();
        },
      ),
    );
  }
}
