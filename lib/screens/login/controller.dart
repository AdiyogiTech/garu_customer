import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/main.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/otp_screen_login.dart';
import 'package:get/get.dart';
class LoginController extends GetxController{
  var LoginLoading = false.obs;
  var LoginData ;
  var OTPLoading = false.obs;
  var OTPData ;
  var ResendOTPLoading = false.obs;
  var ResendOTPData ;
  TextEditingController mobileNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController loginOTP = TextEditingController();
  CountDownController countDownController = CountDownController();
  var ResetPasswordLoading = false.obs;
  var ResetPasswordData;

  TextEditingController resetMobileNo = TextEditingController();
  TextEditingController resetPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController resetOtp = TextEditingController();
  String ?_token;
  String? get token => _token;

  @override
  void onReady() {
    getToken();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> getToken() async {
    print("inside CheckCheck 1");
    try {
      print("inside FCM: getting...");
      await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
      _token = await FirebaseMessaging.instance.getToken();
      print("inside FCM TOKEN: $_token");
      prefs!.setString("token", _token!);
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _token = token;
        prefs!.setString("token", _token!); // Update token in preferences
      });
      print("inside FCM 1 : $_token");
    } catch (e) {
      print("inside Exception : $e");
    }
    print("inside CheckCheck 2");
  }

  Future<void> LoginApi(dynamic url, dynamic parameter) async {
    print('inside login api');
    LoginLoading(true);

    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      LoginData = jsonDecode(response.body);

      print("Response status code: ${response.statusCode}");
      print("Response body: $LoginData");
      // 🚫 TOO MANY ATTEMPTS (403) - Check this FIRST
      if (response.statusCode == 403) {
        print("Your account has been deleted.");
        toastMsg(
          LoginData['message'] ?? "Your account has been deleted.",
          false,
        );
        Get.back();
        LoginLoading(false);
        update();
        return;
      }

      // 🚫 TOO MANY ATTEMPTS (429) - Check this FIRST
      if (response.statusCode == 429) {
        print("Too many attempts detected - status 429");
        toastMsg(
          LoginData['message'] ?? "Too many wrong attempts. Try again later.",
          false,
        );
        Get.back();
        LoginLoading(false);
        update();
        return;
      }

      // ✅ SUCCESS (200)
      if (response.statusCode == 200) {
        if (LoginData['status'] == true) {
          toastMsg(LoginData['message'], true);
          LoginLoading(false);
debugPrint("login data>>>>${LoginData['data']}");
          final data = LoginData['data'];
          final user = data['user'];

          prefs!.setString("token", data['token'].toString());
          prefs!.setBool("loggedin", true);

          // save user details
          prefs!.setString('profileImage_url', user['image']?.toString() ?? "");
          prefs!.setString('user_name', user['name']?.toString() ?? "");
          prefs!.setString('user_mobile', user['mobile']?.toString() ?? "");
          prefs!.setString('referral_code', user['reffer_code']?.toString() ?? "");
          print('profileImage_url>>>>${user['image']?.toString()}');
          print('user_name>>>>${user['name']?.toString()}');
          print('user_mobile>>>>${user['mobile']?.toString()}');
          print('referral>>>>${user['reffer_code']?.toString()}');
//           prefs!.setString("token", LoginData['data']['token']);
//           prefs!.setBool("loggedin", true);
//           prefs!.setString('profileImage_url', LoginData['data']['user']['image'].toString());
//           prefs!.setString('user_name', LoginData['data']['user']['name'].toString());
          Get.offAll(BottomBar(bottomindex: 2));
        } else {
          toastMsg(LoginData['message'], false);
          LoginLoading(false);
        }
        update();
        return;
      }

      // ❌ VALIDATION ERROR (422)
      if (response.statusCode == 422) {
        final data = LoginData['data'];

        if (data != null && data['otp'] != null) {
          toastMsg(data['otp'].toString(), false);
        } else {
          toastMsg(LoginData['message'], false);
        }

        LoginLoading(false);
        update();
        return;
      }

      // 🔥 OTHER STATUS CODES
      toastMsg(
        LoginData['message'] ?? "Something went wrong. Please try again.",
        false,
      );
      LoginLoading(false);
      update();

    } catch (e) {
      print("LoginApi Exception: $e");
      toastMsg(
        "Server error. Please try again after some time.",
        false,
      );
      LoginLoading(false);
      update();
    }
  }


  LoginOtpData(url, parameter) async {
    print('inside LoginOtpData Login Send OTP Loading');
    OTPLoading(true);
    try {
      print('Welcome Login Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      print("url>>>>>>>>${url}");
      OTPData = jsonDecode(response.body);

      // 🚫 Check 403 first
      if (response.statusCode == 403) {
        print("Your account has been deleted.");
        toastMsg(
          OTPData['message'] ?? "Your account has been deleted.",
          false,
        );
        OTPLoading(false);
        update();
        return;
      }

      // 🚫 Check 429 first
      if (response.statusCode == 429) {
        print("Too many attempts detected in OTP - status 429");
        toastMsg(
          OTPData['message'] ?? "Too many attempts. Try again later.",
          false,
        );
        OTPLoading(false);
        update();
        return;
      }

      if (response.statusCode == 200) {
        if (OTPData['status'] == true) {

          var msg = OTPData['message'].toString();
          print("response>>${OTPData['data']}");
          toastMsg(msg.toString(), true);
          OTPLoading(false);
          Get.to(OTPLogin(mobileNo.text.toString(), OTPData['data'].toString()));
        } else {
          var msg = OTPData['message'].toString();
          toastMsg(msg.toString(), false);
          OTPLoading(false);
        }
        update();
      } else {
        toastMsg(OTPData['message'] ?? "Incorrect OTP", false);
        OTPData = [];
        OTPLoading(false);
        update();
      }
    } catch (e) {
      print('Welcome Login Send OTP In Catch\n ${e}');
      OTPLoading(false);
      update();
    }
  }

  ResendOtp(url,parameter)async{
    print('Welcome Send OTP Loading');
    ResendOTPLoading(true);
    try{
      print('Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      ResendOTPData = jsonDecode(response.body);
      if(response.statusCode == 200){
        var msg= ResendOTPData['message'];
        toastMsg(msg.toString(),true);
        // countDownController.reset();
        ResendOTPLoading(false);
        update();
        refresh();
        // nameController.clear();
        // mobileNo.clear();
        // emailController.clear();
        // passwordController.clear();
      }
      else  {
        ResendOTPData=[];
        ResendOTPLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      // toastMsg(msg, false)
      ResendOTPLoading(false);
      update();
    }
  }

  Future<void> resetPasswordApi(dynamic url, dynamic parameter) async {
    print("Inside Reset Password API");

    ResetPasswordLoading(true);

    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);

      ResetPasswordData = jsonDecode(response.body);

      print("Status Code : ${response.statusCode}");
      print("Response : $ResetPasswordData");

      if (response.statusCode == 200) {
        if (ResetPasswordData['status'] == true) {
          toastMsg(ResetPasswordData['message'], true);
          resetMobileNo.clear();
          Get.back(); // ya Get.offAll(LoginScreen());

        } else {
          toastMsg(ResetPasswordData['message'], false);
        }
      }
      else if (response.statusCode == 422) {
        toastMsg(
          ResetPasswordData['message'] ?? "Validation Error",
          false,
        );
      }
      else {
        toastMsg(
          ResetPasswordData['message'] ?? "Something went wrong",
          false,
        );
      }
    } catch (e) {
      print("Reset Password Exception : $e");
      toastMsg("Server Error", false);
    }

    ResetPasswordLoading(false);
    update();
  }

  // Add this method for forgot password OTP
  Future<void> sendForgotOtpApi(dynamic url, dynamic parameter) async {
    print('Inside Send Forgot OTP API');
    OTPLoading(true);

    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      OTPData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (OTPData['status'] == true) {
          toastMsg(OTPData['message'].toString(), true);
          OTPLoading(false);
        } else {
          toastMsg(OTPData['message'].toString(), false);
          OTPLoading(false);
        }
      } else if (response.statusCode == 403) {
        toastMsg(OTPData['message'] ?? "Your account has been deleted.", false);
        OTPLoading(false);
      } else if (response.statusCode == 429) {
        toastMsg(OTPData['message'] ?? "Too many attempts. Try again later.", false);
        OTPLoading(false);
      } else {
        toastMsg(OTPData['message'] ?? "Something went wrong", false);
        OTPData = [];
        OTPLoading(false);
      }
      update();
    } catch (e) {
      print('Send Forgot OTP Exception: ${e}');
      toastMsg("Server Error. Please try again.", false);
      OTPLoading(false);
      update();
    }
  }

}


