import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';

import '../../constant/validations.dart';


class DeliveryFormController extends GetxController {
  var createOrderLoading = false.obs;

  Map<String, dynamic>? createOrderData;

  /// ==================== CREATE WINNER ORDER ====================

  Future<bool> createWinnerOrder({
    required int auctionItemId,
    required int addressId,
    required String customerName,
    required String customerEmail,
    required String customerMobile,
    String userComment = '',
  }) async {
    createOrderLoading(true);

    try {
      final parameter = jsonEncode({
        "auction_item_id": auctionItemId,
        "address_id": addressId,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_mobile": customerMobile,
        "user_comment": userComment,
      });

      log("Create Winner Order Parameter => $parameter");

      final response = await ApiBaseHelper().postAPICall(
        Uri.parse(winnerOrderUrl),
        parameter,
        true,
      );

      log("Create Winner Order Status => ${response.statusCode}");
      log("Create Winner Order Response => ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        createOrderData = Map<String, dynamic>.from(
          data["data"] ?? {},
        );

        toastMsg(
          data["message"]?.toString() ?? "Order created successfully",
          true,
        );

        return true;
      }

      toastMsg(
        data["message"]?.toString() ?? "Unable to create order",
        false,
      );

      return false;
    } catch (e) {
      log("Create Winner Order Error => $e");

      toastMsg(
        "Something went wrong",
        false,
      );

      return false;
    } finally {
      createOrderLoading(false);
      update();
    }
  }
}