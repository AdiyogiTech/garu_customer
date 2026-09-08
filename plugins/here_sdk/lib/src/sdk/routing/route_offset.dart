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
import 'package:here_sdk/src/_library_context.dart' as __lib;

/// Represents a specific location along the route.
///
/// A `RouteOffset` is a location on the route defined by the section index and the distance in meters from the start of that section to the specified location on the route.
/// An offset in meters indicates the distance that needs to be traveled to reach a specific location along the route, such as a railway crossing.
/// For the latter case, the location of a railway crossing can be retrieved from `RouteRailwayCrossing.coordinates`.

class RouteOffset {
  /// Index of the corresponding route [Section]. The start of the section indicates the start of the offset.
  int sectionIndex;

  /// Offset from the start of the indexed [Section] to the specified location along the route.
  /// The maximum possible offset is limited by the length of the section and cannot exceed it.
  double offsetInMeters;

  /// Creates a new instance.

  /// [sectionIndex] Index of the corresponding route [Section]. The start of the section indicates the start of the offset.

  /// [offsetInMeters] Offset from the start of the indexed [Section] to the specified location along the route.
  /// The maximum possible offset is limited by the length of the section and cannot exceed it.

  RouteOffset(this.sectionIndex, this.offsetInMeters);
}


// RouteOffset "private" section, not exported.

final _sdkRoutingRouteoffsetCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Int32, Double),
    Pointer<Void> Function(int, double)
  >('here_sdk_sdk_routing_RouteOffset_create_handle'));
final _sdkRoutingRouteoffsetReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RouteOffset_release_handle'));
final _sdkRoutingRouteoffsetGetFieldsectionIndex = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RouteOffset_get_field_sectionIndex'));
final _sdkRoutingRouteoffsetGetFieldoffsetInMeters = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RouteOffset_get_field_offsetInMeters'));



Pointer<Void> sdkRoutingRouteoffsetToFfi(RouteOffset value) {
  final _sectionIndexHandle = (value.sectionIndex);
  final _offsetInMetersHandle = (value.offsetInMeters);
  final _result = _sdkRoutingRouteoffsetCreateHandle(_sectionIndexHandle, _offsetInMetersHandle);
  
  
  return _result;
}

RouteOffset sdkRoutingRouteoffsetFromFfi(Pointer<Void> handle) {
  final _sectionIndexHandle = _sdkRoutingRouteoffsetGetFieldsectionIndex(handle);
  final _offsetInMetersHandle = _sdkRoutingRouteoffsetGetFieldoffsetInMeters(handle);
  try {
    return RouteOffset(
      (_sectionIndexHandle), 
      (_offsetInMetersHandle)
    );
  } finally {
    
    
  }
}

void sdkRoutingRouteoffsetReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingRouteoffsetReleaseHandle(handle);

// Nullable RouteOffset

final _sdkRoutingRouteoffsetCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RouteOffset_create_handle_nullable'));
final _sdkRoutingRouteoffsetReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RouteOffset_release_handle_nullable'));
final _sdkRoutingRouteoffsetGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RouteOffset_get_value_nullable'));

Pointer<Void> sdkRoutingRouteoffsetToFfiNullable(RouteOffset? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingRouteoffsetToFfi(value);
  final result = _sdkRoutingRouteoffsetCreateHandleNullable(_handle);
  sdkRoutingRouteoffsetReleaseFfiHandle(_handle);
  return result;
}

RouteOffset? sdkRoutingRouteoffsetFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingRouteoffsetGetValueNullable(handle);
  final result = sdkRoutingRouteoffsetFromFfi(_handle);
  sdkRoutingRouteoffsetReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingRouteoffsetReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingRouteoffsetReleaseHandleNullable(handle);

// End of RouteOffset "private" section.


