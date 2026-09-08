// Copyright (c) 2019 HERE Global B.V. and its affiliate(s).
// All rights reserved.
// This software and other materials contain proprietary information
// controlled by HERE and are protected by applicable copyright legislation.
// Any use and utilization of this software and other materials and
// disclosure to any third parties is conditional upon having a separate
// agreement with HERE for the access, use, utilization or disclosure of this
// software. In the absence of such agreement, the use of the software is not
// allowed.

import 'dart:ffi';
import 'dart:typed_data';
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/_type_repository.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_key.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tiling_scheme.dart';

/// A source of raster tiles.
///
/// The implementations must be thread-safe.
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class RasterTileSource implements TileSource {
  /// A source of raster tiles.
  ///
  /// The implementations must be thread-safe.
  /// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
  /// behavior. Related APIs may change for new releases without a deprecation process.

  factory RasterTileSource(
    TileSourceDataVersion Function(TileKey) getDataVersionLambda,
    void Function(TileSourceListener) addListenerLambda,
    void Function(TileSourceListener) removeListenerLambda,
    TileSourceLoadTileRequestHandle? Function(TileKey, RasterTileSourceLoadResultHandler) loadTileLambda,
    TilingScheme Function() tilingSchemeGetLambda,
    List<int> Function() storageLevelsGetLambda
  ) => RasterTileSource$Lambdas(
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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, RasterTileSourceLoadResultHandler completionHandler);
}

/// Result handler of a load tile request.
abstract class RasterTileSourceLoadResultHandler {
  /// Result handler of a load tile request.

  factory RasterTileSourceLoadResultHandler(
    void Function(TileKey, Uint8List, TileSourceTileMetadata) loadedLambda,
    void Function(TileKey) failedLambda,

  ) => RasterTileSourceLoadResultHandler$Lambdas(
    loadedLambda,
    failedLambda,

  );

  /// Called upon successful load tile request.
  ///
  /// [tileKey] Loaded tile key.
  ///
  /// [data] Loaded tile data.
  /// Supported are images in PNG or JPEG format.
  ///
  /// [metadata] Loaded tile metadata.
  ///
  void loaded(TileKey tileKey, Uint8List data, TileSourceTileMetadata metadata);
  /// Called upon failed load tile request.
  ///
  /// [tileKey] Failed tile key.
  ///
  void failed(TileKey tileKey);
}


// RasterTileSourceLoadResultHandler "private" section, not exported.

final _sdkMapviewDatasourceRastertilesourceLoadresulthandlerRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_register_finalizer'));
final _sdkMapviewDatasourceRastertilesourceLoadresulthandlerCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_copy_handle'));
final _sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_release_handle'));
final _sdkMapviewDatasourceRastertilesourceLoadresulthandlerCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_create_proxy'));
final _sdkMapviewDatasourceRastertilesourceLoadresulthandlerGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_get_type_id'));



class RasterTileSourceLoadResultHandler$Lambdas implements RasterTileSourceLoadResultHandler {
  void Function(TileKey, Uint8List, TileSourceTileMetadata) loadedLambda;
  void Function(TileKey) failedLambda;

  RasterTileSourceLoadResultHandler$Lambdas(
    this.loadedLambda,
    this.failedLambda,

  );

  @override
  void loaded(TileKey tileKey, Uint8List data, TileSourceTileMetadata metadata) =>
    loadedLambda(tileKey, data, metadata);
  @override
  void failed(TileKey tileKey) =>
    failedLambda(tileKey);
}

class RasterTileSourceLoadResultHandler$Impl extends __lib.NativeBase implements RasterTileSourceLoadResultHandler {

  RasterTileSourceLoadResultHandler$Impl(Pointer<Void> handle) : super(handle);

  @override
  void loaded(TileKey tileKey, Uint8List data, TileSourceTileMetadata metadata) {
    final _loadedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_loaded__TileKey_Blob_TileMetadata'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _dataHandle = blobToFfi(data);
    final _metadataHandle = sdkMapviewDatasourceTilesourceTilemetadataToFfi(metadata);
    final _handle = this.handle;
    _loadedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _dataHandle, _metadataHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    blobReleaseFfiHandle(_dataHandle);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(_metadataHandle);

  }

  @override
  void failed(TileKey tileKey) {
    final _failedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_RasterTileSource_LoadResultHandler_failed__TileKey'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _handle = this.handle;
    _failedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);

  }


}

int _sdkMapviewDatasourceRastertilesourceLoadresulthandlerloadedStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> data, Pointer<Void> metadata) {

  try {
    (_obj as RasterTileSourceLoadResultHandler).loaded(sdkMapviewDatasourceTilekeyFromFfi(tileKey), blobFromFfi(data), sdkMapviewDatasourceTilesourceTilemetadataFromFfi(metadata));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    blobReleaseFfiHandle(data);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(metadata);
  }
  return 0;
}
int _sdkMapviewDatasourceRastertilesourceLoadresulthandlerfailedStatic(Object _obj, Pointer<Void> tileKey) {

  try {
    (_obj as RasterTileSourceLoadResultHandler).failed(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourceRastertilesourceLoadresulthandlerToFfi(RasterTileSourceLoadResultHandler value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceRastertilesourceLoadresulthandlerCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceRastertilesourceLoadresulthandlerCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>)>(_sdkMapviewDatasourceRastertilesourceLoadresulthandlerloadedStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceRastertilesourceLoadresulthandlerfailedStatic, __lib.unknownError)
  );

  return result;
}

RasterTileSourceLoadResultHandler sdkMapviewDatasourceRastertilesourceLoadresulthandlerFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is RasterTileSourceLoadResultHandler) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceRastertilesourceLoadresulthandlerGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceRastertilesourceLoadresulthandlerCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : RasterTileSourceLoadResultHandler$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceRastertilesourceLoadresulthandlerRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceRastertilesourceLoadresulthandlerToFfiNullable(RasterTileSourceLoadResultHandler? value) =>
  value != null ? sdkMapviewDatasourceRastertilesourceLoadresulthandlerToFfi(value) : Pointer<Void>.fromAddress(0);

RasterTileSourceLoadResultHandler? sdkMapviewDatasourceRastertilesourceLoadresulthandlerFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceRastertilesourceLoadresulthandlerFromFfi(handle) : null;

void sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseHandle(handle);

// End of RasterTileSourceLoadResultHandler "private" section.

// RasterTileSource "private" section, not exported.

final _sdkMapviewDatasourceRastertilesourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_register_finalizer'));
final _sdkMapviewDatasourceRastertilesourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_copy_handle'));
final _sdkMapviewDatasourceRastertilesourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_release_handle'));
final _sdkMapviewDatasourceRastertilesourceCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_create_proxy'));
final _sdkMapviewDatasourceRastertilesourceGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_RasterTileSource_get_type_id'));


class RasterTileSource$Lambdas implements RasterTileSource {
  TileSourceDataVersion Function(TileKey) getDataVersionLambda;
  void Function(TileSourceListener) addListenerLambda;
  void Function(TileSourceListener) removeListenerLambda;
  TileSourceLoadTileRequestHandle? Function(TileKey, RasterTileSourceLoadResultHandler) loadTileLambda;
  TilingScheme Function() tilingSchemeGetLambda;
  List<int> Function() storageLevelsGetLambda;

  RasterTileSource$Lambdas(
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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, RasterTileSourceLoadResultHandler completionHandler) =>
    loadTileLambda(tileKey, completionHandler);
  @override
  TilingScheme get tilingScheme => tilingSchemeGetLambda();
  @override
  List<int> get storageLevels => storageLevelsGetLambda();
}

class RasterTileSource$Impl extends __lib.NativeBase implements RasterTileSource {

  RasterTileSource$Impl(Pointer<Void> handle) : super(handle);

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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, RasterTileSourceLoadResultHandler completionHandler) {
    final _loadTileFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_RasterTileSource_loadTile__TileKey_LoadResultHandler'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _completionHandlerHandle = sdkMapviewDatasourceRastertilesourceLoadresulthandlerToFfi(completionHandler);
    final _handle = this.handle;
    final __resultHandle = _loadTileFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _completionHandlerHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseFfiHandle(_completionHandlerHandle);
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
      return harpPluginsRasterBindingslistofIntFromFfi(__resultHandle);
    } finally {
      harpPluginsRasterBindingslistofIntReleaseFfiHandle(__resultHandle);

    }

  }



}

int _sdkMapviewDatasourceRastertilesourcegetDataVersionStatic(Object _obj, Pointer<Void> tileKey, Pointer<Pointer<Void>> _result) {
  TileSourceDataVersion? _resultObject;
  try {
    _resultObject = (_obj as RasterTileSource).getDataVersion(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
    _result.value = sdkMapviewDatasourceTilesourceDataversionToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}
int _sdkMapviewDatasourceRastertilesourceaddListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as RasterTileSource).addListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourceRastertilesourceremoveListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as RasterTileSource).removeListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourceRastertilesourceloadTileStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> completionHandler, Pointer<Pointer<Void>> _result) {
  TileSourceLoadTileRequestHandle? _resultObject;
  try {
    _resultObject = (_obj as RasterTileSource).loadTile(sdkMapviewDatasourceTilekeyFromFfi(tileKey), sdkMapviewDatasourceRastertilesourceLoadresulthandlerFromFfi(completionHandler));
    _result.value = sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfiNullable(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    sdkMapviewDatasourceRastertilesourceLoadresulthandlerReleaseFfiHandle(completionHandler);
  }
  return 0;
}

int _sdkMapviewDatasourceRastertilesourcetilingSchemeGetStatic(Object _obj, Pointer<Uint32> _result) {
  _result.value = sdkMapviewDatasourceTilingschemeToFfi((_obj as RasterTileSource).tilingScheme);
  return 0;
}
int _sdkMapviewDatasourceRastertilesourcestorageLevelsGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = harpPluginsRasterBindingslistofIntToFfi((_obj as RasterTileSource).storageLevels);
  return 0;
}

Pointer<Void> sdkMapviewDatasourceRastertilesourceToFfi(RasterTileSource value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceRastertilesourceCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceRastertilesourceCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceRastertilesourcegetDataVersionStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceRastertilesourceaddListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceRastertilesourceremoveListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceRastertilesourceloadTileStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Uint32>)>(_sdkMapviewDatasourceRastertilesourcetilingSchemeGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceRastertilesourcestorageLevelsGetStatic, __lib.unknownError)
  );

  return result;
}

RasterTileSource sdkMapviewDatasourceRastertilesourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is RasterTileSource) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceRastertilesourceGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceRastertilesourceCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : RasterTileSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceRastertilesourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceRastertilesourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceRastertilesourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceRastertilesourceToFfiNullable(RasterTileSource? value) =>
  value != null ? sdkMapviewDatasourceRastertilesourceToFfi(value) : Pointer<Void>.fromAddress(0);

RasterTileSource? sdkMapviewDatasourceRastertilesourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceRastertilesourceFromFfi(handle) : null;

void sdkMapviewDatasourceRastertilesourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceRastertilesourceReleaseHandle(handle);

// End of RasterTileSource "private" section.


