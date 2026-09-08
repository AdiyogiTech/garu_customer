// Copyright (c) 2018-2024 HERE Global B.V. and its affiliate(s).
// All rights reserved.
//
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
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/mapview/map_object_descriptor.dart';
import 'package:here_sdk/src/sdk/mapview/pick_map_content_result.dart';
import 'package:here_sdk/src/sdk/mapview/pick_map_items_result.dart';

/// A class representing a map pick result.
abstract class MapPickResult {

  /// Picked map items result.
  /// Gets a picked map items result.
  PickMapItemsResult? get mapItems;

  /// Picked map content result.
  /// Gets a picked map content result.
  PickMapContentResult? get mapContent;

  /// List of map object descriptors representing picked objects from custom user data layers.
  /// Gets a list of map object descriptors representing picked objects from custom user data layers.
  List<MapObjectDescriptor>? get customLayerObjectDescriptors;

}


// MapPickResult "private" section, not exported.

final _sdkMapviewMappickresultRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapPickResult_register_finalizer'));
final _sdkMapviewMappickresultCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapPickResult_copy_handle'));
final _sdkMapviewMappickresultReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapPickResult_release_handle'));


class MapPickResult$Impl extends __lib.NativeBase implements MapPickResult {

  MapPickResult$Impl(Pointer<Void> handle) : super(handle);

  @override
  PickMapItemsResult? get mapItems {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapPickResult_mapItems_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewPickmapitemsresultFromFfiNullable(__resultHandle);
    } finally {
      sdkMapviewPickmapitemsresultReleaseFfiHandleNullable(__resultHandle);

    }

  }


  @override
  PickMapContentResult? get mapContent {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapPickResult_mapContent_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewPickmapcontentresultFromFfiNullable(__resultHandle);
    } finally {
      sdkMapviewPickmapcontentresultReleaseFfiHandleNullable(__resultHandle);

    }

  }


  @override
  List<MapObjectDescriptor>? get customLayerObjectDescriptors {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapPickResult_customLayerObjectDescriptors_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return heresdkMapviewHarpBindingslistofSdkMapviewMapobjectdescriptorFromFfiNullable(__resultHandle);
    } finally {
      heresdkMapviewHarpBindingslistofSdkMapviewMapobjectdescriptorReleaseFfiHandleNullable(__resultHandle);

    }

  }



}

Pointer<Void> sdkMapviewMappickresultToFfi(MapPickResult value) =>
  _sdkMapviewMappickresultCopyHandle((value as __lib.NativeBase).handle);

MapPickResult sdkMapviewMappickresultFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapPickResult) return instance;

  final _copiedHandle = _sdkMapviewMappickresultCopyHandle(handle);
  final result = MapPickResult$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMappickresultRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMappickresultReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMappickresultReleaseHandle(handle);

Pointer<Void> sdkMapviewMappickresultToFfiNullable(MapPickResult? value) =>
  value != null ? sdkMapviewMappickresultToFfi(value) : Pointer<Void>.fromAddress(0);

MapPickResult? sdkMapviewMappickresultFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMappickresultFromFfi(handle) : null;

void sdkMapviewMappickresultReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMappickresultReleaseHandle(handle);

// End of MapPickResult "private" section.


