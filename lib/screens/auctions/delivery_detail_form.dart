import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/api.dart';
import '../address/address_controller.dart';
import '../address/address_screen.dart';
import '../constant/validations.dart';
import 'controller/delivery_form_controller.dart';

class DeliveryDetailForm extends StatefulWidget {
  final Map<String, dynamic> auctionData;
  final Map<String, dynamic> winnerData;

  const DeliveryDetailForm({
    super.key,
    required this.auctionData,
    required this.winnerData,
  });

  @override
  State<DeliveryDetailForm> createState() => _DeliveryDetailFormState();
}

class _DeliveryDetailFormState extends State<DeliveryDetailForm> {
  final _formKey = GlobalKey<FormState>();
  AddressController addressController = Get.put(AddressController());
  final DeliveryFormController deliveryFormController =
  Get.put(DeliveryFormController());
  final GlobalKey _addressSectionKey = GlobalKey();
  Map<String, dynamic>? selectedAddress;

  // Controllers for form fields
  final TextEditingController _fullNameController =
  TextEditingController();

  final TextEditingController _mobileController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _deliveryNoteController =
  TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getAddressList();
  }

  Future<void> getAddressList() async {
    final addressUrl = Uri.parse(addresslistUrl);

    await addressController.AddressListApi(addressUrl);

    if (!mounted) return;

    if (addressController.addListData.isNotEmpty &&
        addressController.addListData['data'] != null &&
        addressController.addListData['data'].isNotEmpty) {

      final address =
      addressController.addListData['data'][0];

      setState(() {
        selectedAddress = address;

        // Fetched address data
        _fullNameController.text =
            address['name']?.toString() ?? '';

        _mobileController.text =
            address['mobile']?.toString() ?? '';

      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _deliveryNoteController.dispose();
    _nameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    // ================= ADDRESS VALIDATION =================

    if (selectedAddress == null ||
        selectedAddress!['id'] == null) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (_addressSectionKey.currentContext != null) {
        await Scrollable.ensureVisible(
          _addressSectionKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      toastMsg(
        'Please select a delivery address',
        false,
      );

      return;
    }

    // ================= FORM VALIDATION =================

    if (!_formKey.currentState!.validate()) {
      // Form fields me se first invalid field par focus
      if (_fullNameController.text.trim().isEmpty) {
        _nameFocusNode.requestFocus();

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        if (_nameFocusNode.context != null) {
          await Scrollable.ensureVisible(
            _nameFocusNode.context!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }

        return;
      }

      if (_mobileController.text.trim().isEmpty ||
          _mobileController.text.trim().length != 10) {
        _mobileFocusNode.requestFocus();

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        if (_mobileFocusNode.context != null) {
          await Scrollable.ensureVisible(
            _mobileFocusNode.context!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }

        return;
      }

      if (_emailController.text.trim().isEmpty ||
          !GetUtils.isEmail(
            _emailController.text.trim(),
          )) {
        _emailFocusNode.requestFocus();

        await Future.delayed(
          const Duration(milliseconds: 100),
        );

        if (_emailFocusNode.context != null) {
          await Scrollable.ensureVisible(
            _emailFocusNode.context!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }

        return;
      }

      return;
    }

    // ================= API CALL =================

    final int? addressId =
    int.tryParse(selectedAddress!['id'].toString());

    if (addressId == null) {
      toastMsg(
        'Invalid delivery address',
        false,
      );
      return;
    }

    final int? auctionItemId =
    int.tryParse(widget.auctionData['id'].toString());

    if (auctionItemId == null) {
      toastMsg(
        'Invalid auction item',
        false,
      );
      return;
    }

    final bool success =
    await deliveryFormController.createWinnerOrder(
      auctionItemId: auctionItemId,
      addressId: addressId,
      customerName: _fullNameController.text.trim(),
      customerEmail: _emailController.text.trim(),
      customerMobile: _mobileController.text.trim(),
      userComment: _deliveryNoteController.text.trim(),
    );

    if (success && mounted) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:HelperAppBar(title: "Delivery Details",
      displayCart: false,
      displaySearch: false,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Congratulations Card
              _buildCongratulationsCard(),

              const SizedBox(height: 20),

              // Delivery Address Section
              _buildDeliveryAddressSection(),

              const SizedBox(height: 20),

              // Contact Details Section
              _buildContactDetailsSection(),

              const SizedBox(height: 20),

              // Order Summary
              _buildOrderSummary(),

              const SizedBox(height: 24),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: deliveryFormController.createOrderLoading.value
                        ? null
                        : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: deliveryFormController.createOrderLoading.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== CONGRATULATIONS CARD ====================
  Widget _buildCongratulationsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.green,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Congratulations, you won!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Payment is complete. Please share the delivery details so we can create your order and ship this vault item.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DELIVERY ADDRESS SECTION ====================
  Widget _buildDeliveryAddressSection() {
    return GetBuilder<AddressController>(
      builder: (addressController) {

        if (addressController.addListLoading.value) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hasAddress =
            addressController.addListData.isNotEmpty &&
                addressController.addListData['data'] != null &&
                addressController.addListData['data'].isNotEmpty;

        if (!hasAddress) {
          return Container(
            key: _addressSectionKey,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'No address found',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          );
        }

        // Agar selectedAddress null hai to first address
        final address = selectedAddress ??
            addressController.addListData['data'][0];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green.shade700,
                    size: 22,
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () async {

                      final result = await Get.to(
                            () => AddressPage(
                          addressId: address['id']?.toString(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedAddress =
                          Map<String, dynamic>.from(result);
                        });
                      }

                      // Address list refresh
                      await addressController.AddressListApi(
                        Uri.parse(addresslistUrl),
                      );

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: const Text(
                      'Change Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  /*  Text(
                      address['address_type']?.toString() ?? 'Address',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),*/

                    Text(
                      "${address['address_1'] ?? ''}, "
                          "${address['address_2'] ?? ''}, "
                          "${address['area'] ?? ''}, "
                          "${address['city'] ?? ''}, "
                          "${address['state'] ?? ''}, "
                          "${address['country'] ?? ''}, "
                          "${address['postcode'] ?? ''}, "
                          "${address['name'] ?? ''}, "
                          "${address['mobile'] ?? ''}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
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

  // ==================== CONTACT DETAILS SECTION ====================
  Widget _buildContactDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.green.shade700,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade300,thickness: 1,),
          const SizedBox(height: 16),

          // Name
          _buildTextField(
            controller: _fullNameController,
            focusNode: _nameFocusNode,
            label: 'Name *',
            hint: 'Enter full name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),

          const SizedBox(height: 14),

          // Mobile
          _buildTextField(
            controller: _mobileController,
            focusNode: _mobileFocusNode,
            label: 'Mobile *',
            hint: 'Enter mobile number',
            keyboardType: TextInputType.phone,
            validator: (value) {
              final mobile = value?.trim() ?? '';

              if (mobile.isEmpty) {
                return 'Please enter your mobile number';
              }

              if (mobile.length != 10) {
                return 'Please enter a valid 10 digit mobile number';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          // Email
          _buildTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: 'Email *',
            hint: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final email = value?.trim() ?? '';

              if (email.isEmpty) {
                return 'Please enter your email';
              }

              if (!GetUtils.isEmail(email)) {
                return 'Please enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          // Delivery Note
          _buildTextField(
            controller: _deliveryNoteController,
            label: 'Delivery note (optional)',
            hint: 'Add any special delivery instructions',
            // icon: Icons.note_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }


// ==================== ORDER SUMMARY ====================
  Widget _buildOrderSummary() {
    final data = widget.auctionData;
    final winner = widget.winnerData;

    final double subtotal =
        double.tryParse(
          winner['subtotal']?.toString() ?? '0',
        ) ??
            0;

    final double gst =
        double.tryParse(
          winner['gst']?.toString() ?? '0',
        ) ??
            0;

    final double tax =
        double.tryParse(
          winner['tax']?.toString() ?? '0',
        ) ??
            0;

    final double shipping =
        double.tryParse(
          winner['shipping']?.toString() ?? '0',
        ) ??
            0;

    final double total =
        double.tryParse(
          winner['total']?.toString() ?? '0',
        ) ??
            0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.green.shade700,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),

          const SizedBox(height: 16),

          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 180,
              color: Colors.grey.shade100,
              child: Image.network(
                data['main_image']?.toString() ?? '',
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported_outlined,
                    size: 45,
                    color: Colors.grey.shade400,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.green.shade700,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Product Title
          Text(
            data['title']?.toString() ?? 'Auction Item',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Subtotal
          _buildSummaryRow(
            'Subtotal',
            '₹${subtotal.toStringAsFixed(2)}',
          ),

          // Tax
          _buildSummaryRow(
            'Tax (${gst.toStringAsFixed(0)}%)',
            '₹${tax.toStringAsFixed(2)}',
          ),

          // Shipping
          _buildSummaryRow(
            'Shipping',
            '₹${shipping.toStringAsFixed(2)}',
          ),

          const Divider(
            height: 20,
            thickness: 1,
          ),

          // Total
          _buildSummaryRow(
            'Total',
            '₹${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

// ==================== TEXT FIELD ====================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        filled: true,
        fillColor: Colors.grey[50],

        // Normal Border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),

        // Normal / Enabled
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),

        // Focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.green.shade700,
            width: 2,
          ),
        ),

        // Error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red.shade300,
          ),
        ),

        // Focused + Error
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),

        // Padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        // Label
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
        ),

        // Hint
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 13,
        ),
      ),
    );
  }
  // ==================== SUMMARY ROW ====================
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.green.shade700 : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}