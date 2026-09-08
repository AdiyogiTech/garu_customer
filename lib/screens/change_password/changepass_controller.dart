import 'dart:convert';

import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/constant/validations.dart';

class ChangePassController extends GetxController{

  var ChangeLoading = false.obs;
  var ChangeData ;
  
  
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ChangeApi(url, parameter) async {
    ChangeLoading(true);
    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);
      ChangeData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var msg = ChangeData['message'];
        toastMsg(msg.toString(), true);

        Get.back(); // ✅ sirf success par back
      }
      else if (response.statusCode == 422) {
        var msg = ChangeData['message'];
        toastMsg(msg.toString(), false);

        // ❌ yaha Get.back() mat lagao
      }
      else {
        toastMsg("Something went wrong", false);
      }
    } catch (e) {
      toastMsg("Server error", false);
    } finally {
      ChangeLoading(false);
      update();
    }
  }

}

