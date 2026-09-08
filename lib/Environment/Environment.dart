import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:garu_customer/main.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static String get filename {
    if (kReleaseMode) {
      return '.env.prod';
    }
    return '.env.dev';
  }

  static String? get apibaseurl{

    print('inside apibaseurl${dotenv.env['baseurl']}');
    return  dotenv.env['baseurl'];
  }


  static String get userid{
    var loginresponse = json.decode(prefs!.getString("login_response")!);
    var userid =loginresponse['employeeId'].toString();
    return  userid;
  }

  static String? get deviceid{

    var device_id =  prefs!.getString("deviceid");
    return  device_id;
  }

  static String? get appname{
    return dotenv.env['appname'];
  }

  static String? get appversion{
    return dotenv.env['appversion'];
  }

  static String? get appstatus{
    return dotenv.env['appstatus'];
  }
  static bool get appuserlog{
    var userlog = prefs!.getBool("loggedin")??false;
    return userlog;
  }
  static String? get apptimeout{
    return dotenv.env['apptimeout'];
  }
  static String? get appxapikey{
    return dotenv.env['header_xpi'];
  }
  static String? get appxapivalue{
    return dotenv.env['header_xpi_value'];
  }
}