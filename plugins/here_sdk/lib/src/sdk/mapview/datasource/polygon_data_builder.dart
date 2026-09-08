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
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_data.dart';
import 'package:meta/meta.dart';

/// Builder of [PolygonData] instances.
///
/// The builder can create [PolygonData] instances for polygons with an outer boundary and
/// optionally one or more inner boundaries (holes).
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonDataBuilder {
  /// Creates a builder instance.
  ///
  factory PolygonDataBuilder() => $prototype.create();

  /// Configures the builder with geometry for the polygon to be created.
  ///
  /// [geometry] Geometry of the polygon.
  /// The outer boundary has to be ordered clockwise and closed.
  /// Any inner boundary has to be ordered counterclockwise and closed.
  /// Altitude of boundary vertices is ignored.
  /// The visual behaviour for self-intersecting outer boundary is undefined.
  ///
  /// Returns [PolygonDataBuilder]. The builder.
  ///
  PolygonDataBuilder withGeometry(GeoPolygon geometry);
  /// Configures the builder with custom attributes for polygon to be created.
  ///
  /// [attributes] Custom data attributes to be associated with the polygon.
  ///
  /// Returns [PolygonDataBuilder]. The builder.
  ///
  PolygonDataBuilder withAttributes(DataAttributes attributes);
  /// Builds an instance of [PolygonData] and resets the builder instance.
  ///
  /// Returns [PolygonData]. Instance of [PolygonData] created with the configured parameters.
  ///
  PolygonData build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = PolygonDataBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// PolygonDataBuilder "private" section, not exported.

final _sdkMapviewDatasourcePolygondatabuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_register_finalizer'));
final _sdkMapviewDatasourcePolygondatabuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_copy_handle'));
final _sdkMapviewDatasourcePolygondatabuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_release_handle'));






/// @nodoc
@visibleForTesting
class PolygonDataBuilder$Impl extends __lib.NativeBase implements PolygonDataBuilder {

  PolygonDataBuilder$Impl(Pointer<Void> handle) : super(handle);


  PolygonDataBuilder create() {
    final _result_handle = _create();
    final _result = PolygonDataBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourcePolygondatabuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create() {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_create'));
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId);
    return __resultHandle;
  }

  @override
  PolygonDataBuilder withGeometry(GeoPolygon geometry) {
    final _withGeometryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_withGeometry__GeoPolygon'));
    final _geometryHandle = sdkCoreGeopolygonToFfi(geometry);
    final _handle = this.handle;
    final __resultHandle = _withGeometryFfi(_handle, __lib.LibraryContext.isolateId, _geometryHandle);
    sdkCoreGeopolygonReleaseFfiHandle(_geometryHandle);
    try {
      return sdkMapviewDatasourcePolygondatabuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondatabuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PolygonDataBuilder withAttributes(DataAttributes attributes) {
    final _withAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_withAttributes__DataAttributes'));
    final _attributesHandle = sdkMapviewDatasourceDataattributesToFfi(attributes);
    final _handle = this.handle;
    final __resultHandle = _withAttributesFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle);
    sdkMapviewDatasourceDataattributesReleaseFfiHandle(_attributesHandle);
    try {
      return sdkMapviewDatasourcePolygondatabuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondatabuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PolygonData build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonDataBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourcePolygondataFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondataReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourcePolygondatabuilderToFfi(PolygonDataBuilder value) =>
  _sdkMapviewDatasourcePolygondatabuilderCopyHandle((value as __lib.NativeBase).handle);

PolygonDataBuilder sdkMapviewDatasourcePolygondatabuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonDataBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePolygondatabuilderCopyHandle(handle);
  final result = PolygonDataBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygondatabuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygondatabuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatabuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygondatabuilderToFfiNullable(PolygonDataBuilder? value) =>
  value != null ? sdkMapviewDatasourcePolygondatabuilderToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonDataBuilder? sdkMapviewDatasourcePolygondatabuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygondatabuilderFromFfi(handle) : null;

void sdkMapviewDatasourcePolygondatabuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatabuilderReleaseHandle(handle);

// End of PolygonDataBuilder "private" section.


