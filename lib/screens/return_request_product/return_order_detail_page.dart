import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../constant/api.dart';
import '../../helper_widget/appbar_helper.dart';
import '../constant/colors.dart';
import 'return_response_controller.dart';

class ReturnOrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> returnItem;
  final ReturnResponseController controller;

  const ReturnOrderDetailPage({
    Key? key,
    required this.returnItem,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Return Request Details',
        displaySearch: false,
        displayCart: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(),
            SizedBox(height: height * 0.02),

            // Product Details Section
            _buildSectionTitle('Product Details', Icons.shopping_bag),
            SizedBox(height: height * 0.01),
            _buildProductCard(),
            SizedBox(height: height * 0.02),

            // Order Information Section
            _buildSectionTitle('Order Information', Icons.receipt_long),
            SizedBox(height: height * 0.01),
            _buildOrderInfoCard(),
            SizedBox(height: height * 0.02),

            // Vendor Details Section
            _buildSectionTitle('Vendor Details', Icons.store),
            SizedBox(height: height * 0.01),
            _buildVendorCard(),
            SizedBox(height: height * 0.02),

            // Return Details Section
            if (returnItem['comment'] != null &&
                returnItem['comment'].toString().isNotEmpty) ...[
              _buildSectionTitle('Return Details', Icons.description),
              SizedBox(height: height * 0.01),
              _buildReturnDetailsCard(),
              SizedBox(height: height * 0.02),
            ],

            // Attachment Section
            if (returnItem['attachment'] != null &&
                returnItem['attachment'].toString().isNotEmpty) ...[
              _buildSectionTitle('Attachment', Icons.attach_file),
              SizedBox(height: height * 0.01),
              _buildAttachmentCard(),
              SizedBox(height: height * 0.02),
            ],

            // Timeline/History Section
            _buildSectionTitle('Request Timeline', Icons.history),
            SizedBox(height: height * 0.01),
            _buildTimelineCard(),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(returnItem['return_status_name']).withOpacity(0.1),
            _getStatusColor(returnItem['return_status_name']).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(returnItem['return_status_name']).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(returnItem['return_status_name']).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(returnItem['return_status_name']),
              color: _getStatusColor(returnItem['return_status_name']),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Status Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  returnItem['return_status_name'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(returnItem['return_status_name']),
                  ),
                ),
                if (returnItem['return_action_name'] != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 12,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Action: ${returnItem['return_action_name']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Request Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDate(returnItem['created_at']),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '#${returnItem['voucher_no'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: primarylogin,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            size: 16,
            color: primarylogin,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: returnItem['product_image'] != null
                  ? Image.network(
                  '$imageUrl${returnItem['product_image']}',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                    ],
                  );
                },
              )
                  : Icon(
                Icons.shopping_bag,
                color: Colors.grey[400],
                size: 40,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  returnItem['product_name'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Attribute:',
                  returnItem['attribute_name'] ?? 'N/A',
                ),
                const SizedBox(height: 4),
                _buildDetailRow(
                  'Quantity:',
                  returnItem['quantity']?.toString() ?? 'N/A',
                ),
                const SizedBox(height: 4),
                _buildDetailRow(
                  'Price:',
                  '₹${_formatPrice(returnItem['total_price'])}',
                  isPrice: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.receipt,
            label: 'Order Number',
            value: returnItem['order_no'] ?? 'N/A',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.confirmation_number,
            label: 'Voucher Number',
            value: returnItem['voucher_no'] ?? 'N/A',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Return Request Date',
            value: _formatDateTime(returnItem['created_at']),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.business,
            label: 'Vendor Name',
            value: returnItem['vendor_name'] ?? 'N/A',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.email,
            label: 'Email',
            value: returnItem['vendor_email'] ?? 'N/A',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.phone,
            label: 'Mobile',
            value: returnItem['vendor_mobile'] ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildReturnDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.comment,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Reason for Return',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              returnItem['comment']?.toString() ?? 'No reason provided',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard() {
    return GestureDetector(
      onTap: () => _showAttachment(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachment',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Click to view attachment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.open_in_new,
                size: 18,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard() {
    // Get status ID and name
    String statusId = returnItem['return_status_id']?.toString() ?? '1';
    String statusName = returnItem['return_status_name']?.toString() ?? 'Pending';

    // Determine which steps are completed based on status ID
    bool isPending = statusId == '1';
    bool isAwaitingProducts = statusId == '2';
    bool isCompleted = statusId == '3';

    // Create timeline events based on actual status flow
    List<Map<String, dynamic>> timelineEvents = [
      {
        'status': 'Pending',
        'date': returnItem['created_at'],
        'description': 'Return request has been submitted and is pending',
        'isCompleted': true, // Always completed as request exists
        'isActive': isPending,
      },
      {
        'status': 'Awaiting Products',
        'date': isAwaitingProducts || isCompleted ? returnItem['updated_at'] : null,
        'description': 'Waiting for products to be received',
        'isCompleted': isAwaitingProducts || isCompleted,
        'isActive': isAwaitingProducts,
      },
      {
        'status': 'Completed',
        'date': isCompleted ? returnItem['updated_at'] : null,
        'description': 'Return request has been completed',
        'isCompleted': isCompleted,
        'isActive': isCompleted,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current status indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusName).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(statusName).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(statusName),
                        size: 16,
                        color: _getStatusColor(statusName),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Current: $statusName',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(statusName),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Timeline events
          ...List.generate(timelineEvents.length, (index) {
            final event = timelineEvents[index];
            final isLast = index == timelineEvents.length - 1;

            return _buildTimelineItem(
              status: event['status'],
              date: event['date'],
              description: event['description'],
              isCompleted: event['isCompleted'],
              isActive: event['isActive'],
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String status,
    required String? date,
    required String description,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line with enhanced styling
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : (isActive ? Colors.blue : Colors.grey[300]),
                border: Border.all(
                  color: isCompleted
                      ? Colors.green
                      : (isActive ? Colors.blue : Colors.grey[400]!),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              )
                  : (isActive
                  ? Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
                  : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted
                    ? Colors.green
                    : (isActive ? Colors.blue : Colors.grey[300]),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Event details with enhanced styling
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive || isCompleted
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isCompleted
                          ? Colors.black87
                          : (isActive ? Colors.blue : Colors.grey[500]),
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Current',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              if (date != null)
                Text(
                  _formatDateTime(date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (!isLast) const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primarylogin.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 14,
            color: primarylogin,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 15 : 12,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
            color: isPrice ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'awaiting products':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'awaiting products':
        return Icons.inventory;
      case 'completed':
        return Icons.task_alt;
      default:
        return Icons.info;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date.toLocal());
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateTime(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy • hh:mm a').format(date.toLocal());
    } catch (e) {
      return dateString;
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    try {
      if (price is num) {
        return price.toStringAsFixed(2);
      }
      return price.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  void _showAttachment() {
    String attachmentUrl = returnItem['attachment']?.toString() ?? '';
    if (attachmentUrl.isEmpty) return;

    String fullUrl = '$imageUrl$attachmentUrl';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Attachment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Image
              Container(
                height: 400,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    fullUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          color: primarylogin,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarylogin,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Close',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}