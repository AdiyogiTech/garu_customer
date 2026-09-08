import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';

import '../../constant/ApiBaseHelper.dart';
import '../constant/validations.dart';

class ContactUsController extends GetxController {
  var contactUsLoader = false.obs;
  var contactUsData = {}.obs;

  contactAPICall(url) async {
    contactUsLoader(true);
    try {
      var response = await ApiBaseHelper().getAPICall(url, true);
      var decodedata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (decodedata["status"] == true) {
          contactUsData.clear();
          contactUsData.addAll(decodedata["data"]["settings"]);
          log('yo ${contactUsData["phone"]}');
          log('yo ${contactUsData["email"]}');
          log('yo ${contactUsData["address"]}');
          contactUsLoader(false);
          update();
          refresh();
        }
      } else {
        toastMsg('Please Try Again !!', false);
        contactUsLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      print('contact in Catch := ${e}');
      contactUsLoader(false);
      update();
    }
  }
}
