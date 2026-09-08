import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:garu_customer/screens/auctions/auction_detail_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../helper_widget/imageShimmer.dart';
import '../constant/colors.dart';
import 'auction_about_screen.dart';
import 'controller/auctions_controller.dart';

class AuctionsScreen extends StatefulWidget {
  const AuctionsScreen({super.key});

  @override
  State<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends State<AuctionsScreen> {
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Live', 'Upcoming', 'Ended'];

  AuctionController auctionController = Get.put(AuctionController());

  @override
  void initState() {
    super.initState();
    auctionController.getAuctionList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: primarylogin.withOpacity(0.11),
      /*appBar: HelperAppBar(title: 'Auctions',
      centerTitle: true,
      displayCart: false,
      displaySearch: false,),*/
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// Background Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/auction_bg.png',
                width: size.width,
                height: size.height * 0.28,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                15,
                0,
                size.height * 0.1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/the_garu_vault_treasurer.jpg',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Title
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: "The Garu Vault ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Treasures",
                          style: TextStyle(
                            color: primarylogin,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Subtitle
                  Text(
                    "Your chance to own a piece of history. \nParticipate in the treasure hunt and bid \non the items you want.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: SizedBox(
                      width: size.width * 0.28,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => AuctionAboutScreen());
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          side: BorderSide(
                            color: primary,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Know More",
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Filter Chips
                  _buildFilterChips(),

                  // Grid View
                  GetBuilder<AuctionController>(
                    builder: (controller) {
                      if (auctionController.auctionLoading.value) {
                        return Padding(
                          padding:  EdgeInsets.symmetric(vertical: size.height*0.15),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
                        child: _buildAuctionGrid(size),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: filterOptions.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              showCheckmark: false,
              // Tick remove

              avatar: isSelected
                  ? const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
              selected: isSelected,
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              backgroundColor: Colors.white,
              selectedColor: primary,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? primarylogin : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAuctionGrid(Size size) {
    // Filter the list based on selected filter
    List filteredList = auctionController.auctionList;
    if (selectedFilter != 'All') {
      filteredList = auctionController.auctionList
          .where((item) =>
              item["phase"].toString().toLowerCase() ==
              selectedFilter.toLowerCase())
          .toList();
    }
    log("filterlist>>>> ${filteredList.toString()}");
    if (filteredList.isEmpty) {
      return Padding(
        padding:  EdgeInsets.symmetric(vertical: size.height*0.12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No vaults found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try changing the filter',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return _buildAuctionCard(item, size);
      },
    );
  }

  Widget _buildAuctionCard(Map<String, dynamic> item, Size size) {
    Color statusColor;
    String statusText = item["phase"].toString().toUpperCase();

    switch (item["phase"].toString().toLowerCase()) {
      case "live":
        statusColor = Colors.green;
        break;
      case "upcoming":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }
    String formatDateTime(String date) {
      try {
        final DateTime dateTime = DateTime.parse(date);
        return DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
      } catch (e) {
        return date;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:  primarylogin.withOpacity(0.11),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Status Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  item["main_image"],
                  width: double.infinity,
                  height: size.height * 0.14,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return imageShimmer(
                      height: size.height * 0.14,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item["title"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 4),
                    // Start Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Start:",
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            formatDateTime(item["start_at"]),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // End Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "End:",
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            formatDateTime(item["end_at"]),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Current Bid
                    Row(
                      children: [
                        Text(
                          'Current bid:',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "₹${item["current_highest_bid"]} (${item['total_bids']} bids)",
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Bottom Row
                Divider(
                  color: Colors.grey.shade300,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Entry Fee",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "₹${item["participation_fee"]}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(AuctionDetailScreen(
                          auctionId: item['id'],
                        ));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff2E7D32),
                              Color(0xff43A047),
                            ],
                          ),
                        ),
                        child: Center(
                          child: const Text(
                            "View",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Auctions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filterOptions.map((filter) {
                  final isSelected = selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    selectedColor: primarylogin,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'All';
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Clear Filter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
