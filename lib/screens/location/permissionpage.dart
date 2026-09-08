import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/location/location_screen.dart';
import 'package:garu_customer/screens/location/trackinlocationController.dart';
import 'package:get/get.dart';

class PermissionVerification extends StatefulWidget {
  const PermissionVerification({super.key});

  @override
  State<PermissionVerification> createState() => _PermissionVerificationState();
}

class _PermissionVerificationState extends State<PermissionVerification> {
  GetCurrentLocationController getcurrentlocationController =
  Get.put(GetCurrentLocationController());
  LooocationController locationController = Get.find<LooocationController>();

  @override
  void initState() {
    super.initState();
    getcurrentlocationController.getPermissionverification();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = primarylogin;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Verify Location',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<GetCurrentLocationController>(
        builder: (locationController) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: locationController.VerifyMsgstatus.value
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: locationController.VerifyMsgstatus.value
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: locationController.VerifyMsgstatus.value
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          locationController.VerifyMsgstatus.value
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: locationController.VerifyMsgstatus.value
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() => Text(
                          locationController.VerifyMsg.value.capitalize.toString(),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.grey.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await locationController.getPermissionverification();
                          if (locationController.VerifyMsgTitle.value == "Permission" ||
                              locationController.VerifyMsgTitle.value == "Location") {
                            locationController.getPermissionverification();
                          } else {
                            locationController.getPermissionverification();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: locationController.VerifyMsgstatus.value
                                ? Colors.green
                                : Colors.red.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: locationController.VerifyMsgstatusloading.value
                              ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Location Display Section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Obx(() => locationController.isLoadingLocation.value
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Fetching your location...',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Location Icon Animation
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: primaryColor,
                            size: 60,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Location Text
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                'Current Location',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey.shade500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  locationController.address.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: isDark ? Colors.white : Colors.grey.shade800,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              if (locationController.address_pincode.value.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'PIN: ${locationController.address_pincode.value}',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Apply Button
                Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      await getcurrentlocationController.getPermissionverification();
                      if (locationController.VerifyMsgstatus.value == true) {
                        FocusScope.of(context).unfocus();
                        var locationUrl = Uri.parse(location_url);
                        var locationbody = json.encode(
                            {"pincode": locationController.address_pincode.value}
                        );
                        print("apply button ------>" + locationbody.toString());
                        await locationController.SetLocation(
                            locationUrl,
                            locationbody,
                            false
                        );
                      } else {
                        toastMsg(locationController.VerifyMsg.value, false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: locationController.VerifyMsgstatus.value
                          ? primaryColor
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: locationController.VerifyMsgstatus.value ? 2 : 0,
                    ),
                    child: Text(
                      "Apply Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Helper Text
                Center(
                  child: Text(
                    'Make sure your GPS is turned on for accurate location',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}