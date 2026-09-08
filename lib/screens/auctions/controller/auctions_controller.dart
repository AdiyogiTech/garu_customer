import 'dart:convert';
import 'dart:developer';

import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Environment/Environment.dart';
import '../../../main.dart';
import '../../constant/validations.dart';

class AuctionController extends GetxController {
  var auctionLoading = false.obs;
  var paginationLoading = false.obs;
  var aboutLoading = false.obs;
  var detailLoading = false.obs;

  List auctionList = [];
  Map<String, dynamic>? auctionDetail;
  var aboutData = Rxn<Map<String, dynamic>>();

  int page = 1;
  int totalPage = 1;
  int limit = 10;

  bool get hasMore => page < totalPage;

  var participationLoading = false.obs;

  List myParticipationList = [];

  ///==================== Get Auction List ====================

  Future<void> getAuctionList({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      auctionList.clear();
    }

    if (page == 1) {
      auctionLoading(true);
    } else {
      paginationLoading(true);
    }

    try {
      String url = auctionsUrl;

      print("Auction Url => $url");

      var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          totalPage = data["totalPage"] ?? 1;

          if (page == 1) {
            auctionList.clear();
          }

          auctionList.addAll(data["data"]);

          print("Auction List Length : ${auctionList.length}");
          log("response>>>${data["data"]}");
        } else {
          toastMsg(data["message"].toString(), false);
        }
      } else {
        toastMsg(data["message"].toString(), false);
      }
    } catch (e) {
      print("Auction Error => $e");
    }

    auctionLoading(false);
    paginationLoading(false);

    update();
    refresh();
  }

  ///==================== Load More ====================

  Future<void> loadMore() async {
    if (paginationLoading.value) return;

    if (page >= totalPage) return;

    page++;

    await getAuctionList();
  }

  ///==================== Refresh ====================

  Future<void> refreshAuction() async {
    page = 1;

    await getAuctionList(isRefresh: true);
  }

  ///==================== Get Auction Detail ====================

  Future<Map<String, dynamic>?> getAuctionDetail(int auctionId) async {
    detailLoading(true);

    try {
      String url = "$auctionsUrl/$auctionId";

      print("Auction Detail Url => $url");

      var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          auctionDetail = data["data"];

          print("Vault Detail : ${auctionDetail}");
          log("Vault Detail Response>>>${data["data"]}");

          detailLoading(false);
          update();

          return auctionDetail;
        } else {
          toastMsg(data["message"].toString(), false);
          detailLoading(false);
          return null;
        }
      } else {
        toastMsg(data["message"].toString(), false);
        detailLoading(false);
        return null;
      }
    } catch (e) {
      print("Vault Detail Error => $e");
      detailLoading(false);
      return null;
    }
  }

  Future<Map<String, dynamic>?> payParticipationFee(int auctionId) async {
    try {
      final token = prefs!.getString("token");

      final response = await http.post(
        Uri.parse("$auctionsUrl/$auctionId/pay-participation-fee"),
        headers: {
          Environment.appxapikey.toString():
              Environment.appxapivalue.toString(),
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Status Code => ${response.statusCode}");
      print("Response => ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return Map<String, dynamic>.from(data["data"]);
      } else {
        toastMsg(data["message"].toString(), false);
        return null;
      }
    } catch (e) {
      print("Payment API Error => $e");
      return null;
    }
  }

  Future<bool> completeParticipationPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final response = await ApiBaseHelper().postAPICall(
        Uri.parse("$auctionsUrl/participation/complete-payment"),
        jsonEncode({
          "razorpay_order_id": razorpayOrderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_signature": razorpaySignature,
        }),
        true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return true;
      }

      toastMsg(data["message"].toString(), false);
      return false;
    } catch (e) {
      print("Complete Payment Error => $e");
      return false;
    }
  }

  Future<bool> placeBid({
    required int auctionId,
    required int amount,
  }) async {
    try {
      final response = await ApiBaseHelper().postAPICall(
        Uri.parse("$auctionsUrl/$auctionId/bid"),
        jsonEncode({
          "amount": amount,
        }),
        true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        toastMsg(data["message"], true);

        return true;
      }

      toastMsg(data["message"], false);

      return false;
    } catch (e) {
      print(e);

      return false;
    }
  }

  Future<Map<String, dynamic>?> getAuctionWinner(int auctionId) async {
    try {
      final response = await ApiBaseHelper().getAPICall(
        Uri.parse("$auctionsUrl/$auctionId/winner"),
        true,
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 403) {
        return {
          "status": result["status"],
          "message": result["message"],
          ...Map<String, dynamic>.from(result["data"] ?? {}),
        };
      }

      toastMsg(result["message"] ?? "Something went wrong", false);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> getMyParticipations() async {
    participationLoading(true);

    try {
      final response = await ApiBaseHelper().getAPICall(
        Uri.parse("$auctionsUrl/my-participations"),
        true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        myParticipationList.clear();

        myParticipationList.addAll(data["data"]);

        log("My Participations => ${data["data"]}");
      } else {
        toastMsg(data["message"].toString(), false);
      }
    } catch (e) {
      print(e);
    }

    participationLoading(false);

    update();
  }

  Future<bool> verifyWinnerPayment({
    required int auctionId,
  }) async {
    try {
      final response = await ApiBaseHelper().postAPICall(
        Uri.parse("$auctionsUrl/winner/verify-payment"),
        jsonEncode({
          "auction_item_id": auctionId,
        }),
        true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        toastMsg(data["message"], true);

        return true;
      }

      toastMsg(data["message"], false);

      return false;
    } catch (e) {
      print(e);

      return false;
    }
  }

  Future<void> getAbout() async {
    aboutLoading(true);

    try {
      String url = auctionAboutUrl;

      log("About Url => $url");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse(url),
        true,
      );

      var data = jsonDecode(response.body);

      log("About Response => $data");

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          if (data["data"] != null) {
            aboutData.value = Map<String, dynamic>.from(
              data["data"],
            );
          } else {
            aboutData.value = null;
          }

          log("About Data => ${aboutData.value}");
        } else {
          aboutData.value = null;

          toastMsg(
            data["message"].toString(),
            false,
          );
        }
      } else {
        aboutData.value = null;

        toastMsg(
          data["message"]?.toString() ?? "Something went wrong",
          false,
        );
      }
    } catch (e) {
      aboutData.value = null;

      log("Get About Error => $e");
    }

    aboutLoading(false);
    update();
  }
}
