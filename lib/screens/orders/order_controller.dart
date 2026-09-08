import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:path_provider/path_provider.dart';
import '../../Environment/Environment.dart';
import '../../constant/ApiBaseHelper.dart';
import '../../constant/api.dart';
import '../../main.dart';

class OrderController extends GetxController {
  ///get orderList data....
  var OrderListLoading = false.obs;
  var progress = "", path = "No Data";
  bool downloading = false;
  var LoadMoreDataloader = false.obs;
  var NoMoreDataloader = false.obs;
  ScrollController? OrderListScrollCtrl;
  var orderListlimit = 10;
  var orderListPage = 1;
  var orderListtotalPage = 0.obs;
  TextEditingController orderSearchCtrl = TextEditingController();
  List orderListData = [];
  var orderLoader = false.obs;
  var reviewData;
  String? selectedStartDate;
  String? selectedEndDate;

  orderListPaginationSearch(String StatusName ) {
    OrderListScrollCtrl = ScrollController();
    log("orderListPaginationSearch");
    OrderListScrollCtrl?.addListener(() {
      if (OrderListScrollCtrl?.position.maxScrollExtent ==
              OrderListScrollCtrl?.position.pixels &&
          LoadMoreDataloader == false) {
        log("orderListPaginationSearch maxScrollExtent");

        if (NoMoreDataloader == false) {
          LoadMoreDataloader(true);
          orderListPage++;
          OrderListApiCall(
            orderSearchCtrl.text,
            StatusName,
            orderListPage,
            orderListlimit,
            startDate: selectedStartDate,
            endDate: selectedEndDate,
          );

          update();
        }
      } else {
        update();
      }
    });
  }

  OrderListApiCall(search, status, page, limit,
      {String? startDate, String? endDate}) async {
    if (page == 1) {
      orderListData.clear();
      OrderListLoading(true);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    } else {
      OrderListLoading(false);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }
    update();
    var url;
    // url =
    //     "$orderList_url?limit=$limit&page=$page&search=$search&order_status_id=$status";
    url = "$orderList_url?limit=$limit&page=$page&search=$search&order_status_id=$status";

    if (startDate != null && startDate.isNotEmpty) {
      url += "&start_date=$startDate";
    }

    if (endDate != null && endDate.isNotEmpty) {
      url += "&end_date=$endDate";
    }

    log('Url==>' + url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    orderListtotalPage.value = responsedata['total_page'] ?? 0;
    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        log("responsedata==>" + responsedata.toString());
        if (responsedata['data'].length == 0) {
          NoMoreDataloader(true);
        } else {
          orderListData.addAll(responsedata['data']);
          NoMoreDataloader(false);
        }
        OrderListLoading(false);
        LoadMoreDataloader(false);

        update();
      } else {
        if (responsedata['data'].length == 0) {
          NoMoreDataloader(true);
        } else {
          orderListData = [];
          NoMoreDataloader(false);
        }
        OrderListLoading(false);
        LoadMoreDataloader(false);
        update();
      }
    } else if (response.statusCode == 404) {
      if (responsedata['data'].length == 0) {
        NoMoreDataloader(true);
      } else {
        orderListData = [];
        NoMoreDataloader(false);
      }
      OrderListLoading(false);
      LoadMoreDataloader(false);
      update();
    }
  }

  ///order details ........
  var OrderDetailsDataLoading = false.obs;
  var OrderId = ''.obs;
  List OrderDetailsData = [];

  OrderDetailsApiCalling(id) async {
    OrderDetailsDataLoading.value = true;
    OrderDetailsData.clear();
    var url = orderDetails_url + '/${id}';
    log('url==>' + url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    log('responsedata11==>' + responsedata.toString());
    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        log("hgg---->" + responsedata.toString());
        OrderDetailsData.add(responsedata['data']);
        log('OrderDetailsData11==>' + OrderDetailsData.toString());
        log('order id here ==>' +
            OrderDetailsData[0]['delivery_boy_id'].toString());
        OrderDetailsDataLoading.value = false;
        update();
      } else {
        OrderDetailsData = [];
        OrderDetailsDataLoading.value = false;
        update();
      }
    }
  }

  ///order Delete.....
  var OrderCencelLoading = false.obs;
  orderDeleteApiCall(id) async {
    OrderCencelLoading(true);

    var headers = {
      'x-api-key': Environment.appxapivalue.toString(),
      'Authorization': 'Bearer ${prefs!.getString("token")}'
    };
    var url = orderCencel_url + '/${id}';
    log('url==>' + url.toString());

    var request = http.MultipartRequest('DELETE', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    var responsedata = jsonDecode(responseBody);
    print('responsedata==>' + responsedata['status'].toString());
    print('statusCode==>' + response.statusCode.toString());

    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        OrderCencelLoading(false);
        toastMsg(responsedata['message'], responsedata['status']);
      } else if (responsedata['status'] == false) {
        OrderCencelLoading(false);
        toastMsg(responsedata['message'], responsedata['status']);
      }
    } else if (response.statusCode == 404) {
      OrderCencelLoading(false);
      toastMsg(responsedata['message'], responsedata['status']);
    } else {
      OrderCencelLoading(false);
      print('Error: ${response.reasonPhrase}');
      print('Response Body: $responseBody');
    }
  }

  orderInvoiceApiCall(id) async {
    OrderCencelLoading(true);

    var headers = {
      'x-api-key': Environment.appxapivalue.toString(),
      'Authorization': 'Bearer ${prefs!.getString("token")}'
    };
    var url = orderInvoice_url + '/${82}';
    log('url==>' + url.toString());

    var request = http.MultipartRequest('GET', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    var responsedata = jsonDecode(responseBody);
    print('responsedata==>' + responsedata['status'].toString());
    print('statusCode==>' + response.statusCode.toString());
    // toastMsg(responsedata['message'], responsedata['status']);
    var msg = responsedata['message'].toString();
    toastMsg(msg.toString(), true);
    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        OrderCencelLoading(false);
        toastMsg(responsedata['message'], responsedata['status']);
        String pdfUrl = responsedata['data'];
        // String pdfUrl = "https://staging.adiyogitechnology.com/garu_customer/storage/invoices/inv-0811304001-08113-000086.pdf";

        var file_format = pdfUrl.split('.').last;
        downloadurl(pdfUrl, file_format);
      } else if (responsedata['status'] == false) {
        OrderCencelLoading(false);
        toastMsg(responsedata['message'], responsedata['status']);
      }
    } else if (response.statusCode == 404) {
      OrderCencelLoading(false);
      toastMsg(responsedata['message'], responsedata['status']);
    } else {
      OrderCencelLoading(false);
      print('Error: ${response.reasonPhrase}');
      print('Response Body: $responseBody');
    }
  }

  Future<String> downloadurl(String url, String ext) async {
    Dio dio = Dio();
    String dirloc = "";
    if (Platform.isAndroid) {
      new Directory('/storage/emulated/0/download/MaxTime_Folder_Download')
          .create();
      dirloc = "/storage/emulated/0/download/";
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    try {
      await dio.download(
        url,
        dirloc + convertCurrentDateTimeToString() + "." + ext,
        onReceiveProgress: (receivedBytes, totalBytes) {
          downloading = true;
          progress =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        },
      );
      Fluttertoast.showToast(
          msg: "Downloading completed..", backgroundColor: Colors.red);
      downloading = false;
      progress = "Download Completed.";
      path = dirloc + convertCurrentDateTimeToString() + "." + ext;
      Fluttertoast.showToast(
        msg: path,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Failed to download");
      downloading = false;
      progress = "Failed to download";
    }
    return progress;
  }

  String convertCurrentDateTimeToString() {
    String formattedDateTime =
        DateFormat('yyyyMMdd_kkmmss').format(DateTime.now().toLocal()).toString();
    return formattedDateTime;
  }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // void createNotification(title, body, filePath) {
  //   //show the notifications.
  //   var initializationSettingsAndroid =
  //       AndroidInitializationSettings('logo');
  //   final DarwinInitializationSettings initializationSettingsDarwin =
  //       DarwinInitializationSettings(
  //           onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //   final LinuxInitializationSettings initializationSettingsLinux =
  //       LinuxInitializationSettings(defaultActionName: 'Open notification');
  //
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           iOS: initializationSettingsDarwin,
  //           linux: initializationSettingsLinux);
  //
  //   flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  //   );
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'progress channel', 'progress channel',
  //     channelDescription: 'progress channel description',
  //     channelShowBadge: false,
  //     // importance: Importance.max,
  //     // priority: Priority.high,
  //     onlyAlertOnce: true,
  //     showProgress: true,
  //   );
  //   var platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   flutterLocalNotificationsPlugin
  //       .show(0, title, body, platformChannelSpecifics, payload: filePath);
  //   // flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: "payloads");
  // }

  // void ReviewApi(String returnRequest_url, Map<String, dynamic> reviewBody) {
  //
  // }
  ReviewApi(url, parameter) async {
    orderLoader(true);
    update();
    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);

      var decoded = jsonDecode(response.body);
      log("inside ReviewApi Resoponse ==> " + decoded.toString());
      if (response.statusCode == 200) {
        print('inside add to cart api  200');
        reviewData = jsonDecode(response.body);
        var msg = reviewData['message'];
        toastMsg(msg.toString(), true);

        orderLoader(false);
        update();
        refresh();
      } else if (response.statusCode == 422) {
        reviewData = jsonDecode(response.body);

        var msg = reviewData['message'];
        toastMsg(msg.toString(), false);
        orderLoader(false);
        update();
        refresh();
      } else {
        reviewData = [];
        orderLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      print(' add to cart Catch 1----->>>${e}');
      orderLoader(false);
      update();
    }
  }
}
