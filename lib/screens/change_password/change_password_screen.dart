import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/auth_textformfield_widget.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/change_password/changepass_controller.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:garu_customer/screens/constant/validations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  ChangePassController changePassController = Get.put(ChangePassController());
  final formKey = GlobalKey<FormState>();
  bool oldviewpass = true;
  bool viewpass = true;
  bool cviewpass = true;

  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  Future<void> change() async {
    if(formKey.currentState!.validate()){
      var body = json.encode({
        "old_password": oldpasswordController.text.toString(),
        "password": newpasswordController.text.toString(),
        "password_confirmation": conPasswordController.text.toString()
      });
      await changePassController.ChangeApi(Uri.parse(changepassword_url),body);
    }
  }
  void cancel(){
    print('bsdahjcvbjhsdbvchjsvchjs');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomBar(bottomindex: 2,)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Change Password',
        displayCart: false,
        displaySearch: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primarylogin.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: primarylogin,
                    size: 50,
                  ),
                ),
                // Image.asset('assets/images/logoname.png',filterQuality: FilterQuality.high,color: primarylogin,),

                const SizedBox(height: 40),

                // Old Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AuthTextField(
                    hintText: old_password,
                    length: 15,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscure: oldviewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: Validations.validatePassword,
                    controller: oldpasswordController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: 16,
                    elevation: 0,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          oldviewpass = !oldviewpass;
                        });
                      },
                      icon: Icon(
                        oldviewpass ? Icons.visibility_off : Icons.visibility,
                        color: primarylogin,
                        size: 20,
                      ),
                    ),
                    hoverColor: Color.fromRGBO(54, 54, 54, 1),
                  ),
                ),

                const SizedBox(height: 16),

                // New Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AuthTextField(
                    hintText: newpassword,
                    length: 15,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscure: viewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: Validations.validatePassword,
                    controller: newpasswordController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: 16,
                    elevation: 0,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          viewpass = !viewpass;
                        });
                      },
                      icon: Icon(
                        viewpass ? Icons.visibility_off : Icons.visibility,
                        color: primarylogin,
                        size: 20,
                      ),
                    ),
                    hoverColor: Color.fromRGBO(54, 54, 54, 1),
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AuthTextField(
                    hintText: con_newpassword,
                    length: 15,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscure: cviewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: (value) => Validations.validateConfirmPassword(
                      newpasswordController.text,
                      value!,
                    ),
                    controller: conPasswordController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: 16,
                    elevation: 0,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          cviewpass = !cviewpass;
                        });
                      },
                      icon: Icon(
                        cviewpass ? Icons.visibility_off : Icons.visibility,
                        color: primarylogin,
                        size: 20,
                      ),
                    ),
                    hoverColor: Color.fromRGBO(54, 54, 54, 1),
                  ),
                ),

                const SizedBox(height: 50),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: change,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primarylogin,
                                primarylogin.withOpacity(0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: primarylogin.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: changePassController.ChangeLoading.value
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Change',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: cancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: primarylogin,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primarylogin,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}