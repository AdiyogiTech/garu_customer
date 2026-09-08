// Copyright (c) 2018-2024 HERE Global B.V. and its affiliate(s).
// All rights reserved.
//
// This software and other materials contain proprietary information
// controlled by HERE and are protected by applicable copyright legislation.
// Any use and utilization of this software and other materials and
// disclosure to any third parties is conditional upon having a separate
// agreement with HERE for the access, use, utilization or disclosure of this
// software. In the absence of such agreement, the use of the software is not
// allowed.
//

import 'dart:ffi';
import 'package:collection/collection.dart';
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/routing/route_place.dart';
import 'package:here_sdk/src/sdk/routing/traffic_incident_on_route.dart';
import 'package:here_sdk/src/sdk/routing/traffic_on_span.dart';

/// Traffic information on a section.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behaviors. Related APIs may change for new releases without a deprecation process.

class TrafficOnSection {
  /// List of coordinates representing the polyline of this section.
  List<GeoCoordinates> geometry;

  /// List of traffic spans.
  List<TrafficOnSpan> trafficSpans;

  /// List of traffic incidents.
  List<TrafficIncidentOnRoute> trafficIncidents;

  /// Describes the departure place.
  RoutePlace departurePlace;

  /// Describes the arrival place.
  RoutePlace arrivalPlace;

  /// Creates a new instance.

  /// [geometry] List of coordinates representing the polyline of this section.

  /// [trafficSpans] List of traffic spans.

  /// [trafficIncidents] List of traffic incidents.

  /// [departurePlace] Describes the departure place.

  /// [arrivalPlace] Describes the arrival place.

  TrafficOnSection._(this.geometry, this.trafficSpans, this.trafficIncidents, this.departurePlace, this.arrivalPlace);
  TrafficOnSection(RoutePlace departurePlace, RoutePlace arrivalPlace)
    : geometry = [], trafficSpans = [], trafficIncidents = [], departurePlace = departurePlace, arrivalPlace = arrivalPlace;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TrafficOnSection) return false;
    TrafficOnSection _other = other;
    return DeepCollectionEquality().equals(geometry, _other.geometry) &&
        DeepCollectionEquality().equals(trafficSpans, _other.trafficSpans) &&
        DeepCollectionEquality().equals(trafficIncidents, _other.trafficIncidents) &&
        departurePlace == _other.departurePlace &&
        arrivalPlace == _other.arrivalPlace;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + DeepCollectionEquality().hash(geometry);
    result = 31 * result + DeepCollectionEquality().hash(trafficSpans);
    result = 31 * result + DeepCollectionEquality().hash(trafficIncidents);
    result = 31 * result + departurePlace.hashCode;
    result = 31 * result + arrivalPlace.hashCode;
    return result;
  }
}


// TrafficOnSection "private" section, not exported.

final _sdkRoutingTrafficonsectionCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_create_handle'));
final _sdkRoutingTrafficonsectionReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_release_handle'));
final _sdkRoutingTrafficonsectionGetFieldgeometry = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_get_field_geometry'));
final _sdkRoutingTrafficonsectionGetFieldtrafficSpans = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_get_field_trafficSpans'));
final _sdkRoutingTrafficonsectionGetFieldtrafficIncidents = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_get_field_trafficIncidents'));
final _sdkRoutingTrafficonsectionGetFielddeparturePlace = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_get_field_departurePlace'));
final _sdkRoutingTrafficonsectionGetFieldarrivalPlace = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_get_field_arrivalPlace'));



Pointer<Void> sdkRoutingTrafficonsectionToFfi(TrafficOnSection value) {
  final _geometryHandle = heresdkRoutingCommonBindingslistofSdkCoreGeocoordinatesToFfi(value.geometry);
  final _trafficSpansHandle = heresdkRoutingCommonBindingslistofSdkRoutingTrafficonspanToFfi(value.trafficSpans);
  final _trafficIncidentsHandle = heresdkRoutingCommonBindingslistofSdkRoutingTrafficincidentonrouteToFfi(value.trafficIncidents);
  final _departurePlaceHandle = sdkRoutingRouteplaceToFfi(value.departurePlace);
  final _arrivalPlaceHandle = sdkRoutingRouteplaceToFfi(value.arrivalPlace);
  final _result = _sdkRoutingTrafficonsectionCreateHandle(_geometryHandle, _trafficSpansHandle, _trafficIncidentsHandle, _departurePlaceHandle, _arrivalPlaceHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeocoordinatesReleaseFfiHandle(_geometryHandle);
  heresdkRoutingCommonBindingslistofSdkRoutingTrafficonspanReleaseFfiHandle(_trafficSpansHandle);
  heresdkRoutingCommonBindingslistofSdkRoutingTrafficincidentonrouteReleaseFfiHandle(_trafficIncidentsHandle);
  sdkRoutingRouteplaceReleaseFfiHandle(_departurePlaceHandle);
  sdkRoutingRouteplaceReleaseFfiHandle(_arrivalPlaceHandle);
  return _result;
}

TrafficOnSection sdkRoutingTrafficonsectionFromFfi(Pointer<Void> handle) {
  final _geometryHandle = _sdkRoutingTrafficonsectionGetFieldgeometry(handle);
  final _trafficSpansHandle = _sdkRoutingTrafficonsectionGetFieldtrafficSpans(handle);
  final _trafficIncidentsHandle = _sdkRoutingTrafficonsectionGetFieldtrafficIncidents(handle);
  final _departurePlaceHandle = _sdkRoutingTrafficonsectionGetFielddeparturePlace(handle);
  final _arrivalPlaceHandle = _sdkRoutingTrafficonsectionGetFieldarrivalPlace(handle);
  try {
    return TrafficOnSection._(
      heresdkRoutingCommonBindingslistofSdkCoreGeocoordinatesFromFfi(_geometryHandle), 
      heresdkRoutingCommonBindingslistofSdkRoutingTrafficonspanFromFfi(_trafficSpansHandle), 
      heresdkRoutingCommonBindingslistofSdkRoutingTrafficincidentonrouteFromFfi(_trafficIncidentsHandle), 
      sdkRoutingRouteplaceFromFfi(_departurePlaceHandle), 
      sdkRoutingRouteplaceFromFfi(_arrivalPlaceHandle)
    );
  } finally {
    heresdkRoutingCommonBindingslistofSdkCoreGeocoordinatesReleaseFfiHandle(_geometryHandle);
    heresdkRoutingCommonBindingslistofSdkRoutingTrafficonspanReleaseFfiHandle(_trafficSpansHandle);
    heresdkRoutingCommonBindingslistofSdkRoutingTrafficincidentonrouteReleaseFfiHandle(_trafficIncidentsHandle);
    sdkRoutingRouteplaceReleaseFfiHandle(_departurePlaceHandle);
    sdkRoutingRouteplaceReleaseFfiHandle(_arrivalPlaceHandle);
  }
}

void sdkRoutingTrafficonsectionReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingTrafficonsectionReleaseHandle(handle);

// Nullable TrafficOnSection

final _sdkRoutingTrafficonsectionCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_create_handle_nullable'));
final _sdkRoutingTrafficonsectionReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_release_handle_nullable'));
final _sdkRoutingTrafficonsectionGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSection_get_value_nullable'));

Pointer<Void> sdkRoutingTrafficonsectionToFfiNullable(TrafficOnSection? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTrafficonsectionToFfi(value);
  final result = _sdkRoutingTrafficonsectionCreateHandleNullable(_handle);
  sdkRoutingTrafficonsectionReleaseFfiHandle(_handle);
  return result;
}

TrafficOnSection? sdkRoutingTrafficonsectionFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTrafficonsectionGetValueNullable(handle);
  final result = sdkRoutingTrafficonsectionFromFfi(_handle);
  sdkRoutingTrafficonsectionReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTrafficonsectionReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTrafficonsectionReleaseHandleNullable(handle);

// End of TrafficOnSection "private" section.


