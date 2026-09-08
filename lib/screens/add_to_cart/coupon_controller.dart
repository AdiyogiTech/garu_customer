import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/add_to_cart/addto_cart_controller.dart';
import 'package:garu_customer/screens/constant/validations.dart';

import '../../Environment/Environment.dart';

class ApplyCouponController extends GetxController {
  /// text controller
  final TextEditingController couponController;
  ApplyCouponController(this.couponController);

  /// loaders
  var applyLoading = false.obs;
  var deleteLoading = false.obs;
  var listLoading = false.obs;

  /// coupon list
  var couponList = [].obs;

  /// ------------------------------
  /// GET COUPON LIST
  /// ------------------------------
  Future<void> getCouponList() async {
    listLoading(true);
    try {
      var response = await ApiBaseHelper()
          .getAPICall(Uri.parse(getcoupon_url), false);

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        couponList.value = decoded['data'] ?? [];
      } else {
        couponList.clear();
      }
    } catch (e) {
      print("Coupon list error: $e");
      couponList.clear();
    } finally {
      listLoading(false);
    }
  }

  /// ------------------------------
  /// APPLY COUPON
  /// ------------------------------
  Future<void> applyCouponApi(Uri url, String body) async {
    applyLoading(true);
    try {
      var response = await ApiBaseHelper().postAPICall(url, body, true);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['status'] == true) {
        toastMsg(decoded['message'], true);

        couponController.clear();

        final cartController = Get.find<AddCartController>();

        /// 🔥 IMPORTANT: wait + safe refresh
        await cartController.GetCartApi(
          getcart_url,
          Environment.deviceid.toString(),
          false,
        );

      } else {
        toastMsg(decoded['message'] ?? "Error", false);
      }
      // if (response.statusCode == 200) {
      //   toastMsg(decoded['message'], true);
      //
      //   couponController.clear();
      //
      //   /// refresh cart
      //   Get.find<AddCartController>().getCartRefresh(false);
      //
      // } else {
      //   toastMsg(decoded['message'], false);
      // }
    } catch (e) {
      print("Apply coupon error: $e");
      toastMsg("Something went wrong", false);
    } finally {
      applyLoading(false);
    }
  }

  /// ------------------------------
  /// DELETE COUPON
  /// ------------------------------
  Future<void> deleteCouponApi(Uri url) async {
    deleteLoading(true);
    try {
      var response = await ApiBaseHelper().deleteAPICall(url);
      var decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        print("Delete JSON error: $e");
        decoded = {};
      }

      if (response.statusCode == 200 && decoded['status'] == true) {
        toastMsg(decoded['message'], true);

        /// SAFE refresh
        await Get.find<AddCartController>().GetCartApi(
          getcart_url,
          Environment.deviceid.toString(),
          false,
        );
      } else {
        toastMsg(decoded['message'] ?? "Error", false);
      }

      // var decoded = jsonDecode(response.body);
      //
      // if (response.statusCode == 200 && decoded['status'] == true) {
      //   toastMsg(decoded['message'], true);
      //
      //   /// refresh cart
      //   Get.find<AddCartController>().getCartRefresh(false);
      // } else {
      //   toastMsg(decoded['message'], false);
      // }
    } catch (e) {
      print("Delete coupon error: $e");
      toastMsg("Something went wrong", false);
    } finally {
      deleteLoading(false);
    }
  }
}
