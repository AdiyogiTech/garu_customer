import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';


class Validations {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null; // Validation passed
  }

  // Validation of Mobile Number
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the mobile number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null; // Validation passed
  }

  // Validation of Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {

      return 'Please enter a valid email address';
    }
    return null; // Validation passed
  }
  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Comment';
    }
    return null; // Validation passed
  }

  // Validation of Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the password';
    }
    if (value.length < 8) {
      return 'Password size must be 8';
    }
    return null; // Validation passed
  }

  // Validation of Confirm Password
  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null; // Validation passed
  }

  static String? validateState(String? value) {
    if (value!.isEmpty) {
      return 'Please enter State';
    }
    return null; // Validation passed
  }

  static String? validateCity(String? value) {
    if (value!.isEmpty) {
      return 'Please enter City';
    }
    return null; // Validation passed
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return ' Please enter OTP';
    }
    else if(value.length != 6){
      return ' Please enter correct OTP';
    }
    return null; // Validation passed
  }

  static String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Pincode';
    }
    if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null; // Validation passed
  }

  static String? validateBottomPincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Pincode';
    }
    // if (value.length != 6) {
    //   return 'Pincode must be 6 digits';
    // }
    return null; // Validation passed
  }

  static String? validateAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter Address';
    }

    return null; // Validation passed
  }
  static String? validateDate(String value) {
    if (value.isEmpty) {
      return 'Please select date and time';
    }else{

    }

    return null; // Validation passed
  }
}
Future<void> toastMsg(var msg,bool noErrorr){
  var Msg = Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: noErrorr == false?Colors.red:primarylogin,
      textColor: Colors.white,
      fontSize: 16.0
  );
  return Msg;
}
String formatDateNumber(String number) {


  Map<String, String> replacements = {
    "0": "00",
    "1": "01",
    "2": "02",
    "3": "03",
    "4": "04",
    "5": "05",
    "6": "06",
    "7": "07",
    "8": "08",
    "9": "09"
  };

    String modifiedString = replaceValuesInString(number, replacements);
    print("change before " + number);
    print("change date " + modifiedString);

    return modifiedString.replaceAll('-', '/').toString();

}

String replaceValuesInString(
    String originalString, Map<String, String> replacements) {
  String modifiedString = originalString;

  replacements.forEach((key, value) {
    modifiedString = modifiedString.replaceAll(key, value);
  });

  return modifiedString;
}