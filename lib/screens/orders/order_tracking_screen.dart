import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_tracking_controller.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? initialWaybill;

  const OrderTrackingScreen({Key? key, this.initialWaybill}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late final OrderTrackingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OrderTrackingController());

    if (widget.initialWaybill != null &&
        widget.initialWaybill!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setWaybillAndFetch(widget.initialWaybill!);
      });
    }
  }

  @override
  void dispose() {
    Get.delete<OrderTrackingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Order Tracking",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.black),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () async {
                if (controller.waybill.value.isNotEmpty) {
                  await controller.fetchOrderTracking();
                }
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.trackingData.value.isEmpty) {
          return const Center(child: Text("No Data Found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order: ${controller.referenceNo.value}"),
                          Text("AWB: ${controller.awbNumber.value}"),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: controller.getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        controller.currentStatus.value,
                        style: TextStyle(
                          color: controller.getStatusColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= ORDER DETAILS =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Order Details",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    Text("AWB: ${controller.awbNumber.value}"),
                    Text("Reference: ${controller.referenceNo.value}"),
                    Text("Order Type: ${controller.getValue('OrderType')}"),
                    Text("Amount: ${controller.formatCurrency(controller.getValue('InvoiceAmount'))}"),
                  ],
                ),
              ),

              const SizedBox(height: 16),


              // ================= ADDRESS =================
              if (controller.getFullAddress() != 'N/A')
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _boxDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.getFullAddress(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // ================= TIMELINE =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tracking History",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    ...controller.scansList.map((scan) {
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFAFAFA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      scan['Scan'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.formatDate(scan['ScanDateTime']),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(scan['ScannedLocation'] ?? ''),
                                    const SizedBox(height: 4),
                                    Text(
                                      scan['Instructions'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }





  // ================= COMMON =================
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}