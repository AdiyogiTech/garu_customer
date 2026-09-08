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
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_data_source.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:meta/meta.dart';

/// Builder of the polygons data source.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonDataSourceBuilder {
  /// Creates a data source builder instance in the given context.
  ///
  /// [context] Map context to associate the data source with.
  ///
  factory PolygonDataSourceBuilder(MapContext context) => $prototype.create(context);

  /// Configures the builder to use the given name for data source.
  ///
  /// [dataSourceName] Name of the created data source. Must be unique.
  ///
  /// Returns [PolygonDataSourceBuilder]. This data source builder instance.
  ///
  PolygonDataSourceBuilder withName(String dataSourceName);
  /// Configures the builder to insert the given polygon in the data source.
  ///
  /// [polygon] The polygon to add.
  ///
  /// Returns [PolygonDataSourceBuilder]. This data source builder instance.
  ///
  PolygonDataSourceBuilder withPolygon(PolygonData polygon);
  /// Configures the builder to insert the given polygons in the data source.
  ///
  /// [polygon] The polygons to add.
  ///
  /// Returns [PolygonDataSourceBuilder]. This data source builder instance.
  ///
  PolygonDataSourceBuilder withPolygons(List<PolygonData> polygon);
  /// Builds a PolygonDataSource instance.
  ///
  /// Returns [PolygonDataSource]. Instance of the data source created with given polygons and attributes.
  ///
  PolygonDataSource build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = PolygonDataSourceBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// PolygonDataSourceBuilder "private" section, not exported.

final _sdkMapviewDatasourcePolygondatasourcebuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_register_finalizer'));
final _sdkMapviewDatasourcePolygondatasourcebuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_copy_handle'));
final _sdkMapviewDatasourcePolygondatasourcebuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_release_handle'));







/// @nodoc
@visibleForTesting
class PolygonDataSourceBuilder$Impl extends __lib.NativeBase implements PolygonDataSourceBuilder {

  PolygonDataSourceBuilder$Impl(Pointer<Void> handle) : super(handle);


  PolygonDataSourceBuilder create(MapContext context) {
    final _result_handle = _create(context);
    final _result = PolygonDataSourceBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourcePolygondatasourcebuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create(MapContext context) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_create__MapContext'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    return __resultHandle;
  }

  @override
  PolygonDataSourceBuilder withName(String dataSourceName) {
    final _withNameFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_withName__String'));
    final _dataSourceNameHandle = stringToFfi(dataSourceName);
    final _handle = this.handle;
    final __resultHandle = _withNameFfi(_handle, __lib.LibraryContext.isolateId, _dataSourceNameHandle);
    stringReleaseFfiHandle(_dataSourceNameHandle);
    try {
      return sdkMapviewDatasourcePolygondatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PolygonDataSourceBuilder withPolygon(PolygonData polygon) {
    final _withPolygonFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_withPolygon__PolygonData'));
    final _polygonHandle = sdkMapviewDatasourcePolygondataToFfi(polygon);
    final _handle = this.handle;
    final __resultHandle = _withPolygonFfi(_handle, __lib.LibraryContext.isolateId, _polygonHandle);
    sdkMapviewDatasourcePolygondataReleaseFfiHandle(_polygonHandle);
    try {
      return sdkMapviewDatasourcePolygondatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PolygonDataSourceBuilder withPolygons(List<PolygonData> polygon) {
    final _withPolygonsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_withPolygons__ListOf_sdk_mapview_datasource_PolygonData'));
    final _polygonHandle = harpSdkBindingslistofSdkMapviewDatasourcePolygondataToFfi(polygon);
    final _handle = this.handle;
    final __resultHandle = _withPolygonsFfi(_handle, __lib.LibraryContext.isolateId, _polygonHandle);
    harpSdkBindingslistofSdkMapviewDatasourcePolygondataReleaseFfiHandle(_polygonHandle);
    try {
      return sdkMapviewDatasourcePolygondatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PolygonDataSource build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonDataSourceBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourcePolygondatasourceFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygondatasourceReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourcePolygondatasourcebuilderToFfi(PolygonDataSourceBuilder value) =>
  _sdkMapviewDatasourcePolygondatasourcebuilderCopyHandle((value as __lib.NativeBase).handle);

PolygonDataSourceBuilder sdkMapviewDatasourcePolygondatasourcebuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonDataSourceBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePolygondatasourcebuilderCopyHandle(handle);
  final result = PolygonDataSourceBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygondatasourcebuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygondatasourcebuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatasourcebuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygondatasourcebuilderToFfiNullable(PolygonDataSourceBuilder? value) =>
  value != null ? sdkMapviewDatasourcePolygondatasourcebuilderToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonDataSourceBuilder? sdkMapviewDatasourcePolygondatasourcebuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygondatasourcebuilderFromFfi(handle) : null;

void sdkMapviewDatasourcePolygondatasourcebuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatasourcebuilderReleaseHandle(handle);

// End of PolygonDataSourceBuilder "private" section.


