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
import 'package:here_sdk/src/_type_repository.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/line_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_key.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tiling_scheme.dart';

/// A source of geodetic line tiles.
///
/// Lines provided by an implementation must be clipped to the boundaries of the requested tile.
/// The implementations must be thread-safe.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class LineTileSource implements TileSource {
  /// A source of geodetic line tiles.
  ///
  /// Lines provided by an implementation must be clipped to the boundaries of the requested tile.
  /// The implementations must be thread-safe.
  ///
  /// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
  /// behavior. Related APIs may change for new releases without a deprecation process.

  factory LineTileSource(
    TileSourceDataVersion Function(TileKey) getDataVersionLambda,
    void Function(TileSourceListener) addListenerLambda,
    void Function(TileSourceListener) removeListenerLambda,
    TileSourceLoadTileRequestHandle? Function(TileKey, LineTileSourceLoadResultHandler) loadTileLambda,
    TilingScheme Function() tilingSchemeGetLambda,
    List<int> Function() storageLevelsGetLambda
  ) => LineTileSource$Lambdas(
    getDataVersionLambda,
    addListenerLambda,
    removeListenerLambda,
    loadTileLambda,
    tilingSchemeGetLambda,
    storageLevelsGetLambda
  );

  /// Load data of a tile.
  ///
  /// Upon completion, the handler gets informed.
  ///
  /// [tileKey] Key of the tile to load data for.
  ///
  /// [completionHandler] Load result handler.
  ///
  /// Returns [TileSourceLoadTileRequestHandle?]. A handle to the created load request.
  ///
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, LineTileSourceLoadResultHandler completionHandler);
}

/// Result handler of a load tile request.
abstract class LineTileSourceLoadResultHandler {
  /// Result handler of a load tile request.

  factory LineTileSourceLoadResultHandler(
    void Function(TileKey, List<LineData>, TileSourceTileMetadata) loadedLambda,
    void Function(TileKey) failedLambda,

  ) => LineTileSourceLoadResultHandler$Lambdas(
    loadedLambda,
    failedLambda,

  );

  /// Called upon successful load tile request.
  ///
  /// [tileKey] Loaded tile key.
  ///
  /// [data] Loaded tile data.
  ///
  /// [metadata] Loaded tile metadata.
  ///
  void loaded(TileKey tileKey, List<LineData> data, TileSourceTileMetadata metadata);
  /// Called upon failed load tile request.
  ///
  /// [tileKey] Failed tile key.
  ///
  void failed(TileKey tileKey);
}


// LineTileSourceLoadResultHandler "private" section, not exported.

final _sdkMapviewDatasourceLinetilesourceLoadresulthandlerRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_register_finalizer'));
final _sdkMapviewDatasourceLinetilesourceLoadresulthandlerCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_copy_handle'));
final _sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_release_handle'));
final _sdkMapviewDatasourceLinetilesourceLoadresulthandlerCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_create_proxy'));
final _sdkMapviewDatasourceLinetilesourceLoadresulthandlerGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_get_type_id'));



class LineTileSourceLoadResultHandler$Lambdas implements LineTileSourceLoadResultHandler {
  void Function(TileKey, List<LineData>, TileSourceTileMetadata) loadedLambda;
  void Function(TileKey) failedLambda;

  LineTileSourceLoadResultHandler$Lambdas(
    this.loadedLambda,
    this.failedLambda,

  );

  @override
  void loaded(TileKey tileKey, List<LineData> data, TileSourceTileMetadata metadata) =>
    loadedLambda(tileKey, data, metadata);
  @override
  void failed(TileKey tileKey) =>
    failedLambda(tileKey);
}

class LineTileSourceLoadResultHandler$Impl extends __lib.NativeBase implements LineTileSourceLoadResultHandler {

  LineTileSourceLoadResultHandler$Impl(Pointer<Void> handle) : super(handle);

  @override
  void loaded(TileKey tileKey, List<LineData> data, TileSourceTileMetadata metadata) {
    final _loadedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_loaded__TileKey_ListOf_sdk_mapview_datasource_LineData_TileMetadata'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _dataHandle = harpSdkBindingslistofSdkMapviewDatasourceLinedataToFfi(data);
    final _metadataHandle = sdkMapviewDatasourceTilesourceTilemetadataToFfi(metadata);
    final _handle = this.handle;
    _loadedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _dataHandle, _metadataHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    harpSdkBindingslistofSdkMapviewDatasourceLinedataReleaseFfiHandle(_dataHandle);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(_metadataHandle);

  }

  @override
  void failed(TileKey tileKey) {
    final _failedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineTileSource_LoadResultHandler_failed__TileKey'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _handle = this.handle;
    _failedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);

  }


}

int _sdkMapviewDatasourceLinetilesourceLoadresulthandlerloadedStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> data, Pointer<Void> metadata) {

  try {
    (_obj as LineTileSourceLoadResultHandler).loaded(sdkMapviewDatasourceTilekeyFromFfi(tileKey), harpSdkBindingslistofSdkMapviewDatasourceLinedataFromFfi(data), sdkMapviewDatasourceTilesourceTilemetadataFromFfi(metadata));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    harpSdkBindingslistofSdkMapviewDatasourceLinedataReleaseFfiHandle(data);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(metadata);
  }
  return 0;
}
int _sdkMapviewDatasourceLinetilesourceLoadresulthandlerfailedStatic(Object _obj, Pointer<Void> tileKey) {

  try {
    (_obj as LineTileSourceLoadResultHandler).failed(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourceLinetilesourceLoadresulthandlerToFfi(LineTileSourceLoadResultHandler value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceLinetilesourceLoadresulthandlerCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceLinetilesourceLoadresulthandlerCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>)>(_sdkMapviewDatasourceLinetilesourceLoadresulthandlerloadedStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceLinetilesourceLoadresulthandlerfailedStatic, __lib.unknownError)
  );

  return result;
}

LineTileSourceLoadResultHandler sdkMapviewDatasourceLinetilesourceLoadresulthandlerFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineTileSourceLoadResultHandler) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceLinetilesourceLoadresulthandlerGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceLinetilesourceLoadresulthandlerCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : LineTileSourceLoadResultHandler$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinetilesourceLoadresulthandlerRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinetilesourceLoadresulthandlerToFfiNullable(LineTileSourceLoadResultHandler? value) =>
  value != null ? sdkMapviewDatasourceLinetilesourceLoadresulthandlerToFfi(value) : Pointer<Void>.fromAddress(0);

LineTileSourceLoadResultHandler? sdkMapviewDatasourceLinetilesourceLoadresulthandlerFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinetilesourceLoadresulthandlerFromFfi(handle) : null;

void sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseHandle(handle);

// End of LineTileSourceLoadResultHandler "private" section.

// LineTileSource "private" section, not exported.

final _sdkMapviewDatasourceLinetilesourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_register_finalizer'));
final _sdkMapviewDatasourceLinetilesourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_copy_handle'));
final _sdkMapviewDatasourceLinetilesourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_release_handle'));
final _sdkMapviewDatasourceLinetilesourceCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_create_proxy'));
final _sdkMapviewDatasourceLinetilesourceGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineTileSource_get_type_id'));


class LineTileSource$Lambdas implements LineTileSource {
  TileSourceDataVersion Function(TileKey) getDataVersionLambda;
  void Function(TileSourceListener) addListenerLambda;
  void Function(TileSourceListener) removeListenerLambda;
  TileSourceLoadTileRequestHandle? Function(TileKey, LineTileSourceLoadResultHandler) loadTileLambda;
  TilingScheme Function() tilingSchemeGetLambda;
  List<int> Function() storageLevelsGetLambda;

  LineTileSource$Lambdas(
    this.getDataVersionLambda,
    this.addListenerLambda,
    this.removeListenerLambda,
    this.loadTileLambda,
    this.tilingSchemeGetLambda,
    this.storageLevelsGetLambda
  );

  @override
  TileSourceDataVersion getDataVersion(TileKey tileKey) =>
    getDataVersionLambda(tileKey);
  @override
  void addListener(TileSourceListener listener) =>
    addListenerLambda(listener);
  @override
  void removeListener(TileSourceListener listener) =>
    removeListenerLambda(listener);
  @override
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, LineTileSourceLoadResultHandler completionHandler) =>
    loadTileLambda(tileKey, completionHandler);
  @override
  TilingScheme get tilingScheme => tilingSchemeGetLambda();
  @override
  List<int> get storageLevels => storageLevelsGetLambda();
}

class LineTileSource$Impl extends __lib.NativeBase implements LineTileSource {

  LineTileSource$Impl(Pointer<Void> handle) : super(handle);

  @override
  TileSourceDataVersion getDataVersion(TileKey tileKey) {
    final _getDataVersionFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_TileSource_getDataVersion__TileKey'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _handle = this.handle;
    final __resultHandle = _getDataVersionFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    try {
      return sdkMapviewDatasourceTilesourceDataversionFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  void addListener(TileSourceListener listener) {
    final _addListenerFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_TileSource_addListener__Listener'));
    final _listenerHandle = sdkMapviewDatasourceTilesourceListenerToFfi(listener);
    final _handle = this.handle;
    _addListenerFfi(_handle, __lib.LibraryContext.isolateId, _listenerHandle);
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(_listenerHandle);

  }

  @override
  void removeListener(TileSourceListener listener) {
    final _removeListenerFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_TileSource_removeListener__Listener'));
    final _listenerHandle = sdkMapviewDatasourceTilesourceListenerToFfi(listener);
    final _handle = this.handle;
    _removeListenerFfi(_handle, __lib.LibraryContext.isolateId, _listenerHandle);
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(_listenerHandle);

  }

  @override
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, LineTileSourceLoadResultHandler completionHandler) {
    final _loadTileFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineTileSource_loadTile__TileKey_LoadResultHandler'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _completionHandlerHandle = sdkMapviewDatasourceLinetilesourceLoadresulthandlerToFfi(completionHandler);
    final _handle = this.handle;
    final __resultHandle = _loadTileFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _completionHandlerHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseFfiHandle(_completionHandlerHandle);
    try {
      return sdkMapviewDatasourceTilesourceLoadtilerequesthandleFromFfiNullable(__resultHandle);
    } finally {
      sdkMapviewDatasourceTilesourceLoadtilerequesthandleReleaseFfiHandleNullable(__resultHandle);

    }

  }

  /// Gets the tiling scheme used by this source.
  TilingScheme get tilingScheme {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_TileSource_tilingScheme_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceTilingschemeFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceTilingschemeReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the storage levels available for this data source. Supported range \[0, 31\].
  /// At least one level must be available for this to be used as a source of data.
  List<int> get storageLevels {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_TileSource_storageLevels_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofIntFromFfi(__resultHandle);
    } finally {
      harpSdkBindingslistofIntReleaseFfiHandle(__resultHandle);

    }

  }



}

int _sdkMapviewDatasourceLinetilesourcegetDataVersionStatic(Object _obj, Pointer<Void> tileKey, Pointer<Pointer<Void>> _result) {
  TileSourceDataVersion? _resultObject;
  try {
    _resultObject = (_obj as LineTileSource).getDataVersion(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
    _result.value = sdkMapviewDatasourceTilesourceDataversionToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}
int _sdkMapviewDatasourceLinetilesourceaddListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as LineTileSource).addListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourceLinetilesourceremoveListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as LineTileSource).removeListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourceLinetilesourceloadTileStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> completionHandler, Pointer<Pointer<Void>> _result) {
  TileSourceLoadTileRequestHandle? _resultObject;
  try {
    _resultObject = (_obj as LineTileSource).loadTile(sdkMapviewDatasourceTilekeyFromFfi(tileKey), sdkMapviewDatasourceLinetilesourceLoadresulthandlerFromFfi(completionHandler));
    _result.value = sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfiNullable(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    sdkMapviewDatasourceLinetilesourceLoadresulthandlerReleaseFfiHandle(completionHandler);
  }
  return 0;
}

int _sdkMapviewDatasourceLinetilesourcetilingSchemeGetStatic(Object _obj, Pointer<Uint32> _result) {
  _result.value = sdkMapviewDatasourceTilingschemeToFfi((_obj as LineTileSource).tilingScheme);
  return 0;
}
int _sdkMapviewDatasourceLinetilesourcestorageLevelsGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = harpSdkBindingslistofIntToFfi((_obj as LineTileSource).storageLevels);
  return 0;
}

Pointer<Void> sdkMapviewDatasourceLinetilesourceToFfi(LineTileSource value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceLinetilesourceCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceLinetilesourceCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceLinetilesourcegetDataVersionStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceLinetilesourceaddListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceLinetilesourceremoveListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceLinetilesourceloadTileStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Uint32>)>(_sdkMapviewDatasourceLinetilesourcetilingSchemeGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceLinetilesourcestorageLevelsGetStatic, __lib.unknownError)
  );

  return result;
}

LineTileSource sdkMapviewDatasourceLinetilesourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineTileSource) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceLinetilesourceGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceLinetilesourceCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : LineTileSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinetilesourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinetilesourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinetilesourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinetilesourceToFfiNullable(LineTileSource? value) =>
  value != null ? sdkMapviewDatasourceLinetilesourceToFfi(value) : Pointer<Void>.fromAddress(0);

LineTileSource? sdkMapviewDatasourceLinetilesourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinetilesourceFromFfi(handle) : null;

void sdkMapviewDatasourceLinetilesourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinetilesourceReleaseHandle(handle);

// End of LineTileSource "private" section.


