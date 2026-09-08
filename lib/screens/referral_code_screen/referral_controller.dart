import 'dart:convert';
import 'dart:developer';

import 'package:garu_customer/constant/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../main.dart';
import '../constant/colors.dart';
import '../constant/validations.dart';

class ReferralController extends GetxController {
  bool referralLoading = false;
  List<dynamic> referralList = [];


  @override
  void onInit() {
    super.onInit();
    getReferralList();
  }


  Future getReferralList() async {
    referralLoading = true;
    update();

    try {
      String url = referral_url;

      print("Referral Url => $url");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse(url),
        true,
      );

      var data = jsonDecode(response.body);

      log("Referral Response => $data");

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          referralList.clear();

          referralList.addAll(data["data"] ?? []);

          print("Referral List Length => ${referralList.length}");
        } else {
          toastMsg(
            data["message"].toString(),
            false,
          );
        }
      } else {
        toastMsg(
          data["message"]?.toString() ?? "Something went wrong",
          false,
        );
      }
    } catch (e) {
      print("Referral Error => $e");
    }

    referralLoading = false;
    update();
    refresh();
  }




}