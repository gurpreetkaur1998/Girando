import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Helper extends GetConnect {
  // static const domain = "https://staging.girando.app";
  static const domain = "https://girando.app";
  static const urlBase = domain + "/restful.php?";
  static String authToken = "";
  static bool isLoggedIn = false;
  static bool isSocialLogin = false;

  @override
  void onInit() {}

  constructor() {
    print('timeout');
  }

  Future<Map<String, dynamic>> getData(String url) async {
    print(urlBase + url);
    httpClient.timeout = const Duration(seconds: 500);

    Response response = await httpClient.get(
      urlBase + url,
      contentType: 'application/json; charset=UTF-8',
      headers: {
        'Content-type': 'application/json',
      },
    );
    if (!response.status.hasError) {
      dynamic _result = jsonDecode(response.bodyString!);
      if (_result['data'] != null) {
        return _result;
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> postData(
      String url, Map<String, dynamic> params) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;
    String version = packageInfo.version;

    params['buildNumber'] = buildNumber;
    params['version'] = version;

    final form = FormData(params);
    print(params.toString());
    print(urlBase + url);
    Response res = await post(
      urlBase + url,
      form,
    );

    return res.body;
    return {};
  }

  Future<Map<String, dynamic>> postJson(
      String url, Map<String, dynamic> params) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;
    String version = packageInfo.version;

    params['buildNumber'] = buildNumber;
    params['version'] = version;

    final form = FormData(params);
    httpClient.timeout = const Duration(seconds: 500);
    try {
      print(params);
      print(urlBase + url);
      Response res = await httpClient.post(
        urlBase + url,
        body: params,
        contentType: 'application/json',
      );
      return res.body;
      // return {};
    } catch (e) {
      // error
      print("other error");
      print(e.toString());
      return {};
    }
  }

  showToast(String txt, {String? title}) {
    Get.rawSnackbar(
      titleText: title != null ? Text(title) : null,
      messageText: Text(
        txt,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      backgroundColor: Color(0xFFE12900),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  showInfo(String txt, {String? title}) {
    Get.rawSnackbar(
      titleText: title != null ? Text(title) : null,
      messageText: Text(
        txt,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  showToastWarning(String txt, {String? title}) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      titleText: title != null ? Text(title) : null,
      messageText: Text(
        txt,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      backgroundColor: Color(0xFF1B1B1B),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  showErrorToast(String txt, {String? title}) {
    Get.rawSnackbar(
      title: title,
      messageText: Text(
        txt,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      backgroundColor: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );
  }

  getLoggedInToken() {
    return authToken;
  }

  bool isUserLoggedIn() {
    return isLoggedIn;
  }

  logout() {
    authToken = "";
  }

  appbarStyle(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 23,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  appbar() {
    return AppBar();
  }
}

class MobileAds {}
