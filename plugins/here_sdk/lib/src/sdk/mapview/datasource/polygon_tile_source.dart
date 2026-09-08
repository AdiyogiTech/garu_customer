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
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_key.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tiling_scheme.dart';

/// A source of geodetic polygon tiles.
///
/// Polygons provided by an implementation must be clipped to the boundaries of the requested tile.
/// The implementations must be thread-safe.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonTileSource implements TileSource {
  /// A source of geodetic polygon tiles.
  ///
  /// Polygons provided by an implementation must be clipped to the boundaries of the requested tile.
  /// The implementations must be thread-safe.
  ///
  /// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
  /// behavior. Related APIs may change for new releases without a deprecation process.

  factory PolygonTileSource(
    TileSourceDataVersion Function(TileKey) getDataVersionLambda,
    void Function(TileSourceListener) addListenerLambda,
    void Function(TileSourceListener) removeListenerLambda,
    TileSourceLoadTileRequestHandle? Function(TileKey, PolygonTileSourceLoadResultHandler) loadTileLambda,
    TilingScheme Function() tilingSchemeGetLambda,
    List<int> Function() storageLevelsGetLambda
  ) => PolygonTileSource$Lambdas(
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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, PolygonTileSourceLoadResultHandler completionHandler);
}

/// Result handler of a load tile request.
abstract class PolygonTileSourceLoadResultHandler {
  /// Result handler of a load tile request.

  factory PolygonTileSourceLoadResultHandler(
    void Function(TileKey, List<PolygonData>, TileSourceTileMetadata) loadedLambda,
    void Function(TileKey) failedLambda,

  ) => PolygonTileSourceLoadResultHandler$Lambdas(
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
  void loaded(TileKey tileKey, List<PolygonData> data, TileSourceTileMetadata metadata);
  /// Called upon failed load tile request.
  ///
  /// [tileKey] Failed tile key.
  ///
  void failed(TileKey tileKey);
}


// PolygonTileSourceLoadResultHandler "private" section, not exported.

final _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_register_finalizer'));
final _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_copy_handle'));
final _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_release_handle'));
final _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_create_proxy'));
final _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_get_type_id'));



class PolygonTileSourceLoadResultHandler$Lambdas implements PolygonTileSourceLoadResultHandler {
  void Function(TileKey, List<PolygonData>, TileSourceTileMetadata) loadedLambda;
  void Function(TileKey) failedLambda;

  PolygonTileSourceLoadResultHandler$Lambdas(
    this.loadedLambda,
    this.failedLambda,

  );

  @override
  void loaded(TileKey tileKey, List<PolygonData> data, TileSourceTileMetadata metadata) =>
    loadedLambda(tileKey, data, metadata);
  @override
  void failed(TileKey tileKey) =>
    failedLambda(tileKey);
}

class PolygonTileSourceLoadResultHandler$Impl extends __lib.NativeBase implements PolygonTileSourceLoadResultHandler {

  PolygonTileSourceLoadResultHandler$Impl(Pointer<Void> handle) : super(handle);

  @override
  void loaded(TileKey tileKey, List<PolygonData> data, TileSourceTileMetadata metadata) {
    final _loadedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_loaded__TileKey_ListOf_sdk_mapview_datasource_PolygonData_TileMetadata'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _dataHandle = harpSdkBindingslistofSdkMapviewDatasourcePolygondataToFfi(data);
    final _metadataHandle = sdkMapviewDatasourceTilesourceTilemetadataToFfi(metadata);
    final _handle = this.handle;
    _loadedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _dataHandle, _metadataHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    harpSdkBindingslistofSdkMapviewDatasourcePolygondataReleaseFfiHandle(_dataHandle);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(_metadataHandle);

  }

  @override
  void failed(TileKey tileKey) {
    final _failedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonTileSource_LoadResultHandler_failed__TileKey'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _handle = this.handle;
    _failedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);

  }


}

int _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerloadedStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> data, Pointer<Void> metadata) {

  try {
    (_obj as PolygonTileSourceLoadResultHandler).loaded(sdkMapviewDatasourceTilekeyFromFfi(tileKey), harpSdkBindingslistofSdkMapviewDatasourcePolygondataFromFfi(data), sdkMapviewDatasourceTilesourceTilemetadataFromFfi(metadata));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    harpSdkBindingslistofSdkMapviewDatasourcePolygondataReleaseFfiHandle(data);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(metadata);
  }
  return 0;
}
int _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerfailedStatic(Object _obj, Pointer<Void> tileKey) {

  try {
    (_obj as PolygonTileSourceLoadResultHandler).failed(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourcePolygontilesourceLoadresulthandlerToFfi(PolygonTileSourceLoadResultHandler value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>)>(_sdkMapviewDatasourcePolygontilesourceLoadresulthandlerloadedStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourcePolygontilesourceLoadresulthandlerfailedStatic, __lib.unknownError)
  );

  return result;
}

PolygonTileSourceLoadResultHandler sdkMapviewDatasourcePolygontilesourceLoadresulthandlerFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonTileSourceLoadResultHandler) return instance;

  final _typeIdHandle = _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : PolygonTileSourceLoadResultHandler$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygontilesourceLoadresulthandlerToFfiNullable(PolygonTileSourceLoadResultHandler? value) =>
  value != null ? sdkMapviewDatasourcePolygontilesourceLoadresulthandlerToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonTileSourceLoadResultHandler? sdkMapviewDatasourcePolygontilesourceLoadresulthandlerFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygontilesourceLoadresulthandlerFromFfi(handle) : null;

void sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseHandle(handle);

// End of PolygonTileSourceLoadResultHandler "private" section.

// PolygonTileSource "private" section, not exported.

final _sdkMapviewDatasourcePolygontilesourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_register_finalizer'));
final _sdkMapviewDatasourcePolygontilesourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_copy_handle'));
final _sdkMapviewDatasourcePolygontilesourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_release_handle'));
final _sdkMapviewDatasourcePolygontilesourceCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_create_proxy'));
final _sdkMapviewDatasourcePolygontilesourceGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonTileSource_get_type_id'));


class PolygonTileSource$Lambdas implements PolygonTileSource {
  TileSourceDataVersion Function(TileKey) getDataVersionLambda;
  void Function(TileSourceListener) addListenerLambda;
  void Function(TileSourceListener) removeListenerLambda;
  TileSourceLoadTileRequestHandle? Function(TileKey, PolygonTileSourceLoadResultHandler) loadTileLambda;
  TilingScheme Function() tilingSchemeGetLambda;
  List<int> Function() storageLevelsGetLambda;

  PolygonTileSource$Lambdas(
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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, PolygonTileSourceLoadResultHandler completionHandler) =>
    loadTileLambda(tileKey, completionHandler);
  @override
  TilingScheme get tilingScheme => tilingSchemeGetLambda();
  @override
  List<int> get storageLevels => storageLevelsGetLambda();
}

class PolygonTileSource$Impl extends __lib.NativeBase implements PolygonTileSource {

  PolygonTileSource$Impl(Pointer<Void> handle) : super(handle);

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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, PolygonTileSourceLoadResultHandler completionHandler) {
    final _loadTileFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonTileSource_loadTile__TileKey_LoadResultHandler'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _completionHandlerHandle = sdkMapviewDatasourcePolygontilesourceLoadresulthandlerToFfi(completionHandler);
    final _handle = this.handle;
    final __resultHandle = _loadTileFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _completionHandlerHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseFfiHandle(_completionHandlerHandle);
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

int _sdkMapviewDatasourcePolygontilesourcegetDataVersionStatic(Object _obj, Pointer<Void> tileKey, Pointer<Pointer<Void>> _result) {
  TileSourceDataVersion? _resultObject;
  try {
    _resultObject = (_obj as PolygonTileSource).getDataVersion(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
    _result.value = sdkMapviewDatasourceTilesourceDataversionToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}
int _sdkMapviewDatasourcePolygontilesourceaddListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as PolygonTileSource).addListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourcePolygontilesourceremoveListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as PolygonTileSource).removeListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourcePolygontilesourceloadTileStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> completionHandler, Pointer<Pointer<Void>> _result) {
  TileSourceLoadTileRequestHandle? _resultObject;
  try {
    _resultObject = (_obj as PolygonTileSource).loadTile(sdkMapviewDatasourceTilekeyFromFfi(tileKey), sdkMapviewDatasourcePolygontilesourceLoadresulthandlerFromFfi(completionHandler));
    _result.value = sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfiNullable(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    sdkMapviewDatasourcePolygontilesourceLoadresulthandlerReleaseFfiHandle(completionHandler);
  }
  return 0;
}

int _sdkMapviewDatasourcePolygontilesourcetilingSchemeGetStatic(Object _obj, Pointer<Uint32> _result) {
  _result.value = sdkMapviewDatasourceTilingschemeToFfi((_obj as PolygonTileSource).tilingScheme);
  return 0;
}
int _sdkMapviewDatasourcePolygontilesourcestorageLevelsGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = harpSdkBindingslistofIntToFfi((_obj as PolygonTileSource).storageLevels);
  return 0;
}

Pointer<Void> sdkMapviewDatasourcePolygontilesourceToFfi(PolygonTileSource value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourcePolygontilesourceCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourcePolygontilesourceCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourcePolygontilesourcegetDataVersionStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourcePolygontilesourceaddListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourcePolygontilesourceremoveListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourcePolygontilesourceloadTileStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Uint32>)>(_sdkMapviewDatasourcePolygontilesourcetilingSchemeGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourcePolygontilesourcestorageLevelsGetStatic, __lib.unknownError)
  );

  return result;
}

PolygonTileSource sdkMapviewDatasourcePolygontilesourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonTileSource) return instance;

  final _typeIdHandle = _sdkMapviewDatasourcePolygontilesourceGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourcePolygontilesourceCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : PolygonTileSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygontilesourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygontilesourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygontilesourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygontilesourceToFfiNullable(PolygonTileSource? value) =>
  value != null ? sdkMapviewDatasourcePolygontilesourceToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonTileSource? sdkMapviewDatasourcePolygontilesourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygontilesourceFromFfi(handle) : null;

void sdkMapviewDatasourcePolygontilesourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygontilesourceReleaseHandle(handle);

// End of PolygonTileSource "private" section.


