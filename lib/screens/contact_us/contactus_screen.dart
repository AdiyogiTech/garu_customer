import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/api.dart';
import 'contactUsController.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  ContactUsController contactController = Get.put(ContactUsController());

  @override
  void initState() {
    super.initState();
    // contactController.contactAPICall(Uri.parse("https://garu_customer.com/api/customer/settings"));
    contactController.contactAPICall(Uri.parse("${baseurl}settings"));
    // contactController.contactAPICall(Uri.parse("https://staging.adiyogitechnology.com/garu_customer/api/customer/settings"));
  }

  void callPhoneNumber() async {
    final Uri phoneUri = Uri(
        scheme: 'tel',
        path: contactController.contactUsData["phone"].toString());
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch phone dialer');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer.')),
      );
    }
  }

  void sendEmail() async {
    final Uri url = Uri.parse(
        'mailto:${contactController.contactUsData["email"].toString()}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch email.')));
      throw 'Could not launch $url';
    }
  }

  void openMap() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${contactController.contactUsData["address"].toString()}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperAppBar(
          title: 'Contact Us',
          displayCart: false,
          displaySearch: false,
        ),
        body: GetBuilder<ContactUsController>(
          init: ContactUsController(),
          builder: (controller) {
            log(contactController.contactUsData["address"].toString());
            if (controller.contactUsLoader.value == true) {
              return Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/contact_us.png',
                        scale: 1,
                      ),
                    ),
                    sizebox_height_20,
                    ContactInfo(
                      icon: Icons.phone_in_talk_rounded,
                      text: contactController.contactUsData["phone"].toString(),
                      onTap: callPhoneNumber,
                    ),
                    ContactInfo(
                      icon: Icons.email,
                      text: contactController.contactUsData["email"].toString(),
                      onTap: sendEmail,
                    ),
                    ContactInfo(
                      icon: Icons.location_on,
                      text:
                          contactController.contactUsData["address"].toString(),
                      onTap: openMap,
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget ContactInfo({IconData? icon, String? text, void Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                        BorderSide(width: 2, color: primaryn))),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    size: 30,
                    color: primaryn,
                  ),
                ),
              ),
              sizebox_width_10,
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  text!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
