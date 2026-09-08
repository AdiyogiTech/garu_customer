import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({super.key});

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  void referFriend(){
    print('Share this link with your friend and after they install,'
        ' both of you will get ₹50 cash rewards');
  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: HelperAppBar(
        title: 'Refer & Earn',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding:  EdgeInsets.all(30.0),
                child: Image.asset('assets/images/referEarnImage.png',scale: 2,),
              ),
            ),
            Text(
              'Refer to your friend \nand Get a cash reward of \$50'.toUpperCase(),
              style: TextStyle(
                  color: primaryn,
                  fontSize: 18,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,

            ),
            sizebox_height_10,
            Text(
              'Share this link with your friend and after they install, \nboth of you will get ₹50 cash rewards'.toUpperCase(),
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 9,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,

            ),
            sizebox_height_40,
            DottedBorder(
              padding: EdgeInsets.all(12),
              radius: Radius.circular(8),
              borderType: BorderType.RRect,
              color: grey,
              child: Container(
                width: size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width * 0.3,
                      alignment: Alignment.center,
                      child: Text('GA474',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 20,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    sizebox_width_10,
                    Icon(Icons.copy,color: primaryn,),
                    sizebox_width_15,
                  ],
                ),
              ),

            ),
            sizebox_height_50,
            GestureDetector(
              onTap: (){
                referFriend();
              },
              child: Container(
                width: size.width,
                color: primaryn,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Refer Friend',
                  style: TextStyle(
                    color: Colors.white,fontWeight: FontWeight.w700,fontSize: 18,letterSpacing: 0.2,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
