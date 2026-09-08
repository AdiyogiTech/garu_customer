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
import 'package:here_sdk/src/sdk/mapview/datasource/point_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/point_data_source.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:meta/meta.dart';

/// Builder of points data source.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointDataSourceBuilder {
  /// Creates a data source builder instance in the given context.
  ///
  /// [context] Map context to associate the data source with.
  ///
  factory PointDataSourceBuilder(MapContext context) => $prototype.create(context);

  /// Configures the builder to use the given name for data source.
  ///
  /// [dataSourceName] Name of the created data source. Must be unique.
  ///
  /// Returns [PointDataSourceBuilder]. This data source builder instance.
  ///
  PointDataSourceBuilder withName(String dataSourceName);
  /// Configures the builder to insert the given point in the data source.
  ///
  /// [point] Point to be added.
  ///
  /// Returns [PointDataSourceBuilder]. This data source builder instance.
  ///
  PointDataSourceBuilder withPoint(PointData point);
  /// Configures the builder to insert the given points in the data source.
  ///
  /// [points] Points to be added.
  ///
  /// Returns [PointDataSourceBuilder]. This data source builder instance.
  ///
  PointDataSourceBuilder withPoints(List<PointData> points);
  /// Builds a PointDataSource instance and resets the builder instance.
  ///
  /// Returns [PointDataSource]. Instance of the data source created with given points and attributes.
  ///
  PointDataSource build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = PointDataSourceBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// PointDataSourceBuilder "private" section, not exported.

final _sdkMapviewDatasourcePointdatasourcebuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_register_finalizer'));
final _sdkMapviewDatasourcePointdatasourcebuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_copy_handle'));
final _sdkMapviewDatasourcePointdatasourcebuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_release_handle'));







/// @nodoc
@visibleForTesting
class PointDataSourceBuilder$Impl extends __lib.NativeBase implements PointDataSourceBuilder {

  PointDataSourceBuilder$Impl(Pointer<Void> handle) : super(handle);


  PointDataSourceBuilder create(MapContext context) {
    final _result_handle = _create(context);
    final _result = PointDataSourceBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourcePointdatasourcebuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create(MapContext context) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_create__MapContext'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    return __resultHandle;
  }

  @override
  PointDataSourceBuilder withName(String dataSourceName) {
    final _withNameFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_withName__String'));
    final _dataSourceNameHandle = stringToFfi(dataSourceName);
    final _handle = this.handle;
    final __resultHandle = _withNameFfi(_handle, __lib.LibraryContext.isolateId, _dataSourceNameHandle);
    stringReleaseFfiHandle(_dataSourceNameHandle);
    try {
      return sdkMapviewDatasourcePointdatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PointDataSourceBuilder withPoint(PointData point) {
    final _withPointFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_withPoint__PointData'));
    final _pointHandle = sdkMapviewDatasourcePointdataToFfi(point);
    final _handle = this.handle;
    final __resultHandle = _withPointFfi(_handle, __lib.LibraryContext.isolateId, _pointHandle);
    sdkMapviewDatasourcePointdataReleaseFfiHandle(_pointHandle);
    try {
      return sdkMapviewDatasourcePointdatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PointDataSourceBuilder withPoints(List<PointData> points) {
    final _withPointsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_withPoints__ListOf_sdk_mapview_datasource_PointData'));
    final _pointsHandle = harpSdkBindingslistofSdkMapviewDatasourcePointdataToFfi(points);
    final _handle = this.handle;
    final __resultHandle = _withPointsFfi(_handle, __lib.LibraryContext.isolateId, _pointsHandle);
    harpSdkBindingslistofSdkMapviewDatasourcePointdataReleaseFfiHandle(_pointsHandle);
    try {
      return sdkMapviewDatasourcePointdatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  PointDataSource build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointDataSourceBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourcePointdatasourceFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointdatasourceReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourcePointdatasourcebuilderToFfi(PointDataSourceBuilder value) =>
  _sdkMapviewDatasourcePointdatasourcebuilderCopyHandle((value as __lib.NativeBase).handle);

PointDataSourceBuilder sdkMapviewDatasourcePointdatasourcebuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointDataSourceBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePointdatasourcebuilderCopyHandle(handle);
  final result = PointDataSourceBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointdatasourcebuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointdatasourcebuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatasourcebuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointdatasourcebuilderToFfiNullable(PointDataSourceBuilder? value) =>
  value != null ? sdkMapviewDatasourcePointdatasourcebuilderToFfi(value) : Pointer<Void>.fromAddress(0);

PointDataSourceBuilder? sdkMapviewDatasourcePointdatasourcebuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointdatasourcebuilderFromFfi(handle) : null;

void sdkMapviewDatasourcePointdatasourcebuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatasourcebuilderReleaseHandle(handle);

// End of PointDataSourceBuilder "private" section.


