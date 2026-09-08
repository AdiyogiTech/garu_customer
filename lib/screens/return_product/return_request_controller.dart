import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/add_to_cart/add_to_cart_screen.dart';
import 'package:garu_customer/screens/add_to_cart/cart_count_controll.dart';

import '../../main.dart';
import '../constant/validations.dart';

class ReturnRequestController extends GetxController {
  // var getcartProductList = <Map<String, dynamic>>[].obs;
  var returnRequestData;
  var ItemRequestLoader = false.obs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  // Function to decrease item quantity
  ReturnItemRequestApi(
      String url,
      Map<String, dynamic> parameter,
      File? selectedImage,
      ) async {
    ItemRequestLoader(true);
    update();

    try {
      // 🚫 DO NOT add MultipartFile here
      var response = await ApiBaseHelper()
          .multipartAPICallNew(url, parameter, selectedImage, true);

      var decoded = jsonDecode(response.body);
      log("Return Request Response ==> $decoded");

      toastMsg(
        decoded['message'].toString(),
        true,
      );

      ItemRequestLoader(false);
      update();
      refresh();
    } catch (e) {
      log("Return Request Error ==> $e");
      ItemRequestLoader(false);
      toastMsg('Something went wrong', false);
      update();
    }
  }


// ReturnItemRequestApi(url, parameter, File? selectedImage) async{
  //   ItemRequestLoader(true);
  //   update();
  //   try{
  //     var response = await ApiBaseHelper().multipartAPICallNew(url, parameter,selectedImage, true);
  //
  //     var decoded =jsonDecode(response.body);
  //     log("inside Return Request body  Resoponse ==> "+decoded.toString());
  //     returnRequestData =jsonDecode(response.body);
  //     var msg = returnRequestData['message'];
  //     toastMsg(msg.toString(), true);
  //     if(response.statusCode == 200){
  //       print('inside add to cart api  200');
  //       returnRequestData =jsonDecode(response.body);
  //       var msg = returnRequestData['message'];
  //       toastMsg(msg.toString(), true);
  //
  //       update();
  //       refresh();
  //     }else if(response.statusCode == 422){
  //       returnRequestData =jsonDecode(response.body);
  //
  //       var msg = returnRequestData['message'];
  //       toastMsg(msg.toString(), false);
  //       ItemRequestLoader(false);
  //       update();
  //       refresh();
  //     }else{
  //       returnRequestData = [];
  //       ItemRequestLoader(false);
  //       update();
  //       refresh();
  //     }
  //   }
  //   catch(e){
  //     print(' add to cart Catch 1----->>>${e}');
  //     ItemRequestLoader(false);
  //     update();
  //   }
  // }
}
