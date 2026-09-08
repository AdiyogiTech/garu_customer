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
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes_accessor.dart';

/// Point data accessor used for manipulating points that are part of a PointDataSource.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointDataAccessor {

  /// Gets point coordinates.
  ///
  /// Returns [GeoCoordinates]. The point coordinates.
  ///
  GeoCoordinates getCoordinates();
  /// Gets point attributes accessor.
  ///
  /// Returns [DataAttributesAccessor]. The point attributes accessor.
  ///
  DataAttributesAccessor getAttributes();
  /// Updates point coordinates.
  ///
  /// [position] The new point coordinates.
  ///
  void setCoordinates(GeoCoordinates position);
  /// Replaces point attributes.
  ///
  /// [attributes] The new point attributes.
  ///
  void setAttributes(DataAttributes attributes);
}


// PointDataAccessor "private" section, not exported.

final _sdkMapviewDatasourcePointdataaccessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointDataAccessor_register_finalizer'));
final _sdkMapviewDatasourcePointdataaccessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataAccessor_copy_handle'));
final _sdkMapviewDatasourcePointdataaccessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataAccessor_release_handle'));






class PointDataAccessor$Impl extends __lib.NativeBase implements PointDataAccessor {

  PointDataAccessor$Impl(Pointer<Void> handle) : super(handle);

  @override
  GeoCoordinates getCoordinates() {
    final _getCoordinatesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointDataAccessor_getCoordinates'));
    final _handle = this.handle;
    final __resultHandle = _getCoordinatesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreGeocoordinatesFromFfi(__resultHandle);
    } finally {
      sdkCoreGeocoordinatesReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesAccessor getAttributes() {
    final _getAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointDataAccessor_getAttributes'));
    final _handle = this.handle;
    final __resultHandle = _getAttributesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceDataattributesaccessorFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesaccessorReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void setCoordinates(GeoCoordinates position) {
    final _setCoordinatesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataAccessor_setCoordinates__GeoCoordinates'));
    final _positionHandle = sdkCoreGeocoordinatesToFfi(position);
    final _handle = this.handle;
    _setCoordinatesFfi(_handle, __lib.LibraryContext.isolateId, _positionHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_positionHandle);

  }

  @override
  void setAttributes(DataAttributes attributes) {
    final _setAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataAccessor_setAttributes__DataAttributes'));
    final _attributesHandle = sdkMapviewDatasourceDataattributesToFfi(attributes);
    final _handle = this.handle;
    _setAttributesFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle);
    sdkMapviewDatasourceDataattributesReleaseFfiHandle(_attributesHandle);

  }


}

Pointer<Void> sdkMapviewDatasourcePointdataaccessorToFfi(PointDataAccessor value) =>
  _sdkMapviewDatasourcePointdataaccessorCopyHandle((value as __lib.NativeBase).handle);

PointDataAccessor sdkMapviewDatasourcePointdataaccessorFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointDataAccessor) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePointdataaccessorCopyHandle(handle);
  final result = PointDataAccessor$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointdataaccessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointdataaccessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdataaccessorReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointdataaccessorToFfiNullable(PointDataAccessor? value) =>
  value != null ? sdkMapviewDatasourcePointdataaccessorToFfi(value) : Pointer<Void>.fromAddress(0);

PointDataAccessor? sdkMapviewDatasourcePointdataaccessorFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointdataaccessorFromFfi(handle) : null;

void sdkMapviewDatasourcePointdataaccessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdataaccessorReleaseHandle(handle);

// End of PointDataAccessor "private" section.


