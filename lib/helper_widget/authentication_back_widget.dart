import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';

class AuthBackground extends StatelessWidget {
  final String labelname;
  final Widget childs;
  final double? space;

  const AuthBackground({
    super.key,
    required this.labelname,
    required this.childs,
     this.space,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/images/loginBackground.png",
            height: size.height,
            width: size.width,
            fit: BoxFit.cover,
          ),


          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    "assets/images/logoname.png",
                    color: primarylogin,
                    scale: 1.3,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: space ??  size.height * 0.09),

                  // Card Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: size.width * 0.075,
                    horizontal: size.width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.20),
                          offset: const Offset(3, 3),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          labelname.toUpperCase(),
                          style: TextStyle(
                            color: primarylogin,
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: size.height * 0.025),

                        // Child Widget
                        childs,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';


class AuthBackground extends StatelessWidget {
  final String labelname;
  final Widget childs;

  AuthBackground({
    super.key,
    required this.labelname,
    required this.childs
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/loginBackground.png'),
            fit: BoxFit.fill
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/bacgroundrings.png'),
                        fit: BoxFit.fill
                    ),
                  ),
                 //  child: Container(
                 //    width: 100, // set your desired width
                 //    height: 54, // set your desired height
                 //    child: Image.asset('assets/images/logoname.png',
                 //      fit: BoxFit.contain,
                 // ),
                 //  ),
                  child: Center(
                    child: Transform.scale(
                      scale: 1.4,
                      child: Image.asset(
                        'assets/images/logoname.png',
                        width: 200,
                        height: 54,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 30,
                  right: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: secondary,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        labelname!.toUpperCase(),
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            sizebox_height_40,
            childs,
          ],
        ),
      ),
    );
  }
}*/
