import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/auth_textformfield_widget.dart';
import 'package:garu_customer/helper_widget/authentication_back_widget.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/Registration/controller.dart';
import 'package:garu_customer/screens/Registration/otp_screen_register.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import 'package:get/get.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController registerController = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();
  bool viewpass = true;
  bool confirmviewpass = true;

  ///LOGIC FOR registor
  savereg() async {
    if (formKey.currentState!.validate()) {
      var user_name = registerController.nameController.text.trim();
      var user_number = registerController.numberController.text.trim();
      var user_email = registerController.emailController.text.trim().toLowerCase();
      var user_password = registerController.passwordController.text.trim();
      var user_confirm_password = registerController.conPasswordController.text.trim();
      var user_refercode_password = registerController.referController.text.trim();

      // Check if password matches confirm password
      if (user_password != user_confirm_password) {
        print('Error: Password and Confirm Password do not match.');
        // You can also show an error message to the user
        toastMsg('Password and Confirm Password do not match.',false);
        return;
      }

      print('user_name ..:: ${user_name}\n user_number ..:: ${user_number}\n user_email ..:: ${user_email}\n user_password ..:: ${user_password}');

      var body = jsonEncode({
        "name":user_name,
        "email":user_email,
        "mobile": user_number.toString(),
        "password":user_password.toString(),
        "referral_code":user_refercode_password.toString(),
        "is_register": "1"
      });

      await registerController.RegisterOtpData(Uri.parse(sendotp_url), body);
    }
  }

  void clearFields() {
    registerController.nameController.clear();
    registerController.numberController.clear();
    registerController.emailController.clear();
    registerController.passwordController.clear();
    registerController.conPasswordController.clear();
    registerController.referController.clear();

    viewpass = true;
    confirmviewpass = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          clearFields();
        }
      },
      child: Scaffold(
        body: AuthBackground(
            labelname: register_text,
            space: size.height*0.025,
            childs: Form(
              key: formKey,
              child: Column(
                children: [
                  AuthTextField(
                    hintText: name,
                    length: 35,
                    validator: Validations.validateName,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]"))],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    IconImage: 'assets/images/userIcon.png',
                    controller: registerController.nameController,
                  ),
                  AuthTextField(
                    hintText: mobile,
                    validator: Validations.validateMobile,
                    length: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    IconImage:  'assets/images/mobile_icon.png',
                    controller: registerController.numberController,
                  ),

                  AuthTextField(
                    hintText: email,
                    // length: 25,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    IconImage: 'assets/images/ic_email_black.png',
                    controller: registerController.emailController,
                    validator: Validations.validateEmail,
                    Imagescale: 3.5,
                  ),
                  AuthTextField(
                    hintText: password,
                    length: 15,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscure: viewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: Validations.validatePassword,
                    controller: registerController.passwordController,
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
                  AuthTextField(
                    hintText: con_password,
                    length: 15,
                    keyboardType: TextInputType.visiblePassword,
                    validator: Validations.validatePassword,
                    textInputAction: TextInputAction.next,
                    IconImage:  'assets/images/keyIcon.png',
                    controller: registerController.conPasswordController,
                    Imagescale: 3.5,
                    obscure: confirmviewpass,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if(confirmviewpass){ //if viewpass == true, make it false
                            confirmviewpass = false;
                          }else{
                            confirmviewpass = true; //if viewpass == false, make it true
                          }
                        });
                      },
                      icon: Icon(
                        confirmviewpass == true
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: primary,
                        size: 24,
                      ),
                    ),
                    hoverColor: const Color.fromRGBO(54, 54, 54, 1),
                  ),
                  AuthTextField(
                    hintText: 'Referral Code',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    IconImage:  'assets/images/referEarnImage.png',
                    controller: registerController.referController,
                    Imagescale: 3.5,

                    hoverColor: Color.fromRGBO(54, 54, 54, 1),
                  ),
                  sizebox_height_30,
                  GestureDetector(
                    onTap: () async {
                      savereg();
                      // Get.to(OTPRegister());

                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: primarylogin,
                      child: Center(
                          child: Icon(Icons.arrow_forward_ios_rounded,
                            color: white,
                            size: 55,
                          ) ),
                    ),
                  ),
                  sizebox_height_15,
                  RichText(
                    text: TextSpan(
                      text: have_account,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: login_text,
                          style:  TextStyle(
                              color: primaryn,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  LoginPage(),
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
            )),
      ),
    );
  }
}
