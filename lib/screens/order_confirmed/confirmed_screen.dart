import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/colors.dart';

class ConfirmedOrderPage extends StatefulWidget {
  const ConfirmedOrderPage({super.key});

  @override
  State<ConfirmedOrderPage> createState() => _ConfirmedOrderPageState();
}

class _ConfirmedOrderPageState extends State<ConfirmedOrderPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Order Confirmed',
        displayCart: false,
        displaySearch: false,
        onBackPressed: () => Get.offAll(() => BottomBar(bottomindex: 2)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(() => BottomBar(bottomindex: 2)); // Back to LoginPage
          return false;
        },
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Animation/Image
                  Container(

                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Image.asset(
                      'assets/images/confirmed.png',
              scale: 2.5,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Order Confirmed Text
                  Text(
                    'YOUR ORDER IS',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'CONFIRMED',
                    style: TextStyle(
                      color: primarylogin,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Thank You Message
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Thanks for your order!',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Done Button
                  GestureDetector(
                    onTap: () {
                      Get.to(BottomBar(bottomindex: 2));
                    },
                    child: Container(
                      width: size.width * 0.6,
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
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Text(
                        'DONE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Order Details Hint
                  Text(
                    'You will receive an order confirmation shortly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}