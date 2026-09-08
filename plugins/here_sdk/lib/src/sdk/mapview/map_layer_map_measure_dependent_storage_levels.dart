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
import 'package:meta/meta.dart';

/// Provides a mapping between a MapLayer map measure to datasource storage level.
abstract class MapLayerMapMeasureDependentStorageLevels {
  /// Constructs a mapping in which the offset value is added (or subtracted if value is
  /// negative) to the storage level which would be applied by default.
  ///
  /// In the default mapping the
  /// storage level is generally one below the zoom level. When the map camera is significantly
  /// tilted then the storage level is reduced further.
  /// The value will be clamped to a range of -3 to 3. Setting an offset of zero will have no
  /// effect.
  ///
  /// [storageLevelOffset] The offset value which is added (or subtracted if value is negative) to the storage level
  /// that would be applied by default. The value will be clamped to a range of -3 to 3.
  ///
  @Deprecated("Will be removed in v4.22.0. Use [MapLayerMapMeasureDependentStorageLevels.withStorageLevelOffset] to\ncreate [MapLayerMapMeasureDependentStorageLevels] instance instead.")

  factory MapLayerMapMeasureDependentStorageLevels(int storageLevelOffset) => $prototype.make(storageLevelOffset);

  /// Creates an instance of [MapLayerMapMeasureDependentStorageLevels] with the specified storage level offset.
  ///
  /// This creates a map where the storage level is determined by applying an "offset" to the zoom level.
  /// A negative offset results in a storage level lower than the zoom level, while a positive offset increases it.
  /// For example, with an offset of 0, the storage level matches the zoom level directly.
  /// An offset of -1 makes the storage level one less than the zoom level, and so on.
  /// The offset value is clamped to the range of -3 to 3.
  /// Note: The generated mapping adjusts so that when the map camera is significantly tilted,
  /// the storage level is further reduced for data near the horizon.
  ///
  /// [offset] Defines an offset of storage level from the zoom level.
  /// The value will be clamped to a range of -3 to 3.
  ///
  /// Returns [MapLayerMapMeasureDependentStorageLevels]. MapLayerMapMeasureDependentStorageLevels instance.
  ///
  static MapLayerMapMeasureDependentStorageLevels withStorageLevelOffset(int offset) => $prototype.withStorageLevelOffset(offset);

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = MapLayerMapMeasureDependentStorageLevels$Impl(Pointer<Void>.fromAddress(0));
}


// MapLayerMapMeasureDependentStorageLevels "private" section, not exported.

final _sdkMapviewMaplayermapmeasuredependentstoragelevelsRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapLayerMapMeasureDependentStorageLevels_register_finalizer'));
final _sdkMapviewMaplayermapmeasuredependentstoragelevelsCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapLayerMapMeasureDependentStorageLevels_copy_handle'));
final _sdkMapviewMaplayermapmeasuredependentstoragelevelsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapLayerMapMeasureDependentStorageLevels_release_handle'));




/// @nodoc
@visibleForTesting
class MapLayerMapMeasureDependentStorageLevels$Impl extends __lib.NativeBase implements MapLayerMapMeasureDependentStorageLevels {

  MapLayerMapMeasureDependentStorageLevels$Impl(Pointer<Void> handle) : super(handle);


  MapLayerMapMeasureDependentStorageLevels make(int storageLevelOffset) {
    final _result_handle = _make(storageLevelOffset);
    final _result = MapLayerMapMeasureDependentStorageLevels$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewMaplayermapmeasuredependentstoragelevelsRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _make(int storageLevelOffset) {
    final _makeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Int32), Pointer<Void> Function(int, int)>('here_sdk_sdk_mapview_MapLayerMapMeasureDependentStorageLevels_make__Int'));
    final _storageLevelOffsetHandle = (storageLevelOffset);
    final __resultHandle = _makeFfi(__lib.LibraryContext.isolateId, _storageLevelOffsetHandle);

    return __resultHandle;
  }

  MapLayerMapMeasureDependentStorageLevels withStorageLevelOffset(int offset) {
    final _withStorageLevelOffsetFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Int32), Pointer<Void> Function(int, int)>('here_sdk_sdk_mapview_MapLayerMapMeasureDependentStorageLevels_withStorageLevelOffset__Int'));
    final _offsetHandle = (offset);
    final __resultHandle = _withStorageLevelOffsetFfi(__lib.LibraryContext.isolateId, _offsetHandle);

    try {
      return sdkMapviewMaplayermapmeasuredependentstoragelevelsFromFfi(__resultHandle);
    } finally {
      sdkMapviewMaplayermapmeasuredependentstoragelevelsReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewMaplayermapmeasuredependentstoragelevelsToFfi(MapLayerMapMeasureDependentStorageLevels value) =>
  _sdkMapviewMaplayermapmeasuredependentstoragelevelsCopyHandle((value as __lib.NativeBase).handle);

MapLayerMapMeasureDependentStorageLevels sdkMapviewMaplayermapmeasuredependentstoragelevelsFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapLayerMapMeasureDependentStorageLevels) return instance;

  final _copiedHandle = _sdkMapviewMaplayermapmeasuredependentstoragelevelsCopyHandle(handle);
  final result = MapLayerMapMeasureDependentStorageLevels$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMaplayermapmeasuredependentstoragelevelsRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMaplayermapmeasuredependentstoragelevelsReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMaplayermapmeasuredependentstoragelevelsReleaseHandle(handle);

Pointer<Void> sdkMapviewMaplayermapmeasuredependentstoragelevelsToFfiNullable(MapLayerMapMeasureDependentStorageLevels? value) =>
  value != null ? sdkMapviewMaplayermapmeasuredependentstoragelevelsToFfi(value) : Pointer<Void>.fromAddress(0);

MapLayerMapMeasureDependentStorageLevels? sdkMapviewMaplayermapmeasuredependentstoragelevelsFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMaplayermapmeasuredependentstoragelevelsFromFfi(handle) : null;

void sdkMapviewMaplayermapmeasuredependentstoragelevelsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMaplayermapmeasuredependentstoragelevelsReleaseHandle(handle);

// End of MapLayerMapMeasureDependentStorageLevels "private" section.


