import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/auth_textformfield_widget.dart';
import 'package:garu_customer/helper_widget/authentication_back_widget.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/Registration/registration_screen.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/controller.dart';
import 'package:garu_customer/screens/login/otp_screen_login.dart';
import 'package:garu_customer/screens/splash/setting_controller.dart';

import 'forget_password.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());
  var OtpAllow ;
  bool viewpass = true;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    getSettings(); // ✅ call API
    loginController.getToken();
  }
  void getSettings() async {
    var settingController = Get.find<SettingController>();

    await settingController.SettingData(Uri.parse(settings_url));

    setState(() {
      OtpAllow = int.tryParse(settingController.isOtpAllow ?? '0') ?? 0;
      print("otpallow>>>>$OtpAllow");
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  WillPopScope(
      onWillPop: () async {
        // Navigate to bottom bar index 2 (Profile)
        Get.offAll(BottomBar(bottomindex: 2,)); // If using named routes
        return false; // Prevent default back behavior
      },
      child: Scaffold(
          body: AuthBackground(
            labelname: login_text,
            space: size.height*0.08,
            childs: Form(
              key: formKey,
              child: Column(
                children: [
                  AuthTextField(
                    hintText: mobile,
                    length: 10,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    controller: loginController.mobileNo,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validations.validateMobile,
                    IconImage: 'assets/images/mobile_icon.png',
                  ),
                  if(OtpAllow == 0)
                    AuthTextField(
                      hintText: password,
                      length: 15,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                       obscure: viewpass,
                      IconImage: 'assets/images/keyIcon.png',
                      Imagescale: 3.2,
                      validator: Validations.validatePassword,
                      controller: loginController.password,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if(viewpass){ //if viewpass == true, make it false
                              viewpass = false;
                            }else{
                              viewpass = true; //if viewpass == false, make it true
                            }
                          });
                        },
                        icon: Icon(
                          viewpass == true
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: primary,
                          size: 24,
                        ),
                      ),
                      hoverColor: Color.fromRGBO(54, 54, 54, 1),
                    ),
                  if(OtpAllow == 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 18,top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Forgot Password',
                              style: TextStyle(
                                  color: primarylogin,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  );
                                },
                            ),
                          ),
                        ],
                      ),
                    ),
                  sizebox_height_30,
                  GestureDetector(
                    onTap: () async {
                      print('inside GestureDetector');
                      if(formKey.currentState!.validate()){
                        print('inside formKey.currentState!.validate()');
                       // Get.to(OTPLogin());
                    //     if(OtpAllow == 1){
                        if(OtpAllow == 0){
                          print('inside GestureDetector OtpAllow==0');
                          print('.password...${OtpAllow.toString()}....');
                          print('.password...${loginController.mobileNo.text}....');

                          print('inside mobileNo ${loginController.mobileNo.text}');
                          print('inside password ${loginController.password.text}');
                          print('inside token ${loginController.token.toString()}');
                          print('inside deviceid ${Environment.deviceid.toString()}');
                          var loginpassUrl = Uri.parse(login_url);
                          var loginPassbody = json.encode({
                            "mobile":loginController.mobileNo.text,
                            "password":loginController.password.text,
                            "fcm_id":loginController.token.toString(),
                            "otp":loginController.loginOTP.toString(),
                            "device_id":Environment.deviceid.toString()
                          });
                          await loginController.LoginApi(loginpassUrl, loginPassbody);
                        }
                        else{
                          print('inside GestureDetector otpAllow==1');
                          print('.Otp...${OtpAllow.toString()}....');
                          print('.Otp...${loginController.mobileNo.text}....');
                          var loginOtpUrl = Uri.parse(sendotp_url);
                          var loginOtpbody = json.encode({
                            "mobile":loginController.mobileNo.text.trim(),
                            "is_register":"0"
                          });
                          print("body for login>>>$loginOtpbody");
                          await loginController.LoginOtpData(loginOtpUrl, loginOtpbody);
                        }
                      }
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: primarylogin,
                      child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: white,
                            size: 55,
                          )),
                    ),
                  ),
                  sizebox_height_20,
                  RichText(
                    text: TextSpan(
                      text: no_account,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: register_text,
                          style: TextStyle(
                              color: primaryn,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  sizebox_height_20,
                ],
              ),
            ),
          )
      ),
    );
  }
}
