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
import 'package:here_sdk/src/sdk/mapview/datasource/line_tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:meta/meta.dart';

/// Line tile data source allows the rendering engine access to user managed data sets of
/// geodetic lines and their attributes through a [LineTileSource].
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class LineTileDataSource {

  /// Creates a named [LineTileDataSource] in the given context over a given [LineTileSource].
  ///
  /// [context] Map context to associate the data source with.
  ///
  /// [name] Name of the data source to be created. Must be unique.
  ///
  /// [tileSource] The source of tile data.
  ///
  /// Returns [LineTileDataSource]. Instance of the data source created with given name and tile source.
  ///
  static LineTileDataSource create(MapContext context, String name, LineTileSource tileSource) => $prototype.create(context, name, tileSource);
  /// Frees all internally used resources.
  ///
  /// After calling this method, the object
  /// is not usable anymore.
  ///
  void destroy();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = LineTileDataSource$Impl(Pointer<Void>.fromAddress(0));
}


// LineTileDataSource "private" section, not exported.

final _sdkMapviewDatasourceLinetiledatasourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineTileDataSource_register_finalizer'));
final _sdkMapviewDatasourceLinetiledatasourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileDataSource_copy_handle'));
final _sdkMapviewDatasourceLinetiledatasourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileDataSource_release_handle'));




/// @nodoc
@visibleForTesting
class LineTileDataSource$Impl extends __lib.NativeBase implements LineTileDataSource {

  LineTileDataSource$Impl(Pointer<Void> handle) : super(handle);

  LineTileDataSource create(MapContext context, String name, LineTileSource tileSource) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineTileDataSource_create__MapContext_String_LineTileSource'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final _nameHandle = stringToFfi(name);
    final _tileSourceHandle = sdkMapviewDatasourceLinetilesourceToFfi(tileSource);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle, _nameHandle, _tileSourceHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    stringReleaseFfiHandle(_nameHandle);
    sdkMapviewDatasourceLinetilesourceReleaseFfiHandle(_tileSourceHandle);
    try {
      return sdkMapviewDatasourceLinetiledatasourceFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinetiledatasourceReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void destroy() {
    final _destroyFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineTileDataSource_destroy'));
    final _handle = this.handle;
    _destroyFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewDatasourceLinetiledatasourceToFfi(LineTileDataSource value) =>
  _sdkMapviewDatasourceLinetiledatasourceCopyHandle((value as __lib.NativeBase).handle);

LineTileDataSource sdkMapviewDatasourceLinetiledatasourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineTileDataSource) return instance;

  final _copiedHandle = _sdkMapviewDatasourceLinetiledatasourceCopyHandle(handle);
  final result = LineTileDataSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinetiledatasourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinetiledatasourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinetiledatasourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinetiledatasourceToFfiNullable(LineTileDataSource? value) =>
  value != null ? sdkMapviewDatasourceLinetiledatasourceToFfi(value) : Pointer<Void>.fromAddress(0);

LineTileDataSource? sdkMapviewDatasourceLinetiledatasourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinetiledatasourceFromFfi(handle) : null;

void sdkMapviewDatasourceLinetiledatasourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinetiledatasourceReleaseHandle(handle);

// End of LineTileDataSource "private" section.


