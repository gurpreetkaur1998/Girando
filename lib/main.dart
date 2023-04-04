import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/widgets/cartDetails.dart';
import 'package:girando/widgets/categories.dart';
import 'package:girando/widgets/failed.dart';
import 'package:girando/widgets/forgot.dart';
import 'package:girando/widgets/help.dart';
import 'package:girando/widgets/login.dart';
import 'package:girando/widgets/main_screen.dart';
import 'package:girando/widgets/orderComplete.dart';
import 'package:girando/widgets/orderDetail.dart';
import 'package:girando/widgets/orderHold.dart';
import 'package:girando/widgets/orderModified.dart';
import 'package:girando/widgets/orderStatusChanged.dart';
import 'package:girando/widgets/orders.dart';
import 'package:girando/widgets/productDetail.dart';
import 'package:girando/widgets/productList.dart';
import 'package:girando/widgets/profile.dart';
import 'package:girando/widgets/welcome.dart';
import 'utils/const.dart';
import 'widgets/register.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  await GetStorage.init();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarBrightness:
          Brightness.dark // Dark == white status bar -- for IOS.
      ));

  OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);

  OneSignal.shared.setAppId("232e403f-1afa-4982-b9da-c9b1b2577651");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthController auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    // storage.remove('user');
    var user = storage.read('user');
    if (user != null) {
      print("---");
      auth.getSavedUser();
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.lightTheme,
      builder: EasyLoading.init(),
      defaultTransition: Transition.fadeIn,
      home: AnimatedSplashScreen(
        duration: 100,
        splash: SizedBox(
          height: 400,
          child: Image.asset(
            'assets/images/logo.png',
            height: 500,
          ),
        ),
        nextScreen: (user == null) ? WelcomeScreen() : MainScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Color(0xFFFFFFFF),
      ),
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/welcome',
          page: () => WelcomeScreen(),
        ),
        GetPage(
          name: '/main',
          page: () => MainScreen(),
        ),
        GetPage(
          name: '/cart',
          page: () => CartDetail(),
        ),
        GetPage(
          name: '/help',
          page: () => HelpScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
        ),
        GetPage(
          name: '/categories',
          page: () => Categories(),
        ),
        GetPage(
          name: '/orderFailed',
          page: () => OrderFailed(),
        ),
        GetPage(
          name: '/productList',
          page: () => ProductScreen(),
        ),
        GetPage(
          name: '/orderScreen',
          page: () => OrderScreen(),
        ),
        GetPage(
          name: '/orderDetailScreen',
          page: () => OrderDetail(),
        ),
        GetPage(
          name: '/OrderHold',
          page: () => OrderHold(),
        ),
        GetPage(
          name: '/profile',
          page: () => Profile(),
        ),
        GetPage(
          name: '/forgot',
          page: () => ForgotScreen(),
        ),
        GetPage(
          name: '/orderComplete',
          page: () => OrderComplete(),
        ),
        GetPage(
          name: '/orderStatusChanged',
          page: () => OrderStatusChanged(),
        ),
        GetPage(
          name: '/productDetail',
          page: () => ProductDetail(),
        ),
        GetPage(
          name: '/orderModified',
          page: () => OrderModified(),
        ),
      ],
    );
  }
}
