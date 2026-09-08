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
import 'package:here_sdk/src/sdk/mapview/datasource/point_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_key.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tiling_scheme.dart';

/// A source of geodetic point tiles.
///
/// The implementations must be thread-safe.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointTileSource implements TileSource {
  /// A source of geodetic point tiles.
  ///
  /// The implementations must be thread-safe.
  ///
  /// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
  /// behavior. Related APIs may change for new releases without a deprecation process.

  factory PointTileSource(
    TileSourceDataVersion Function(TileKey) getDataVersionLambda,
    void Function(TileSourceListener) addListenerLambda,
    void Function(TileSourceListener) removeListenerLambda,
    TileSourceLoadTileRequestHandle? Function(TileKey, PointTileSourceLoadResultHandler) loadTileLambda,
    TilingScheme Function() tilingSchemeGetLambda,
    List<int> Function() storageLevelsGetLambda
  ) => PointTileSource$Lambdas(
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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, PointTileSourceLoadResultHandler completionHandler);
}

/// Result handler of a load tile request.
abstract class PointTileSourceLoadResultHandler {
  /// Result handler of a load tile request.

  factory PointTileSourceLoadResultHandler(
    void Function(TileKey, List<PointData>, TileSourceTileMetadata) loadedLambda,
    void Function(TileKey) failedLambda,

  ) => PointTileSourceLoadResultHandler$Lambdas(
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
  void loaded(TileKey tileKey, List<PointData> data, TileSourceTileMetadata metadata);
  /// Called upon failed load tile request.
  ///
  /// [tileKey] Failed tile key.
  ///
  void failed(TileKey tileKey);
}


// PointTileSourceLoadResultHandler "private" section, not exported.

final _sdkMapviewDatasourcePointtilesourceLoadresulthandlerRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_register_finalizer'));
final _sdkMapviewDatasourcePointtilesourceLoadresulthandlerCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_copy_handle'));
final _sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_release_handle'));
final _sdkMapviewDatasourcePointtilesourceLoadresulthandlerCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_create_proxy'));
final _sdkMapviewDatasourcePointtilesourceLoadresulthandlerGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_get_type_id'));



class PointTileSourceLoadResultHandler$Lambdas implements PointTileSourceLoadResultHandler {
  void Function(TileKey, List<PointData>, TileSourceTileMetadata) loadedLambda;
  void Function(TileKey) failedLambda;

  PointTileSourceLoadResultHandler$Lambdas(
    this.loadedLambda,
    this.failedLambda,

  );

  @override
  void loaded(TileKey tileKey, List<PointData> data, TileSourceTileMetadata metadata) =>
    loadedLambda(tileKey, data, metadata);
  @override
  void failed(TileKey tileKey) =>
    failedLambda(tileKey);
}

class PointTileSourceLoadResultHandler$Impl extends __lib.NativeBase implements PointTileSourceLoadResultHandler {

  PointTileSourceLoadResultHandler$Impl(Pointer<Void> handle) : super(handle);

  @override
  void loaded(TileKey tileKey, List<PointData> data, TileSourceTileMetadata metadata) {
    final _loadedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_loaded__TileKey_ListOf_sdk_mapview_datasource_PointData_TileMetadata'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _dataHandle = harpSdkBindingslistofSdkMapviewDatasourcePointdataToFfi(data);
    final _metadataHandle = sdkMapviewDatasourceTilesourceTilemetadataToFfi(metadata);
    final _handle = this.handle;
    _loadedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _dataHandle, _metadataHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    harpSdkBindingslistofSdkMapviewDatasourcePointdataReleaseFfiHandle(_dataHandle);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(_metadataHandle);

  }

  @override
  void failed(TileKey tileKey) {
    final _failedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointTileSource_LoadResultHandler_failed__TileKey'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _handle = this.handle;
    _failedFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);

  }


}

int _sdkMapviewDatasourcePointtilesourceLoadresulthandlerloadedStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> data, Pointer<Void> metadata) {

  try {
    (_obj as PointTileSourceLoadResultHandler).loaded(sdkMapviewDatasourceTilekeyFromFfi(tileKey), harpSdkBindingslistofSdkMapviewDatasourcePointdataFromFfi(data), sdkMapviewDatasourceTilesourceTilemetadataFromFfi(metadata));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    harpSdkBindingslistofSdkMapviewDatasourcePointdataReleaseFfiHandle(data);
    sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(metadata);
  }
  return 0;
}
int _sdkMapviewDatasourcePointtilesourceLoadresulthandlerfailedStatic(Object _obj, Pointer<Void> tileKey) {

  try {
    (_obj as PointTileSourceLoadResultHandler).failed(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourcePointtilesourceLoadresulthandlerToFfi(PointTileSourceLoadResultHandler value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourcePointtilesourceLoadresulthandlerCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourcePointtilesourceLoadresulthandlerCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>)>(_sdkMapviewDatasourcePointtilesourceLoadresulthandlerloadedStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourcePointtilesourceLoadresulthandlerfailedStatic, __lib.unknownError)
  );

  return result;
}

PointTileSourceLoadResultHandler sdkMapviewDatasourcePointtilesourceLoadresulthandlerFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointTileSourceLoadResultHandler) return instance;

  final _typeIdHandle = _sdkMapviewDatasourcePointtilesourceLoadresulthandlerGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourcePointtilesourceLoadresulthandlerCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : PointTileSourceLoadResultHandler$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointtilesourceLoadresulthandlerRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointtilesourceLoadresulthandlerToFfiNullable(PointTileSourceLoadResultHandler? value) =>
  value != null ? sdkMapviewDatasourcePointtilesourceLoadresulthandlerToFfi(value) : Pointer<Void>.fromAddress(0);

PointTileSourceLoadResultHandler? sdkMapviewDatasourcePointtilesourceLoadresulthandlerFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointtilesourceLoadresulthandlerFromFfi(handle) : null;

void sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseHandle(handle);

// End of PointTileSourceLoadResultHandler "private" section.

// PointTileSource "private" section, not exported.

final _sdkMapviewDatasourcePointtilesourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_register_finalizer'));
final _sdkMapviewDatasourcePointtilesourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_copy_handle'));
final _sdkMapviewDatasourcePointtilesourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_release_handle'));
final _sdkMapviewDatasourcePointtilesourceCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_create_proxy'));
final _sdkMapviewDatasourcePointtilesourceGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointTileSource_get_type_id'));


class PointTileSource$Lambdas implements PointTileSource {
  TileSourceDataVersion Function(TileKey) getDataVersionLambda;
  void Function(TileSourceListener) addListenerLambda;
  void Function(TileSourceListener) removeListenerLambda;
  TileSourceLoadTileRequestHandle? Function(TileKey, PointTileSourceLoadResultHandler) loadTileLambda;
  TilingScheme Function() tilingSchemeGetLambda;
  List<int> Function() storageLevelsGetLambda;

  PointTileSource$Lambdas(
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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, PointTileSourceLoadResultHandler completionHandler) =>
    loadTileLambda(tileKey, completionHandler);
  @override
  TilingScheme get tilingScheme => tilingSchemeGetLambda();
  @override
  List<int> get storageLevels => storageLevelsGetLambda();
}

class PointTileSource$Impl extends __lib.NativeBase implements PointTileSource {

  PointTileSource$Impl(Pointer<Void> handle) : super(handle);

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
  TileSourceLoadTileRequestHandle? loadTile(TileKey tileKey, PointTileSourceLoadResultHandler completionHandler) {
    final _loadTileFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointTileSource_loadTile__TileKey_LoadResultHandler'));
    final _tileKeyHandle = sdkMapviewDatasourceTilekeyToFfi(tileKey);
    final _completionHandlerHandle = sdkMapviewDatasourcePointtilesourceLoadresulthandlerToFfi(completionHandler);
    final _handle = this.handle;
    final __resultHandle = _loadTileFfi(_handle, __lib.LibraryContext.isolateId, _tileKeyHandle, _completionHandlerHandle);
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(_tileKeyHandle);
    sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseFfiHandle(_completionHandlerHandle);
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

int _sdkMapviewDatasourcePointtilesourcegetDataVersionStatic(Object _obj, Pointer<Void> tileKey, Pointer<Pointer<Void>> _result) {
  TileSourceDataVersion? _resultObject;
  try {
    _resultObject = (_obj as PointTileSource).getDataVersion(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
    _result.value = sdkMapviewDatasourceTilesourceDataversionToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}
int _sdkMapviewDatasourcePointtilesourceaddListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as PointTileSource).addListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourcePointtilesourceremoveListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as PointTileSource).removeListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourcePointtilesourceloadTileStatic(Object _obj, Pointer<Void> tileKey, Pointer<Void> completionHandler, Pointer<Pointer<Void>> _result) {
  TileSourceLoadTileRequestHandle? _resultObject;
  try {
    _resultObject = (_obj as PointTileSource).loadTile(sdkMapviewDatasourceTilekeyFromFfi(tileKey), sdkMapviewDatasourcePointtilesourceLoadresulthandlerFromFfi(completionHandler));
    _result.value = sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfiNullable(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
    sdkMapviewDatasourcePointtilesourceLoadresulthandlerReleaseFfiHandle(completionHandler);
  }
  return 0;
}

int _sdkMapviewDatasourcePointtilesourcetilingSchemeGetStatic(Object _obj, Pointer<Uint32> _result) {
  _result.value = sdkMapviewDatasourceTilingschemeToFfi((_obj as PointTileSource).tilingScheme);
  return 0;
}
int _sdkMapviewDatasourcePointtilesourcestorageLevelsGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = harpSdkBindingslistofIntToFfi((_obj as PointTileSource).storageLevels);
  return 0;
}

Pointer<Void> sdkMapviewDatasourcePointtilesourceToFfi(PointTileSource value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourcePointtilesourceCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourcePointtilesourceCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourcePointtilesourcegetDataVersionStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourcePointtilesourceaddListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourcePointtilesourceremoveListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourcePointtilesourceloadTileStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Uint32>)>(_sdkMapviewDatasourcePointtilesourcetilingSchemeGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourcePointtilesourcestorageLevelsGetStatic, __lib.unknownError)
  );

  return result;
}

PointTileSource sdkMapviewDatasourcePointtilesourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointTileSource) return instance;

  final _typeIdHandle = _sdkMapviewDatasourcePointtilesourceGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourcePointtilesourceCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : PointTileSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointtilesourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointtilesourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointtilesourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointtilesourceToFfiNullable(PointTileSource? value) =>
  value != null ? sdkMapviewDatasourcePointtilesourceToFfi(value) : Pointer<Void>.fromAddress(0);

PointTileSource? sdkMapviewDatasourcePointtilesourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointtilesourceFromFfi(handle) : null;

void sdkMapviewDatasourcePointtilesourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointtilesourceReleaseHandle(handle);

// End of PointTileSource "private" section.


