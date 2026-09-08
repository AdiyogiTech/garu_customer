import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/auth_textformfield_widget.dart';
import 'package:garu_customer/helper_widget/authentication_back_widget.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/controller.dart';

// import 'package:pinput/pinput.dart';
import 'dart:convert';
import '../../main.dart';
import '../bottom_bar/BottomBar.dart';
import 'controller.dart';

class OTPLogin extends StatefulWidget {
  // const OTPLogin({super.key});
  String? mobileNo;
  String? otpData;
  OTPLogin(this.mobileNo, this.otpData, {super.key});

  @override
  State<OTPLogin> createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  LoginController loginController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();
  bool resendDisable = false ;
  bool buttonDisplay = false ;


  void _registerForegroundMessageHandler() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print(" --- foreground message received ---");
      print(remoteMessage.notification!.title);
      print(remoteMessage.notification!.body);
      var title = remoteMessage.notification!.title;
      var body = remoteMessage.notification!.body;
      _showNotification(title,body);
      // Get.snackbar(title,body);
    });
  }

  Future<void> _showNotification(titles,bodys) async {
    // // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    // var androidPlatformChannelSpecifics =   AndroidNotificationDetails(
    //   'your channel id',
    //   'your channel name',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   ticker: 'ticker',
    //   playSound: true,
    //   fullScreenIntent: true, // If needed
    //   enableVibration: true,
    //   setAsGroupSummary: true,
    //   styleInformation: DefaultStyleInformation(true, true),
    //   // additionalFlags: Int32List.fromList(<int>[4]), // FLAG_IMMUTABLE
    // );
    //
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics);
    //
    // // android: androidPlatformChannelSpecifics, iOS: iosDetail);
    // await flutterLocalNotificationsPlugin.show(0, titles, bodys, NotificationDetails(android: androidPlatformChannelSpecifics), );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerForegroundMessageHandler();
    setState(() {
      loginController.loginOTP.text = widget.otpData.toString()  ;
    });
  }

  Future<void> Submit() async {
    print('inside logincontroller submit ${loginController.token}');

    final body = {
      "mobile": loginController.mobileNo.text.trim(),
      "otp": loginController.loginOTP.text.trim(),
      "fcm_id": loginController.token,
      "password": loginController.password.text.trim(), // ✅ VERY IMPORTANT
      "device_id": Environment.deviceid.toString(),
    };

    print("Loginbody---->> ${jsonEncode(body)}");

    // ❌ DO NOT expect a bool
    await loginController.LoginApi(
      Uri.parse(login_url),
      jsonEncode(body),
    );
  }

  Future<void> resendOtp() async {
    setState(() {
      resendDisable = false;
      buttonDisplay = false;
    });
    var body =json.encode({
      "mobile": widget.mobileNo.toString(),
      "is_register": "0"
    });
    print(' body ... ${body}');
    print(widget.mobileNo);
    await loginController.ResendOtp(Uri.parse(sendotp_url),body);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Get.offAll(() => LoginPage()); // Back to LoginPage

          return true;
        },
        child: AuthBackground(
            labelname: enter_otp,
            space: size.height*0.1,
            childs: Form(
              key: formKey,
              child: Column(
                children: [
                  sizebox_height_10,
                  AuthTextField(
                    hintText: "Otp",
                    length: 6,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    controller: loginController.loginOTP,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofillHints: const [AutofillHints.oneTimeCode],
                    validator: Validations.validateOtp,
                    IconImage: 'assets/images/mobile_icon.png',
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buttonDisplay == true ?
                          GestureDetector(
                            onTap: resendDisable
                                ? () {
                              resendOtp();
                            } : null,
                            child: Text(
                              resend,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ) :
                          CircularCountDownTimer(
                            width: 40,
                            height: 40,
                            // controller: loginController.countDownController,
                            duration: 30,
                            fillColor: Colors.white,
                            ringColor: Colors.transparent,
                            isReverse: true,
                            isReverseAnimation: false,
                            textFormat: CountdownTextFormat.MM_SS,
                            textStyle:  TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),

                            // onStart: () {
                            // },
                            onComplete: () {
                              setState(() {
                                resendDisable = true;
                                buttonDisplay = true;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  sizebox_height_20,
                  GestureDetector(
                    onTap: () {
                      Submit();
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: primary3,
                      child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: white,
                            size: 55,
                          )),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
