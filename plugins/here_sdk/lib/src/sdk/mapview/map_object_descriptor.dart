// Copyright (c) 2019-2024 HERE Global B.V. and its affiliate(s).
// All rights reserved.
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
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes.dart';

/// Interface represents descriptor of a pickable map object.
abstract class MapObjectDescriptor {

  /// Returns the name of the layer where this picked item came from.
  ///
  /// Returns [String]. The name of the layer map object belongs to.
  ///
  String getLayerName();
  /// Returns data attributes of a map object.
  ///
  /// Returns [DataAttributes]. The data attributes of a map object.
  ///
  DataAttributes getDataAttributes();
  /// Return a geo point of the picked object, closest to the picking location.
  ///
  /// For polygons and polylines null is returned.
  ///
  /// Returns [GeoCoordinates?]. The coordinates of a map object.
  ///
  GeoCoordinates? getClosestPoint();
}


// MapObjectDescriptor "private" section, not exported.

final _sdkMapviewMapobjectdescriptorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapObjectDescriptor_register_finalizer'));
final _sdkMapviewMapobjectdescriptorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapObjectDescriptor_copy_handle'));
final _sdkMapviewMapobjectdescriptorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapObjectDescriptor_release_handle'));





class MapObjectDescriptor$Impl extends __lib.NativeBase implements MapObjectDescriptor {

  MapObjectDescriptor$Impl(Pointer<Void> handle) : super(handle);

  @override
  String getLayerName() {
    final _getLayerNameFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapObjectDescriptor_getLayerName'));
    final _handle = this.handle;
    final __resultHandle = _getLayerNameFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfi(__resultHandle);
    } finally {
      stringReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributes getDataAttributes() {
    final _getDataAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapObjectDescriptor_getDataAttributes'));
    final _handle = this.handle;
    final __resultHandle = _getDataAttributesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceDataattributesFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  GeoCoordinates? getClosestPoint() {
    final _getClosestPointFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapObjectDescriptor_getClosestPoint'));
    final _handle = this.handle;
    final __resultHandle = _getClosestPointFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreGeocoordinatesFromFfiNullable(__resultHandle);
    } finally {
      sdkCoreGeocoordinatesReleaseFfiHandleNullable(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewMapobjectdescriptorToFfi(MapObjectDescriptor value) =>
  _sdkMapviewMapobjectdescriptorCopyHandle((value as __lib.NativeBase).handle);

MapObjectDescriptor sdkMapviewMapobjectdescriptorFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapObjectDescriptor) return instance;

  final _copiedHandle = _sdkMapviewMapobjectdescriptorCopyHandle(handle);
  final result = MapObjectDescriptor$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapobjectdescriptorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapobjectdescriptorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapobjectdescriptorReleaseHandle(handle);

Pointer<Void> sdkMapviewMapobjectdescriptorToFfiNullable(MapObjectDescriptor? value) =>
  value != null ? sdkMapviewMapobjectdescriptorToFfi(value) : Pointer<Void>.fromAddress(0);

MapObjectDescriptor? sdkMapviewMapobjectdescriptorFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapobjectdescriptorFromFfi(handle) : null;

void sdkMapviewMapobjectdescriptorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapobjectdescriptorReleaseHandle(handle);

// End of MapObjectDescriptor "private" section.


