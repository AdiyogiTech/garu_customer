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
import 'package:here_sdk/src/sdk/core/geo_polygon.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes_accessor.dart';

/// Polygon data accessor used for manipulating polygons that are part of a PolygonDataSource.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonDataAccessor {

  /// Gets polygon geometry.
  ///
  /// Returns [GeoPolygon]. The polygon geometry.
  ///
  GeoPolygon getGeometry();
  /// Gets polygon attributes accessor.
  ///
  /// Returns [DataAttributesAccessor]. The polygon attributes accessor.
  ///
  DataAttributesAccessor getAttributes();
  /// Replaces polygon geometry.
  ///
  /// The outer boundary has to be ordered clockwise and closed.
  ///
  /// Altitude of the vertices is ignored.
  ///
  /// The visual behaviour for self-intersecting outer boundary is undefined.
  ///
  /// [geometry] Geometry of the polygon. The outer boundary has to be ordered clockwise and closed.
  /// Altitude of the vertices is ignored.
  /// The visual behaviour for self-intersecting outer boundary is undefined.
  ///
  void setGeometry(GeoPolygon geometry);
  /// Replaces polygon attributes.
  ///
  /// [attributes] The attributes.
  ///
  void setAttributes(DataAttributes attributes);
}


// PolygonDataAccessor "private" section, not exported.

final _sdkMapviewDatasourcePolygondataaccessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_register_finalizer'));
final _sdkMapviewDatasourcePolygondataaccessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_copy_handle'));
final _sdkMapviewDatasourcePolygondataaccessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_release_handle'));






class PolygonDataAccessor$Impl extends __lib.NativeBase implements PolygonDataAccessor {

  PolygonDataAccessor$Impl(Pointer<Void> handle) : super(handle);

  @override
  GeoPolygon getGeometry() {
    final _getGeometryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_getGeometry'));
    final _handle = this.handle;
    final __resultHandle = _getGeometryFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreGeopolygonFromFfi(__resultHandle);
    } finally {
      sdkCoreGeopolygonReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesAccessor getAttributes() {
    final _getAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_getAttributes'));
    final _handle = this.handle;
    final __resultHandle = _getAttributesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceDataattributesaccessorFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesaccessorReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void setGeometry(GeoPolygon geometry) {
    final _setGeometryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_setGeometry__GeoPolygon'));
    final _geometryHandle = sdkCoreGeopolygonToFfi(geometry);
    final _handle = this.handle;
    _setGeometryFfi(_handle, __lib.LibraryContext.isolateId, _geometryHandle);
    sdkCoreGeopolygonReleaseFfiHandle(_geometryHandle);

  }

  @override
  void setAttributes(DataAttributes attributes) {
    final _setAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataAccessor_setAttributes__DataAttributes'));
    final _attributesHandle = sdkMapviewDatasourceDataattributesToFfi(attributes);
    final _handle = this.handle;
    _setAttributesFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle);
    sdkMapviewDatasourceDataattributesReleaseFfiHandle(_attributesHandle);

  }


}

Pointer<Void> sdkMapviewDatasourcePolygondataaccessorToFfi(PolygonDataAccessor value) =>
  _sdkMapviewDatasourcePolygondataaccessorCopyHandle((value as __lib.NativeBase).handle);

PolygonDataAccessor sdkMapviewDatasourcePolygondataaccessorFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonDataAccessor) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePolygondataaccessorCopyHandle(handle);
  final result = PolygonDataAccessor$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygondataaccessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygondataaccessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondataaccessorReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygondataaccessorToFfiNullable(PolygonDataAccessor? value) =>
  value != null ? sdkMapviewDatasourcePolygondataaccessorToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonDataAccessor? sdkMapviewDatasourcePolygondataaccessorFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygondataaccessorFromFfi(handle) : null;

void sdkMapviewDatasourcePolygondataaccessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondataaccessorReleaseHandle(handle);

// End of PolygonDataAccessor "private" section.


