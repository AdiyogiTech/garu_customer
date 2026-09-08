
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget imageShimmer({double height = 120, double width = 120}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
