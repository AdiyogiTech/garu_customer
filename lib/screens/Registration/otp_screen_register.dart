import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/helper_widget/authentication_back_widget.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/Registration/controller.dart';
import 'package:garu_customer/screens/Registration/registration_screen.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:garu_customer/screens/constant/validations.dart';
// import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../constant/api.dart';
import '../../helper_widget/auth_textformfield_widget.dart';

class OTPRegister extends StatefulWidget {
  String? mobileNo;
  String? otpData;
  OTPRegister(this.mobileNo, this.otpData, {super.key});

  @override
  State<OTPRegister> createState() => _OTPRegisterState();
}

class _OTPRegisterState extends State<OTPRegister> {
  RegisterController registerController = Get.put(RegisterController());
  @override
  void initState() {
    // TODO: implement initState

    print('mobilwno ... ${widget.mobileNo}');
    setState(() {
      print('inside initState my otp data  ${widget.otpData.toString()}');
      registerController.otpController.text = widget.otpData.toString();
    });
    super.initState();
  }

  bool resendDisable = false;
  bool buttonDisplay = false;
  void Submit() {
    print('Otp is ::..:: }');
    // registerController.call_registerapi();
    if (formKey.currentState!.validate()) {
      print('Otp is ::..::${registerController.otpController.text} }');
      registerController.call_registerapi();
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(() => RegisterPage()); // Back to LoginPage
          return false;
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
                    autofillHints: const [AutofillHints.oneTimeCode],
                    controller: registerController.otpController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validations.validateOtp,
                    IconImage: 'assets/images/mobile_icon.png',
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buttonDisplay == true
                              ? GestureDetector(
                            onTap: resendDisable
                                ? () async {

                              bool success = await registerController.ResendOtp(
                                Uri.parse(sendotp_url),
                                {
                                  "mobile": widget.mobileNo,
                                  "is_register": "1",
                                },
                              );

                              if (success) {
                                setState(() {
                                  resendDisable = false;
                                  buttonDisplay = false;
                                });

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  registerController.countDownController.restart(
                                    duration: 30,
                                  );
                                });
                              }
                            }
                                : null,
                                  child: Text(
                                    resend,
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : CircularCountDownTimer(
                                  width: 40,
                                  height: 40,
                                  controller:
                                      registerController.countDownController,
                                  duration: 30,
                                  fillColor: Colors.white,
                                  ringColor: Colors.transparent,
                                  isReverse: true,
                                  isReverseAnimation: false,
                                  textFormat: CountdownTextFormat.MM_SS,
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      color: primary,
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
                      backgroundColor: primarylogin,
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
