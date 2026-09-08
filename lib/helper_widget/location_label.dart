import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/location/location_screen.dart';
import 'package:garu_customer/screens/location/permissionpage.dart';
import '../screens/here_map/location_controller.dart';

class LocationLabel extends StatefulWidget {
  const LocationLabel({super.key});

  @override
  State<LocationLabel> createState() => _LocationLabelState();
}

class _LocationLabelState extends State<LocationLabel> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  bool pinUi = false;
  bool isLoading = false;
  final LooocationController locationController = Get.find<LooocationController>();
  TextEditingController pinCodeController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? pinCodeError;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  void showUi() {
    setState(() {
      pinUi = true;
      pinCodeError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = primarylogin;

    return GetBuilder<LooocationController>(
      builder: (locationController) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () {
              setState(() {
                pinUi = false;
                pinCodeController.clear();
                pinCodeError = null;
              });
              _showLocationBottomSheet(context, size);
            },
            child: Container(
              width: size.width,
             /* decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  width: 1,
                ),
              ),*/
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        (locationController.getcityname?.isNotEmpty ?? false)
                            ? "${locationController.getcityname} ${locationController.getpincode ?? ''}"
                            : "Select Delivery Location",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Change',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: primaryColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLocationBottomSheet(BuildContext context, Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = primarylogin;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black87.withOpacity(0.6),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext buildContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: formKey,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Handle
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      pinUi == false
                          ? _buildMainContent(context, size, stateSetter)
                          : _buildPinContent(context, size, stateSetter),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, Size size, StateSetter stateSetter) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = primarylogin;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Delivery Location',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to set your delivery location',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Enter Pincode Option
          _buildOptionCard(
            icon: Icons.pin_drop_outlined,
            title: 'Enter Pincode',
            subtitle: 'Enter your area pincode manually',
            onTap: () {
              stateSetter(() {
                showUi();
              });
            },
            primaryColor: primaryColor,
          ),

          const SizedBox(height: 12),

          // Detect Location Option
          _buildOptionCard(
            icon: Icons.location_searching,
            title: 'Detect My Location',
            subtitle: 'Use GPS to find your current location',
            onTap: () async {
              Navigator.pop(context);
              LocationPermission permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                Get.to(() => const PermissionVerification());
                return;
              }
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                Get.to(() => const PermissionVerification());
              } else if (permission == LocationPermission.deniedForever) {
                Get.snackbar(
                  "Permission Required",
                  "Please enable location permission from settings.",
                );
                await Geolocator.openAppSettings();
              } else {
                toastMsg("Location permission denied", false);
              }
            },
            primaryColor: primaryColor,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPinContent(BuildContext context, Size size, StateSetter stateSetter) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = primarylogin;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enter Pincode',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    pinUi = false;
                    pinCodeError = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Enter PIN code to see product availability, offers and discounts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // PIN Code Input with Validation
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: pinCodeError != null ? Colors.red : Colors.grey.shade200,
                    width: pinCodeError != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: pinCodeError != null ? Colors.red : primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: pinCodeController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          setState(() {
                            pinCodeError = null;
                          });
                          // Real-time validation
                          if (value.isNotEmpty && value.length == 6) {
                            // Auto-validate when 6 digits are entered
                          }
                        },
                        onFieldSubmitted: (value) {
                          _handleApply(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pincode';
                          }
                          if (value.length != 6) {
                            return 'Pincode must be 6 digits';
                          }
                          if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                            return 'Enter a valid 6-digit pincode';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your pincode',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                            fontSize: 0,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _handleApply(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Error Message
              if (pinCodeError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        pinCodeError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Back button
          GestureDetector(
            onTap: () {
              setState(() {
                pinUi = false;
                pinCodeError = null;
                pinCodeController.clear();
              });
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.grey.shade600, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleApply(BuildContext context) {
    FocusScope.of(context).unfocus();

    // Manual validation
    String pinCode = pinCodeController.text.trim();

    if (pinCode.isEmpty) {
      setState(() {
        pinCodeError = 'Please enter pincode';
      });
      return;
    }

    if (pinCode.length != 6) {
      setState(() {
        pinCodeError = 'Pincode must be 6 digits';
      });
      return;
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(pinCode)) {
      setState(() {
        pinCodeError = 'Enter a valid 6-digit pincode';
      });
      return;
    }

    // If validation passes
    setState(() {
      pinCodeError = null;
      isLoading = true;
    });

    // Call API
    _submitPincode(context);
  }

  Future<void> _submitPincode(BuildContext context) async {
    try {
      Navigator.pop(context);
      var locationUrl = Uri.parse(location_url);
      var locationbody = json.encode({
        "pincode": pinCodeController.text.trim()
      });
      await locationController.SetLocation(locationUrl, locationbody, false);
      setState(() {
        isLoading = false;
        pinUi = false;
        pinCodeController.clear();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        pinCodeError = 'Something went wrong. Please try again.';
      });
    }
  }
}