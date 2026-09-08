import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Constant/ApiBaseHelper.dart';
import '../../Environment/Environment.dart';

class OrderTrackingController extends GetxController {
  // Observable variables for loading and error states
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Main data observable
  final trackingData = Rx<Map<String, dynamic>>({});

  // Helper observables for specific sections
  final scansList = <Map<String, dynamic>>[].obs;
  final consigneeData = Rx<Map<String, dynamic>>({});
  final statusData = Rx<Map<String, dynamic>>({});

  // Additional observables for easy access to common fields
  final awbNumber = ''.obs;
  final referenceNo = ''.obs;
  final currentStatus = ''.obs;
  final currentStatusLocation = ''.obs;
  final currentStatusInstructions = ''.obs;

  // Waybill input
  final waybillController = TextEditingController();
  final waybill = ''.obs;

  final ApiBaseHelper _apiHelper = ApiBaseHelper();

  @override
  void onInit() {
    super.onInit();
    clearData();
  }

  @override
  void onClose() {
    waybillController.dispose();
    super.onClose();
  }

  void clearData() {
    trackingData.value = {};
    scansList.clear();
    consigneeData.value = {};
    statusData.value = {};
    awbNumber.value = '';
    referenceNo.value = '';
    currentStatus.value = '';
    currentStatusLocation.value = '';
    currentStatusInstructions.value = '';
    errorMessage.value = '';
  }

  // Method to set waybill and fetch tracking
  void setWaybillAndFetch(String waybillNumber) {
    waybill.value = waybillNumber;
    waybillController.text = waybillNumber;
    fetchOrderTracking();
  }

  Future<void> fetchOrderTracking() async {
    // Validate waybill
    if (waybill.value.isEmpty && waybillController.text.isEmpty) {
      errorMessage.value = 'Please enter a waybill number';
      return;
    }

    // Use either the observable or controller text
    String waybillToUse = waybill.value.isNotEmpty ? waybill.value : waybillController.text;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      String? baseUrl = Environment.apibaseurl;
      String url = '${baseUrl}order/tracking';

      // Create payload with waybill
      Map<String, dynamic> payload = {
        'waybill': waybillToUse,
      };

      Uri uri = Uri.parse(url);

      print('Fetching order tracking from: $url');
      print('Payload: $payload');

      // Make the API call using your ApiBaseHelper
      final http.Response response = await _apiHelper.postAPICall(uri, json.encode(payload), true);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Parsed JSON Response: $jsonResponse');

        // Check if response has status field (common pattern)
        if (jsonResponse is Map) {
          // Convert dynamic map to String map
          Map<String, dynamic> typedResponse = {};
          jsonResponse.forEach((key, value) {
            typedResponse[key.toString()] = value;
          });

          // Check if response contains status flag
          if (typedResponse.containsKey('status') && typedResponse['status'] == true) {
            // Clear existing data
            clearData();

            // Extract data - could be in 'data' field or directly in response
            Map<String, dynamic> responseData = {};

            if (typedResponse.containsKey('data') && typedResponse['data'] != null) {
              if (typedResponse['data'] is Map) {
                // Convert inner map as well
                Map<String, dynamic> innerMap = {};
                (typedResponse['data'] as Map).forEach((key, value) {
                  innerMap[key.toString()] = value;
                });
                responseData = innerMap;
              } else if (typedResponse['data'] is List) {
                // If data is a list, take first item
                List dataList = typedResponse['data'];
                if (dataList.isNotEmpty && dataList.first is Map) {
                  Map<String, dynamic> innerMap = {};
                  (dataList.first as Map).forEach((key, value) {
                    innerMap[key.toString()] = value;
                  });
                  responseData = innerMap;
                }
              }
            } else {
              // If no 'data' field, use the whole response
              responseData = typedResponse;
            }

            // Set main tracking data
            trackingData.value = responseData;

            // Set basic fields
            _setBasicFields();

            // Extract consignee data
            _extractConsigneeData(responseData);

            // Extract status data
            _extractStatusData(responseData);

            // Extract scans
            _extractScans(responseData);

            print('Order tracking fetched successfully');
            print('AWB: ${awbNumber.value}');
            print('Reference: ${referenceNo.value}');
            print('Status: ${currentStatus.value}');
            print('Scans count: ${scansList.length}');
          } else {
            // Handle error message from API
            String message = 'Something went wrong';
            if (typedResponse.containsKey('message')) {
              message = typedResponse['message'].toString();
            } else if (typedResponse.containsKey('error')) {
              message = typedResponse['error'].toString();
            }
            errorMessage.value = message;
          }
        } else {
          errorMessage.value = 'Invalid response format';
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: ${e.toString()}';
      print('Error fetching order tracking: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      isLoading.value = false;
    }
  }

  void _setBasicFields() {
    // Safely set AWB number - try different possible field names
    _setFieldValue('AWB', awbNumber);
    _setFieldValue('awb', awbNumber);
    _setFieldValue('awb_number', awbNumber);
    _setFieldValue('tracking_number', awbNumber);

    // Safely set Reference number
    _setFieldValue('ReferenceNo', referenceNo);
    _setFieldValue('reference_no', referenceNo);
    _setFieldValue('order_id', referenceNo);
    _setFieldValue('order_number', referenceNo);
  }

  void _setFieldValue(String key, RxString targetField) {
    if (trackingData.value.containsKey(key)) {
      var value = trackingData.value[key];
      if (value != null) {
        if (value is Map) {
          // If it's a map, try to extract a meaningful value
          if (value.containsKey('number') || value.containsKey('id')) {
            targetField.value = value['number']?.toString() ?? value['id']?.toString() ?? value.toString();
          } else {
            targetField.value = value.toString();
          }
        } else if (value is List) {
          targetField.value = value.isNotEmpty ? value.join(', ') : '';
        } else {
          targetField.value = value.toString();
        }
      }
    }
  }

  void _extractConsigneeData(Map<String, dynamic> data) {
    // Try different possible field names for consignee
    List<String> possibleKeys = ['Consignee', 'consignee', 'customer', 'recipient', 'receiver'];

    for (String key in possibleKeys) {
      if (data.containsKey(key) && data[key] != null) {
        var consignee = data[key];
        if (consignee is Map) {
          // Convert map keys to String
          Map<String, dynamic> typedConsignee = {};
          (consignee as Map).forEach((k, v) {
            typedConsignee[k.toString()] = v;
          });
          consigneeData.value = typedConsignee;
          break;
        } else if (consignee is String) {
          // Try to parse if it's a JSON string
          try {
            var parsed = json.decode(consignee);
            if (parsed is Map) {
              Map<String, dynamic> typedParsed = {};
              (parsed as Map).forEach((k, v) {
                typedParsed[k.toString()] = v;
              });
              consigneeData.value = typedParsed;
              break;
            }
          } catch (e) {
            // Not a JSON string, store as is with a default key
            consigneeData.value = {'name': consignee};
            break;
          }
        }
      }
    }
  }
// Add this method to OrderTrackingController
// Add this method to OrderTrackingController
  String getCleanLocation() {
    // Try to get from StatusLocation first
    String location = currentStatusLocation.value;

    if (location.isEmpty || location == 'N/A') {
      location = getValue('Origin');
    }

    if (location.isEmpty || location == 'N/A') {
      location = getConsigneeValue('City');
    }

    // Clean up the location string
    location = location.replaceAll('_', ' ');

    // Handle the specific format "Satna_BandhavgarhColony_D (Madhya Pradesh)"
    if (location.contains('(')) {
      // Extract just the city name before any parentheses
      String beforeParen = location.split('(')[0].trim();

      // Check if it contains "Satna"
      if (beforeParen.contains('Satna')) {
        // Return just "Satna, Madhya Pradesh" for better geocoding
        return 'Satna, Madhya Pradesh';
      }

      // If it has multiple parts, take the first meaningful part
      List<String> parts = beforeParen.split(' ');
      if (parts.isNotEmpty) {
        // Check if first part is a city name (like "Satna")
        String firstPart = parts[0];
        if (firstPart.length > 2) { // Avoid single letters
          return '$firstPart, Madhya Pradesh';
        }
      }
      return beforeParen;
    }

    return location;
  }

// Add method to get destination location
  String getDestinationLocation() {
    String destination = getValue('Destination');
    if (destination.isEmpty || destination == 'N/A') {
      destination = getConsigneeValue('City');
    }
    return destination.replaceAll('_', ' ');
  }
  void _extractStatusData(Map<String, dynamic> data) {
    // Try different possible field names for status
    List<String> possibleKeys = ['Status', 'status', 'tracking_status', 'current_status'];

    for (String key in possibleKeys) {
      if (data.containsKey(key) && data[key] != null) {
        var status = data[key];
        if (status is Map) {
          // Convert map keys to String
          Map<String, dynamic> typedStatus = {};
          (status as Map).forEach((k, v) {
            typedStatus[k.toString()] = v;
          });
          statusData.value = typedStatus;

          // Set current status fields
          _setStatusField(typedStatus, 'Status', currentStatus);
          _setStatusField(typedStatus, 'status', currentStatus);
          _setStatusField(typedStatus, 'StatusLocation', currentStatusLocation);
          _setStatusField(typedStatus, 'location', currentStatusLocation);
          _setStatusField(typedStatus, 'Instructions', currentStatusInstructions);
          _setStatusField(typedStatus, 'instructions', currentStatusInstructions);
          _setStatusField(typedStatus, 'message', currentStatusInstructions);

          break;
        } else if (status is String) {
          // If status is a string, set it directly
          currentStatus.value = status;
          break;
        }
      }
    }

    // If no status found in nested objects, look for direct status fields
    if (currentStatus.value.isEmpty) {
      List<String> directStatusKeys = ['current_status', 'status_text', 'delivery_status'];
      for (String key in directStatusKeys) {
        if (data.containsKey(key) && data[key] != null) {
          currentStatus.value = data[key].toString();
          break;
        }
      }
    }
  }

  void _setStatusField(Map<String, dynamic> statusMap, String key, RxString targetField) {
    if (statusMap.containsKey(key) && statusMap[key] != null) {
      targetField.value = statusMap[key].toString();
    }
  }

  void _extractScans(Map<String, dynamic> data) {
    // Try different possible field names for scans
    List<String> possibleKeys = ['Scans', 'scans', 'tracking_history', 'history', 'events'];

    for (String key in possibleKeys) {
      if (data.containsKey(key) && data[key] != null) {
        var scans = data[key];
        if (scans is List) {
          _processScansList(scans);
          break;
        } else if (scans is Map) {
          // If scans is a map, try to convert to list
          if (scans.containsKey('items') || scans.containsKey('data')) {
            var items = scans['items'] ?? scans['data'];
            if (items is List) {
              _processScansList(items);
              break;
            }
          } else {
            // Single scan object, wrap in list
            _processScansList([scans]);
            break;
          }
        }
      }
    }
  }

  void _processScansList(List scans) {
    List<Map<String, dynamic>> processedScans = [];

    for (var scan in scans) {
      try {
        if (scan is Map) {
          Map<String, dynamic> processedScan = {};

          // Convert all keys to String
          (scan as Map).forEach((k, v) {
            String key = k.toString();

            // Handle nested ScanDetail if present
            if (key == 'ScanDetail' && v is Map) {
              Map<String, dynamic> scanDetail = {};
              (v as Map).forEach((sk, sv) {
                scanDetail[sk.toString()] = sv?.toString() ?? '';
              });
              processedScan.addAll(scanDetail);
            } else {
              if (v is Map || v is List) {
                // Skip complex nested objects or convert to string
                processedScan[key] = v.toString();
              } else {
                processedScan[key] = v?.toString() ?? '';
              }
            }
          });

          // Ensure we have at least some basic fields
          if (!processedScan.containsKey('Scan') && scan.containsKey('status')) {
            processedScan['Scan'] = scan['status'].toString();
          }
          if (!processedScan.containsKey('ScanDateTime') && scan.containsKey('timestamp')) {
            processedScan['ScanDateTime'] = scan['timestamp'].toString();
          }
          if (!processedScan.containsKey('ScannedLocation') && scan.containsKey('location')) {
            processedScan['ScannedLocation'] = scan['location'].toString();
          }

          if (processedScan.isNotEmpty) {
            processedScans.add(processedScan);
          }
        }
      } catch (e) {
        print('Error processing scan: $e');
      }
    }

    // Sort scans by date if possible
    processedScans.sort((a, b) {
      String dateA = a['ScanDateTime'] ?? a['timestamp'] ?? '';
      String dateB = b['ScanDateTime'] ?? b['timestamp'] ?? '';
      return dateB.compareTo(dateA); // Newest first
    });

    scansList.assignAll(processedScans);
  }

  // Helper method to safely get values from main tracking data
  String getValue(String key, {String defaultValue = 'N/A'}) {
    try {
      if (trackingData.value.containsKey(key)) {
        var value = trackingData.value[key];
        return _formatValue(value, defaultValue);
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  String _formatValue(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;

    if (value is List) {
      return value.isNotEmpty ? value.join(', ') : defaultValue;
    }
    if (value is Map) {
      return defaultValue; // Don't try to display maps as strings
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    String strValue = value.toString();
    return strValue.isNotEmpty ? strValue : defaultValue;
  }

  // Helper method for consignee data
  String getConsigneeValue(String key, {String defaultValue = 'N/A'}) {
    try {
      if (consigneeData.value.containsKey(key)) {
        var value = consigneeData.value[key];
        return _formatValue(value, defaultValue);
      }

      // Try case-insensitive match
      for (String dataKey in consigneeData.value.keys) {
        if (dataKey.toLowerCase() == key.toLowerCase()) {
          var value = consigneeData.value[dataKey];
          return _formatValue(value, defaultValue);
        }
      }

      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Helper method for status data
  String getStatusValue(String key, {String defaultValue = 'N/A'}) {
    try {
      if (statusData.value.containsKey(key)) {
        var value = statusData.value[key];
        return _formatValue(value, defaultValue);
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Get consignee full address
  String getFullAddress() {
    try {
      List<String> addressParts = [];

      // Try different possible field names for address components
      _addAddressPart(addressParts, 'Address1');
      _addAddressPart(addressParts, 'address1');
      _addAddressPart(addressParts, 'address');
      _addAddressPart(addressParts, 'Address2');
      _addAddressPart(addressParts, 'address2');
      _addAddressPart(addressParts, 'Address3');
      _addAddressPart(addressParts, 'address3');
      _addAddressPart(addressParts, 'City');
      _addAddressPart(addressParts, 'city');
      _addAddressPart(addressParts, 'State');
      _addAddressPart(addressParts, 'state');
      _addAddressPart(addressParts, 'PinCode');
      _addAddressPart(addressParts, 'pincode');
      _addAddressPart(addressParts, 'zip');
      _addAddressPart(addressParts, 'Country');
      _addAddressPart(addressParts, 'country');

      // Remove duplicates while preserving order
      List<String> uniqueParts = [];
      for (var part in addressParts) {
        if (!uniqueParts.contains(part)) {
          uniqueParts.add(part);
        }
      }

      return uniqueParts.isNotEmpty ? uniqueParts.join(', ') : 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }

  void _addAddressPart(List<String> parts, String key) {
    String value = getConsigneeValue(key);
    if (value != 'N/A' && value.isNotEmpty && !parts.contains(value)) {
      parts.add(value);
    }
  }

  // Format date helper
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      // Try to parse ISO date string
      DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      // If parsing fails, return original string
      return dateString;
    }
  }

  // Format currency helper
  String formatCurrency(dynamic amount) {
    if (amount == null) return 'N/A';
    try {
      double value = amount is String ? double.parse(amount) : amount.toDouble();
      return '₹ ${value.toStringAsFixed(2)}';
    } catch (e) {
      return '₹ $amount';
    }
  }

  // Get color based on status
  Color getStatusColor() {
    String status = currentStatus.value.toLowerCase();
    if (status.contains('delivered') || status.contains('completed') || status.contains('picked')) {
      return Colors.green;
    } else if (status.contains('pending') || status.contains('manifest') || status.contains('processing')) {
      return Colors.orange;
    } else if (status.contains('cancelled') || status.contains('failed') || status.contains('not picked')) {
      return Colors.red;
    } else if (status.contains('intransit') || status.contains('shipped') || status.contains('in transit') || status.contains('out for delivery')) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  // Get status icon
  IconData getStatusIcon() {
    String status = currentStatus.value.toLowerCase();
    if (status.contains('delivered') || status.contains('completed')) {
      return Icons.check_circle;
    } else if (status.contains('picked')) {
      return Icons.check_circle_outline;
    } else if (status.contains('pending') || status.contains('processing')) {
      return Icons.pending;
    } else if (status.contains('cancelled') || status.contains('failed')) {
      return Icons.cancel;
    } else if (status.contains('not picked') || status.contains('return')) {
      return Icons.error;
    } else if (status.contains('intransit') || status.contains('shipped') || status.contains('out for delivery')) {
      return Icons.local_shipping;
    }
    return Icons.help;
  }
}