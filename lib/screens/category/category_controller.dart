import 'dart:convert';

import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/constant/validations.dart';

class CategoryController extends GetxController{
  var CatLoader = false.obs;
  List CatData =[];
  @override
  void onReady() {
    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }
  GetCategories(url) async{
    CatLoader(true);
    try{
      var response = await ApiBaseHelper().getAPICall(url, true);
      var decodedata =jsonDecode(response.body);
      if(response.statusCode == 200){

        if(decodedata["status"] == true){
          CatData.clear();
          CatData.addAll(decodedata["data"]);
          CatLoader(false);
          update();
          refresh();
        }
      }else{
        CatData = [];
        var msg = decodedata['message'];

        toastMsg(msg.toString(),false);
        CatLoader(false);
        update();
        refresh();
      }
    }
    catch(e){
      print(' Category in Catch =:.:= ${e}');
      CatLoader(false);
      update();
    }
  }
}