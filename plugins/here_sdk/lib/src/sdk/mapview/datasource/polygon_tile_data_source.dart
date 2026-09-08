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
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:meta/meta.dart';

/// Polygon tile data source allows the rendering engine access to user managed data sets of
/// geodetic polygons and their attributes through a [PolygonTileSource].
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonTileDataSource {

  /// Creates a named [PolygonTileDataSource] in the given context over a given [PolygonTileSource].
  ///
  /// [context] Map context to associate the data source with.
  ///
  /// [name] Name of the data source to be created. Must be unique.
  ///
  /// [tileSource] The source of tile data.
  ///
  /// Returns [PolygonTileDataSource]. Instance of the data source created with given name and tile source.
  ///
  static PolygonTileDataSource create(MapContext context, String name, PolygonTileSource tileSource) => $prototype.create(context, name, tileSource);
  /// Frees all internally used resources.
  ///
  /// After calling this method, the object
  /// is not usable anymore.
  ///
  void destroy();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = PolygonTileDataSource$Impl(Pointer<Void>.fromAddress(0));
}


// PolygonTileDataSource "private" section, not exported.

final _sdkMapviewDatasourcePolygontiledatasourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonTileDataSource_register_finalizer'));
final _sdkMapviewDatasourcePolygontiledatasourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileDataSource_copy_handle'));
final _sdkMapviewDatasourcePolygontiledatasourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileDataSource_release_handle'));




/// @nodoc
@visibleForTesting
class PolygonTileDataSource$Impl extends __lib.NativeBase implements PolygonTileDataSource {

  PolygonTileDataSource$Impl(Pointer<Void> handle) : super(handle);

  PolygonTileDataSource create(MapContext context, String name, PolygonTileSource tileSource) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonTileDataSource_create__MapContext_String_PolygonTileSource'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final _nameHandle = stringToFfi(name);
    final _tileSourceHandle = sdkMapviewDatasourcePolygontilesourceToFfi(tileSource);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle, _nameHandle, _tileSourceHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    stringReleaseFfiHandle(_nameHandle);
    sdkMapviewDatasourcePolygontilesourceReleaseFfiHandle(_tileSourceHandle);
    try {
      return sdkMapviewDatasourcePolygontiledatasourceFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourcePolygontiledatasourceReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void destroy() {
    final _destroyFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonTileDataSource_destroy'));
    final _handle = this.handle;
    _destroyFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewDatasourcePolygontiledatasourceToFfi(PolygonTileDataSource value) =>
  _sdkMapviewDatasourcePolygontiledatasourceCopyHandle((value as __lib.NativeBase).handle);

PolygonTileDataSource sdkMapviewDatasourcePolygontiledatasourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonTileDataSource) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePolygontiledatasourceCopyHandle(handle);
  final result = PolygonTileDataSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygontiledatasourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygontiledatasourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygontiledatasourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygontiledatasourceToFfiNullable(PolygonTileDataSource? value) =>
  value != null ? sdkMapviewDatasourcePolygontiledatasourceToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonTileDataSource? sdkMapviewDatasourcePolygontiledatasourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygontiledatasourceFromFfi(handle) : null;

void sdkMapviewDatasourcePolygontiledatasourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygontiledatasourceReleaseHandle(handle);

// End of PolygonTileDataSource "private" section.


