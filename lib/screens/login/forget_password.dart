import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/api.dart';
import '../../helper_widget/auth_textformfield_widget.dart';
import '../../helper_widget/authentication_back_widget.dart';
import '../../helper_widget/sized_box.dart';
import '../Registration/registration_screen.dart';
import '../bottom_bar/BottomBar.dart';
import '../constant/colors.dart';
import '../constant/strings.dart';
import '../constant/validations.dart';
import 'controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  LoginController loginController = Get.put(LoginController());
  bool viewpass = true;
  bool confirmviewpass = true;
  final formKey = GlobalKey<FormState>();

  // New variables for OTP flow
  bool isOTPSent = false;
  bool isLoading = false;
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(LoginPage());
        return false;
      },
      child: Scaffold(
        body: AuthBackground(
          labelname: "Forget Password",
          space: size.height * 0.08,
          childs: Form(
            key: formKey,
            child: Column(
              children: [
                // Mobile Number Field
                AuthTextField(
                  hintText: mobile,
                  length: 10,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validations.validateMobile,
                  IconImage: 'assets/images/mobile_icon.png',
                  controller: loginController.resetMobileNo,
                ),

                // Send OTP Button or OTP Field based on state
                if (!isOTPSent)
                  _buildSendOtpButton()
                else
                  _buildOtpAndPasswordFields(),

                sizebox_height_20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return Column(
      children: [
        sizebox_height_10,
        GestureDetector(
          onTap: isLoading ? null : _sendOTP,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            decoration: BoxDecoration(
              color: primarylogin,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator(color: white)
                  : Text(
                "Send OTP",
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        sizebox_height_20,
        // Back to Login
        RichText(
          text: TextSpan(
            text: "Remember password? ",
            style: TextStyle(color: Colors.black54, fontSize: 14),
            children: [
              TextSpan(
                text: "Login",
                style: TextStyle(
                  color: primarylogin,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.offAll(LoginPage());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpAndPasswordFields() {
    return Column(
      children: [
        // OTP Field
        AuthTextField(
          hintText: "Enter OTP",
          length: 6,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter OTP";
            }
            if (value.length < 6) {
              return "Please enter valid 6 digit OTP";
            }
            return null;
          },
          IconImage: 'assets/images/mobile_icon.png',
          controller: otpController,
        ),

        // Resend OTP
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     TextButton(
        //       onPressed: _resendOTP,
        //       child: Text(
        //         "Resend OTP",
        //         style: TextStyle(color: primarylogin),
        //       ),
        //     ),
        //   ],
        // ),

        // New Password Field
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
          controller: loginController.resetPassword,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                viewpass = !viewpass;
              });
            },
            icon: Icon(
              viewpass ? Icons.visibility_off : Icons.visibility,
              color: primary,
              size: 24,
            ),
          ),
          hoverColor: Color.fromRGBO(54, 54, 54, 1),
        ),

        // Confirm Password Field
        AuthTextField(
          hintText: con_password,
          length: 15,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please confirm your password";
            }
            if (value != loginController.resetPassword.text) {
              return "Passwords do not match";
            }
            return Validations.validatePassword(value);
          },
          textInputAction: TextInputAction.next,
          IconImage: 'assets/images/keyIcon.png',
          controller: loginController.confirmPassword,
          Imagescale: 3.5,
          obscure: confirmviewpass,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                confirmviewpass = !confirmviewpass;
              });
            },
            icon: Icon(
              confirmviewpass ? Icons.visibility_off : Icons.visibility,
              color: primary,
              size: 24,
            ),
          ),
          hoverColor: const Color.fromRGBO(54, 54, 54, 1),
        ),

        sizebox_height_30,

        // Reset Password Button
        GestureDetector(
          onTap: isLoading ? null : _resetPassword,
          child: CircleAvatar(
            radius: 35,
            backgroundColor: primarylogin,
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator(color: white)
                  : Icon(
                Icons.arrow_forward_ios_rounded,
                color: white,
                size: 55,
              ),
            ),
          ),
        ),

        sizebox_height_20,
      ],
    );
  }

  // Send OTP Method
  void _sendOTP() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Call Send OTP API
      var parameter = json.encode({
        'mobile': loginController.resetMobileNo.text.trim(),
        "is_register":"0"
      });

      await loginController. sendForgotOtpApi(
        Uri.parse(sendotp_url), // Replace with actual endpoint
        parameter,
      );

      // Check if OTP sent successfully
      if (loginController.OTPData != null &&
          loginController.OTPData['status'] == true) {
        setState(() {
          isOTPSent = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error sending OTP: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

/*  // Resend OTP Method
  void _resendOTP() async {
    setState(() {
      isLoading = true;
    });

    try {
      var parameter = {
        'mobile': loginController.resetMobileNo.text,
      };

      await loginController.ResendOtp(
        'your-resend-otp-endpoint', // Replace with actual endpoint
        parameter,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error resending OTP: $e");
      setState(() {
        isLoading = false;
      });
    }
  }*/

  // Reset Password Method
  void _resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      var parameter = json.encode({
        'mobile': loginController.resetMobileNo.text.trim(),
        'otp': otpController.text.trim(),
        'password': loginController.resetPassword.text.trim(),
        'password_confirmation': loginController.confirmPassword.text.trim(),
      });

      await loginController.resetPasswordApi(
       Uri.parse(resetpassword_url), // Replace with actual endpoint
        parameter,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error resetting password: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
}