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

import '../constant/validations.dart';

class EditAddress extends StatefulWidget {
  Map<String, dynamic> datalist;
  EditAddress({required this.datalist});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  AddressController addressController = Get.put(AddressController());
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController address_1 = TextEditingController();
  TextEditingController address_2 = TextEditingController();
  TextEditingController postcode = TextEditingController();
  var selectedCountry;
  var selectedState;
  var selectedCity;
  var selectedArea;

  List countryList = [];
  List stateList = [];
  List cityList = [];
  List areaList = [];

  var countryId;
  var stateId;
  var cityId;
  var areaId;

  bool isDefault = false;
  var isDefaultId = "0";
  var addType = 'Home';
  var addTypeId = '1';

  // Add this flag to track if we're initializing
  bool isInitializing = true;

  String TypeId(String type) {
    switch (type) {
      case 'Home':
        return '1';
      case 'Office':
        return '2';
      case 'Other':
        return '3';
      default:
        return '1';
    }
  }

  editModeFunction() async {
    nameController.text=widget.datalist['name'].toString();
    mobileController.text=widget.datalist['mobile'].toString();
    address_1.text = widget.datalist['address_1'].toString();
    address_2.text = widget.datalist['address_2'].toString() == "null"
        ? ""
        : widget.datalist['address_2'].toString();
    postcode.text = widget.datalist['postcode'].toString() == "null"
        ? ""
        : widget.datalist['postcode'].toString();

    if (widget.datalist['country_id'] != null && widget.datalist['country'] != null) {
      countryId = widget.datalist['country_id'].toString();
      stateId = widget.datalist['state_id'].toString();
      cityId = widget.datalist['city_id'].toString();
      areaId = widget.datalist['area_id'].toString();

      selectedCountry = widget.datalist['country'].toString();
      selectedState = widget.datalist['state'].toString();
      selectedCity = widget.datalist['city'].toString();
      selectedArea = widget.datalist['area'].toString();

      await fetchCountry();
      if (widget.datalist['state_id'] != null && widget.datalist['state'] != null) {
        await fetchState(countryId.toString());
      }
      if (widget.datalist['city_id'] != null && widget.datalist['city'] != null) {
        await fetchCity(stateId.toString());
      }
      if (widget.datalist['area_id'] != null && widget.datalist['area'] != null) {
        await fetchArea(cityId.toString());
      }
    } else {
      await fetchCountry();
    }

    // Set initializing flag to false after all data is loaded
    setState(() {
      isInitializing = false;
    });

    print("country_id..." + countryId.toString());
    print("country_name..." + selectedCountry.toString());
  }

  @override
  void initState() {
    super.initState();
    print("datalist..." + widget.datalist['id'].toString());
    print("latitude..." + widget.datalist['latitude'].toString());
    print("longitude..." + widget.datalist['longitude'].toString());
    editModeFunction();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Edit Address',
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

                // Address Line 1
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

                // Address Line 2
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
                        value: country['name'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            country['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
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
                      setState(() {
                        cityList.clear();
                        stateList.clear();
                        areaList.clear(); // Clear area list too
                        selectedCity = null;
                        selectedState = null;
                        selectedArea = null; // Clear selected area
                        cityId = null;
                        stateId = null;
                        areaId = null; // Clear area ID
                        selectedCountry = newValue;
                        if (countryId == 0) {
                          countryId = null;
                        }
                      });
                      fetchState(countryId);
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
                        value: state['name'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            state['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
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
                      setState(() {
                        cityList.clear();
                        areaList.clear(); // Clear area list
                        selectedCity = null;
                        selectedArea = null; // Clear selected area
                        cityId = null;
                        areaId = null; // Clear area ID
                        selectedState = newValue;
                        if (stateId == 0) {
                          stateId = null;
                        }
                      });
                      fetchCity(stateId);
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
                        value: city['name'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            city['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
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
                      setState(() {
                        areaList.clear();
                        selectedArea = null;
                        areaId = null;
                        selectedCity = newValue;
                        if (cityId == 0) {
                          cityId = null;
                        }
                      });
                      fetchArea(cityId);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Area Dropdown - Fixed version
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropTextField(
                    hintText: 'Select Area',
                    value: areaList.isNotEmpty && selectedArea != null
                        ? (areaList.any((area) => area['name'].toString() == selectedArea)
                        ? selectedArea
                        : null)
                        : null,
                    items: areaList.map((area) {
                      return DropdownMenuItem<String>(
                        value: area['name'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            area['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedArea = newValue;
                        // Find the area ID from the selected area name
                        final selectedAreaObj = areaList.firstWhere(
                              (area) => area['name'].toString() == newValue,
                          orElse: () => null,
                        );
                        if (selectedAreaObj != null) {
                          areaId = selectedAreaObj['id'].toString();
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null && areaList.isNotEmpty) {
                        return 'Please select Area';
                      }
                      return null;
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
                    textInputAction: TextInputAction.done,
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

                // Address Type Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField(
                    value: addType,
                    alignment: Alignment.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    isExpanded: true,
                    menuMaxHeight: 300, // Dropdown Height
                    elevation: 8,
                    borderRadius: BorderRadius.circular(14),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                      size: 24,
                    ),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/icon_home.png',
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
                          (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                            color: isDefault ? primarylogin : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDefault ? primarylogin : Colors.grey[400]!,
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
                      var addressUrl = Uri.parse(editAddressUrl);
                      var addressBody = json.encode({
                        'id': widget.datalist['id'],
                        'name':nameController.text.trim(),
                        'mobile':mobileController.text.trim(),
                        'address_1': address_1.text,
                        'address_2': address_2.text,
                        'postcode': postcode.text,
                        'country_id': countryId.toString(),
                        'state_id': stateId.toString(),
                        'city_id': cityId.toString(),
                        'latitude': widget.datalist['latitude'].toString(),
                        'longitude': widget.datalist['longitude'].toString(),
                        'is_default': isDefaultId.toString(),
                        'address_type': addTypeId.toString(),
                        "area_id": areaId?.toString() ?? "", // Handle null safely
                      });
                      print("Url and body ... ${addressUrl}\n${addressBody}");
                      await addressController.AddAddressApi(addressUrl, addressBody);
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
    var countryUrl = Uri.parse(countries_url);
    print("countryUrl--> " + countryUrl.toString());
    var response = await ApiBaseHelper().getAPICall(countryUrl, true);
    var CountryData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        countryList.clear();
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
        stateList.clear();
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
        cityList.clear();
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
    print("areaUrl : " + areaUrl.toString());
    var response = await ApiBaseHelper().getAPICall(areaUrl, true);
    var AreaData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        areaList.clear();
        areaList.addAll(AreaData['data']);

        // After loading areas, verify if the saved area exists
        if (selectedArea != null && !isInitializing) {
          bool areaExists = areaList.any((area) => area['name'].toString() == selectedArea);
          if (!areaExists) {
            // If the saved area doesn't exist in the new list, clear it
            selectedArea = null;
            areaId = null;
          }
        }
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