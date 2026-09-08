import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// Future<PermissionStatus> permissionStatus =
// NotificationPermissions.getNotificationPermissionStatus();
var permGranted = "granted";
var permDenied = "denied";
var permUnknown = "unknown";
var permProvisional = "provisional";
//
// Future<String> getCheckNotificationPermStatus() {
//   return NotificationPermissions.getNotificationPermissionStatus()
//       .then((status) {
//     switch (status) {
//       case PermissionStatus.denied:
//         return permDenied;
//       case PermissionStatus.granted:
//         return permGranted;
//       case PermissionStatus.unknown:
//         return permUnknown;
//       case PermissionStatus.provisional:
//         return permProvisional;
//       default:
//         return "status";
//     }
//   });
// }

class PushNotificationServicePage {
  BuildContext context;

  PushNotificationServicePage({
    required this.context,
  });

  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   // if (notificationResponse.payload != null) {
  //   //   debugPrint('notification payload: $payload');
  //   // }
  //   print("onDidReceiveNotificationResponse : ");
  //   if (payload != null) {
  //     List<String> pay = payload.split(',');
  //     if (pay[0] == 'products') {
  //       getProduct(pay[1], 0, 0, true);
  //     } else if (pay[0] == 'categories') {
  //       Future.delayed(Duration.zero, () {
  //         // tabController.animateTo(1);
  //       });
  //     } else if (pay[0] == 'wallet') {
  //       // Navigator.push(context,
  //       //     (CupertinoPageRoute(builder: (context) => const MyWallet())));
  //     } else if (pay[0] == 'order') {
  //       // Navigator.push(context,
  //       //     (CupertinoPageRoute(builder: (context) => const MyOrder())));
  //     } else if (pay[0] == 'ticket_message') {
  //       // Navigator.push(
  //       //   context,
  //       //   CupertinoPageRoute(
  //       //       builder: (context) => Chat(
  //       //         id: pay[1],
  //       //         status: '',
  //       //       )),
  //       // );
  //     } else if (pay[0] == 'ticket_status') {
  //       // Navigator.push(
  //       //   context,
  //       //   CupertinoPageRoute(
  //       //     builder: (context) =>  CustomerSupport(false),
  //       //   ),
  //       // );
  //     } else {
  //       // Navigator.push(
  //       //   context,
  //       //   CupertinoPageRoute(builder: (context) => const Splash()),
  //       // );
  //     }
  //   } else {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // Navigator.push(
  //     //   context,
  //     //   CupertinoPageRoute(
  //     //       builder: (context) => MyApp(sharedPreferences: prefs)),
  //     // );
  //   }
  //
  // }
  Future initialise() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permission granted
    } else {
      // Notification permission denied
    }
    iOSPermission();
    // var result= await getCheckNotificationPermStatus();
    // print("result : "+result.toString());

    messaging.getToken().then((token) async {
      print("fcm_id: " + token.toString());
      // SettingProvider settingsProvider =
      // Provider.of<SettingProvider>(context, listen: false);
      // if (settingsProvider.userId != null && settingsProvider.userId != '') {
      //   print("fcm_id: "+token.toString());
      //   _registerToken(token);
      // }
    });

    // const AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('mipmap/ic_launcher');
    //
    // // final DarwinInitializationSettings initializationSettingsDarwin =
    // // DarwinInitializationSettings(
    // //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    //
    // final LinuxInitializationSettings initializationSettingsLinux =
    // LinuxInitializationSettings(defaultActionName: 'Open notification');
    // final InitializationSettings initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid,
    //     // iOS: initializationSettingsDarwin,
    //     linux: initializationSettingsLinux);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //
    //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

// FirebaseMessaging.onBackgroundMessage((message){
//
// } );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final prefs = await SharedPreferences.getInstance();

      final notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;

      if (!notificationsEnabled) {
        return;
      }

      print("onMessage");
      print("message.notification : " + message.notification.toString());
      print("message.data : " + message.data.toString());

      var data = message.notification;

      var title = data!.title.toString();
      var body = data.body.toString();
      var image = message.data['image'] ?? '';
      print("data from message title : " + title.toString());
      print("data from message body : " + body.toString());
      print("data from message body : " + image.toString());
      if (image != null && image != 'null' && image != '') {
        generateImageNotication(
          title,
          body,
          image,
        );
      } else {
        generateSimpleNotication(
          title,
          body,
        );
      }
      /*generateSimpleNotication(
        title,
        body,
      );*/
      // var type = message.data['type'] ?? '';
      // var id = '';
      // id = message.data['type_id'] ?? '';

      // if (type == 'ticket_status') {
      //   // Navigator.push(context,
      //   //     CupertinoPageRoute(builder: (context) =>  CustomerSupport(false)));
      // } else if (type == 'ticket_message') {
      //   // if (CUR_TICK_ID == id) {
      //   //   if (chatstreamdata != null) {
      //   //     var parsedJson = json.decode(message.data['chat']);
      //   //     parsedJson = parsedJson[0];
      //   //
      //   //     Map<String, dynamic> sendata = {
      //   //       'id': parsedJson[ID],
      //   //       'title': parsedJson[TITLE],
      //   //       'message': parsedJson[MESSAGE],
      //   //       'user_id': parsedJson[USER_ID],
      //   //       'name': parsedJson[NAME],
      //   //       'date_created': parsedJson[DATE_CREATED],
      //   //       'attachments': parsedJson['attachments']
      //   //     };
      //   //     var chat = {};
      //   //
      //   //     chat['data'] = sendata;
      //   //     if (parsedJson[USER_ID] != settingsProvider.userId) {
      //   //       chatstreamdata!.sink.add(jsonEncode(chat));
      //   //     }
      //   //   }
      //   // } else {
      //   //   if (image != null && image != 'null' && image != '') {
      //   //     generateImageNotication(title, body, image, type, id);
      //   //   } else {
      //   //     generateSimpleNotication(title, body, type, id);
      //   //   }
      //   // }
      // } else if (image != null && image != 'null' && image != '') {
      //   // generateImageNotication(title, body, image, type, id);
      // } else {
      //   generateSimpleNotication(title, body, type, id);
      // }
    });

    messaging.getInitialMessage().then((RemoteMessage message) async {
          print("onMessage getInitialMessage");
          // print("message.notification : "+message.notification.toString());
          // print("message.data : "+message.data.toString());
          // bool back = await getPrefrenceBool(ISFROMBACK);
          // bool back = await Provider.of<SettingProvider>(context, listen: false)
          //     .getPrefrenceBool(ISFROMBACK);

          // if (message != null && back) {
          if (message != null) {
            var type = message.data['type'] ?? '';
            var id = '';
            id = message.data['type_id'] ?? '';

            if (type == 'products') {
              getProduct(id, 0, 0, true);
            } else if (type == 'categories') {
              Future.delayed(Duration.zero, () {
                // tabController.animateTo(1);
              });
            } else if (type == 'wallet') {
              // Navigator.push(context,
              //     (CupertinoPageRoute(builder: (context) => const MyWallet())));
            } else if (type == 'order') {
              // Navigator.push(context,
              //     (CupertinoPageRoute(builder: (context) => const MyOrder())));
            } else if (type == 'ticket_message') {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //       builder: (context) => Chat(
              //         id: id,
              //         status: '',
              //       )),
              // );
            } else if (type == 'ticket_status') {
              // Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //         builder: (context) =>CustomerSupport(false)));
            } else {
              // Navigator.push(context,
              //     (CupertinoPageRoute(builder: (context) => const Splash())));
            }
            // Provider.of<SettingProvider>(context, listen: false)
            //     .setPrefrenceBool(ISFROMBACK, false);
          }
        } as FutureOr Function(RemoteMessage? value));

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp");
      print("message.notification : " + message.notification.toString());
      print("message.data onMessageOpenedApp: " + message.data.toString());
      print("message.data onMessageOpenedApp: " +
          message.data['type'].toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (message.data != null) {
        var type = message.data['type'] ?? '';
        var id = message.data['id'] ?? '';
        print("message.data type : " + type.toString());
        print("message.data id : " + id.toString());

        if (type.toString() == 'category') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         NewProductListScreen(
          //             category_id:id),
          //   ),
          // );
          // getProduct(id, 0, 0, true);
        } else if (type.toString() == 'product') {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             ProductDetailScreen(
          //                 product_id: id)));
        } else if (type == 'wallet') {
          // Navigator.push(context,
          //     (CupertinoPageRoute(builder: (context) => const MyWallet())));
        } else if (type == 'order') {
          // Navigator.push(context,
          //     (CupertinoPageRoute(builder: (context) => const MyOrder())));
        } else if (type == 'ticket_message') {
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //       builder: (context) => Chat(
          //         id: id,
          //         status: '',
          //       )),
          // );
        } else if (type == 'ticket_status') {
          // Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => CustomerSupport(false)));
        } else {
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //       builder: (context) => MyApp(
          //         sharedPreferences: prefs,
          //       )),
          // );
        }
        // Provider.of<SettingProvider>(context, listen: false)
        //     .setPrefrenceBool(ISFROMBACK, false);
      }
    });
  }

  void iOSPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> getProduct(String id, int index, int secPos, bool list) async {
    try {
      // var parameter = {
      //   ID: id,
      // };
      //
      // Response response =
      // await post(getProductApi, headers: headers, body: parameter)
      //     .timeout(const Duration(seconds: timeOut));
      // var getdata = json.decode(response.body);
      // bool error = getdata['error'];
      // if (!error) {
      //   var data = getdata['data'];
      //
      //   List<Product> items = [];
      //
      //   items = (data as List).map((data) => Product.fromJson(data)).toList();
      //
      //   Navigator.of(context).push(CupertinoPageRoute(
      //       builder: (context) => ProductDetail(
      //         index: int.parse(id),
      //         model: items[0],
      //         secPos: secPos,
      //         list: list,
      //       )));
      // } else {}
    } on Exception {}
  }

  static void myBackgroundMessageHandler(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();

    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    if (!notificationsEnabled) {
      return;
    }

    print("myBackgroundMessageHandler");
    print("message.notification : " + message.notification.toString());
    print("message.data : " + message.data.toString());
    var data = message.notification;
    var title = data!.title.toString();
    var body = data.body.toString();
    generateSimpleNotication(
      title,
      body,
    );
  }
}

Future<String> _downloadAndSaveImage(String url, String fileName) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$fileName';
  var response = await http.get(Uri.parse(url));

  var file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> generateImageNotication(
    String title, String msg, String image) async {
  // var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
  // var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
  // var bigPictureStyleInformation = BigPictureStyleInformation(
  //     FilePathAndroidBitmap(bigPicturePath),
  //     hideExpandedLargeIcon: true,
  //     contentTitle: title,
  //     htmlFormatContentTitle: true,
  //     summaryText: msg,
  //     htmlFormatSummaryText: true);
  // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'big text channel id', 'big text channel name',
  //     channelDescription: 'big text channel description',
  //     largeIcon: FilePathAndroidBitmap(largeIconPath),
  //     styleInformation: bigPictureStyleInformation,
  //     playSound: true);
  // var platformChannelSpecifics =
  // NotificationDetails(android: androidPlatformChannelSpecifics);
  // await flutterLocalNotificationsPlugin
  //     .show(0, title, msg, platformChannelSpecifics,
  //   // payload: type + ',' + id
  // );
}

Future<void> generateSimpleNotication(
  String title,
  String msg,
) async {
  // var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //     'your channel id', 'your channel name',
  //     channelDescription: 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //     playSound: true);
  // // var iosDetail = const IOSNotificationDetails();
  //
  // var platformChannelSpecifics = NotificationDetails(
  //   android: androidPlatformChannelSpecifics, );
  // // android: androidPlatformChannelSpecifics, iOS: iosDetail);
  // await flutterLocalNotificationsPlugin
  //     .show(0, title, msg, platformChannelSpecifics, );
}
