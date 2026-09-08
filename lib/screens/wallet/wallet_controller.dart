import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class WalletController extends GetxController {
  var walletListLoading = false.obs;
  var loadMoreDataLoader = false.obs;
  var noMoreDataLoader = false.obs;

  final ScrollController walletListScrollCtrl = ScrollController();

  int walletListLimit = 10;
  int walletListPage = 1;

  var walletListTotalPage = 0.obs;

  TextEditingController walletSearchCtrl = TextEditingController();

  // Your screen expects:
  // walletListData[0]['user']
  // walletListData[0]['wallet']
  List<Map<String, dynamic>> walletListData = [];

  @override
  void onInit() {
    super.onInit();

    walletListScrollCtrl.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!walletListScrollCtrl.hasClients) return;

    final position = walletListScrollCtrl.position;

    // Start pagination 200 pixels before bottom
    if (position.pixels >= position.maxScrollExtent - 200) {
      if (!loadMoreDataLoader.value &&
          !noMoreDataLoader.value &&
          walletListPage < walletListTotalPage.value) {

        log(
          "Pagination triggered: "
              "currentPage=$walletListPage, "
              "totalPage=${walletListTotalPage.value}",
        );

        walletListPage++;

        WalletListApiCall(
          walletSearchCtrl.text,
          '',
          walletListPage,
          walletListLimit,
        );
      }
    }
  }

  Future<void> WalletListApiCall(
      String search,
      String status,
      int page,
      int limit,
      ) async {
    try {
      if (page == 1) {
        walletListLoading.value = true;
        loadMoreDataLoader.value = false;
        noMoreDataLoader.value = false;

        walletListData.clear();
      } else {
        loadMoreDataLoader.value = true;
      }

      update();

      final url =
          "$wallet_url?limit=$limit&page=$page&search=$search";

      log("Wallet API URL => $url");

      final response = await ApiBaseHelper().getAPICall(
        Uri.parse(url),
        true,
      );

      final responseData = jsonDecode(response.body);

      log("Wallet Response => $responseData");

      if (response.statusCode != 200) {
        return;
      }

      if (responseData['status'] != true) {
        return;
      }

      // IMPORTANT:
      // API key is totalPage, NOT total_page
      walletListTotalPage.value =
          responseData['totalPage'] ?? 0;

      // API data is MAP
      final Map<String, dynamic> data =
      Map<String, dynamic>.from(
        responseData['data'] ?? {},
      );

      final List<dynamic> newWallet =
          data['wallet'] ?? [];

      log("Current Page => $page");
      log("Total Pages => ${walletListTotalPage.value}");
      log("New Wallet Records => ${newWallet.length}");

      if (page == 1) {
        // First page
        walletListData.clear();

        walletListData.add({
          'user': data['user'] ?? {},
          'wallet': List<dynamic>.from(newWallet),
        });
      } else {
        // Next pages
        if (walletListData.isNotEmpty) {
          final List<dynamic> existingWallet =
              walletListData[0]['wallet'] ?? [];

          existingWallet.addAll(newWallet);

          walletListData[0]['wallet'] = existingWallet;
        } else {
          // Safety fallback
          walletListData.add({
            'user': data['user'] ?? {},
            'wallet': List<dynamic>.from(newWallet),
          });
        }
      }

      log(
        "Total wallet records => ${walletListData.isNotEmpty
        ? walletListData[0]['wallet'].length
            : 0}",
      );

      // Check whether all pages are loaded
      if (walletListPage >= walletListTotalPage.value) {
        noMoreDataLoader.value = true;

        log("No more pages available");
      } else {
        noMoreDataLoader.value = false;
      }
    } catch (e, stackTrace) {
    log("Wallet API Error => $e");
    log("StackTrace => $stackTrace");
    } finally {
    walletListLoading.value = false;
    loadMoreDataLoader.value = false;

    update();
    }
  }

  @override
  void onClose() {
    walletListScrollCtrl.dispose();
    walletSearchCtrl.dispose();

    super.onClose();
  }
}

