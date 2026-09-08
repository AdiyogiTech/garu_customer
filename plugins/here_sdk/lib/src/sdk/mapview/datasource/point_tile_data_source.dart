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
import 'package:here_sdk/src/sdk/mapview/datasource/point_tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:meta/meta.dart';

/// Point tile data source allows the rendering engine access to user managed data sets of
/// geographical locations and their attributes through a [PointTileSource].
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointTileDataSource {

  /// Creates a named [PointTileDataSource] in the given context over a given [PointTileSource].
  ///
  /// [context] Map context to associate the data source with.
  ///
  /// [name] Name of the data source to be created. Must be unique.
  ///
  /// [tileSource] The source of tile data.
  ///
  /// Returns [PointTileDataSource]. Instance of the data source created with given name and tile source.
  ///
  static PointTileDataSource create(MapContext context, String name, PointTileSource tileSource) => $prototype.create(context, name, tileSource);
  /// Frees all internally used resources.
  ///
  /// After calling this method, the object
  /// is not usable anymore.
  ///
  void destroy();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = PointTileDataSource$Impl(Pointer<Void>.fromAddress(0));
}


// PointTileDataSource "private" section, not exported.

final _sdkMapviewDatasourcePointtiledatasourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointTileDataSource_register_finalizer'));
final _sdkMapviewDatasourcePointtiledatasourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileDataSource_copy_handle'));
final _sdkMapviewDatasourcePointtiledatasourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileDataSource_release_handle'));




/// @nodoc
@visibleForTesting
class PointTileDataSource$Impl extends __lib.NativeBase implements PointTileDataSource {

  PointTileDataSource$Impl(Pointer<Void> handle) : super(handle);

  PointTileDataSource create(MapContext context, String name, PointTileSource tileSource) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointTileDataSource_create__MapContext_String_PointTileSource'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final _nameHandle = stringToFfi(name);
    final _tileSourceHandle = sdkMapviewDatasourcePointtilesourceToFfi(tileSource);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle, _nameHandle, _tileSourceHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    stringReleaseFfiHandle(_nameHandle);
    sdkMapviewDatasourcePointtilesourceReleaseFfiHandle(_tileSourceHandle);
    try {
      return sdkMapviewDatasourcePointtiledatasourceFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePointtiledatasourceReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void destroy() {
    final _destroyFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointTileDataSource_destroy'));
    final _handle = this.handle;
    _destroyFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewDatasourcePointtiledatasourceToFfi(PointTileDataSource value) =>
  _sdkMapviewDatasourcePointtiledatasourceCopyHandle((value as __lib.NativeBase).handle);

PointTileDataSource sdkMapviewDatasourcePointtiledatasourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointTileDataSource) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePointtiledatasourceCopyHandle(handle);
  final result = PointTileDataSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointtiledatasourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointtiledatasourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointtiledatasourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointtiledatasourceToFfiNullable(PointTileDataSource? value) =>
  value != null ? sdkMapviewDatasourcePointtiledatasourceToFfi(value) : Pointer<Void>.fromAddress(0);

PointTileDataSource? sdkMapviewDatasourcePointtiledatasourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointtiledatasourceFromFfi(handle) : null;

void sdkMapviewDatasourcePointtiledatasourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointtiledatasourceReleaseHandle(handle);

// End of PointTileDataSource "private" section.


