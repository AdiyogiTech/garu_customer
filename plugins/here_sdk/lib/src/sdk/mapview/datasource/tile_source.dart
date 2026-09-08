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
import 'package:here_sdk/src/sdk/mapview/datasource/line_tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/point_tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_tile_source.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tile_key.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/tiling_scheme.dart';

/// A source of tiles.
///
/// The implementations must be thread-safe.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class TileSource {
  /// A source of tiles.
  ///
  /// The implementations must be thread-safe.
  ///
  /// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
  /// behavior. Related APIs may change for new releases without a deprecation process.

  factory TileSource(
    TileSourceDataVersion Function(TileKey) getDataVersionLambda,
    void Function(TileSourceListener) addListenerLambda,
    void Function(TileSourceListener) removeListenerLambda,
    TilingScheme Function() tilingSchemeGetLambda,
    List<int> Function() storageLevelsGetLambda
  ) => TileSource$Lambdas(
    getDataVersionLambda,
    addListenerLambda,
    removeListenerLambda,
    tilingSchemeGetLambda,
    storageLevelsGetLambda
  );

  /// Gets the current data version of a tile.
  ///
  /// [tileKey] Key of the tile for which to retrieve the version.
  ///
  /// Returns [TileSourceDataVersion]. Data version for a tile.
  ///
  TileSourceDataVersion getDataVersion(TileKey tileKey);
  /// Adds a listener for receiving state notifications.
  ///
  /// [listener] The listener
  ///
  void addListener(TileSourceListener listener);
  /// Removes a listener from receiving state notifications.
  ///
  /// [listener] The listener
  ///
  void removeListener(TileSourceListener listener);
  /// The tiling scheme used by this source.
  /// Gets the tiling scheme used by this source.
  TilingScheme get tilingScheme;

  /// The storage levels available for this data source. Supported range \[0, 31\].
  /// At least one level must be available for this to be used as a source of data.
  /// Gets the storage levels available for this data source. Supported range \[0, 31\].
  /// At least one level must be available for this to be used as a source of data.
  List<int> get storageLevels;

}

/// Tile data version.

class TileSourceDataVersion {
  /// Major version number.
  /// Describes changes in underlying data that would require a complete reload
  /// (e.g. geometry changes).
  int majorVersion;

  /// Minor version number.
  /// Describes changes in underlying data that would not require a complete reload
  /// (e.g. attributes changes).
  int minorVersion;

  /// Creates a new instance.
  /// [majorVersion] Major version number.
  /// Describes changes in underlying data that would require a complete reload
  /// (e.g. geometry changes).
  /// [minorVersion] Minor version number.
  /// Describes changes in underlying data that would not require a complete reload
  /// (e.g. attributes changes).
  TileSourceDataVersion(this.majorVersion, this.minorVersion);
}


// TileSourceDataVersion "private" section, not exported.

final _sdkMapviewDatasourceTilesourceDataversionCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Int32, Int32),
    Pointer<Void> Function(int, int)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_create_handle'));
final _sdkMapviewDatasourceTilesourceDataversionReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_release_handle'));
final _sdkMapviewDatasourceTilesourceDataversionGetFieldmajorVersion = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_get_field_majorVersion'));
final _sdkMapviewDatasourceTilesourceDataversionGetFieldminorVersion = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_get_field_minorVersion'));



Pointer<Void> sdkMapviewDatasourceTilesourceDataversionToFfi(TileSourceDataVersion value) {
  final _majorVersionHandle = (value.majorVersion);
  final _minorVersionHandle = (value.minorVersion);
  final _result = _sdkMapviewDatasourceTilesourceDataversionCreateHandle(_majorVersionHandle, _minorVersionHandle);
  
  
  return _result;
}

TileSourceDataVersion sdkMapviewDatasourceTilesourceDataversionFromFfi(Pointer<Void> handle) {
  final _majorVersionHandle = _sdkMapviewDatasourceTilesourceDataversionGetFieldmajorVersion(handle);
  final _minorVersionHandle = _sdkMapviewDatasourceTilesourceDataversionGetFieldminorVersion(handle);
  try {
    return TileSourceDataVersion(
      (_majorVersionHandle), 
      (_minorVersionHandle)
    );
  } finally {
    
    
  }
}

void sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(Pointer<Void> handle) => _sdkMapviewDatasourceTilesourceDataversionReleaseHandle(handle);

// Nullable TileSourceDataVersion

final _sdkMapviewDatasourceTilesourceDataversionCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_create_handle_nullable'));
final _sdkMapviewDatasourceTilesourceDataversionReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_release_handle_nullable'));
final _sdkMapviewDatasourceTilesourceDataversionGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_DataVersion_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourceTilesourceDataversionToFfiNullable(TileSourceDataVersion? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourceTilesourceDataversionToFfi(value);
  final result = _sdkMapviewDatasourceTilesourceDataversionCreateHandleNullable(_handle);
  sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(_handle);
  return result;
}

TileSourceDataVersion? sdkMapviewDatasourceTilesourceDataversionFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourceTilesourceDataversionGetValueNullable(handle);
  final result = sdkMapviewDatasourceTilesourceDataversionFromFfi(_handle);
  sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceDataversionReleaseHandleNullable(handle);

// End of TileSourceDataVersion "private" section.
/// Tile metadata.

class TileSourceTileMetadata {
  /// Tile data version.
  TileSourceDataVersion dataVersion;

  /// Tile data expiry timestamp, relative to Epoch. Sub-second time-points are not supported.
  DateTime dataExpiryTimestamp;

  /// Creates a new instance.
  /// [dataVersion] Tile data version.
  /// [dataExpiryTimestamp] Tile data expiry timestamp, relative to Epoch. Sub-second time-points are not supported.
  TileSourceTileMetadata(this.dataVersion, this.dataExpiryTimestamp);
}


// TileSourceTileMetadata "private" section, not exported.

final _sdkMapviewDatasourceTilesourceTilemetadataCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Uint64),
    Pointer<Void> Function(Pointer<Void>, int)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_create_handle'));
final _sdkMapviewDatasourceTilesourceTilemetadataReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_release_handle'));
final _sdkMapviewDatasourceTilesourceTilemetadataGetFielddataVersion = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_get_field_dataVersion'));
final _sdkMapviewDatasourceTilesourceTilemetadataGetFielddataExpiryTimestamp = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_get_field_dataExpiryTimestamp'));



Pointer<Void> sdkMapviewDatasourceTilesourceTilemetadataToFfi(TileSourceTileMetadata value) {
  final _dataVersionHandle = sdkMapviewDatasourceTilesourceDataversionToFfi(value.dataVersion);
  final _dataExpiryTimestampHandle = dateToFfi(value.dataExpiryTimestamp);
  final _result = _sdkMapviewDatasourceTilesourceTilemetadataCreateHandle(_dataVersionHandle, _dataExpiryTimestampHandle);
  sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(_dataVersionHandle);
  dateReleaseFfiHandle(_dataExpiryTimestampHandle);
  return _result;
}

TileSourceTileMetadata sdkMapviewDatasourceTilesourceTilemetadataFromFfi(Pointer<Void> handle) {
  final _dataVersionHandle = _sdkMapviewDatasourceTilesourceTilemetadataGetFielddataVersion(handle);
  final _dataExpiryTimestampHandle = _sdkMapviewDatasourceTilesourceTilemetadataGetFielddataExpiryTimestamp(handle);
  try {
    return TileSourceTileMetadata(
      sdkMapviewDatasourceTilesourceDataversionFromFfi(_dataVersionHandle), 
      dateFromFfi(_dataExpiryTimestampHandle)
    );
  } finally {
    sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(_dataVersionHandle);
    dateReleaseFfiHandle(_dataExpiryTimestampHandle);
  }
}

void sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(Pointer<Void> handle) => _sdkMapviewDatasourceTilesourceTilemetadataReleaseHandle(handle);

// Nullable TileSourceTileMetadata

final _sdkMapviewDatasourceTilesourceTilemetadataCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_create_handle_nullable'));
final _sdkMapviewDatasourceTilesourceTilemetadataReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_release_handle_nullable'));
final _sdkMapviewDatasourceTilesourceTilemetadataGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_TileMetadata_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourceTilesourceTilemetadataToFfiNullable(TileSourceTileMetadata? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourceTilesourceTilemetadataToFfi(value);
  final result = _sdkMapviewDatasourceTilesourceTilemetadataCreateHandleNullable(_handle);
  sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(_handle);
  return result;
}

TileSourceTileMetadata? sdkMapviewDatasourceTilesourceTilemetadataFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourceTilesourceTilemetadataGetValueNullable(handle);
  final result = sdkMapviewDatasourceTilesourceTilemetadataFromFfi(_handle);
  sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourceTilesourceTilemetadataReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceTilemetadataReleaseHandleNullable(handle);

// End of TileSourceTileMetadata "private" section.
/// Listener of [TileSource] events.
abstract class TileSourceListener {
  /// Listener of [TileSource] events.

  factory TileSourceListener(
    void Function(TileSourceDataVersion) onDataVersionChangedLambda,

  ) => TileSourceListener$Lambdas(
    onDataVersionChangedLambda,

  );

  /// Called when tile source data version changes.
  ///
  /// [dataVersion] New tile data version.
  ///
  void onDataVersionChanged(TileSourceDataVersion dataVersion);
}


// TileSourceListener "private" section, not exported.

final _sdkMapviewDatasourceTilesourceListenerRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_TileSource_Listener_register_finalizer'));
final _sdkMapviewDatasourceTilesourceListenerCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_Listener_copy_handle'));
final _sdkMapviewDatasourceTilesourceListenerReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_Listener_release_handle'));
final _sdkMapviewDatasourceTilesourceListenerCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_datasource_TileSource_Listener_create_proxy'));
final _sdkMapviewDatasourceTilesourceListenerGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_Listener_get_type_id'));


class TileSourceListener$Lambdas implements TileSourceListener {
  void Function(TileSourceDataVersion) onDataVersionChangedLambda;

  TileSourceListener$Lambdas(
    this.onDataVersionChangedLambda,

  );

  @override
  void onDataVersionChanged(TileSourceDataVersion dataVersion) =>
    onDataVersionChangedLambda(dataVersion);
}

class TileSourceListener$Impl extends __lib.NativeBase implements TileSourceListener {

  TileSourceListener$Impl(Pointer<Void> handle) : super(handle);

  @override
  void onDataVersionChanged(TileSourceDataVersion dataVersion) {
    final _onDataVersionChangedFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_TileSource_Listener_onDataVersionChanged__DataVersion'));
    final _dataVersionHandle = sdkMapviewDatasourceTilesourceDataversionToFfi(dataVersion);
    final _handle = this.handle;
    _onDataVersionChangedFfi(_handle, __lib.LibraryContext.isolateId, _dataVersionHandle);
    sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(_dataVersionHandle);

  }


}

int _sdkMapviewDatasourceTilesourceListeneronDataVersionChangedStatic(Object _obj, Pointer<Void> dataVersion) {

  try {
    (_obj as TileSourceListener).onDataVersionChanged(sdkMapviewDatasourceTilesourceDataversionFromFfi(dataVersion));
  } finally {
    sdkMapviewDatasourceTilesourceDataversionReleaseFfiHandle(dataVersion);
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourceTilesourceListenerToFfi(TileSourceListener value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceTilesourceListenerCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceTilesourceListenerCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceTilesourceListeneronDataVersionChangedStatic, __lib.unknownError)
  );

  return result;
}

TileSourceListener sdkMapviewDatasourceTilesourceListenerFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is TileSourceListener) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceTilesourceListenerGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceTilesourceListenerCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : TileSourceListener$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceTilesourceListenerRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceListenerReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceTilesourceListenerToFfiNullable(TileSourceListener? value) =>
  value != null ? sdkMapviewDatasourceTilesourceListenerToFfi(value) : Pointer<Void>.fromAddress(0);

TileSourceListener? sdkMapviewDatasourceTilesourceListenerFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceTilesourceListenerFromFfi(handle) : null;

void sdkMapviewDatasourceTilesourceListenerReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceListenerReleaseHandle(handle);

// End of TileSourceListener "private" section.
/// Handle of a load request.
abstract class TileSourceLoadTileRequestHandle {
  /// Handle of a load request.

  factory TileSourceLoadTileRequestHandle(
    void Function() cancelLambda,

  ) => TileSourceLoadTileRequestHandle$Lambdas(
    cancelLambda,

  );

  /// Cancels the associated load tile request.
  ///
  /// Upon cancellation, the corresponding result handler must be informed.
  ///
  void cancel();
}


// TileSourceLoadTileRequestHandle "private" section, not exported.

final _sdkMapviewDatasourceTilesourceLoadtilerequesthandleRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_TileSource_LoadTileRequestHandle_register_finalizer'));
final _sdkMapviewDatasourceTilesourceLoadtilerequesthandleCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_LoadTileRequestHandle_copy_handle'));
final _sdkMapviewDatasourceTilesourceLoadtilerequesthandleReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_LoadTileRequestHandle_release_handle'));
final _sdkMapviewDatasourceTilesourceLoadtilerequesthandleCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_datasource_TileSource_LoadTileRequestHandle_create_proxy'));
final _sdkMapviewDatasourceTilesourceLoadtilerequesthandleGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_LoadTileRequestHandle_get_type_id'));


class TileSourceLoadTileRequestHandle$Lambdas implements TileSourceLoadTileRequestHandle {
  void Function() cancelLambda;

  TileSourceLoadTileRequestHandle$Lambdas(
    this.cancelLambda,

  );

  @override
  void cancel() =>
    cancelLambda();
}

class TileSourceLoadTileRequestHandle$Impl extends __lib.NativeBase implements TileSourceLoadTileRequestHandle {

  TileSourceLoadTileRequestHandle$Impl(Pointer<Void> handle) : super(handle);

  @override
  void cancel() {
    final _cancelFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_TileSource_LoadTileRequestHandle_cancel'));
    final _handle = this.handle;
    _cancelFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

int _sdkMapviewDatasourceTilesourceLoadtilerequesthandlecancelStatic(Object _obj) {

  try {
    (_obj as TileSourceLoadTileRequestHandle).cancel();
  } finally {
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfi(TileSourceLoadTileRequestHandle value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceTilesourceLoadtilerequesthandleCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceTilesourceLoadtilerequesthandleCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle)>(_sdkMapviewDatasourceTilesourceLoadtilerequesthandlecancelStatic, __lib.unknownError)
  );

  return result;
}

TileSourceLoadTileRequestHandle sdkMapviewDatasourceTilesourceLoadtilerequesthandleFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is TileSourceLoadTileRequestHandle) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceTilesourceLoadtilerequesthandleGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceTilesourceLoadtilerequesthandleCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : TileSourceLoadTileRequestHandle$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceTilesourceLoadtilerequesthandleRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceTilesourceLoadtilerequesthandleReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceLoadtilerequesthandleReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfiNullable(TileSourceLoadTileRequestHandle? value) =>
  value != null ? sdkMapviewDatasourceTilesourceLoadtilerequesthandleToFfi(value) : Pointer<Void>.fromAddress(0);

TileSourceLoadTileRequestHandle? sdkMapviewDatasourceTilesourceLoadtilerequesthandleFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceTilesourceLoadtilerequesthandleFromFfi(handle) : null;

void sdkMapviewDatasourceTilesourceLoadtilerequesthandleReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceLoadtilerequesthandleReleaseHandle(handle);

// End of TileSourceLoadTileRequestHandle "private" section.

// TileSource "private" section, not exported.

final _sdkMapviewDatasourceTilesourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_TileSource_register_finalizer'));
final _sdkMapviewDatasourceTilesourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_copy_handle'));
final _sdkMapviewDatasourceTilesourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_release_handle'));
final _sdkMapviewDatasourceTilesourceCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_TileSource_create_proxy'));
final _sdkMapviewDatasourceTilesourceGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileSource_get_type_id'));




class TileSource$Lambdas implements TileSource {
  TileSourceDataVersion Function(TileKey) getDataVersionLambda;
  void Function(TileSourceListener) addListenerLambda;
  void Function(TileSourceListener) removeListenerLambda;
  TilingScheme Function() tilingSchemeGetLambda;
  List<int> Function() storageLevelsGetLambda;

  TileSource$Lambdas(
    this.getDataVersionLambda,
    this.addListenerLambda,
    this.removeListenerLambda,
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
  TilingScheme get tilingScheme => tilingSchemeGetLambda();
  @override
  List<int> get storageLevels => storageLevelsGetLambda();
}

class TileSource$Impl extends __lib.NativeBase implements TileSource {

  TileSource$Impl(Pointer<Void> handle) : super(handle);

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

int _sdkMapviewDatasourceTilesourcegetDataVersionStatic(Object _obj, Pointer<Void> tileKey, Pointer<Pointer<Void>> _result) {
  TileSourceDataVersion? _resultObject;
  try {
    _resultObject = (_obj as TileSource).getDataVersion(sdkMapviewDatasourceTilekeyFromFfi(tileKey));
    _result.value = sdkMapviewDatasourceTilesourceDataversionToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourceTilekeyReleaseFfiHandle(tileKey);
  }
  return 0;
}
int _sdkMapviewDatasourceTilesourceaddListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as TileSource).addListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}
int _sdkMapviewDatasourceTilesourceremoveListenerStatic(Object _obj, Pointer<Void> listener) {

  try {
    (_obj as TileSource).removeListener(sdkMapviewDatasourceTilesourceListenerFromFfi(listener));
  } finally {
    sdkMapviewDatasourceTilesourceListenerReleaseFfiHandle(listener);
  }
  return 0;
}

int _sdkMapviewDatasourceTilesourcetilingSchemeGetStatic(Object _obj, Pointer<Uint32> _result) {
  _result.value = sdkMapviewDatasourceTilingschemeToFfi((_obj as TileSource).tilingScheme);
  return 0;
}
int _sdkMapviewDatasourceTilesourcestorageLevelsGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = harpSdkBindingslistofIntToFfi((_obj as TileSource).storageLevels);
  return 0;
}

Pointer<Void> sdkMapviewDatasourceTilesourceToFfi(TileSource value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceTilesourceCopyHandle((value as __lib.NativeBase).handle);

  final descendantResult = tryDescendantToFfi(value);
  if (descendantResult != null) {
    return descendantResult;
  }

  final result = _sdkMapviewDatasourceTilesourceCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceTilesourcegetDataVersionStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceTilesourceaddListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewDatasourceTilesourceremoveListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Uint32>)>(_sdkMapviewDatasourceTilesourcetilingSchemeGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceTilesourcestorageLevelsGetStatic, __lib.unknownError)
  );

  return result;
}

TileSource sdkMapviewDatasourceTilesourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is TileSource) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceTilesourceGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceTilesourceCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : TileSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceTilesourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceTilesourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceTilesourceToFfiNullable(TileSource? value) =>
  value != null ? sdkMapviewDatasourceTilesourceToFfi(value) : Pointer<Void>.fromAddress(0);

TileSource? sdkMapviewDatasourceTilesourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceTilesourceFromFfi(handle) : null;

void sdkMapviewDatasourceTilesourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilesourceReleaseHandle(handle);

Pointer<Void>? tryDescendantToFfi(TileSource value) {
  if (value is LineTileSource) return sdkMapviewDatasourceLinetilesourceToFfi(value);
  if (value is PointTileSource) return sdkMapviewDatasourcePointtilesourceToFfi(value);
  if (value is PolygonTileSource) return sdkMapviewDatasourcePolygontilesourceToFfi(value);
  return null;
}

// End of TileSource "private" section.


