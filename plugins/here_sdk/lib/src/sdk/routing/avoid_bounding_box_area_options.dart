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
import 'package:here_sdk/src/sdk/core/geo_box.dart';
import 'package:here_sdk/src/sdk/core/geo_corridor.dart';
import 'package:here_sdk/src/sdk/core/geo_polygon.dart';

/// The options to specify rectangular shape which routes must not cross.

class AvoidBoundingBoxAreaOptions {
  /// Area of rectangular shape which routes must not cross. Strictly enforced.
  /// Violations are reported as [SectionNoticeCode.violatedBlockedRoad].
  /// Note: This avoidance option is not supported for `IsolineOptions`. If it is defined for isoline calculation then an [RoutingError.invalidParameter] error is generated.
  GeoBox avoidBoundingBoxArea;

  /// Areas of rectangular shape to exclude from avoidance.
  List<GeoBox> boundingBoxExceptionAreas;

  /// Areas of polygon shape to exclude from avoidance.
  List<GeoPolygon> polygonExceptionAreas;

  /// Areas of corridor shape to exclude from avoidance.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.
  List<GeoCorridor> corridorExceptionAreas;

  /// Creates a new instance.

  /// [avoidBoundingBoxArea] Area of rectangular shape which routes must not cross. Strictly enforced.
  /// Violations are reported as [SectionNoticeCode.violatedBlockedRoad].
  /// Note: This avoidance option is not supported for `IsolineOptions`. If it is defined for isoline calculation then an [RoutingError.invalidParameter] error is generated.

  /// [boundingBoxExceptionAreas] Areas of rectangular shape to exclude from avoidance.

  /// [polygonExceptionAreas] Areas of polygon shape to exclude from avoidance.

  /// [corridorExceptionAreas] Areas of corridor shape to exclude from avoidance.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.

  AvoidBoundingBoxAreaOptions._(this.avoidBoundingBoxArea, this.boundingBoxExceptionAreas, this.polygonExceptionAreas, this.corridorExceptionAreas);
  AvoidBoundingBoxAreaOptions(GeoBox avoidBoundingBoxArea)
    : avoidBoundingBoxArea = avoidBoundingBoxArea, boundingBoxExceptionAreas = [], polygonExceptionAreas = [], corridorExceptionAreas = [];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AvoidBoundingBoxAreaOptions) return false;
    AvoidBoundingBoxAreaOptions _other = other;
    return avoidBoundingBoxArea == _other.avoidBoundingBoxArea &&
        DeepCollectionEquality().equals(boundingBoxExceptionAreas, _other.boundingBoxExceptionAreas) &&
        DeepCollectionEquality().equals(polygonExceptionAreas, _other.polygonExceptionAreas) &&
        DeepCollectionEquality().equals(corridorExceptionAreas, _other.corridorExceptionAreas);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + avoidBoundingBoxArea.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(boundingBoxExceptionAreas);
    result = 31 * result + DeepCollectionEquality().hash(polygonExceptionAreas);
    result = 31 * result + DeepCollectionEquality().hash(corridorExceptionAreas);
    return result;
  }
}


// AvoidBoundingBoxAreaOptions "private" section, not exported.

final _sdkRoutingAvoidboundingboxareaoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_create_handle'));
final _sdkRoutingAvoidboundingboxareaoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_release_handle'));
final _sdkRoutingAvoidboundingboxareaoptionsGetFieldavoidBoundingBoxArea = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_get_field_avoidBoundingBoxArea'));
final _sdkRoutingAvoidboundingboxareaoptionsGetFieldboundingBoxExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_get_field_boundingBoxExceptionAreas'));
final _sdkRoutingAvoidboundingboxareaoptionsGetFieldpolygonExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_get_field_polygonExceptionAreas'));
final _sdkRoutingAvoidboundingboxareaoptionsGetFieldcorridorExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_get_field_corridorExceptionAreas'));



Pointer<Void> sdkRoutingAvoidboundingboxareaoptionsToFfi(AvoidBoundingBoxAreaOptions value) {
  final _avoidBoundingBoxAreaHandle = sdkCoreGeoboxToFfi(value.avoidBoundingBoxArea);
  final _boundingBoxExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeoboxToFfi(value.boundingBoxExceptionAreas);
  final _polygonExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeopolygonToFfi(value.polygonExceptionAreas);
  final _corridorExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeocorridorToFfi(value.corridorExceptionAreas);
  final _result = _sdkRoutingAvoidboundingboxareaoptionsCreateHandle(_avoidBoundingBoxAreaHandle, _boundingBoxExceptionAreasHandle, _polygonExceptionAreasHandle, _corridorExceptionAreasHandle);
  sdkCoreGeoboxReleaseFfiHandle(_avoidBoundingBoxAreaHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeoboxReleaseFfiHandle(_boundingBoxExceptionAreasHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeopolygonReleaseFfiHandle(_polygonExceptionAreasHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeocorridorReleaseFfiHandle(_corridorExceptionAreasHandle);
  return _result;
}

AvoidBoundingBoxAreaOptions sdkRoutingAvoidboundingboxareaoptionsFromFfi(Pointer<Void> handle) {
  final _avoidBoundingBoxAreaHandle = _sdkRoutingAvoidboundingboxareaoptionsGetFieldavoidBoundingBoxArea(handle);
  final _boundingBoxExceptionAreasHandle = _sdkRoutingAvoidboundingboxareaoptionsGetFieldboundingBoxExceptionAreas(handle);
  final _polygonExceptionAreasHandle = _sdkRoutingAvoidboundingboxareaoptionsGetFieldpolygonExceptionAreas(handle);
  final _corridorExceptionAreasHandle = _sdkRoutingAvoidboundingboxareaoptionsGetFieldcorridorExceptionAreas(handle);
  try {
    return AvoidBoundingBoxAreaOptions._(
      sdkCoreGeoboxFromFfi(_avoidBoundingBoxAreaHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeoboxFromFfi(_boundingBoxExceptionAreasHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeopolygonFromFfi(_polygonExceptionAreasHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeocorridorFromFfi(_corridorExceptionAreasHandle)
    );
  } finally {
    sdkCoreGeoboxReleaseFfiHandle(_avoidBoundingBoxAreaHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeoboxReleaseFfiHandle(_boundingBoxExceptionAreasHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeopolygonReleaseFfiHandle(_polygonExceptionAreasHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeocorridorReleaseFfiHandle(_corridorExceptionAreasHandle);
  }
}

void sdkRoutingAvoidboundingboxareaoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingAvoidboundingboxareaoptionsReleaseHandle(handle);

// Nullable AvoidBoundingBoxAreaOptions

final _sdkRoutingAvoidboundingboxareaoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_create_handle_nullable'));
final _sdkRoutingAvoidboundingboxareaoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_release_handle_nullable'));
final _sdkRoutingAvoidboundingboxareaoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidBoundingBoxAreaOptions_get_value_nullable'));

Pointer<Void> sdkRoutingAvoidboundingboxareaoptionsToFfiNullable(AvoidBoundingBoxAreaOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingAvoidboundingboxareaoptionsToFfi(value);
  final result = _sdkRoutingAvoidboundingboxareaoptionsCreateHandleNullable(_handle);
  sdkRoutingAvoidboundingboxareaoptionsReleaseFfiHandle(_handle);
  return result;
}

AvoidBoundingBoxAreaOptions? sdkRoutingAvoidboundingboxareaoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingAvoidboundingboxareaoptionsGetValueNullable(handle);
  final result = sdkRoutingAvoidboundingboxareaoptionsFromFfi(_handle);
  sdkRoutingAvoidboundingboxareaoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingAvoidboundingboxareaoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingAvoidboundingboxareaoptionsReleaseHandleNullable(handle);

// End of AvoidBoundingBoxAreaOptions "private" section.


