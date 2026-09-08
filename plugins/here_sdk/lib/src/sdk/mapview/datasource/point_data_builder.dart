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
import 'package:here_sdk/src/sdk/mapview/datasource/point_data.dart';
import 'package:meta/meta.dart';

/// Builder of [PointData] instances.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointDataBuilder {
  /// Creates a builder instance.
  ///
  factory PointDataBuilder() => $prototype.create();

  /// Configures the builder with geodetic coordinates for point to be created.
  ///
  /// [coordinates] Geodetic coordinates of the point.
  /// Altitude of coordinates is ignored.
  ///
  /// Returns [PointDataBuilder]. The builder.
  ///
  PointDataBuilder withCoordinates(GeoCoordinates coordinates);
  /// Configures the builder with custom attributes for point to be created.
  ///
  /// [attributes] Custom data attributes to be associated with the point.
  ///
  /// Returns [PointDataBuilder]. The builder.
  ///
  PointDataBuilder withAttributes(DataAttributes attributes);
  /// Builds an instance of [PointData] and resets the builder instance.
  ///
  /// Returns [PointData]. Instance of [PointData] created with the configured parameters.
  ///
  PointData build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = PointDataBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// PointDataBuilder "private" section, not exported.

final _sdkMapviewDatasourcePointdatabuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointDataBuilder_register_finalizer'));
final _sdkMapviewDatasourcePointdatabuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataBuilder_copy_handle'));
final _sdkMapviewDatasourcePointdatabuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataBuilder_release_handle'));






/// @nodoc
@visibleForTesting
class PointDataBuilder$Impl extends __lib.NativeBase implements PointDataBuilder {

  PointDataBuilder$Impl(Pointer<Void> handle) : super(handle);


  PointDataBuilder create() {
    final _result_handle = _create();
    final _result = PointDataBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourcePointdatabuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create() {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_mapview_datasource_PointDataBuilder_create'));
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId);
    return __resultHandle;
  }

  @override
  PointDataBuilder withCoordinates(GeoCoordinates coordinates) {
    final _withCoordinatesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataBuilder_withCoordinates__GeoCoordinates'));
    final _coordinatesHandle = sdkCoreGeocoordinatesToFfi(coordinates);
    final _handle = this.handle;
    final __resultHandle = _withCoordinatesFfi(_handle, __lib.LibraryContext.isolateId, _coordinatesHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_coordinatesHandle);
    try {
      return sdkMapviewDatasourcePointdatabuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdatabuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PointDataBuilder withAttributes(DataAttributes attributes) {
    final _withAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataBuilder_withAttributes__DataAttributes'));
    final _attributesHandle = sdkMapviewDatasourceDataattributesToFfi(attributes);
    final _handle = this.handle;
    final __resultHandle = _withAttributesFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle);
    sdkMapviewDatasourceDataattributesReleaseFfiHandle(_attributesHandle);
    try {
      return sdkMapviewDatasourcePointdatabuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdatabuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PointData build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointDataBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourcePointdataFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdataReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourcePointdatabuilderToFfi(PointDataBuilder value) =>
  _sdkMapviewDatasourcePointdatabuilderCopyHandle((value as __lib.NativeBase).handle);

PointDataBuilder sdkMapviewDatasourcePointdatabuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointDataBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePointdatabuilderCopyHandle(handle);
  final result = PointDataBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointdatabuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointdatabuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatabuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointdatabuilderToFfiNullable(PointDataBuilder? value) =>
  value != null ? sdkMapviewDatasourcePointdatabuilderToFfi(value) : Pointer<Void>.fromAddress(0);

PointDataBuilder? sdkMapviewDatasourcePointdatabuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointdatabuilderFromFfi(handle) : null;

void sdkMapviewDatasourcePointdatabuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatabuilderReleaseHandle(handle);

// End of PointDataBuilder "private" section.


