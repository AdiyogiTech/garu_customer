 import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garu_customer/screens/auctions/auction_about_screen.dart';
import 'package:garu_customer/screens/auctions/controller/auctions_controller.dart';
import 'package:garu_customer/screens/home/dashboard_controller.dart';
import 'package:garu_customer/screens/location/location_screen.dart';
import 'package:garu_customer/screens/location/trackinlocationController.dart';
import 'package:garu_customer/screens/remedies/controller/remedies_controller.dart';
import 'package:garu_customer/screens/remedies/remedies_about_screen.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/firebase_options.dart';
import 'package:garu_customer/screens/add_to_cart/add_to_cart_screen.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/product_details/product_detail_screen.dart';
import 'package:garu_customer/screens/pushNotification_service.dart';
import 'package:garu_customer/screens/splash/setting_controller.dart';
import 'package:garu_customer/screens/splash/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
 @pragma('vm:entry-point')
 void downloadCallback(String id, int status, int progress) {
   if (status == DownloadTaskStatus.complete) {
     print("Download Completed");

   }

   if (status == DownloadTaskStatus.failed) {
     print("Download Failed");
   }
 }
SharedPreferences? prefs;

/// Local Notification Instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Firebase Messaging background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  PushNotificationServicePage.myBackgroundMessageHandler(message);

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  print('Handling a background message ${message.messageId}');
}

/// Firebase Messaging foreground handler
void _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(
    LooocationController(),
    permanent: true,
  );

  Get.put(
    GetCurrentLocationController(),
    permanent: true,
  );
  Get.put(
    HomeController(),
    permanent: true,
  );

/*  Get.put(
    AuctionController(),
    permanent: true,
  );

  Get.put(
    RemediesController(),
    permanent: true,
  );*/

  await MediaStore.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  FlutterDownloader.registerCallback(downloadCallback);
  Get.put(SettingController(), permanent: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Local notification init
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // await ScreenProtector.preventScreenshotOn();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

  prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: Environment.filename);
  _initializeHERESDK();
  MediaStore.appFolder = "PDF";
  runApp(MyApp());
}
Future<void> getFCMToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM TOKEN: $token");
  } catch (e) {
    debugPrint("FCM ERROR: $e");
  }
}
Future<void> _initializeHERESDK() async {
  SdkContext.init(IsolateOrigin.main);

  String accessKeyId = "O0ZcdP66pLZArin-tWNQmQ";
  String accessKeySecret =
      "K7ynA1NJyByD_Srkfe4sUJ5rJDlasbTjeXqa9y9AIScAoO_1L0oQArxtNLeQUSDKEXTL20SrxFd7cehASdnMYw";

  SDKOptions sdkOptions = SDKOptions.withAuthenticationMode(
      AuthenticationMode.withKeySecret(accessKeyId, accessKeySecret));

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } catch (e) {
    throw Exception("Failed to initialize HERE SDK: $e");
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  bool _handled = false;
  StreamSubscription<Uri>? _sub;
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }


/*  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    _appLinks = AppLinks();

    // Background / foreground
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null && !_handled) {
        _handled = true;
        handleDeepLink(uri);
      }
    });

    _appLinks.getInitialAppLink().then((uri) {
      if (uri != null && !_handled) {
        _handled = true;
        handleDeepLink(uri);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      getFCMToken();
    });
  }*/


/*  void handleDeepLink(Uri uri) {
    print("Deep Link: $uri");

    if (uri.pathSegments.contains("product-detail")) {

      String lastSegment = uri.pathSegments.last;
      String productId = lastSegment.split('--').last;

      Get.offAllNamed('/BottomBar');
      Get.toNamed('/product-detail/$productId');
    }
  }*/

  @override
  void initState() {
    super.initState();

    requestNotificationPermission();

    _appLinks = AppLinks();

    // App already running / background
    _sub = _appLinks.uriLinkStream.listen((uri) {
      handleDeepLink(uri);
    });

    // App completely closed
    _appLinks.getInitialAppLink().then((uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      getFCMToken();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void handleDeepLink(Uri uri) {
    print("Deep Link: $uri");
    print("Path: ${uri.path}");

    // ================= PRODUCT DETAIL =================
    if (uri.pathSegments.contains("product-detail")) {
      String lastSegment = uri.pathSegments.last;
      String productId = lastSegment.split('--').last;

      Get.offAllNamed('/BottomBar');

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed('/product-detail/$productId');
      });

      return;
    }

    // ================= GARU VAULT ABOUT =================
    if (uri.path == "/the-garu-vault-items") {
      Get.offAllNamed('/BottomBar');

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed('/auction');
      });

      return;
    }


    // ================= dadi-nani-ke-nuskhe =================
    if (uri.path == "/dadi-nani-ke-nuskhe") {
      Get.offAllNamed('/BottomBar');

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed('/remedies');
      });

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return SafeArea(
          top: false, // 👈 sirf bottom safe
          child: MediaQuery(
              data: mediaQueryData.copyWith(
                textScaleFactor: mediaQueryData.textScaleFactor.clamp(0.9, 1.1),
              ),
              child: child!),
        );
      },
      initialRoute: '/splash',

      getPages: [

        GetPage(
          name: '/splash',
          page: () => Splash(),
        ),

        GetPage(
          name: '/BottomBar',
          page: () => BottomBar(),
        ),

        GetPage(
          name: '/AddToCartPage',
          page: () => AddToCartPage(),
        ),

        GetPage(
          name: '/product-detail/:slug',
          page: () => ProductDetails(
            product_id: Get.parameters['slug'],
          ),
        ),

        GetPage(
          name: '/auction',
          page: () => BottomBar(bottomindex: 1,),
        ),

        GetPage(
          name: '/remedies',
          page: () => BottomBar(bottomindex: 3,),
        ),

      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primarylogin,
        ),
      ),
      title: 'Garu',
      home: const Splash(),
    );
  }
}


