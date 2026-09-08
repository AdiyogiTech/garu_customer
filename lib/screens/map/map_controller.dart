import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MapController extends GetxController{

  RxBool mapLoader = false.obs;
  var address = 'Getting Address..'.obs;
  var textController = TextEditingController();
  EnableLoader(loader){

    if(loader==true){
      mapLoader(true);
      update();
      refresh();

    }else{
      mapLoader(false);
      update();
      refresh();

    }

  }
  UpdateData(updatemapaddress){
    textController.text = updatemapaddress;
    update();
  }
}