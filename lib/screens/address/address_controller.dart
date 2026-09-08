import 'dart:convert';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/address/address_screen.dart';

import '../constant/validations.dart';

class AddressController extends GetxController{

  var addLoading = false.obs;
  var addData ;

  var addListLoading = false.obs;
  var addListData ;

  var deleteLoading = false.obs;
  var deleteData ;
  RxInt defaultaddressid = 0.obs;
  var ListUrl = Uri.parse(addresslistUrl); // address list url

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  AddressListApi(url)async{
    addListLoading(true);
    try{
      var response = await ApiBaseHelper().getAPICall(url, true);
      print('inside address $response');
      if(response.statusCode == 200){
        addListData = jsonDecode(response.body);
        print('inside data herererererererere $addListData');
        if (addListData['data'] != null &&
            addListData['data'].isNotEmpty) {
          defaultaddressid.value = addListData['data'][0]['id'];
        }

        addListLoading(false);
        update();
        refresh();
      }
      else  {
        addListData = jsonDecode(response.body);
        addListData = [];
        defaultaddressid.value= 0;
        addListLoading(false);
        toastMsg('No Address Found !!', true);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome AddressListApi In Catch\n ${e}');
      // toastMsg(msg, false)
      addListLoading(false);
      update();
    }
  }


  AddAddressApi(url,parameter)async{
    print('Welcome AddAddressApi Loading');
    addLoading(true);
    try{
      print('Welcome AddAddressApi In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);
      addData = jsonDecode(response.body);
      if(response.statusCode == 200){
        addData = jsonDecode(response.body);
        if(addData['status'] == true){
          await AddressListApi(Uri.parse(addresslistUrl),);
          var msg= addData['message'];
          toastMsg(msg.toString(),true);
          Get.back();
          addLoading(false);
          update();
          refresh();
        }
        else{
          addData = jsonDecode(response.body);
          print('Welcome AddAddressApi In Try      ${addData}');

          var msg= addData['message'];
          toastMsg(msg.toString(),false);
          // countDownController.reset();
          // addData =[];
          addLoading(false);
          update();
          refresh();
        }
      }
      else  {
        addData = jsonDecode(response.body);
        addLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome AddAddressApi In Catch\n ${e}');
      // toastMsg(msg, false)
      addLoading(false);
      update();
    }
  }

  DeleteAddressApi(url)async{
    print('Welcome DeleteAddressApi Loading');
    deleteLoading(true);
    try{
      print('Welcome DeleteAddressApi In Try');
      var response = await ApiBaseHelper().deleteAPICall(url);
      deleteData = jsonDecode(response.body);
      if(response.statusCode == 200){
        print("check 2000");
        if(deleteData['status'] == true){
          var msg= deleteData['message'];
          toastMsg(msg.toString(),true);

          //Get.off(AddressPage());
          await AddressListApi(ListUrl,);
          deleteLoading(false);
          Get.back();
          update();
          refresh();
        }
        else{
          var msg= deleteData['message'];
          toastMsg(msg.toString(),false);
          // countDownController.reset();
          deleteLoading(false);
          update();
          refresh();
        }
      }
      else  {
        deleteData=[];
        deleteLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome DeleteAddressApi In Catch\n ${e}');
      // toastMsg(msg, false)
      deleteLoading(false);
      update();
    }
  }
}
