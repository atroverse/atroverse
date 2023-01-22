import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'Prefs.dart';
import 'ViewHelpers.dart';

class PrefHelpers {
  static Future<void> setToken(String token) async {
    await Prefs.set('token', token);
  }

  static Future<String?> getToken() async {
    return await (Prefs.get('token'));
  }

  static removeToken() async {
    return await Prefs.clear('token');
  }

  static Future<void> setMute(String mute) async {
    await Prefs.set('mute', mute);
  }

  static Future<String?> getMute() async {
    return await (Prefs.get('mute'));
  }

  static removeMute() async {
    return await Prefs.clear('mute');
  }

  static Future<void> setCity(String city) async {
    await Prefs.set('city', city);
  }

  static Future<String?> getCity() async {
    return await (Prefs.get('city'));
  }

  static removeCity() async {
    return await Prefs.clear("city");
  }

  static Future<void> setCity2(String city) async {
    await Prefs.set('city2', city);
  }

  static Future<String?> getCity2() async {
    return await (Prefs.get('city2'));
  }

  static removeCity2() async {
    return await Prefs.clear("city2");
  }

  static void logOut() {
    removeToken();
    ViewHelper.showLoading();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      EasyLoading.dismiss();
      Get.offAllNamed("/login");
    });
  }
}
