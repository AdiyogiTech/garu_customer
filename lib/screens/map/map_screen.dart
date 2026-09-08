import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:map_picker/map_picker.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/map/create_address.dart';
import 'package:garu_customer/screens/map/map_controller.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:garu_customer/screens/map/routes.dart';
import '../here_map/routing.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapPickerController mapPickerController = MapPickerController();
  var choosecameraPosition;

  GeoCoordinates? currentLocation;

  MapController mapController = Get.put(MapController());
  late GoogleMapController createmapControllers;
  // bool _isLoading = true;
  var pincode;
  var address;

  /*here map*/
  late HereMapController _hereMapController;
  bool _isLoading = false;
  GeoCoordinates? _currentLocation;
  GeoCoordinates? _cameraCoordinates;
  String mapAddress = "Searching address...";
  bool _locationPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    SdkContext.init(IsolateOrigin.main);
    _checkLocationPermission();
    initSearchEngine();
  }

  Future<void> _checkLocationPermission() async {
    setState(() => _isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServicesDialog();
      setState(() {
        _locationPermissionDenied = true;
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        setState(() {
          _locationPermissionDenied = true;
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionPermanentlyDeniedDialog();
      setState(() {
        _locationPermissionDenied = true;
        _isLoading = false;
      });
      return;
    }

    // Permission granted, initialize location
    _initializeLocation();
  }

  void _showLocationServicesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Location Services Required',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Please enable location services to use the map feature.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
                _checkLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primarylogin,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Location Permission Required',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Please grant location permission to use the map feature.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.requestPermission();
                _checkLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primarylogin,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Grant Permission'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Location Permission Permanently Denied',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Location permission is permanently denied. Please enable it from app settings.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
                _checkLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primarylogin,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _initializeLocation() async {
    setState(() => _isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = GeoCoordinates(position.latitude, position.longitude);
        _isLoading = false;
        _locationPermissionDenied = false;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() => _isLoading = false);
    }
  }

  RoutingExampleForAddress? _routingExample;

  late SearchEngine _searchEngine;

  void _onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController;

    _hereMapController.mapScene.loadSceneForMapScheme(
      MapScheme.normalDay,
          (MapError? error) async {
        if (error == null) {
          //Initialize it FIRST
          _routingExample = RoutingExampleForAddress(hereMapController);
          _routingExample!.setTapListener(context: context);

          //use
          if (_currentLocation != null) {
            _hereMapController.camera.lookAtPoint(_currentLocation!);
            startCameraTracking();
          } else {
            // Default location if no current location
            GeoCoordinates defaultLocation = GeoCoordinates(28.6139, 77.2090);
            _hereMapController.camera.lookAtPoint(defaultLocation);
            startCameraTracking();
          }
        } else {
          print("Error loading map: $error");
        }
      },
    );
  }

  GeoCoordinates? _lastCoordinates;
  Timer? _cameraIdleTimer;

  void initSearchEngine() {
    try {
      _searchEngine = SearchEngine();
    } catch (e) {
      print("SearchEngine init failed: $e");
    }
  }

  void startCameraTracking() {
    // Call this once after map loads
    const interval = Duration(milliseconds: 300);
    _cameraIdleTimer = Timer.periodic(interval, (timer) {
      if (_hereMapController.camera.state.targetCoordinates != null) {
        final current = _hereMapController.camera.state.targetCoordinates;

        // Compare with previous position
        if (_lastCoordinates != null) {
          double distance = current.distanceTo(_lastCoordinates!);
          if (distance < 2.0) {
            // Camera has likely stopped
            print("Stopped at: ${current.latitude}, ${current.longitude}");

            currentLocation = current;

            _reverseGeocode(current); // Optional
          }
        }

        // Update for next comparison
        _lastCoordinates = current;
      }
    });
  }

  void _reverseGeocode(GeoCoordinates coordinates) {
    _searchEngine.searchByCoordinates(coordinates, SearchOptions(), (SearchError? error, List<Place>? places) {
      if (error != null) {
        print("Reverse geocoding failed: $error");
        return;
      }

      if (places != null && places.isNotEmpty) {
        final address = places.first.address;
        print("Address: ${address.addressText}");
        setState(() {
          mapAddress = address.addressText;
        });
      }
    });
  }

  /*here map*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: primarylogin,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _locationPermissionDenied
                        ? "Location access required"
                        : "Loading map...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_locationPermissionDenied) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _checkLocationPermission,
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
                      ),
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      )
          : Stack(
        children: [
          ///map
          HereMap(onMapCreated: _onMapCreated),

          ///text address name
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primarylogin.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: primarylogin,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      mapAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///marker
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: primarylogin,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          ///continue button
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: GetBuilder<MapController>(builder: (mapContro) {
              return ElevatedButton(
                onPressed: () async {
                  if (currentLocation == null) {
                    Fluttertoast.showToast(
                      msg: "Please select a location",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }

                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      currentLocation!.latitude,
                      currentLocation!.longitude,
                    );

                    if (placemarks.isNotEmpty) {
                      String? address1 = placemarks[0].name!.isNotEmpty
                          ? placemarks[0].name
                          : placemarks[0].subLocality ?? '';
                      String address2 = placemarks[0].locality ?? '';

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAddress(
                            latitute: currentLocation!.latitude.toString(),
                            longitute: currentLocation!.longitude.toString(),
                            address1: address1,
                            address2: address2,
                            pincode: placemarks[0].postalCode ?? '',
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Error getting address",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }

                  _cameraIdleTimer?.cancel();
                  _cameraIdleTimer = null;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primarylogin,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                child: mapContro.mapLoader.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                    : const Text(
                  "Confirm Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );


  }
}

class MyCameraListener implements MapCameraListener {
  final void Function(GeoCoordinates coords) onMoved;

  MyCameraListener(this.onMoved);

  @override
  void onMapCameraUpdated(MapCameraState cameraState) {
    onMoved(cameraState.targetCoordinates);
  }
}