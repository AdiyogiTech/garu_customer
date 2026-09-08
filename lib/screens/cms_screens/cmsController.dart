import 'dart:convert';
import 'package:get/get.dart';

import '../../constant/ApiBaseHelper.dart';
import '../constant/validations.dart';

class CMSController extends GetxController {
  var cmsload = false.obs;
  var cmsdata = {}.obs;

  cmsAPICalling(url) async {
    cmsload(true);
    try {
      var response = await ApiBaseHelper().getAPICall(url, true);
      var decodedata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (decodedata["status"] == true) {
          cmsdata.clear();
          cmsdata.addAll(decodedata["data"]);
          cmsload(false);
          update();
          refresh();
        }
      } else {
        toastMsg('Please Try Again !!', false);
        cmsload(false);
        update();
        refresh();
      }
    } catch (e) {
      print('cms in Catch =:.:= ${e}');
      cmsload(false);
      update();
    }
  }
}
