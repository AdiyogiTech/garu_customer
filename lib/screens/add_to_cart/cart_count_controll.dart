import 'dart:convert';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';

class CartCountController extends GetxController{
  var countLoader = false.obs;
  var decodedata ;
 var _getcount;
   get getcount=> _getcount;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  CartCountUpdateApi(url, parameter) async{
    countLoader(true);
    try{
      var response = await ApiBaseHelper().GetMultipartWithQueryParams(url,parameter, true);
      if(response.statusCode == 200){
        decodedata =jsonDecode(response.body);
        print("inside decodedata----->>>"+decodedata.toString());
       _getcount = decodedata['count'];
       print("_getcount----->>>"+_getcount.toString());
        countLoader(false);
        update();
        refresh();
      }else if(response.statusCode == 422){
        decodedata =jsonDecode(response.body);
        decodedata=[];
        countLoader(false);
        update();
        refresh();
      }else{
        decodedata=[];
        countLoader(false);
        update();
        refresh();
      }
    }
    catch(e){
      print('Catch error----->>>${e}');
      countLoader(false);
      update();
    }
  }
}