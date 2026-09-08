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
import 'package:here_sdk/src/sdk/mapview/datasource/line_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/line_data_source.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:meta/meta.dart';

/// Builder of lines data source.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class LineDataSourceBuilder {
  /// Creates a data source builder instance in the given context.
  ///
  /// [context] Map context to associate the data source with.
  ///
  factory LineDataSourceBuilder(MapContext context) => $prototype.create(context);

  /// Configures the builder to use the given name for data source.
  ///
  /// [dataSourceName] Name of the created data source. Must be unique.
  ///
  /// Returns [LineDataSourceBuilder]. This data source builder instance.
  ///
  LineDataSourceBuilder withName(String dataSourceName);
  /// Configures the builder to insert the given polyline in the data source.
  ///
  /// [polyline] Polyline to add.
  ///
  /// Returns [LineDataSourceBuilder]. This data source builder instance.
  ///
  LineDataSourceBuilder withPolyline(LineData polyline);
  /// Configures the builder to insert the given polylines in the data source.
  ///
  /// [polylines] Polylines to add.
  ///
  /// Returns [LineDataSourceBuilder]. This data source builder instance.
  ///
  LineDataSourceBuilder withPolylines(List<LineData> polylines);
  /// Builds instance of LineDataSource.
  ///
  /// Returns [LineDataSource]. Instance of the data source created with given polylines and attributes.
  ///
  LineDataSource build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = LineDataSourceBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// LineDataSourceBuilder "private" section, not exported.

final _sdkMapviewDatasourceLinedatasourcebuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_register_finalizer'));
final _sdkMapviewDatasourceLinedatasourcebuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_copy_handle'));
final _sdkMapviewDatasourceLinedatasourcebuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_release_handle'));







/// @nodoc
@visibleForTesting
class LineDataSourceBuilder$Impl extends __lib.NativeBase implements LineDataSourceBuilder {

  LineDataSourceBuilder$Impl(Pointer<Void> handle) : super(handle);


  LineDataSourceBuilder create(MapContext context) {
    final _result_handle = _create(context);
    final _result = LineDataSourceBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceLinedatasourcebuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create(MapContext context) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_create__MapContext'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    return __resultHandle;
  }

  @override
  LineDataSourceBuilder withName(String dataSourceName) {
    final _withNameFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_withName__String'));
    final _dataSourceNameHandle = stringToFfi(dataSourceName);
    final _handle = this.handle;
    final __resultHandle = _withNameFfi(_handle, __lib.LibraryContext.isolateId, _dataSourceNameHandle);
    stringReleaseFfiHandle(_dataSourceNameHandle);
    try {
      return sdkMapviewDatasourceLinedatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  LineDataSourceBuilder withPolyline(LineData polyline) {
    final _withPolylineFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_withPolyline__LineData'));
    final _polylineHandle = sdkMapviewDatasourceLinedataToFfi(polyline);
    final _handle = this.handle;
    final __resultHandle = _withPolylineFfi(_handle, __lib.LibraryContext.isolateId, _polylineHandle);
    sdkMapviewDatasourceLinedataReleaseFfiHandle(_polylineHandle);
    try {
      return sdkMapviewDatasourceLinedatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  LineDataSourceBuilder withPolylines(List<LineData> polylines) {
    final _withPolylinesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_withPolylines__ListOf_sdk_mapview_datasource_LineData'));
    final _polylinesHandle = harpSdkBindingslistofSdkMapviewDatasourceLinedataToFfi(polylines);
    final _handle = this.handle;
    final __resultHandle = _withPolylinesFfi(_handle, __lib.LibraryContext.isolateId, _polylinesHandle);
    harpSdkBindingslistofSdkMapviewDatasourceLinedataReleaseFfiHandle(_polylinesHandle);
    try {
      return sdkMapviewDatasourceLinedatasourcebuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedatasourcebuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  LineDataSource build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineDataSourceBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceLinedatasourceFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedatasourceReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourceLinedatasourcebuilderToFfi(LineDataSourceBuilder value) =>
  _sdkMapviewDatasourceLinedatasourcebuilderCopyHandle((value as __lib.NativeBase).handle);

LineDataSourceBuilder sdkMapviewDatasourceLinedatasourcebuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineDataSourceBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourceLinedatasourcebuilderCopyHandle(handle);
  final result = LineDataSourceBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinedatasourcebuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinedatasourcebuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatasourcebuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinedatasourcebuilderToFfiNullable(LineDataSourceBuilder? value) =>
  value != null ? sdkMapviewDatasourceLinedatasourcebuilderToFfi(value) : Pointer<Void>.fromAddress(0);

LineDataSourceBuilder? sdkMapviewDatasourceLinedatasourcebuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinedatasourcebuilderFromFfi(handle) : null;

void sdkMapviewDatasourceLinedatasourcebuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatasourcebuilderReleaseHandle(handle);

// End of LineDataSourceBuilder "private" section.


