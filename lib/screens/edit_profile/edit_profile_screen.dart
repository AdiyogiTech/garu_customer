import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/auth_textformfield_widget.dart';
import 'package:garu_customer/main.dart';
import 'package:garu_customer/screens/Profile/profile_controller.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ProfileController profileController = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();

  TextEditingController editname = TextEditingController();
  TextEditingController editmobile = TextEditingController();
  TextEditingController editemail = TextEditingController();
  TextEditingController editdob = TextEditingController();
  TextEditingController editAnniversary = TextEditingController();

  var editImage;
  bool isProfileLoaded = false;

  Future<void> selectDate({
    required TextEditingController controller,
  }) async {
    DateTime initialDate = DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(controller.text);
      } catch (_) {}
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primarylogin,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.year.toString().padLeft(4, '0')}-"
            "${pickedDate.month.toString().padLeft(2, '0')}-"
            "${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    editmobile.addListener(_mobileListener);
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      var profileUrl = Uri.parse(profile_url);
      await profileController.GetProfile(profileUrl);
      var profileData = profileController.ProfileData['data'];

      profileController.isNumberChanged(false);
      profileController.isOtpSent(false);
      profileController.isOtpVerified(false);
      profileController.otpController.clear();

      updateFields(profileData);
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  void _mobileListener() {
    if (!isProfileLoaded) return;

    final isChanged = editmobile.text != originalMobile;

    profileController.isNumberChanged.value = isChanged;

    if (isChanged) {
      profileController.isOtpSent(false);
      profileController.isOtpVerified(false);
      profileController.otpController.clear();
    }
  }

  void updateFields(Map<String, dynamic> profileData) {
    setState(() {
      editname.text = profileData['name'] ?? '';
      editmobile.text = profileData['mobile'] ?? '';
      editemail.text = profileData['email'] ?? '';
      editdob.text = profileData['dob'] != null
          ? DateFormat('dd MMM yyyy').format(
              DateTime.parse(profileData['dob'].toString()),
            )
          : '';

      editAnniversary.text = profileData['anniversary_date'] != null
          ? DateFormat('dd MMM yyyy').format(
              DateTime.parse(profileData['anniversary_date'].toString()),
            )
          : '';
      editImage = profileData['image'] ?? '';

      originalMobile = profileData['mobile'] ?? '';
      isProfileLoaded = true;
    });
  }

  bool? editLoader;

  multipartAPICall(url, parameter) async {
    print("inside post url : $url");
    print("inside post parameter : $parameter");

    var token = prefs!.getString("token");

    print("get token : $token");
    var mainHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll(parameter);

      request.headers.addAll(mainHeaders);

      if (imgpath != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', imageCapture!.path));
      } else {}

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);
      print("inside response body...." + responsedata.toString());
      final result = jsonDecode(responsedata.body);

      if (responsedata.statusCode == 200) {
        if (result['status'] == true) {
          var profileUrl = Uri.parse(profile_url);
          Get.find<ProfileController>().GetProfile(profileUrl);

          Get.off(BottomBar(
            bottomindex: 4,
          ));
          toastMsg(result['message'].toString(), true);
        } else {
          toastMsg(result['message'].toString(), false);
        }
      } else {
        var msg = result['data'];
        if (msg['name'] != null) {
          toastMsg(msg['name'].toString(), false);
        } else if (msg['mobile'] != null) {
          toastMsg(msg['mobile'].toString(), false);
        } else if (msg['email'] != null) {
          toastMsg(msg['email'].toString(), false);
        }
      }

      print("post statusCode : ${responsedata.statusCode.toString()}");
      print("post response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  final CropController _cropController = CropController();

  Uint8List? _selectedImageBytes;
  File? imageCapture;
  String? imgpath;

  Future<void> pickImageFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes!;
      });

      openCropper();
    }
  }

  void openCropper() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Crop Image',
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              // Crop Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primarylogin.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Crop(
                        image: _selectedImageBytes!,
                        controller: _cropController,
                        aspectRatio: 1,
                        onCropped: (croppedData) async {
                          final tempDir = Directory.systemTemp;
                          final file = await File(
                            '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png',
                          ).writeAsBytes(croppedData);

                          setState(() {
                            imageCapture = file;
                            imgpath = file.path;
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _cropController.crop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarylogin,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 4,
                          shadowColor: primarylogin.withOpacity(0.3),
                        ),
                        child: const Text(
                          "Crop & Save",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isImageCaptured = false;
  String originalMobile = '';

  @override
  void dispose() {
    editmobile.removeListener(_mobileListener);

    profileController.otpController.clear();
    profileController.isOtpSent(false);
    profileController.isOtpVerified(false);
    profileController.isNumberChanged(false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: HelperAppBar(
        title: 'Edit Profile',
        displayCart: false,
        displaySearch: false,
        backgroundColor: Colors.transparent,
        titleColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Profile Image Section with Gradient Background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primarylogin.withOpacity(0.08),
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Image Container with Glow Effect
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primarylogin.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: imageCapture != null
                                    ? Image.file(
                                        imageCapture!,
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      )
                                    : (editImage != null &&
                                            editImage.toString().isNotEmpty
                                        ? Image.network(
                                            editImage.toString(),
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/errorImage.png',
                                                width: 130,
                                                height: 130,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            'assets/images/errorImage.png',
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                          ),
                          // Camera Button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [primarylogin, primary],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primarylogin.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  pickImageFromGallery();
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      editname.text.isNotEmpty ? editname.text : "Your Name",
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: primarylogin.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: primarylogin,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Member',
                            style: TextStyle(
                              color: primarylogin,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Fields Container
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Name Field with Icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: AuthTextField(
                        hintText: name,
                        length: 35,
                        validator: Validations.validateName,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z ]"))
                        ],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        IconImage: 'assets/images/userIcon.png',
                        Imagescale: 3,
                        controller: editname,
                        borderColor: Colors.transparent,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Mobile Field with OTP Button
                    Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AuthTextField(
                                    hintText: mobile,
                                    validator: Validations.validateMobile,
                                    length: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.phone,
                                    IconImage: 'assets/images/mobile_icon.png',
                                    controller: editmobile,
                                    borderColor: Colors.transparent,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                  ),
                                ),
                                if (profileController.isNumberChanged.value)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, top: 6, bottom: 6),
                                    child: GestureDetector(
                                      onTap: (profileController
                                                  .isOtpSent.value ||
                                              profileController
                                                  .otpLoading.value)
                                          ? null
                                          : () {
                                              if (editmobile.text.length ==
                                                  10) {
                                                profileController
                                                    .sendOtp(editmobile.text);
                                              } else {
                                                toastMsg(
                                                    "Enter valid mobile number",
                                                    false);
                                              }
                                            },
                                      child: Container(
                                        height: 44,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          gradient:
                                              profileController.isOtpSent.value
                                                  ? null
                                                  : LinearGradient(
                                                      colors: [
                                                        primarylogin,
                                                        primary
                                                      ],
                                                    ),
                                          color:
                                              profileController.isOtpSent.value
                                                  ? Colors.grey.shade200
                                                  : null,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            if (!profileController
                                                .isOtpSent.value)
                                              BoxShadow(
                                                color: primarylogin
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                          ],
                                        ),
                                        child: profileController
                                                .otpLoading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                profileController
                                                        .isOtpSent.value
                                                    ? "${profileController.resendSeconds.value}s"
                                                    : "Send OTP",
                                                style: TextStyle(
                                                  color: profileController
                                                          .isOtpSent.value
                                                      ? Colors.grey.shade600
                                                      : Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (profileController.isOtpSent.value &&
                                profileController.isNumberChanged.value)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: primarylogin.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: AuthTextField(
                                    hintText: enter_otp,
                                    length: 6,
                                    validator: Validations.validateOtp,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    IconImage: 'assets/images/icon_key.png',
                                    Imagescale: 3,
                                    controller: profileController.otpController,
                                    borderColor: Colors.transparent,
                                    fillColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 18),

                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: AuthTextField(
                        hintText: email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        IconImage: 'assets/images/ic_email_gray.png',
                        controller: editemail,
                        validator: Validations.validateEmail,
                        Imagescale: 2.5,
                        borderColor: Colors.transparent,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          selectDate(controller: editdob);
                        },
                        child: AbsorbPointer(
                          child: AuthTextField(
                            hintText: 'Date of Birth',
                            controller: editdob,
                            keyboardType: TextInputType.datetime,

                            // Calendar icon
                              IconImage: 'assets/images/calendar.png',

                            Imagescale: 1,

                            borderColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          selectDate(controller: editAnniversary);
                        },
                        child: AbsorbPointer(
                          child: AuthTextField(
                            hintText: 'Anniversary Date',
                            controller: editAnniversary,
                            keyboardType: TextInputType.datetime,

                            // Same calendar icon
                            IconImage: 'assets/images/heart.png',
                            Imagescale: 1,

                            borderColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Action Buttons - Modern Design
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            var updateUrl = Uri.parse(updateProfile_url);

                            var body = {
                              'name': editname.text,
                              'email': editemail.text,
                              'mobile': editmobile.text,
                              'dob': editdob.text,
                              'anniversary_date': editAnniversary.text,
                            };

                            if (editmobile.text != originalMobile) {
                              if (profileController
                                  .otpController.text.isEmpty) {
                                toastMsg("Please verify OTP first", false);
                                return;
                              }
                              body['otp'] =
                                  profileController.otpController.text;
                            }

                            print(
                                "inside updateUrl....." + updateUrl.toString());
                            print("inside body....." + body.toString());
                            await multipartAPICall(updateUrl, body);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarylogin,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: primarylogin.withOpacity(0.3),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
