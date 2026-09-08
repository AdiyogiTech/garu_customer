import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/return_product/return_request_controller.dart';

class ReturnProduct extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ReturnProduct({Key? key, required this.productData}) : super(key: key);

  @override
  State<ReturnProduct> createState() => _ReturnProductState();
}

class _ReturnProductState extends State<ReturnProduct> {
  final TextEditingController _messageController = TextEditingController();
  final ReturnRequestController requestController = Get.put(ReturnRequestController());
  File? _selectedImage;
  bool isDelivered = true;
  final ImagePicker _picker = ImagePicker();

  void _submitReturnRequest() {
    if (_selectedImage == null) {
      toastMsg('Please select an image', false);
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      toastMsg('Please enter a message', false);
      return;
    }

    Map<String, dynamic> returnRequestBody = {
      'order_id': widget.productData['order_id'].toString(),
      'order_product_id': widget.productData['order_product_id'].toString(),
      'comment': _messageController.text.trim(),
    };

    // Pass the image with the correct field name 'attachment'
    requestController.ReturnItemRequestApi(
      returnRequest_url,
      returnRequestBody,
      _selectedImage,
    );
  }


  void _selectImage(ImageSource media) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: media,
        imageQuality: 70,
        maxWidth: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        Navigator.pop(context);
        toastMsg('Image selected successfully',true);
        log("Selected Image Path: ${_selectedImage!.path}");
      }
    } catch (e) {
      log("Image picker error: $e");
      toastMsg('Failed to pick image', false);
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Add Image",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    color: Colors.blue,
                    onTap: () => _selectImage(ImageSource.camera),
                  ),
                  _buildPickerOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    color: Colors.green,
                    onTap: () => _selectImage(ImageSource.gallery),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    log('Product Data: ${widget.productData}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Return Request',
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Product Card
                    _buildProductCard(size),
                    SizedBox(height: 20),

                    // Return Request Form
                    _buildReturnForm(),
                    SizedBox(height: 24),

                    // Submit Button
                    _buildSubmitButton(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Loading Overlay
            if (requestController.ItemRequestLoader.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryn),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Submitting request...',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildProductCard(Size size) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${widget.productData['order_no']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDelivered ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDelivered ? Icons.check_circle : Icons.error,
                      color: isDelivered ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Delivered',
                      style: TextStyle(
                        color: isDelivered ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.productData['main_image'] ?? '',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        height: 70,
                        width: 70,
                        color: Colors.grey[200],
                        child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                      ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productData['product_name']?.toString() ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    if (widget.productData['attribute_name'] != null)
                      Text(
                        widget.productData['attribute_name'].toString(),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Qty: ${widget.productData['quantity'] ?? 1}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\u{20B9}${widget.productData['total_price'] ?? 0}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: primaryn,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Date',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.productData['date'] ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Return Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),

          // Message Field
          Text(
            'Message',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextFormField(
              controller: _messageController,
              maxLines: 4,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tell us why you want to return this item...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Image Upload - Important: This will be sent as 'attachment'
          Text(
            'Upload Image',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Required for return verification',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 8),

          GestureDetector(
            onTap: _showImagePickerSheet,
            child: DottedBorder(
              color: _selectedImage != null ? Colors.green : primaryn.withOpacity(0.5),
              strokeWidth: 1.5,
              dashPattern: [6, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: _selectedImage != null
                      ? Colors.green.withOpacity(0.05)
                      : primaryn.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage != null
                    ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: primaryn,
                      size: 36,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to upload image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'JPEG, PNG (Max 5MB)',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_selectedImage != null) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Image ready to upload as attachment',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: requestController.ItemRequestLoader.value
              ? null
              : _submitReturnRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryn,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: Text(
            'Submit Return Request',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}