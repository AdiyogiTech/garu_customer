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
import 'package:here_sdk/src/sdk/core/geo_polyline.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes_accessor.dart';

/// Line data accessor used for manipulating polylines that are part of a LineDataSource.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class LineDataAccessor {

  /// Gets polyline geometry.
  ///
  /// Returns [GeoPolyline]. The line geometry.
  ///
  GeoPolyline getGeometry();
  /// Gets polyline attributes accessor.
  ///
  /// Returns [DataAttributesAccessor]. The polyline attributes accessor.
  ///
  DataAttributesAccessor getAttributes();
  /// Replaces polyline geometry.
  ///
  /// Altitude of the vertices is ignored.
  ///
  /// [geometry] The geometry.
  ///
  void setGeometry(GeoPolyline geometry);
  /// Replaces polyline attributes.
  ///
  /// [attributes] The attributes.
  ///
  void setAttributes(DataAttributes attributes);
}


// LineDataAccessor "private" section, not exported.

final _sdkMapviewDatasourceLinedataaccessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineDataAccessor_register_finalizer'));
final _sdkMapviewDatasourceLinedataaccessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataAccessor_copy_handle'));
final _sdkMapviewDatasourceLinedataaccessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataAccessor_release_handle'));






class LineDataAccessor$Impl extends __lib.NativeBase implements LineDataAccessor {

  LineDataAccessor$Impl(Pointer<Void> handle) : super(handle);

  @override
  GeoPolyline getGeometry() {
    final _getGeometryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineDataAccessor_getGeometry'));
    final _handle = this.handle;
    final __resultHandle = _getGeometryFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreGeopolylineFromFfi(__resultHandle);
    } finally {
      sdkCoreGeopolylineReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesAccessor getAttributes() {
    final _getAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineDataAccessor_getAttributes'));
    final _handle = this.handle;
    final __resultHandle = _getAttributesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceDataattributesaccessorFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesaccessorReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void setGeometry(GeoPolyline geometry) {
    final _setGeometryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataAccessor_setGeometry__GeoPolyline'));
    final _geometryHandle = sdkCoreGeopolylineToFfi(geometry);
    final _handle = this.handle;
    _setGeometryFfi(_handle, __lib.LibraryContext.isolateId, _geometryHandle);
    sdkCoreGeopolylineReleaseFfiHandle(_geometryHandle);

  }

  @override
  void setAttributes(DataAttributes attributes) {
    final _setAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataAccessor_setAttributes__DataAttributes'));
    final _attributesHandle = sdkMapviewDatasourceDataattributesToFfi(attributes);
    final _handle = this.handle;
    _setAttributesFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle);
    sdkMapviewDatasourceDataattributesReleaseFfiHandle(_attributesHandle);

  }


}

Pointer<Void> sdkMapviewDatasourceLinedataaccessorToFfi(LineDataAccessor value) =>
  _sdkMapviewDatasourceLinedataaccessorCopyHandle((value as __lib.NativeBase).handle);

LineDataAccessor sdkMapviewDatasourceLinedataaccessorFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineDataAccessor) return instance;

  final _copiedHandle = _sdkMapviewDatasourceLinedataaccessorCopyHandle(handle);
  final result = LineDataAccessor$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinedataaccessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinedataaccessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedataaccessorReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinedataaccessorToFfiNullable(LineDataAccessor? value) =>
  value != null ? sdkMapviewDatasourceLinedataaccessorToFfi(value) : Pointer<Void>.fromAddress(0);

LineDataAccessor? sdkMapviewDatasourceLinedataaccessorFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinedataaccessorFromFfi(handle) : null;

void sdkMapviewDatasourceLinedataaccessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedataaccessorReleaseHandle(handle);

// End of LineDataAccessor "private" section.


