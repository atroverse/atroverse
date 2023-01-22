import 'package:atroverse/Screens/CommentScreen.dart';
import 'package:atroverse/Screens/ToDoApp/DB/category_model.dart';
import 'package:atroverse/Screens/ToDoApp/DB/notes_model.dart';
import 'package:atroverse/Screens/ToDoApp/TodoScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'Helpers/theme.dart';
import 'Screens/ArchiveScreen.dart';
import 'Screens/BlockListScreen.dart';
import 'Screens/EditProfileScreen.dart';
import 'Screens/MainScreen.dart';
import 'Screens/SavedScreen.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/loginScreen.dart';
import 'Screens/ticketScreen.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  try {
    await CategoryModel().createDb();
  } catch (e) {
    print(e);
  }
  try {
    await NotesModel().createDb();
  } catch (e) {
    print(e);
  }
  try {
    await CheckBoxModel().createDb();
  } catch (e) {
    print(e);
  }
  runApp(
    MediaQuery(
      data: const MediaQueryData(),
      child: Phoenix(
        child: GetMaterialApp(
          getPages: [
            GetPage(name: "/", page: () => SplashScreen()),
            GetPage(name: "/login", page: () => LoginScreen()),
            GetPage(name: "/commentScreen", page: () => CommentScreen()),
            GetPage(name: "/editProfile", page: () => EditProfileScreen()),
            GetPage(name: "/main", page: () => MainScreen()),
            GetPage(name: "/archive", page: () => ArchiveScreen()),
            GetPage(name: "/saved", page: () => SavedScreen()),
            GetPage(name: "/ticketing", page: () => TicketScreen()),
            GetPage(name: "/blockList", page: () => BlockListScreen()),
            // GetPage(name: "/createAtro", page: () => CreateAtroScreen()),
            // GetPage(name: "/addFavorite", page: () => AddFavoriteScreen()),
            // GetPage(name: "/createWill", page: () => WillCreateScreen()),
          ],
          theme: themeData(),
          defaultTransition: Transition.cupertino,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          // home: HomeScreen(),
          home: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                FlutterNativeSplash.remove();
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    connected == true ? SplashScreen() : TodoScreen(),
                    connected
                        ? Container()
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: Get.height * .05,
                              width: Get.width,
                              color: Colors.white,
                              child: const Center(
                                  child: Text(
                                "Offline",
                                style:
                                    TextStyle(color: Colors.black, fontSize: 14),
                              )),
                            ),
                          ),
                  ],
                );
              },
              child: Container()),
        ),
      ),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 60
    ..textColor = Colors.black
    ..radius = 20
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.white
    ..indicatorColor = Colors.black54
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[]
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid;
}
// AIzaSyBDF_zTCXI0pLShUNvxi04NoA3Jl5YKpPQ
//AIzaSyDRmAixUwmdiuzPOG_OnEmKtJwjdmVt0m0
