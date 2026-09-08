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
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/_type_repository.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/core/localized_text.dart';
import 'package:here_sdk/src/sdk/core/picked_place.dart';
import 'package:here_sdk/src/sdk/traffic/traffic_incident_base.dart';
import 'package:here_sdk/src/sdk/traffic/traffic_incident_impact.dart';
import 'package:here_sdk/src/sdk/traffic/traffic_incident_type.dart';

/// A class that contains possible results from picking map content on the map scene.
abstract class PickMapContentResult {

  /// List of picked places containing the POIs at the location of picking.
  /// Gets a list of picked places containing the POIs at the location of picking.
  List<PickedPlace> get pickedPlaces;

  /// List of traffic incidents at the location of picking.
  /// Gets the list of traffic incidents at the location of picking.
  List<PickTrafficIncidentResult> get trafficIncidents;

}

/// Carries the result of picking a Carto traffic incident object.
///
/// Description of incident is currently not present in our map data, so
/// [TrafficIncidentBase.description] always returns an empty string.
abstract class PickTrafficIncidentResult implements TrafficIncidentBase {

  /// Unique traffic event ID. Can be referenced when checking for updated traffic information
  /// for the specified event.
  /// Gets the unique traffic event ID.
  /// Can be referenced when checking for updated traffic information
  /// for the specified event.
  String get originalId;

  /// The geographic coordinates of the traffic incident.
  /// Gets the geographic coordinates of the traffic incident.
  GeoCoordinates get coordinates;

}


// PickTrafficIncidentResult "private" section, not exported.

final _sdkMapviewPickmapcontentresultTrafficincidentresultRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_register_finalizer'));
final _sdkMapviewPickmapcontentresultTrafficincidentresultCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_copy_handle'));
final _sdkMapviewPickmapcontentresultTrafficincidentresultReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_release_handle'));
final _sdkMapviewPickmapcontentresultTrafficincidentresultGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_get_type_id'));


class PickTrafficIncidentResult$Impl extends __lib.NativeBase implements PickTrafficIncidentResult {

  PickTrafficIncidentResult$Impl(Pointer<Void> handle) : super(handle);

  @override
  String get originalId {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_originalId_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfi(__resultHandle);
    } finally {
      stringReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  GeoCoordinates get coordinates {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_coordinates_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreGeocoordinatesFromFfi(__resultHandle);
    } finally {
      sdkCoreGeocoordinatesReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  TrafficIncidentImpact get impact {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_impact_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkTrafficTrafficincidentimpactFromFfi(__resultHandle);
    } finally {
      sdkTrafficTrafficincidentimpactReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  TrafficIncidentType get type {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_type_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkTrafficTrafficincidenttypeFromFfi(__resultHandle);
    } finally {
      sdkTrafficTrafficincidenttypeReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  LocalizedText get description {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_description_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreLocalizedtextFromFfi(__resultHandle);
    } finally {
      sdkCoreLocalizedtextReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  DateTime? get startTime {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_startTime_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return dateFromFfiNullable(__resultHandle);
    } finally {
      dateReleaseFfiHandleNullable(__resultHandle);

    }

  }


  @override
  DateTime? get endTime {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_TrafficIncidentResult_endTime_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return dateFromFfiNullable(__resultHandle);
    } finally {
      dateReleaseFfiHandleNullable(__resultHandle);

    }

  }



}

Pointer<Void> sdkMapviewPickmapcontentresultTrafficincidentresultToFfi(PickTrafficIncidentResult value) =>
  _sdkMapviewPickmapcontentresultTrafficincidentresultCopyHandle((value as __lib.NativeBase).handle);

PickTrafficIncidentResult sdkMapviewPickmapcontentresultTrafficincidentresultFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PickTrafficIncidentResult) return instance;

  final _typeIdHandle = _sdkMapviewPickmapcontentresultTrafficincidentresultGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewPickmapcontentresultTrafficincidentresultCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : PickTrafficIncidentResult$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewPickmapcontentresultTrafficincidentresultRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewPickmapcontentresultTrafficincidentresultReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewPickmapcontentresultTrafficincidentresultReleaseHandle(handle);

Pointer<Void> sdkMapviewPickmapcontentresultTrafficincidentresultToFfiNullable(PickTrafficIncidentResult? value) =>
  value != null ? sdkMapviewPickmapcontentresultTrafficincidentresultToFfi(value) : Pointer<Void>.fromAddress(0);

PickTrafficIncidentResult? sdkMapviewPickmapcontentresultTrafficincidentresultFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewPickmapcontentresultTrafficincidentresultFromFfi(handle) : null;

void sdkMapviewPickmapcontentresultTrafficincidentresultReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewPickmapcontentresultTrafficincidentresultReleaseHandle(handle);

// End of PickTrafficIncidentResult "private" section.

// PickMapContentResult "private" section, not exported.

final _sdkMapviewPickmapcontentresultRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_PickMapContentResult_register_finalizer'));
final _sdkMapviewPickmapcontentresultCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_PickMapContentResult_copy_handle'));
final _sdkMapviewPickmapcontentresultReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_PickMapContentResult_release_handle'));


class PickMapContentResult$Impl extends __lib.NativeBase implements PickMapContentResult {

  PickMapContentResult$Impl(Pointer<Void> handle) : super(handle);

  @override
  List<PickedPlace> get pickedPlaces {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_pickedPlaces_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return heresdkMapviewHarpBindingslistofSdkCorePickedplaceFromFfi(__resultHandle);
    } finally {
      heresdkMapviewHarpBindingslistofSdkCorePickedplaceReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  List<PickTrafficIncidentResult> get trafficIncidents {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_PickMapContentResult_trafficIncidents_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return heresdkMapviewHarpBindingslistofSdkMapviewPickmapcontentresultTrafficincidentresultFromFfi(__resultHandle);
    } finally {
      heresdkMapviewHarpBindingslistofSdkMapviewPickmapcontentresultTrafficincidentresultReleaseFfiHandle(__resultHandle);

    }

  }



}

Pointer<Void> sdkMapviewPickmapcontentresultToFfi(PickMapContentResult value) =>
  _sdkMapviewPickmapcontentresultCopyHandle((value as __lib.NativeBase).handle);

PickMapContentResult sdkMapviewPickmapcontentresultFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PickMapContentResult) return instance;

  final _copiedHandle = _sdkMapviewPickmapcontentresultCopyHandle(handle);
  final result = PickMapContentResult$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewPickmapcontentresultRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewPickmapcontentresultReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewPickmapcontentresultReleaseHandle(handle);

Pointer<Void> sdkMapviewPickmapcontentresultToFfiNullable(PickMapContentResult? value) =>
  value != null ? sdkMapviewPickmapcontentresultToFfi(value) : Pointer<Void>.fromAddress(0);

PickMapContentResult? sdkMapviewPickmapcontentresultFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewPickmapcontentresultFromFfi(handle) : null;

void sdkMapviewPickmapcontentresultReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewPickmapcontentresultReleaseHandle(handle);

// End of PickMapContentResult "private" section.


