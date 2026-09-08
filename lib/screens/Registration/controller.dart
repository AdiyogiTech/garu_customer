import 'dart:convert';
import 'dart:developer';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/Registration/otp_screen_register.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/login_screen.dart';

class RegisterController extends GetxController{

  var RegisterLoading = false.obs;
  var RegisterData ;

  var OTPLoading = false.obs;
  var OTPData ;

  var ResendOTPLoading = false.obs;
  var ResendOTPData ;

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController referController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  CountDownController countDownController = CountDownController();
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> call_registerapi() async {
    print('inside call_registerapi');
    var registerbody = jsonEncode({
      "name": nameController.text.trim().toString(),
      "email": emailController.text.trim().toString(),
      "mobile":numberController.text.trim().toString(),
      "password": passwordController.text.trim().toString(),
      "referral_code":referController.text.trim().toString(),
      "otp": otpController.text.trim().toString()
    });
    await RegiserData(Uri.parse(register_url),registerbody);
  }
// hit Register api
    RegiserData(url,parameter)async{
    print('inside Register Data $url');
    print('inside Register Data $parameter');
    RegisterLoading(true);
    try{
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      RegisterData = jsonDecode(response.body);
      log("RegisterData>>>>> $RegisterData");
      if(response.statusCode == 200 ){
        print('inside RegiserData');
        var msg= RegisterData['message'];
        toastMsg(msg.toString(),true);
        RegisterLoading(false);
        nameController.clear();
        numberController.clear();
        emailController.clear();
        passwordController.clear();
        conPasswordController.clear();
        referController.clear();
        Get.offAll(LoginPage());
        update();
        refresh();
      }
///6377962057
      else if (response.statusCode == 422){
        var msg= RegisterData['data'];
        if(msg['name']!= null) {
          toastMsg(msg['name'].toString(), false);
        }
        else if(msg['mobile']!= null){
          toastMsg(msg['mobile'].toString(), false);
        }
        else if(msg['email']!= null){
          toastMsg(msg['email'].toString(), false);
        }
        else if(msg['otp']!= null){
          toastMsg(msg['otp'].toString(), false);
        }
        else if(msg['referral_code']!= null){
          toastMsg(msg['referral_code'].toString(), false);
        }

        RegisterLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      RegisterLoading(false);
      update();
    }
  }
  // hit send otp api
  RegisterOtpData(url,parameter)async{
    print('inside Welcome Send OTP Loading');
    OTPLoading(true);
    try{
      print('inside Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      OTPData = jsonDecode(response.body);
      if(response.statusCode == 200){
        print('inside 200 response');
        if(OTPData['status'] == true){
          var msg= OTPData['message'];
          print('inside otp message $msg');
          toastMsg(msg.toString(),true);
          OTPLoading(false);
          Get.offAll( OTPRegister(numberController.text.toString(),OTPData['data'].toString()));
        }else{
          String errorMsg = "Incorrect OTP";

          // case 1: message me error
          if (OTPData['message'] != null &&
              OTPData['message'].toString().isNotEmpty) {
            errorMsg = OTPData['message'].toString();
          }

          // case 2: data map me otp error
          else if (OTPData['data'] != null &&
              OTPData['data'] is Map &&
              OTPData['data']['otp'] != null) {
            errorMsg = OTPData['data']['otp'].toString();
          }

          toastMsg(errorMsg, false);
          OTPLoading(false);
        }

        print('name ${nameController.text.toString()}');
        print('name ${numberController.text.toString()}');
        print('name ${emailController.text.toString()}');
        print('name ${passwordController.text.toString()}');
        update();
        refresh();
      }
      else  {
        OTPData=[];
        OTPLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      // toastMsg(msg, false)
      OTPLoading(false);
      update();
    }
  }

  ResendOtp(url,parameter)async{
    print('Welcome Send OTP Loading');
    ResendOTPLoading(true);
    try{
      print('Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, json.encode(parameter), true);
      ResendOTPData = jsonDecode(response.body);
      if(response.statusCode == 200){
        var msg= ResendOTPData['message'];
        toastMsg(msg.toString(),true);
        // countDownController.reset();
        ResendOTPLoading(false);
        update();
        refresh();
        return response.statusCode == 200;
      }
      else  {
        var msg= ResendOTPData['message'];
        toastMsg(msg.toString(),true);
        ResendOTPLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
    /*  var msg= ResendOTPData['message'];
      toastMsg(msg, false);*/
      ResendOTPLoading(false);
      update();
    }
  }

}