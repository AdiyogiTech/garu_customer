import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class NotificationController extends GetxController {

  ///get Notification data....
  var notificationListLoading = false.obs;

  var LoadMoreDataloader = false.obs;
  var NoMoreDataloader = false.obs;
  ScrollController? notificationListScrollCtrl;
  var notificationListlimit = 8;
  var notificationListPage = 1;
  var notificationListtotalPage =0.obs ;
  TextEditingController notificationSearchCtrl=TextEditingController();
  List notificationListData = [];

  var count = 0.obs;


  notificationListPaginationSearch() {
    notificationListScrollCtrl = ScrollController();

    notificationListScrollCtrl!.addListener(() {

      if (notificationListScrollCtrl!.position.pixels >=
          notificationListScrollCtrl!.position.maxScrollExtent - 100 &&
          !LoadMoreDataloader.value &&
          !NoMoreDataloader.value) {
        print("Load Next Page");

        if (notificationListPage < notificationListtotalPage.value) {

          LoadMoreDataloader(true);

          notificationListPage++;

          NotificationListApiCall(
            notificationSearchCtrl.text,
            '',
            notificationListPage,
            notificationListlimit,
          );
        }
      }
    });
  }

  NotificationListApiCall(search,status,page,limit) async {
    if(page==1){
      notificationListData.clear();
      notificationListLoading(true);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }else{
      notificationListLoading(false);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }
    update();
    var url;
    url=notification_url+"?limit=${limit}"+"&page=${page}&search=${search}";
    log('Url==>'+url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    notificationListtotalPage.value = responsedata['totalPage'] ?? 0;
    count.value = responsedata['data'].length;
    log('yo count: $count');
    if(response.statusCode==200){
      log("totalPage = ${responsedata['totalPage']}");
      log("current_page = $notificationListPage");
      if(responsedata['status']==true){
        notificationListtotalPage.value =
            responsedata["totalPage"] ?? 0;

// ALWAYS ADD DATA
        notificationListData.addAll(responsedata["data"]);

// AFTER ADDING DATA CHECK LAST PAGE
        if (notificationListPage >= notificationListtotalPage.value) {
          NoMoreDataloader(true);
        } else {
          NoMoreDataloader(false);
        }

        notificationListLoading(false);
        LoadMoreDataloader(false);
        update();
      }
      else{
        if(responsedata['data'].length==0){
          NoMoreDataloader(true);
        }else{
          notificationListData=[];
          NoMoreDataloader(false);
        }
        notificationListLoading(false);
        LoadMoreDataloader(false);
        update();
      }

    }
    else if(response.statusCode==404){
      if(responsedata['data'].length==0){
        NoMoreDataloader(true);
      }else{
        notificationListData=[];
        NoMoreDataloader(false);
      }
      notificationListLoading(false);
      LoadMoreDataloader(false);
      update();
    }
  }

}
