import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/address/address_controller.dart';
import 'package:garu_customer/screens/checkout/checkout_screen.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/map/map_screen.dart';

import 'edit_address.dart';

class AddressPage extends StatefulWidget {
  final String? addressId;
  const AddressPage({super.key,this.addressId});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressController addressController = Get.put(AddressController());
  String? selectedAddressId;

  @override
  initState() {
    super.initState();
    selectedAddressId = widget.addressId;
    callAddressList();
  }

  Future<void> callAddressList() async {
    var ListUrl = Uri.parse(addresslistUrl);
    await addressController.AddressListApi(ListUrl);

    // Check if data exists and is a List
    if (addressController.addListData != null &&
        addressController.addListData['data'] != null &&
        addressController.addListData['data'] is List) {

      var dataList = addressController.addListData['data'];
      if (dataList.isNotEmpty) {
        setState(() {
          selectedAddressId ??= dataList[0]["id"].toString();
        });
      }
    }
  }

  String addType(String id) {
    switch (id) {
      case "1":
        return 'Home';
      case '2':
        return 'Office';
      case '3':
        return 'Other';
      default:
        return 'Other';
    }
  }

  IconData _getAddressTypeIcon(String type) {
    switch (type) {
      case "1":
        return Icons.home_outlined;
      case "2":
        return Icons.business_center_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  String _buildAddressString(Map<String, dynamic> address) {
    List<String> parts = [];

    if (address["address_1"] != null && address["address_1"].toString() != "null")
      parts.add(address["address_1"].toString());
    if (address["address_2"] != null && address["address_2"].toString() != "null")
      parts.add(address["address_2"].toString());
    if (address["area"] != null && address["area"].toString() != "null")
      parts.add(address["area"].toString());
    if (address["city"] != null && address["city"].toString() != "null")
      parts.add(address["city"].toString());
    if (address["state"] != null && address["state"].toString() != "null")
      parts.add(address["state"].toString());
    if (address["country"] != null && address["country"].toString() != "null")
      parts.add(address["country"].toString());
    if (address["postcode"] != null && address["postcode"].toString() != "null")
      parts.add(address["postcode"].toString());
    if (address["name"] != null && address["name"].toString() != "null")
      parts.add(address["name"].toString());
    if (address["mobile"] != null && address["mobile"].toString() != "null")
      parts.add(address["mobile"].toString());
    return parts.join(', ');
  }

  void _showDeleteDialog(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to delete this address?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          var deleteUrl = Uri.parse(deleteAddressUrl + addressId);
                          await addressController.DeleteAddressApi(deleteUrl);
                          await callAddressList();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'My Address',
        displayCart: false,
        displaySearch: false,
      ),
      body: GetBuilder<AddressController>(
          builder: (addressController) {
            if (addressController.addListLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryn,
                  strokeWidth: 2,
                ),
              );
            }

            // Safe way to get address list
            List<dynamic> addressList = [];
            try {
              if (addressController.addListData != null &&
                  addressController.addListData['data'] != null &&
                  addressController.addListData['data'] is List) {
                addressList = addressController.addListData['data'];
              }
            } catch (e) {
              print('Error getting address list: $e');
              addressList = [];
            }

            return Column(
              children: [
                const SizedBox(height: 16),

                // Empty State
                if (addressList.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "No addresses saved",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add your first delivery address",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Address List
                if (addressList.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: addressList.length,
                      itemBuilder: (context, index) {
                        // Safe way to get address at index
                        if (index >= addressList.length) return const SizedBox.shrink();
                        var address = addressList[index];
                        if (address == null) return const SizedBox.shrink();

                        bool isSelected = selectedAddressId == address["id"]?.toString();

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAddressId = address["id"].toString();
                            });
                            Get.back(result: address);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? primarylogin : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primarylogin.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getAddressTypeIcon(address["address_type"]?.toString() ?? "3"),
                                            size: 14,
                                            color: primarylogin,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            addType(address["address_type"]?.toString() ?? "3"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: primarylogin,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => EditAddress(
                                                datalist: address
                                            ));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit_outlined,
                                              size: 16,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            _showDeleteDialog(context, address["id"]?.toString() ?? "");
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.delete_outline,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    _buildAddressString(address),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primarylogin.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 14,
                                                color: primarylogin,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Selected',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: primarylogin,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Add Address Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen())
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: primarylogin,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add New Address',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}