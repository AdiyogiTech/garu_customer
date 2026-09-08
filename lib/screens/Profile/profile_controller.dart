import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/main.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var ProfileLoading = false.obs;
  var DashBoardLoading = false.obs;
  var ProfileData;
  var DashBoardData;
  var profileData_model;
  var isOtpSent = false.obs;
  var isOtpVerified = false.obs;
  var otpLoading = false.obs;
  RxBool isNumberChanged = false.obs;
  RxInt resendSeconds = 0.obs;
  Timer? _resendTimer;

  TextEditingController otpController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  void startResendTimer() {
    resendSeconds.value = 30;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      resendSeconds.value--;

      if (resendSeconds.value == 0) {
        timer.cancel();
        isOtpSent(false); // 🔁 enable Send OTP again
      }
    });
  }

  sendOtp(String mobile) async {
    otpLoading(true);

    var url = Uri.parse(sendotp_url);

    var body = {"mobile": mobile, "is_register": "1"};

    try {
      await Future.delayed(Duration(seconds: 1));
      var response =
          await ApiBaseHelper().postAPICall(url, jsonEncode(body), true);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        isOtpSent(true);
        toastMsg(data['message'].toString(), true);
        startResendTimer();
      } else {
        toastMsg(data['message'].toString(), false);
      }
    } catch (e) {
      toastMsg("OTP send failed", false);
    } finally {
      otpLoading(false);
      update();
    }
  }

  GetProfile(url) async {
    print('inside getProfile');
    // ProfileLoading(true);
    print('inside getProfile $url');
    try {
      var response = await ApiBaseHelper().getAPICall(url, true);
      print('inside response try $response');
      if (response.statusCode == 200) {
        ProfileData = jsonDecode(response.body);
        print("inside ProfileData-->>" + ProfileData.toString());
        ProfileLoading(false);
        prefs!.setString('profileImage_url', ProfileData['image'].toString());
        prefs!.setString('user_name', ProfileData['name'].toString());
        prefs!
            .setString('referral_code', ProfileData['reffer_code'].toString());
        print("prfs 1.... ${prefs!.getString("profileImage_url")}");
        print("prfs 2.... ${prefs!.getString("user_name")}");
        // if(ProfileData['status'] == true){
        //
        //   // profileData_model = ProfileModel.fromJson(ProfileData);
        //   // print('profiledata ... ${profileData_model.data.mobile.toString()}');
        //   // var msg = ProfileData['message'];
        //   // prefs!.setString('profileImage_url',ProfileData['data']['image'].toString());
        //   // prefs!.setString('user_name',ProfileData['data']['name'].toString());
        //   // print("prfs 1.... ${prefs!.getString("profileImage_url")}");
        //   // print("prfs 2.... ${prefs!.getString("user_name")}");
        //   // toastMsg(msg.toString(),true);
        //   ProfileLoading(false);
        update();
        refresh();
        // }
      } else {
        print('inside else dashboard data');
        var msg = ProfileData['message'];
        toastMsg(msg.toString(), false);
        // ProfileLoading(false);
        ProfileData = [];
        update();
        refresh();
      }
    } catch (e) {
      print('inside Profile in Catch =:.:= ${e}');
      // ProfileLoading(false);
      update();
    }
  }

  GetDashBoard(url) async {
    print('inside GetDashBoard $url');
    DashBoardLoading(true);
    try {
      var response = await ApiBaseHelper().getAPICall(url, true);
      // print("inside try DashBoardData--->>"+DashBoardData.toString());
      print('inside response  ${response.statusCode}');
      if (response.statusCode == 200) {
        DashBoardLoading(false);
        print('inside GetDashBoard $url');
        DashBoardData = jsonDecode(response.body);
        // log("DashBoardData-->>"+DashBoardData.toString());

        // profileData_model = ProfileModel.fromJson(DashBoardData);
        // print('DashBoardData ... ${profileData_model.data.mobile.toString()}');

        prefs!.setString(
            'profileImage_url', DashBoardData['data']['image'].toString());
        prefs!.setString('user_name', DashBoardData['data']['name'].toString());
        prefs!.setString(
            'referral_code', DashBoardData['data']['reffer_code'].toString());
        prefs!.setString(
            "user_balance", DashBoardData['data']['user_balance'].toString());
        print("inside prfs 1.... ${prefs!.getString("profileImage_url")}");
        print("inside prfs 2.... ${prefs!.getString("user_name")}");
        print("inside prfs 2.... ${prefs!.getString("referral_code")}");

        DashBoardLoading(false);
        update();
        refresh();
      } else {
        print('inside else');
        var msg = DashBoardData['message'];
        // DashBoardData = jsonDecode(response.body);
        // toastMsg(msg.toString(),false);
        // DashBoardData=[];
        // DashBoardLoading(false);
        update();
        refresh();
      }
    } catch (e) {
      // print(' Profile in Catch dashboard =:.:= ${e}');
      // print('inside catch $e');
      // DashBoardLoading(false);
      update();
      refresh();
    }
  }
}
