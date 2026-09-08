import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.threading.dart';
import 'package:here_sdk/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:here_sdk/animation.dart' as here;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;
import 'package:intl/intl.dart';
import 'package:garu_customer/screens/here_map/timeUtils.dart';
import '../here_map/location_controller.dart';

class RoutingExampleForAddress {

  late final HereMapController _hereMapController;
  List<MapPolyline> _mapPolylines = [];
  late RoutingEngine _routingEngine;
  bool _trafficOptimization = true;
  // final ShowDialogFunction _showDialog;
  List<Waypoint> waypoints = [];
  final _MyLocation_GEO_COORDINATES = GeoCoordinates(26.297852, 73.039742);
  final _timeUtils = TimeUtils();

  late MapMarker startMarkerForTap;
  late MapMarker customerMarker;
  late MapMarker vendorMarker;
  var distanceDeliveryBoy, timeDeliveryBoy;

  LocationController locationController = Get.put(LocationController());

  RoutingExampleForAddress(
      // ShowDialogFunction showDialogCallback,
      HereMapController hereMapController)
  // : _showDialog = showDialogCallback,
  {
    _hereMapController = hereMapController;
    double distanceToEarthInMeters = 3000;
    MapMeasure mapMeasureZoom =
    MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
    _hereMapController.camera.lookAtPointWithMeasure(
        GeoCoordinates(24.5908617, 80.8247403), mapMeasureZoom);

    try {
      _routingEngine = RoutingEngine();
    } on InstantiationException {
      throw ("Initialization of RoutingEngine failed.");
    }
  }

  Future<void> addRoute({
    required GeoCoordinates startCoordination,
    required GeoCoordinates endCoordination,
    required GeoCoordinates deliveryBoyCoordinates,
  }) async {
    var startGeoCoordinates = startCoordination;
    var destinationGeoCoordinates = endCoordination;


    var startWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    var destinationWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);

    waypoints = [startWaypoint, destinationWaypoint];

    // refreshMarker();
    // _hereMapController.mapScene.removeMapMarker(startMarkerForTap);

    int imageWidth = 50;
    int imageHeight = 80;
    MapImage mapImage = MapImage.withFilePathAndWidthAndHeight(
      "assets/images/marker.png",
      imageWidth,
      imageHeight,
    );

    ///for customer
    MapImage customerMapImage = MapImage.withFilePathAndWidthAndHeight(
      "assets/images/customerMarker.png",
      imageWidth,
      imageHeight,
    );

    ///for vendor boy
    MapImage vendorMapImage = MapImage.withFilePathAndWidthAndHeight(
      "assets/images/vendorMarker.png",
      imageWidth,
      imageHeight,
    );

    log('here ----->>>>>> ${deliveryBoyCoordinates.latitude} ${deliveryBoyCoordinates.longitude}');

    customerMarker = MapMarker(
        destinationGeoCoordinates,
        customerMapImage);

    vendorMarker = MapMarker(
        startGeoCoordinates,
        vendorMapImage
    );

    startMarkerForTap = MapMarker(
        deliveryBoyCoordinates,
        mapImage);

    ///customer
    _hereMapController.mapScene.addMapMarker(customerMarker);

    ///vendor
    _hereMapController.mapScene.addMapMarker(vendorMarker);

    ///delivery
    _hereMapController.mapScene.addMapMarker(startMarkerForTap);

    log('here ----->>>>>> ${deliveryBoyCoordinates.latitude} ${deliveryBoyCoordinates.longitude}');

    log('Marker refreshed at: ${deliveryBoyCoordinates}');

    // Calculate route only when required
    _calculateRoute(waypoints);
  }

  void setTapListener({required BuildContext context}) {
    _hereMapController.gestures.tapListener = TapListener((Point2D touchPoint) {
      log('Here in setTapListener');

      GeoCoordinates? tappedCoordinates =
      _hereMapController.viewToGeoCoordinates(touchPoint);

      if (tappedCoordinates == null) return;

      // Check if the tapped location is close to the marker
      if (_isTappedOnMarker(tappedCoordinates, startMarkerForTap.coordinates)) {
        log('Here in setTapListener start');
        _toggleLabel(context, startMarkerForTap.coordinates,'delivery');
      }

      if (_isTappedOnMarker(tappedCoordinates, customerMarker.coordinates)) {
        log('Here in customer setTapListener start');
        _toggleLabel(context, customerMarker.coordinates,'customer');
      }

      if (_isTappedOnMarker(tappedCoordinates, vendorMarker.coordinates)) {
        log('Here in vendor setTapListener start');
        _toggleLabel(context, vendorMarker.coordinates,'vendor');
      }
    });
  }

  bool _isTappedOnMarker(
      GeoCoordinates tappedCoordinates, GeoCoordinates markerCoordinates) {
    const double distanceThresholdInMeters =
    20; // Define a tap sensitivity radius
    double distance = tappedCoordinates.distanceTo(markerCoordinates);
    return distance <= distanceThresholdInMeters;
  }

  bool _isLabelVisible = false;

  void _toggleLabel(BuildContext context, GeoCoordinates coordinates, String whatIs) {
    if (_isLabelVisible) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } else {
      // Initialize SearchEngine
      try {
        SearchEngine searchEngine = SearchEngine();

        // Search by coordinates to get address
        TaskHandle taskHandle = searchEngine.searchByCoordinates(
          coordinates,
          SearchOptions(), // Default search options
              (SearchError? searchError, List<Place>? places) {
            if (searchError != null || places == null || places.isEmpty) {
              print("Error fetching address or no address found.");
              return;
            }

            String address = places.first.address.addressText;

            // Determine the label text
            String labelText = (whatIs == 'delivery')
                ? 'Delivery Boy\'s Location Distance: $distanceDeliveryBoy, Time: $timeDeliveryBoy'
                : (whatIs == 'customer')
                ? "Customer's Location: $address"
                : "Vendor's Location: $address";

            // Show the label
            final snackBar = SnackBar(
              content: Text(labelText),
              duration: const Duration(hours: 10),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );
      } catch (e) {
        print("Error initializing HERE SDK: $e");
      }
    }

    // Toggle the state
    _isLabelVisible = !_isLabelVisible;
  }

  void toggleTrafficOptimization() {
    _trafficOptimization = !_trafficOptimization;
    if (waypoints.isNotEmpty) {
      _calculateRoute(waypoints);
    }
  }

  void _calculateRoute(List<Waypoint> waypoints) {
    CarOptions carOptions = CarOptions();
    carOptions.routeOptions.enableTolls = true;
    // Disabled - Traffic optimization is completely disabled, including long-term road closures. It helps in producing stable routes.
    // Time dependent - Traffic optimization is enabled, the shape of the route will be adjusted according to the traffic situation which depends on departure time and arrival time.
    carOptions.routeOptions.trafficOptimizationMode = _trafficOptimization
        ? TrafficOptimizationMode.timeDependent
        : TrafficOptimizationMode.disabled;

    _routingEngine.calculateCarRoute(waypoints, carOptions,
            (RoutingError? routingError, List<here.Route>? routeList) async {
          if (routingError == null) {
            // When error is null, then the list guaranteed to be not null.
            here.Route route = routeList!.first;
            _showRouteDetails(route);
            _showRouteOnMap(route);
            // _logRouteRailwayCrossingDetails(route);
            _logRouteSectionDetails(route);
            // _logRouteViolations(route);
            // _logTollDetails(route);
            _animateToRoute(route);
          } else {
            var error = routingError.toString();
            // _showDialog('Error', 'Error while calculating a route: $error');
          }
        });
  }
  //
  // String _toString(GeoCoordinates geoCoordinates) {
  //   return "${geoCoordinates.latitude},  ${geoCoordinates.longitude}";
  // }

  void _logRouteSectionDetails(here.Route route) {
    DateFormat dateFormat = DateFormat().add_Hm();

    for (int i = 0; i < route.sections.length; i++) {
      Section section = route.sections.elementAt(i);

      print("Route Section : " + (i + 1).toString());
      print("Route Section Departure Time: " +
          dateFormat.format(section.departureLocationTime!.localTime));
      print("Route Section Arrival Time: " +
          dateFormat.format(section.arrivalLocationTime!.localTime));
      print(
          "Route Section length: " + section.lengthInMeters.toString() + " m");
      print("Route Section duration: " +
          section.duration.inSeconds.toString() +
          " s");
    }
  }

  /*i need to send data time duration and distance in killo meter*/
  void _showRouteDetails(here.Route route) {
    // estimatedTravelTimeInSeconds includes traffic delay.
    int estimatedTravelTimeInSeconds = route.duration.inSeconds;
    int estimatedTrafficDelayInSeconds = route.trafficDelay.inSeconds;
    int lengthInMeters = route.lengthInMeters;

    distanceDeliveryBoy = _timeUtils.formatLength(lengthInMeters);
    timeDeliveryBoy = _timeUtils
        .formatTime(estimatedTravelTimeInSeconds);
    // Timezones can vary depending on the device's geographic location.
    // For instance, when calculating a route, the device's current timezone may differ from that of the destination.
    // Consider a scenario where a user calculates a route from Berlin to London — each city operates in a different timezone.
    // To address this, you can display the Estimated Time of Arrival (ETA) in multiple timezones: the device's current timezone (Berlin), the destination's timezone (London), and UTC (Coordinated Universal Time), which serves as a global reference.
    String routeDetails =
        'Travel Time: ${_timeUtils.formatTime(estimatedTravelTimeInSeconds)}, Traffic Delay: ${_timeUtils.formatTime(estimatedTrafficDelayInSeconds).replaceAll("0:", '')}, Length: ${_timeUtils.formatLength(lengthInMeters)}\nETA in device timezone: ${_timeUtils.getETAinDeviceTimeZone(route)}\nETA in destination timezone: ${_timeUtils.getETAinDestinationTimeZone(route)}\nETA in UTC: ${_timeUtils.getEstimatedTimeOfArrivalInUTC(route)}';

    // _showDialog('Route Details', routeDetails);
  }

  _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = route.geometry;
    double widthInPixels = 10;
    Color polylineColor = const Color(0xff4da6ff);
    MapPolyline routeMapPolyline;
    try {
      routeMapPolyline = MapPolyline.withRepresentation(
          routeGeoPolyline,
          MapPolylineSolidRepresentation(
              MapMeasureDependentRenderSize.withSingleSize(
                  RenderSizeUnit.pixels, widthInPixels),
              polylineColor,
              LineCap.round));
      _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
      _mapPolylines.add(routeMapPolyline);
    } on MapPolylineRepresentationInstantiationException catch (e) {
      print("MapPolylineRepresentation Exception:${e.error.name}");
      return;
    } on MapMeasureDependentRenderSizeInstantiationException catch (e) {
      print("MapMeasureDependentRenderSize Exception:${e.error.name}");
      return;
    }

    // Optionally, render traffic on route.
    // _showTrafficOnRoute(route);
  }

  void _animateToRoute(here.Route route) {
    // The animation results in an untilted and unrotated map.
    double bearing = 0;
    double tilt = 0;
    // We want to show the route fitting in the map view with an additional padding of 50 pixels.
    Point2D origin = Point2D(50, 50);
    Size2D sizeInPixels = Size2D(_hereMapController.viewportSize.width - 100,
        _hereMapController.viewportSize.height - 100);
    Rectangle2D mapViewport = Rectangle2D(origin, sizeInPixels);

    // Animate to the route within a duration of 3 seconds.
    MapCameraUpdate update =
    MapCameraUpdateFactory.lookAtAreaWithGeoOrientationAndViewRectangle(
        route.boundingBox,
        GeoOrientationUpdate(bearing, tilt),
        mapViewport);
    MapCameraAnimation animation =
    MapCameraAnimationFactory.createAnimationFromUpdateWithEasing(
        update,
        const Duration(milliseconds: 3000),
        here.Easing(here.EasingFunction.inCubic));
    _hereMapController.camera.startAnimation(animation);
  }

  ///
  Future<Position> determinePosition() async {
    LocationPermission permission;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, cannot request.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void addMarkerAtLocation(GeoCoordinates geoCoordinates) {
    final Image image = Image.asset("assets/marker.png");
    MapImage mapImage = MapImage.withFilePathAndWidthAndHeight(
      "assets/images/marker.png",
      50,
      80,
    );

    MapMarker marker = MapMarker(geoCoordinates, mapImage);
    _hereMapController.mapScene.addMapMarker(marker);
  }

}