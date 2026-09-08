import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:garu_customer/constant/api.dart';
import '../../Environment/Environment.dart';
import '../../helper_widget/appbar_helper.dart';
import '../constant/colors.dart';
import 'return_response_controller.dart';
import 'return_order_detail_page.dart'; // You'll need to create this

class ReturnResponsePage extends GetView<ReturnResponseController> {
  const ReturnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure controller is registered
    Get.put(ReturnResponseController(), permanent: false);

    // Fetch data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchReturnRequests();
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Return Requests',
        displaySearch: false,
        displayCart: false,
      ),
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: primarylogin,
                  strokeWidth: 2,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading return requests...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Show error message
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarylogin,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => controller.fetchReturnRequests(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state
        if (controller.returnRequestData.isEmpty) {
          return Center(
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
                    Icons.assignment_return_outlined,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No return requests found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your return requests will appear here',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        // Display the data
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.returnRequestData.length,
          itemBuilder: (context, index) {
            final returnItem = controller.returnRequestData[index];
            return _buildReturnRequestCard(returnItem);
          },
        );
      }),
    );
  }

  Widget _buildReturnRequestCard(Map<String, dynamic> returnItem) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail page
        Get.to(() => ReturnOrderDetailPage(
          returnItem: returnItem,
          controller: controller,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            // Header with Status and Voucher
            // Row(
            //   children: [
            //     // Icon based on status
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: _getStatusColor(returnItem['return_status_name']).withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Icon(
            //         _getStatusIcon(returnItem['return_status_name']),
            //         color: _getStatusColor(returnItem['return_status_name']),
            //         size: 24,
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //
            //     // Voucher and Date
            //     // Expanded(
            //     //   child: Column(
            //     //     crossAxisAlignment: CrossAxisAlignment.start,
            //     //     children: [
            //     //       Text(
            //     //         'Voucher #${returnItem['voucher_no']?.toUpperCase() ?? 'N/A'}',
            //     //         style: TextStyle(
            //     //           fontWeight: FontWeight.w600,
            //     //           fontSize: 14,
            //     //           color: Colors.grey[900],
            //     //         ),
            //     //         overflow: TextOverflow.ellipsis,
            //     //         maxLines: 1,
            //     //       ),
            //     //       const SizedBox(height: 4),
            //     //       Row(
            //     //         children: [
            //     //           Icon(
            //     //             Icons.calendar_today_outlined,
            //     //             size: 10,
            //     //             color: Colors.grey[500],
            //     //           ),
            //     //           const SizedBox(width: 4),
            //     //           Text(
            //     //             _formatDate(returnItem['created_at']),
            //     //             style: TextStyle(
            //     //               fontSize: 11,
            //     //               color: Colors.grey[600],
            //     //             ),
            //     //           ),
            //     //         ],
            //     //       ),
            //     //     ],
            //     //   ),
            //     // ),
            //
            //     // Status Badge
            //     Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 10,
            //         vertical: 5,
            //       ),
            //       decoration: BoxDecoration(
            //         color: _getStatusColor(returnItem['return_status_name']).withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Text(
            //         returnItem['return_status_name'] ?? 'N/A',
            //         style: TextStyle(
            //           fontSize: 10,
            //           fontWeight: FontWeight.w500,
            //           color: _getStatusColor(returnItem['return_status_name']),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 16),

            // Product Details
            Row(
              children: [
                // Product Image
                Container(
                  width: 70,
                  height: 70,
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
                        return Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 30,
                        );
                      },
                    )
                        : Icon(
                      Icons.shopping_bag,
                      color: Colors.grey[400],
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        returnItem['product_name'] ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey[900],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (returnItem['attribute_name'] != null)
                        Text(
                          returnItem['attribute_name'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Qty: ${returnItem['quantity'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '₹${_formatPrice(returnItem['total_price'])}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: primarylogin,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order Number and Action
         /*   Row(
              children: [
                // Order Number
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Order #${returnItem['order_no']?.toUpperCase() ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Badge (if any)
                if (returnItem['return_action_name'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
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
                          size: 10,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          returnItem['return_action_name'],
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Arrow indicator
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),

            // Attachment Indicator
            if (returnItem['attachment'] != null &&
                returnItem['attachment'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 12,
                    color: Colors.blue[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Attachment available',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],

            // Comment Preview
            if (returnItem['comment'] != null &&
                returnItem['comment'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      returnItem['comment'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],*/
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'completed':
        return Icons.task_alt;
      default:
        return Icons.assignment_return;
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
}