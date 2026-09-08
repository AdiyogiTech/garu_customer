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

/// Area of corridor shape which routes must not cross and exceptions for this area.

class AvoidCorridorAreaOptions {
  /// Area of corridor shape which routes must not cross. Strictly enforced.
  /// Violations are reported as [SectionNoticeCode.violatedBlockedRoad].
  /// Note: This avoidance option is not supported for `IsolineOptions`. If it is defined for isoline calculation then an [RoutingError.invalidParameter] error is generated.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.
  GeoCorridor avoidCorridorArea;

  /// Areas of rectangular shape to exclude from avoidance.
  List<GeoBox> boundingBoxExceptionAreas;

  /// Areas of polygon shape to exclude from avoidance.
  List<GeoPolygon> polygonExceptionAreas;

  /// Areas of corridor shape to exclude from avoidance.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.
  List<GeoCorridor> corridorExceptionAreas;

  /// Creates a new instance.

  /// [avoidCorridorArea] Area of corridor shape which routes must not cross. Strictly enforced.
  /// Violations are reported as [SectionNoticeCode.violatedBlockedRoad].
  /// Note: This avoidance option is not supported for `IsolineOptions`. If it is defined for isoline calculation then an [RoutingError.invalidParameter] error is generated.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.

  /// [boundingBoxExceptionAreas] Areas of rectangular shape to exclude from avoidance.

  /// [polygonExceptionAreas] Areas of polygon shape to exclude from avoidance.

  /// [corridorExceptionAreas] Areas of corridor shape to exclude from avoidance.
  /// Note: Even though `GeoCorridor.half_width_in_meters` is an optional property in case of exception areas it is mandatory.
  /// Otherwise route calculation will fail with an [RoutingError.invalidParameter] error.

  AvoidCorridorAreaOptions._(this.avoidCorridorArea, this.boundingBoxExceptionAreas, this.polygonExceptionAreas, this.corridorExceptionAreas);
  AvoidCorridorAreaOptions(GeoCorridor avoidCorridorArea)
    : avoidCorridorArea = avoidCorridorArea, boundingBoxExceptionAreas = [], polygonExceptionAreas = [], corridorExceptionAreas = [];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AvoidCorridorAreaOptions) return false;
    AvoidCorridorAreaOptions _other = other;
    return avoidCorridorArea == _other.avoidCorridorArea &&
        DeepCollectionEquality().equals(boundingBoxExceptionAreas, _other.boundingBoxExceptionAreas) &&
        DeepCollectionEquality().equals(polygonExceptionAreas, _other.polygonExceptionAreas) &&
        DeepCollectionEquality().equals(corridorExceptionAreas, _other.corridorExceptionAreas);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + avoidCorridorArea.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(boundingBoxExceptionAreas);
    result = 31 * result + DeepCollectionEquality().hash(polygonExceptionAreas);
    result = 31 * result + DeepCollectionEquality().hash(corridorExceptionAreas);
    return result;
  }
}


// AvoidCorridorAreaOptions "private" section, not exported.

final _sdkRoutingAvoidcorridorareaoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_create_handle'));
final _sdkRoutingAvoidcorridorareaoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_release_handle'));
final _sdkRoutingAvoidcorridorareaoptionsGetFieldavoidCorridorArea = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_get_field_avoidCorridorArea'));
final _sdkRoutingAvoidcorridorareaoptionsGetFieldboundingBoxExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_get_field_boundingBoxExceptionAreas'));
final _sdkRoutingAvoidcorridorareaoptionsGetFieldpolygonExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_get_field_polygonExceptionAreas'));
final _sdkRoutingAvoidcorridorareaoptionsGetFieldcorridorExceptionAreas = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_get_field_corridorExceptionAreas'));



Pointer<Void> sdkRoutingAvoidcorridorareaoptionsToFfi(AvoidCorridorAreaOptions value) {
  final _avoidCorridorAreaHandle = sdkCoreGeocorridorToFfi(value.avoidCorridorArea);
  final _boundingBoxExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeoboxToFfi(value.boundingBoxExceptionAreas);
  final _polygonExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeopolygonToFfi(value.polygonExceptionAreas);
  final _corridorExceptionAreasHandle = heresdkRoutingCommonBindingslistofSdkCoreGeocorridorToFfi(value.corridorExceptionAreas);
  final _result = _sdkRoutingAvoidcorridorareaoptionsCreateHandle(_avoidCorridorAreaHandle, _boundingBoxExceptionAreasHandle, _polygonExceptionAreasHandle, _corridorExceptionAreasHandle);
  sdkCoreGeocorridorReleaseFfiHandle(_avoidCorridorAreaHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeoboxReleaseFfiHandle(_boundingBoxExceptionAreasHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeopolygonReleaseFfiHandle(_polygonExceptionAreasHandle);
  heresdkRoutingCommonBindingslistofSdkCoreGeocorridorReleaseFfiHandle(_corridorExceptionAreasHandle);
  return _result;
}

AvoidCorridorAreaOptions sdkRoutingAvoidcorridorareaoptionsFromFfi(Pointer<Void> handle) {
  final _avoidCorridorAreaHandle = _sdkRoutingAvoidcorridorareaoptionsGetFieldavoidCorridorArea(handle);
  final _boundingBoxExceptionAreasHandle = _sdkRoutingAvoidcorridorareaoptionsGetFieldboundingBoxExceptionAreas(handle);
  final _polygonExceptionAreasHandle = _sdkRoutingAvoidcorridorareaoptionsGetFieldpolygonExceptionAreas(handle);
  final _corridorExceptionAreasHandle = _sdkRoutingAvoidcorridorareaoptionsGetFieldcorridorExceptionAreas(handle);
  try {
    return AvoidCorridorAreaOptions._(
      sdkCoreGeocorridorFromFfi(_avoidCorridorAreaHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeoboxFromFfi(_boundingBoxExceptionAreasHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeopolygonFromFfi(_polygonExceptionAreasHandle), 
      heresdkRoutingCommonBindingslistofSdkCoreGeocorridorFromFfi(_corridorExceptionAreasHandle)
    );
  } finally {
    sdkCoreGeocorridorReleaseFfiHandle(_avoidCorridorAreaHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeoboxReleaseFfiHandle(_boundingBoxExceptionAreasHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeopolygonReleaseFfiHandle(_polygonExceptionAreasHandle);
    heresdkRoutingCommonBindingslistofSdkCoreGeocorridorReleaseFfiHandle(_corridorExceptionAreasHandle);
  }
}

void sdkRoutingAvoidcorridorareaoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingAvoidcorridorareaoptionsReleaseHandle(handle);

// Nullable AvoidCorridorAreaOptions

final _sdkRoutingAvoidcorridorareaoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_create_handle_nullable'));
final _sdkRoutingAvoidcorridorareaoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_release_handle_nullable'));
final _sdkRoutingAvoidcorridorareaoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AvoidCorridorAreaOptions_get_value_nullable'));

Pointer<Void> sdkRoutingAvoidcorridorareaoptionsToFfiNullable(AvoidCorridorAreaOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingAvoidcorridorareaoptionsToFfi(value);
  final result = _sdkRoutingAvoidcorridorareaoptionsCreateHandleNullable(_handle);
  sdkRoutingAvoidcorridorareaoptionsReleaseFfiHandle(_handle);
  return result;
}

AvoidCorridorAreaOptions? sdkRoutingAvoidcorridorareaoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingAvoidcorridorareaoptionsGetValueNullable(handle);
  final result = sdkRoutingAvoidcorridorareaoptionsFromFfi(_handle);
  sdkRoutingAvoidcorridorareaoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingAvoidcorridorareaoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingAvoidcorridorareaoptionsReleaseHandleNullable(handle);

// End of AvoidCorridorAreaOptions "private" section.


