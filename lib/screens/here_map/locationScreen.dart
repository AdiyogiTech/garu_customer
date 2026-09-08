import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:garu_customer/screens/here_map/routing.dart';

class LocationTrackerScreen extends StatefulWidget {
  GeoCoordinates Start, end, deliveryBoy;
  int id;
  LocationTrackerScreen({super.key, required this.Start, required this.end,required this.id,required this.deliveryBoy});
  @override
  State<LocationTrackerScreen> createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {

  @override
  void initState() {
    super.initState();
    log('here ----->>>>>> ${widget.deliveryBoy.latitude} ${widget.deliveryBoy.longitude}');
  }

  RoutingExample? _routingExample;
  HereMapController? _hereMapController;

  String timeDistance = '';
  String Distance = '';

  ///on Map Created Function
  void _onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController;
    _hereMapController?.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError? error) {
      if (error == null) {
        _hereMapController?.mapScene.enableFeatures(
            {MapFeatures.lowSpeedZones: MapFeatureModes.lowSpeedZonesAll});
        _routingExample = RoutingExample(hereMapController);
        _routingExample!.addRoute(
            startCoordination: widget.Start, endCoordination:widget.end, deliveryBoyCoordinates: widget.deliveryBoy,);
        _routingExample!.setTapListener(context: context);
        log('yes');
      } else {
        print("Map scene not loaded. MapError: $error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HereMap(
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
