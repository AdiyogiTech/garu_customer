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

/// Asset types for loading icons.
enum IconProviderAssetType {
    /// Asset with UI optimized icons.
    ui,
    /// Asset with Map optimized icons.
    map
}

// IconProviderAssetType "private" section, not exported.

int sdkMapviewIconproviderassettypeToFfi(IconProviderAssetType value) {
  switch (value) {
  case IconProviderAssetType.ui:
    return 0;
  case IconProviderAssetType.map:
    return 1;
  default:
    throw StateError("Invalid enum value $value for IconProviderAssetType enum.");
  }
}

IconProviderAssetType sdkMapviewIconproviderassettypeFromFfi(int handle) {
  switch (handle) {
  case 0:
    return IconProviderAssetType.ui;
  case 1:
    return IconProviderAssetType.map;
  default:
    throw StateError("Invalid numeric value $handle for IconProviderAssetType enum.");
  }
}

void sdkMapviewIconproviderassettypeReleaseFfiHandle(int handle) {}

final _sdkMapviewIconproviderassettypeCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_IconProviderAssetType_create_handle_nullable'));
final _sdkMapviewIconproviderassettypeReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderAssetType_release_handle_nullable'));
final _sdkMapviewIconproviderassettypeGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderAssetType_get_value_nullable'));

Pointer<Void> sdkMapviewIconproviderassettypeToFfiNullable(IconProviderAssetType? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewIconproviderassettypeToFfi(value);
  final result = _sdkMapviewIconproviderassettypeCreateHandleNullable(_handle);
  sdkMapviewIconproviderassettypeReleaseFfiHandle(_handle);
  return result;
}

IconProviderAssetType? sdkMapviewIconproviderassettypeFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewIconproviderassettypeGetValueNullable(handle);
  final result = sdkMapviewIconproviderassettypeFromFfi(_handle);
  sdkMapviewIconproviderassettypeReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewIconproviderassettypeReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewIconproviderassettypeReleaseHandleNullable(handle);

// End of IconProviderAssetType "private" section.


