  import 'dart:async';
  import 'dart:convert';
  import 'dart:io';

  import 'package:connectivity_plus/connectivity_plus.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:garu_customer/Environment/Environment.dart';
  import 'package:garu_customer/constant/ApiBaseHelper.dart';
  import 'package:garu_customer/constant/api.dart';
  import 'package:garu_customer/screens/app_update/App_Mentaintion_Mood.dart';
  import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
  import 'package:garu_customer/screens/constant/colors.dart';
  import 'package:garu_customer/screens/location/location_screen.dart';
  import 'package:garu_customer/screens/splash/setting_controller.dart';
  import 'package:garu_customer/screens/splash/setting_controller.dart';

  import '../constant/no_internet_screen.dart';



  class Splash extends StatefulWidget {
    const Splash({super.key});

    @override
    State<Splash> createState() => _SplashState();
  }

  class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
    SettingController settingController = Get.put(SettingController());
    LooocationController locationController = Get.put(LooocationController());
    double radiuschange = 0.8;
    var userlogin;

    getDeviceID() async {
      await ApiBaseHelper().getDeviceId();
    }

    @override
    void initState() {
      super.initState();

      userlogin = Environment.appuserlog;
      getDeviceID();

      checkInternetAndProceed();
    }


    Future<bool> hasInternet() async {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false; // Airplane mode / data off / wifi off
      }

      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        return false; // Network hai but internet nahi
      }
    }

    void checkInternetAndProceed() async {
      bool internet = await hasInternet();

      if (!internet) {
        //No internet → direct No Internet screen
        Get.offAll(() => NoInternetScreen());
      } else {
        // Internet available → splash animation + next flow
        Timer(
          const Duration(seconds: 3),
              () {
            if (!mounted) return;

            setState(() {
              radiuschange = 1.0;
            });

            toNextPage();
          },
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        backgroundColor: primary,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            AnimatedScale(
              scale: 1 * radiuschange,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: CustomPaint(
                painter: WavePainter(),
                child: Container(),
              ),
            ),
            Center(
              child: Container(
                width: 200, // Adjust the width as needed
                height: 200,
                child: Center(
                    child: Image.asset(
                      'assets/images/splashLogo'
                          '.png',
                      scale: 1.3,
                    )),
              ),
            ),
          ],
        ),
      );
    }

    // Future<void> toNextPage() async {
    //
    //       print('inside else pushreplacement');
    //       Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => DeliveryLocation()));
    // }
    Future<void> toNextPage() async {
      print('inside toNextPage');
      print('inside toNextPage  settings_url $settings_url');

      await settingController.SettingData(Uri.parse(settings_url));

      if (setting_json_data == null) {
        print('Error: setting_json_data is null');
        return; // Exit the function if data is not received
      }

      var serverVersion;
      if (Platform.isAndroid) {
        print('inside if ');
        print('inside setting data android ${setting_json_data}');
        serverVersion = setting_json_data?['data']?['settings']?['app_version_android']?.toString() ?? '0.0.0';
      } else {
        print('inside else');
        serverVersion = setting_json_data?['data']?['settings']?['app_version_android']?.toString() ?? '0.0.0';
      }

      if (setting_json_data?['data']?['settings']?['maintenance_toggle']?.toString() == maintainversion) {
        print('inside if maintenance_toggle');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AppMaintanceDialog(
              appupdatetext: setting_json_data?['data']?['settings']?['maintenance']?.toString() ?? 'Maintenance ongoing',
            ),
          ),
        );
      } else if (double.parse(serverVersion) > (Platform.isAndroid ? appversion : iosversion)) {
        print('inside else if iosversion');
        showDialog(
          context: context,
          barrierDismissible: setting_json_data?['data']?['settings']?['force_update_android']?.toString() == App_force_updateNo ? true : false,
          builder: (_) => WillPopScope(
            onWillPop: () async {
              return setting_json_data?['data']?['settings']?['force_update_android']?.toString() == App_force_updateNo ? false : true;
            },
            child: AppUpdateDialog(
              appforceupdate: setting_json_data?['data']?['settings']?['force_update_android']?.toString() ?? '0',
              appupdatetext: setting_json_data?['data']?['settings']?['force_update_message_android']?.toString() ?? 'New update available!',
              appurl: setting_json_data?['data']?['settings']?['app_url_android']?.toString() ?? 'https://example.com',
            ),
          ),
        );
      } else {
        print('inside else splash');
        if (!Get.currentRoute.contains('product-detail')) {
          Get.offAllNamed('/BottomBar');
        }

      }
    }

    // Future<void> toNextPage() async {
    //   print('inside toNextPage');
    //   print('inside toNextPage  settings_url $settings_url');
    //
    //   await settingController.SettingData(Uri.parse(settings_url));
    //
    //   if (setting_json_data == null) {
    //     print('Error: setting_json_data is null');
    //     return; // Exit the function if data is not received
    //   }
    //
    //   var serverVersion;
    //   if (Platform.isAndroid) {
    //     print('inside if ');
    //     print('inside setting data android ${setting_json_data}');
    //     serverVersion = setting_json_data?['data']?['settings']?['app_version_android']?.toString() ?? '0.0.0';
    //   } else {
    //     print('inside else');
    //     serverVersion = setting_json_data?['data']?['settings']?['app_version_android']?.toString() ?? '0.0.0';
    //   }
    //
    //   if (setting_json_data?['data']?['settings']?['maintenance_toggle']?.toString() == maintainversion) {
    //     print('inside if maintenance_toggle');
    //     showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (_) => WillPopScope(
    //         onWillPop: () async {
    //           return false;
    //         },
    //         child: AppMaintanceDialog(
    //           appupdatetext: setting_json_data?['data']?['settings']?['maintenance']?.toString() ?? 'Maintenance ongoing',
    //         ),
    //       ),
    //     );
    //   } else if (double.parse(serverVersion) > (Platform.isAndroid ? appversion : iosversion)) {
    //     print('inside else if iosversion');
    //     showDialog(
    //       context: context,
    //       barrierDismissible: setting_json_data?['data']?['settings']?['force_update_android']?.toString() == App_force_updateNo ? true : false,
    //       builder: (_) => WillPopScope(
    //         onWillPop: () async {
    //           return setting_json_data?['data']?['settings']?['force_update_android']?.toString() == App_force_updateNo ? false : true;
    //         },
    //         child: AppUpdateDialog(
    //           appforceupdate: setting_json_data?['data']?['settings']?['force_update_android']?.toString() ?? '0',
    //           appupdatetext: setting_json_data?['data']?['settings']?['force_update_message_android']?.toString() ?? 'New update available!',
    //           appurl: setting_json_data?['data']?['settings']?['app_url_android']?.toString() ?? 'https://example.com',
    //         ),
    //       ),
    //     );
    //   } else {
    //     print('inside else splash');
    //     if (setting_json_data?['data']?['settings']?['default_address_pincode']?.toString() != "null") {
    //       print('inside else splash splaSH if');
    //       var locationUrl = Uri.parse(location_url);
    //       var locationbody = json.encode({
    //         "pincode": setting_json_data?['data']?['settings']?['default_address_pincode']?.toString()
    //       });
    //       await locationController.SetLocation(locationUrl, locationbody, true);
    //     } else {
    //       print('inside else pushReplacement');
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => DeliveryLocation()),
    //       );
    //     }
    //   }
    // }

  }

  class WavePainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final center = Offset(size.width / 2, size.height / 2);
      final waveRadii = [
        480.0,
        460.0,
        430.0,
        390.0,
        360.0,
        320.0,
        290.0,
        250.0,
        220.0,
        180.0,
        150.0
      ];
      final waveColors = [
        primary,
        primary2,
        primary,
        primary2,
        primary,
        primary2,
        primary,
        primary2,
        primary,
        primary2,
        primary,
      ];

      for (var i = 0; i < waveRadii.length; i++) {
        final waveRadius = waveRadii[i];
        final paint = Paint()
          ..color = waveColors[i]
          ..style = PaintingStyle.fill;

        final wavePath = Path()
          ..addOval(Rect.fromCircle(center: center, radius: waveRadius));

        canvas.drawPath(wavePath, paint);
      }
    }

    @override

    bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
  }
