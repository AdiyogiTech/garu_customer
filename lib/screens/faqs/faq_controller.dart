import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class FaqController extends GetxController {
  var faqList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getFaqs();
    super.onInit();
  }

  Future<void> getFaqs() async {
    try {
      isLoading(true);
      var url = Uri.parse(faqUrl);
      var response = await ApiBaseHelper().getAPICall(url, true);
      print('Faq Url>>>$url');

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          faqList.value = jsonData["data"];
          log('faq response>>>>$jsonData["data');// ⭐ direct map list
        }
      }
    } catch (e) {
      print("FAQ error: $e");
    } finally {
      isLoading(false);
    }
  }
}