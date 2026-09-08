import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import 'package:garu_customer/screens/splash/setting_controller.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateDialog extends StatefulWidget {
  var appupdatetext;
  var appforceupdate;
  var appurl;
  // const AppUpdateDialog({super.key});
  AppUpdateDialog({this.appupdatetext, this.appforceupdate, this.appurl});

  @override
  State<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  @override
  void initState() {
    super.initState();
    print("widget.appupdatetext  ${widget.appupdatetext}");
    print("appforceupdate  ${widget.appforceupdate}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  var userlogin;
  SettingController settingController = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: white
            // gradient: LinearGradient(
            //   colors: [primaryColor, primaryColor],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(
              //   Icons.update,
              //   size: 60,
              //   color: Colors.white,
              // ),

              Image.asset(
                "assets/images/appbar_img.png",
                color: primary,
              ),
              SizedBox(height: 20),
              Text(
                appname,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 0.5),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.appupdatetext}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        StoreRedirect.redirect(
                            androidAppId: widget.appurl.toString(),
                            iOSAppId: "585027354");
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.purple, backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Go To Playstore',
                        style: TextStyle(color: primary),
                      ),
                    ),
                  ),
                  widget.appforceupdate == "1"
                      ? Container()
                      : Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                userlogin = Environment.appuserlog;
                                print("userlogin...." + userlogin.toString());
                                // var settingUrl = apiUrls().setting_api;
                                // print("settingUrl....."+settingUrl.toString());
                                // settingController.GetSettingData(settingUrl);
                                await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => userlogin == true
                                            ? BottomBar(
                                                bottomindex: 2,
                                              )
                                            : LoginPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.purple,
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Continue',
                                style: TextStyle(color: primary),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppMaintanceDialog extends StatefulWidget {
  var appupdatetext;
  AppMaintanceDialog({this.appupdatetext});
  @override
  _AppMaintanceDialogState createState() => _AppMaintanceDialogState();
}

class _AppMaintanceDialogState extends State<AppMaintanceDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: white
            // gradient: LinearGradient(
            //   colors: [primaryColor, primaryColor],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  // color: black,
                  child: Image.asset(
                    "assets/images/appbar_img.png",
                    color: primary,
                  ),
                ),
              ),
              SizedBox(height: 25),
              // Text(apiUrls().appmaintancename,
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black,
              //       letterSpacing: 0.5
              //   ),
              // ),
              SizedBox(height: 25),
              Text(
                '${widget.appupdatetext}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
