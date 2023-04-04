import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:girando/models/User.dart';
import 'package:girando/utils/helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/verification.dart';

class AuthController extends GetxController {
  final count = 0.obs;
  RxBool isLoggedIn = false.obs;
  Helper hlp = Helper();
  RxString authToken = "".obs;
  final storage = GetStorage();

  Rx<User> loggedInUser = User().obs;

  Future<void> loginUser(
      String Username, String Password, String one_signal_id) async {
    Map<String, dynamic> params = {
      "email": Username,
      "password": Password,
      "one_signal_id": one_signal_id
    };
    EasyLoading.show();
    if (kDebugMode) {
      print(params);
    }
    Map<String, dynamic> loginData = await hlp.postData("f=loginUser", params);

    if (loginData['err'] == "1") {
      Map data = loginData['data'];
      hlp.showErrorToast(data['msg']);
    } else {
      User u = User.fromJson(loginData['data']);
      print(u.isUserActivated);
      if (u.isUserActivated == "no") {
        hlp.showErrorToast("Your account is not activated");
        EasyLoading.dismiss();

        return;
      }

      isLoggedIn.value = true;
      loggedInUser.value = u;
      storage.write('user', loginData['data']);
      update();
      Get.offAndToNamed("/main");
    }
    EasyLoading.dismiss();
  }

  getSavedUser() {
    dynamic _user = storage.read('user');
    // print(_user.runtimeType);
    if (_user != null) {
      User u = User.fromJson(_user);
      isLoggedIn.value = true;
      loggedInUser.value = u;
    }
  }

  logout() {
    hlp.logout();
    isLoggedIn.value = false;
    storage.remove('user');

    update();
    Get.offAndToNamed("/welcome");
  }

  Future<void> registerUser(Map<String, dynamic> params) async {
    EasyLoading.show();

    Map<String, dynamic> regData = await hlp.postData("f=registerUser", params);

    if (regData['err'] == "1") {
      Map data = regData['data'];
      hlp.showErrorToast(data['error']);
    } else {
      Get.off(VerificationScreen());
    }
    EasyLoading.dismiss();
  }

  Future<void> updateProfile(Map<String, dynamic> params) async {
    EasyLoading.show();

    Map<String, dynamic> regData =
        await hlp.postData("f=updateUserProfile", params);
    print(regData);
    if (regData['err'] == "1") {
      Map data = regData['data'];
      hlp.showErrorToast(data['error']);
    } else {
      User u = User.fromJson(regData['data']);
      isLoggedIn.value = true;
      loggedInUser.value = u;
      storage.write('user', u);
      update();
      Get.offAndToNamed("/main");
    }
    EasyLoading.dismiss();
  }

  Future<void> changePassword(newPassword) async {
    Map<String, dynamic> params = {
      "user_id": loggedInUser.value.ID,
      "password": newPassword
    };
    EasyLoading.show();

    Map<String, dynamic> loginData =
        await hlp.postData("user/change_password", params);
    print(loginData);
    if (loginData['error'] == "-1") {
      hlp.showErrorToast(loginData['message']);
    } else {
      // loggedInUser.value = newPassword;
      User u = loggedInUser.value;
      isLoggedIn.value = true;
      loggedInUser.value = u;
      storage.write('user', u);
      update();
      Helper().showToast("Password updated successfully");
    }
  }

  Future<void> forgotPassword(email) async {
    Map<String, dynamic> params = {
      "email": email,
    };
    EasyLoading.show();
    Map<String, dynamic> loginData =
        await hlp.postData("f=forgotPassword", params);
    print(loginData);
    if (loginData['err'] == "1") {
      EasyLoading.dismiss();
      hlp.showErrorToast(loginData['data']);
    } else {
      EasyLoading.dismiss();

      Get.back();
      Helper().showInfo('Bitte Postfach überprüfen');
    }
  }
}
