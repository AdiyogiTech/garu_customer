import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/screens/constant/validations.dart';
class ReviewController extends GetxController {
  var orderLoader = false.obs;
  var reviewData;
  ReviewApi(url, parameter) async{
    orderLoader(true);
    update();
    try{
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);

      var decoded =jsonDecode(response.body);
      log("AddtoCartApi Resoponse ==> "+decoded.toString());
      if(response.statusCode == 200){
        print('inside add to cart api  200');
        reviewData =jsonDecode(response.body);
        var msg = reviewData['message'];
        toastMsg(msg.toString(), true);

        orderLoader(false);
        update();
        refresh();
      }else if(response.statusCode == 422){
        reviewData =jsonDecode(response.body);

        var msg = reviewData['message'];
        toastMsg(msg.toString(), false);
        orderLoader(false);
        update();
        refresh();
      }else{
        reviewData = [];
        orderLoader(false);
        update();
        refresh();
      }
    }
    catch(e){
      print(' add to cart Catch 1----->>>${e}');
      orderLoader(false);
      update();
    }
  }
}