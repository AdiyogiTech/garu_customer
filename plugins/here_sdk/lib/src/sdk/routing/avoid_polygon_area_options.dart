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

/// The options to specify polygon shape which routes must not cross.

class AvoidPolygonAreaOptions {
  /// Area of polygon shape which routes must not cross. Strictly enforced.
  /// Violations are reported as [SectionNoticeCode.violatedBlockedRoad].
  /// Note: This avoidance option is not supported for `IsolineOptions`. If it is defined for isoline calculation then an [RoutingError.invalidParameter] error is generated.
  GeoPolygon avoidPolygonArea;

  /// Areas of rectangular shape to exclude from avoidance.
  List<GeoBox> boundingBoxExceptionAreas;

  /// Areas of polygon shape to exclude from avoidance.
  List<GeoPolygon> polygonExceptionAreas;

  /// Areas of corridor shape to exclude from avoidance.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.
  List<GeoCorridor> corridorExceptionAreas;

  /// Creates a new instance.

  /// [avoidPolygonArea] Area of polygon shape which routes must not cross. Strictly enforced.
  /// Violations are reported as [SectionNoticeCode.violatedBlockedRoad].
  /// Note: This avoidance option is not supported for `IsolineOptions`. If it is defined for isoline calculation then an [RoutingError.invalidParameter] error is generated.

  /// [boundingBoxExceptionAreas] Areas of rectangular shape to exclude from avoidance.

  /// [polygonExceptionAreas] Areas of polygon shape to exclude from avoidance.

  /// [corridorExceptionAreas] Areas of corridor shape to exclude from avoidance.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.

  AvoidPolygonAreaOptions._(this.avoidPolygonArea, this.boundingBoxExceptionAreas, this.polygonExceptionAreas, this.corridorExceptionAreas);
  AvoidPolygonAreaOptions(GeoPolygon avoidPolygonArea)
    : avoidPolygonArea = avoidPolygonArea, boundingBoxExceptionAreas = [], polygonExceptionAreas = [], corridorExceptionAreas = [];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AvoidPolygonAreaOptions) return false;
    AvoidPolygonAreaOptions _other = other;
    return avoidPolygonArea == _other.avoidPolygonArea &&
        DeepCollectionEquality().equals(boundingBoxExceptionAreas, _other.boundingBoxExceptionAreas) &&
        DeepCollectionEquality().equals(polygonExceptionAreas, _other.polygonExceptionAreas) &&
        DeepCollectionEquality().equals(corridorExceptionAreas, _other.corridorExceptionAreas);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + avoidPolygonArea.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(boundingBoxExceptionAreas);
    result = 31 * result + DeepCollectionEquality().hash(polygonExceptionAreas);
    result = 31 * result + DeepCollectionEquality().hash(corridorExceptionAreas);
    return result;
  }
}


// AvoidPolygonAreaOptions "private" section, not exported.

final _sdkRoutingAvoidpolygonareaoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_create_handle'));
final _sdkRoutingAvoidpolygonareaoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_release_handle'));
final _sdkRoutingAvoidpolygonareaoptionsGetFieldavoidPolygonArea = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_get_field_avoidPolygonArea'));
final _sdkRoutingAvoidpolygonareaoptionsGetFieldboundingBoxExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_get_field_boundingBoxExceptionAreas'));
final _sdkRoutingAvoidpolygonareaoptionsGetFieldpolygonExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_get_field_polygonExceptionAreas'));
final _sdkRoutingAvoidpolygonareaoptionsGetFieldcorridorExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_get_field_corridorExceptionAreas'));



Pointer<Void> sdkRoutingAvoidpolygonareaoptionsToFfi(AvoidPolygonAreaOptions value) {
  final _avoidPolygonAreaHandle = sdkCoreGeopolygonToFfi(value.avoidPolygonArea);
  final _boundingBoxExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeoboxToFfi(value.boundingBoxExceptionAreas);
  final _polygonExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeopolygonToFfi(value.polygonExceptionAreas);
  final _corridorExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeocorridorToFfi(value.corridorExceptionAreas);
  final _result = _sdkRoutingAvoidpolygonareaoptionsCreateHandle(_avoidPolygonAreaHandle, _boundingBoxExceptionAreasHandle, _polygonExceptionAreasHandle, _corridorExceptionAreasHandle);
  sdkCoreGeopolygonReleaseFfiHandle(_avoidPolygonAreaHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeoboxReleaseFfiHandle(_boundingBoxExceptionAreasHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeopolygonReleaseFfiHandle(_polygonExceptionAreasHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeocorridorReleaseFfiHandle(_corridorExceptionAreasHandle);
  return _result;
}

AvoidPolygonAreaOptions sdkRoutingAvoidpolygonareaoptionsFromFfi(Pointer<Void> handle) {
  final _avoidPolygonAreaHandle = _sdkRoutingAvoidpolygonareaoptionsGetFieldavoidPolygonArea(handle);
  final _boundingBoxExceptionAreasHandle = _sdkRoutingAvoidpolygonareaoptionsGetFieldboundingBoxExceptionAreas(handle);
  final _polygonExceptionAreasHandle = _sdkRoutingAvoidpolygonareaoptionsGetFieldpolygonExceptionAreas(handle);
  final _corridorExceptionAreasHandle = _sdkRoutingAvoidpolygonareaoptionsGetFieldcorridorExceptionAreas(handle);
  try {
    return AvoidPolygonAreaOptions._(
      sdkCoreGeopolygonFromFfi(_avoidPolygonAreaHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeoboxFromFfi(_boundingBoxExceptionAreasHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeopolygonFromFfi(_polygonExceptionAreasHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeocorridorFromFfi(_corridorExceptionAreasHandle)
    );
  } finally {
    sdkCoreGeopolygonReleaseFfiHandle(_avoidPolygonAreaHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeoboxReleaseFfiHandle(_boundingBoxExceptionAreasHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeopolygonReleaseFfiHandle(_polygonExceptionAreasHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeocorridorReleaseFfiHandle(_corridorExceptionAreasHandle);
  }
}

void sdkRoutingAvoidpolygonareaoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingAvoidpolygonareaoptionsReleaseHandle(handle);

// Nullable AvoidPolygonAreaOptions

final _sdkRoutingAvoidpolygonareaoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_create_handle_nullable'));
final _sdkRoutingAvoidpolygonareaoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_release_handle_nullable'));
final _sdkRoutingAvoidpolygonareaoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidPolygonAreaOptions_get_value_nullable'));

Pointer<Void> sdkRoutingAvoidpolygonareaoptionsToFfiNullable(AvoidPolygonAreaOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingAvoidpolygonareaoptionsToFfi(value);
  final result = _sdkRoutingAvoidpolygonareaoptionsCreateHandleNullable(_handle);
  sdkRoutingAvoidpolygonareaoptionsReleaseFfiHandle(_handle);
  return result;
}

AvoidPolygonAreaOptions? sdkRoutingAvoidpolygonareaoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingAvoidpolygonareaoptionsGetValueNullable(handle);
  final result = sdkRoutingAvoidpolygonareaoptionsFromFfi(_handle);
  sdkRoutingAvoidpolygonareaoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingAvoidpolygonareaoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingAvoidpolygonareaoptionsReleaseHandleNullable(handle);

// End of AvoidPolygonAreaOptions "private" section.


