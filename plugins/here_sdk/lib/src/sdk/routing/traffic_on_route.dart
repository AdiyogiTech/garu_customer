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
import 'package:here_sdk/src/sdk/routing/traffic_on_section.dart';

/// Traffic information on a route.
///
/// Information for the already traveled portion of the route is
/// omitted.
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behaviors. Related APIs may change for new releases without a deprecation process.

class TrafficOnRoute {
  /// Indicates the index of the last traveled route section. Traveled part of the route won't
  /// be reused.
  int lastTraveledSectionIndex;

  /// Offset, in meter, to the last visited position on the route section defined by the last
  /// traveled section index.
  int traveledDistanceOnLastSectionInMeters;

  /// List of traffic sections.
  List<TrafficOnSection> trafficSections;

  /// Creates a new instance.

  /// [lastTraveledSectionIndex] Indicates the index of the last traveled route section. Traveled part of the route won't
  /// be reused.

  /// [traveledDistanceOnLastSectionInMeters] Offset, in meter, to the last visited position on the route section defined by the last
  /// traveled section index.

  /// [trafficSections] List of traffic sections.

  TrafficOnRoute._(this.lastTraveledSectionIndex, this.traveledDistanceOnLastSectionInMeters, this.trafficSections);
  TrafficOnRoute()
    : lastTraveledSectionIndex = 0, traveledDistanceOnLastSectionInMeters = 0, trafficSections = [];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TrafficOnRoute) return false;
    TrafficOnRoute _other = other;
    return lastTraveledSectionIndex == _other.lastTraveledSectionIndex &&
        traveledDistanceOnLastSectionInMeters == _other.traveledDistanceOnLastSectionInMeters &&
        DeepCollectionEquality().equals(trafficSections, _other.trafficSections);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + lastTraveledSectionIndex.hashCode;
    result = 31 * result + traveledDistanceOnLastSectionInMeters.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(trafficSections);
    return result;
  }
}


// TrafficOnRoute "private" section, not exported.

final _sdkRoutingTrafficonrouteCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Int32, Int32, Pointer<Void>),
    Pointer<Void> Function(int, int, Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_create_handle'));
final _sdkRoutingTrafficonrouteReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_release_handle'));
final _sdkRoutingTrafficonrouteGetFieldlastTraveledSectionIndex = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_get_field_lastTraveledSectionIndex'));
final _sdkRoutingTrafficonrouteGetFieldtraveledDistanceOnLastSectionInMeters = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_get_field_traveledDistanceOnLastSectionInMeters'));
final _sdkRoutingTrafficonrouteGetFieldtrafficSections = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_get_field_trafficSections'));



Pointer<Void> sdkRoutingTrafficonrouteToFfi(TrafficOnRoute value) {
  final _lastTraveledSectionIndexHandle = (value.lastTraveledSectionIndex);
  final _traveledDistanceOnLastSectionInMetersHandle = (value.traveledDistanceOnLastSectionInMeters);
  final _trafficSectionsHandle = heresdkRoutingCommonBindingslistofSdkRoutingTrafficonsectionToFfi(value.trafficSections);
  final _result = _sdkRoutingTrafficonrouteCreateHandle(_lastTraveledSectionIndexHandle, _traveledDistanceOnLastSectionInMetersHandle, _trafficSectionsHandle);
  
  
  heresdkRoutingCommonBindingslistofSdkRoutingTrafficonsectionReleaseFfiHandle(_trafficSectionsHandle);
  return _result;
}

TrafficOnRoute sdkRoutingTrafficonrouteFromFfi(Pointer<Void> handle) {
  final _lastTraveledSectionIndexHandle = _sdkRoutingTrafficonrouteGetFieldlastTraveledSectionIndex(handle);
  final _traveledDistanceOnLastSectionInMetersHandle = _sdkRoutingTrafficonrouteGetFieldtraveledDistanceOnLastSectionInMeters(handle);
  final _trafficSectionsHandle = _sdkRoutingTrafficonrouteGetFieldtrafficSections(handle);
  try {
    return TrafficOnRoute._(
      (_lastTraveledSectionIndexHandle), 
      (_traveledDistanceOnLastSectionInMetersHandle), 
      heresdkRoutingCommonBindingslistofSdkRoutingTrafficonsectionFromFfi(_trafficSectionsHandle)
    );
  } finally {
    
    
    heresdkRoutingCommonBindingslistofSdkRoutingTrafficonsectionReleaseFfiHandle(_trafficSectionsHandle);
  }
}

void sdkRoutingTrafficonrouteReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingTrafficonrouteReleaseHandle(handle);

// Nullable TrafficOnRoute

final _sdkRoutingTrafficonrouteCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_create_handle_nullable'));
final _sdkRoutingTrafficonrouteReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_release_handle_nullable'));
final _sdkRoutingTrafficonrouteGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnRoute_get_value_nullable'));

Pointer<Void> sdkRoutingTrafficonrouteToFfiNullable(TrafficOnRoute? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTrafficonrouteToFfi(value);
  final result = _sdkRoutingTrafficonrouteCreateHandleNullable(_handle);
  sdkRoutingTrafficonrouteReleaseFfiHandle(_handle);
  return result;
}

TrafficOnRoute? sdkRoutingTrafficonrouteFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTrafficonrouteGetValueNullable(handle);
  final result = sdkRoutingTrafficonrouteFromFfi(_handle);
  sdkRoutingTrafficonrouteReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTrafficonrouteReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTrafficonrouteReleaseHandleNullable(handle);

// End of TrafficOnRoute "private" section.


