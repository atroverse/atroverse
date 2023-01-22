import 'dart:async';
import 'dart:developer';
import 'package:atroverse/Controllers/ExplorController.dart';
import 'package:atroverse/Controllers/ProfileController.dart';
import 'package:atroverse/Helpers/RequestHelper.dart';
import 'package:atroverse/Helpers/WidgetHelper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../Helpers/PrefHelpers.dart';
import 'AtroController.dart';
import 'FavoriteController.dart';
import 'HomeController.dart';

class SplashController extends GetxController {
  @override
  onInit() async {
    getAppUpdateInfo();

    super.onInit();
  }

  getAppUpdateInfo() {
    RequestHelper.getUpdateInfo().then((value) {
      if (value.statusCode == 200) {
        if (true != false) {
          showCupertinoModalBottomSheet(
              context: Get.context!,
              enableDrag: false,
              isDismissible: false,
              animationCurve: Curves.easeIn,
              builder: (_) {
                return Container(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/update.png',height: Get.height * .2,),
                      const SizedBox(height: 50,),
                      const Text(
                          'New version is available!!',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            height: 1.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          )),
                     const SizedBox(height: 20,),
                      WidgetHelper.softButton(
                          onTap: () {
                            Get.put(PushNotificationsController());
                            Future.delayed(const Duration(seconds: 2)).then(
                              (value) async {
                                if (await PrefHelpers.getToken() != null) {
                                  Get.put(HomeController());
                                  Get.put(ProfileController());
                                  Get.put(ExplorController());
                                  Get.put(FavoriteController());
                                  Get.put(AtroController());
                                  Get.offAllNamed("/main");
                                  FlutterNativeSplash.remove();
                                } else {
                                  Get.offAllNamed("/login");
                                  FlutterNativeSplash.remove();
                                }
                              },
                            );
                          },
                          title: "Update Atroverse")
                    ],
                  ),
                );
              });
        } else {
          Get.put(PushNotificationsController());
          Future.delayed(const Duration(seconds: 2)).then(
            (value) async {
              if (await PrefHelpers.getToken() != null) {
                Get.put(HomeController());
                Get.put(ProfileController());
                Get.put(ExplorController());
                Get.put(FavoriteController());
                Get.put(AtroController());
                Get.offAllNamed("/main");
                FlutterNativeSplash.remove();
              } else {
                Get.offAllNamed("/login");
                FlutterNativeSplash.remove();
              }
            },
          );
        }
      } else {}
    });
  }
}

class PushNotificationsController extends GetxController {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
      ledColor: Colors.blue,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  getNot() async {
    log('firebase start');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        Get.put(FavoriteController());
        print("back");
        print(message.notification!.body);
        print(message.collapseKey);
        print(message.data);
        print("back");
      },
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Get.put(FavoriteController());
        RemoteNotification? notification = message.notification;
        // AndroidNotification? android = message.notification?.android;
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            iOS: DarwinNotificationDetails(
                presentSound: true, presentBadge: true, presentAlert: true),
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    getNot();
    super.onInit();
  }
}
