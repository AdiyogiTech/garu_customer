import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Function to get current location
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied");
        return null;
      }
    }

    // Fetch the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  // Function to convert latitude and longitude to a human-readable address
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      // Perform reverse geocoding
      List<Placemark> placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(latitude, longitude);

      // Check if placemarks are available and return a formatted address
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        log('thisi s============= ${placemark}');
        String address = '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, , ${placemark.country}, ${placemark.postalCode}';
        return address;
      }
    } catch (e) {
      print("Error getting address: $e");
      return 'Address not available'; // In case of error, return a default message
    }

    return 'Address not available';
  }
}
