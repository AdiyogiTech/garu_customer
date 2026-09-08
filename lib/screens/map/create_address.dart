import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/helper_dropdown.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/address/address_controller.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/style.dart';

import '../../main.dart';
import '../constant/validations.dart';

class CreateAddress extends StatefulWidget {
  var subtotal,tax,discount,total;
  var latitute,longitute;
  var address1,address2,pincode;
  CreateAddress({this.latitute,this.longitute,this.address1,this.address2,this.pincode});

  @override
  State<CreateAddress> createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  AddressController addressController = Get.put(AddressController());
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(); // use for api
  TextEditingController mobileController = TextEditingController(); // use for api
  TextEditingController address_1 = TextEditingController(); // use for api
  TextEditingController address_2 = TextEditingController(); // use for api
  TextEditingController postcode = TextEditingController(); // use for api
  var selectedCountry;
  var selectedState;
  var selectedCity;
  var selectedArea;
  List countryList = [];
  List stateList = [];
  List cityList = [];
  List areaList = [];
  var countryId; // use for api
  var stateId; // use for api
  var cityId; // use for api
  var areaId; // use for api

  bool isDefault = false;
  var isDefaultId = "0"; // use for api
  var addType = 'Home';
  var addTypeId = '1'; // use for api
  String TypeId(String type) {
    switch (type) {
      case 'Home':
        return '1';
      case 'Office':
        return '2';
      case 'Other':
        return '3';
      default:
        return '1'; // Return null for an invalid selection.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = prefs?.getString('user_name') ?? '';
    mobileController.text = prefs?.getString('user_mobile') ?? '';
    fetchCountry();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Add New Address',
        displaySearch: false,
        displayCart: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // name
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    maxLines: 1,
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter name';
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return 'Only letters allowed';
                      } else if (value.length < 3) {
                        return 'Name too short';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_profile.png',
                          scale: 2.5,
                          color: primarylogin,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: primarylogin,
                          width: 1.5,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 16),

                // mobile
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    maxLines: 1,
                    controller: mobileController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mobile number';
                      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        return 'Enter valid 10-digit mobile number';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_phone.png',
                          scale: 2.5,
                          color: primarylogin,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: primarylogin,
                          width: 1.5,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 16),

                // Street Address 1
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    maxLines: 1,
                    controller: address_1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter street address';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_home.png',
                          scale: 2.0,
                          color: primarylogin,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: primarylogin,
                          width: 1.5,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 16),

                // Street Address 2 (Optional)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: address_2,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_home.png',
                          scale: 2.0,
                          color: primarylogin,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: primarylogin,
                          width: 1.5,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 16),

                // Country Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropTextField(
                    hintText: 'Select Country',
                    value: selectedCountry,
                    items: countryList.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['id'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            country['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            countryId = country['id'].toString();
                          });
                        },
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Country';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      cityList.clear();
                      stateList.clear();
                      fetchState(countryId);
                      selectedCity = null;
                      selectedState = null;
                      setState(() {
                        selectedCountry = newValue;
                        if (countryId == 0) {
                          countryId = null;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // State Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropTextField(
                    hintText: 'Select State',
                    value: selectedState,
                    items: stateList.map((state) {
                      return DropdownMenuItem<String>(
                        value: state['id'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            state['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            stateId = state['id'].toString();
                          });
                        },
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select State';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      cityList.clear();
                      fetchCity(stateId);
                      selectedCity = null;
                      setState(() {
                        selectedState = newValue;
                        if (stateId == 0) {
                          stateId = null;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // City Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropTextField(
                    hintText: 'Select City',
                    value: selectedCity,
                    items: cityList.map((city) {
                      return DropdownMenuItem<String>(
                        value: city['id'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            city['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            cityId = city['id'].toString();
                          });
                        },
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select City';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      areaList.clear();
                      fetchArea(cityId);
                      setState(() {
                        selectedCity = newValue;
                        if (cityId == 0) {
                          cityId = null;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Area Dropdown - NOW OPTIONAL
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropTextField(
                    hintText: 'Select Area',
                    value: selectedArea,
                    items: areaList.map((area) {
                      return DropdownMenuItem<String>(
                        value: area['id'].toString(),
                        child: Container(
                          width: size.width * 0.6,
                          child: Text(
                            area['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            areaId = area['id'].toString();
                          });
                        },
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select area';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedArea = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Zip Code
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: postcode,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter pincode';
                      } else if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
                        return 'Enter valid 6-digit pincode';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_key.png',
                          scale: 2.0,
                          color: primarylogin,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: primarylogin,
                          width: 1.5,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                  ),
                ),
                const SizedBox(height: 16),

                // Address Type Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField(
                    value: addType,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(14),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                      size: 24,
                    ),
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_home.png',
                          scale: 2.0,
                          color: primarylogin,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: primarylogin,
                          width: 1.5,
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),

                    onChanged: (newValue) {
                      setState(() {
                        addType = newValue!;
                        addTypeId = TypeId(newValue);
                      });
                    },
                    items: <String>[
                      'Home',
                      'Office',
                      'Other',
                    ].map<DropdownMenuItem<String>>(
                          (String value) =>
                          DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(value,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                          ),
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Default Address Checkbox
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDefault = !isDefault;
                      isDefaultId = isDefault == true ? "1" : "0";
                      print("isDefault .. ${isDefaultId}...${isDefault}");
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDefault ? primarylogin : Colors
                                .transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDefault ? primarylogin : Colors
                                  .grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: isDefault
                              ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Set as Default Address',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Submit Button
                GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      var addressUrl = Uri.parse(addAddressUrl);
                      var addressBody = json.encode({
                        'name':nameController.text.trim(),
                        'mobile':mobileController.text.trim(),
                        'address_1': address_1.text,
                        'address_2': address_2.text,
                        'postcode': postcode.text,
                        'country_id': countryId.toString(),
                        'state_id': stateId.toString(),
                        'city_id': cityId.toString(),
                        'latitude': widget.latitute.toString(),
                        'longitude': widget.longitute.toString(),
                        'is_default': isDefaultId.toString(),
                        'address_type': addTypeId.toString(),
                        "area_id": areaId?.toString() ?? "", // Handle null area
                      });
                      print("hello ... ${addressUrl}\n${addressBody}");
                      await addressController.AddAddressApi(
                          addressUrl, addressBody);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: primarylogin,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: addressController.addLoading.value == true
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : const Text(
                        'Save Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchCountry() async {
    address_1.text = widget.address1 ?? '';
    address_2.text = widget.address2 ?? '';
    postcode.text = widget.pincode ?? '';

    var countryUrl = Uri.parse(countries_url);
    print("countryUrl--> " + countryUrl.toString());
    var response = await ApiBaseHelper().getAPICall(countryUrl, true);
    var CountryData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        countryList.addAll(CountryData['data']);
      });
    }
  }

  Future<void> fetchState(countryId) async {
    var stateUrl = Uri.parse(states_url + countryId);
    print("profileUrl--> " + stateUrl.toString());
    var response = await ApiBaseHelper().getAPICall(stateUrl, true);
    var StateData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        stateList.addAll(StateData['data']);
      });
    }
  }

  Future<void> fetchCity(state_id) async {
    var cityUrl = Uri.parse(cities_url + state_id);
    print("cityurl : " + cityUrl.toString());
    var response = await ApiBaseHelper().getAPICall(cityUrl, true);
    var CityData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        cityList.addAll(CityData['data']);
      });
    }
    else {
      /// ❌ Delivery not available
      setState(() {
        cityList.clear();
      });

      toastMsg("Delivery not available on this address", false);
    }
  }

  Future<void> fetchArea(city_id) async {
    var areaUrl = Uri.parse(areas_url + city_id);
    print("cityurl : " + areaUrl.toString());
    var response = await ApiBaseHelper().getAPICall(areaUrl, true);
    var AreaData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        areaList.addAll(AreaData['data']);
      });
    }
    else {
      /// ❌ Delivery not available
      setState(() {
        areaList.clear();
      });

      toastMsg("Delivery not available on this address", false);
    }
  }
}

OutlineInputBorder _OutlineInputBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: borderColor, width: 1),
  );
}