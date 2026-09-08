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

/// EVSE status
enum EVSEStatus {
    /// The EVSE is able to start a new charging session.
    available,
    /// The EVSE is in use.
    occupied,
    /// No status information available. Also used when offline.
    offline,
    /// No status information available. Also used when offline.
    other,
    /// The EVSE is currently out of order.
    outOfService,
    /// The EVSE has been reserved for a particular EV driver and is unavailable for other drivers.
    reserved,
    /// The EVSE is not available because of a physical barrier, for example a car.
    unavailable
}

// EVSEStatus "private" section, not exported.

int sdkSearchEvsestatusToFfi(EVSEStatus value) {
  switch (value) {
  case EVSEStatus.available:
    return 0;
  case EVSEStatus.occupied:
    return 1;
  case EVSEStatus.offline:
    return 2;
  case EVSEStatus.other:
    return 3;
  case EVSEStatus.outOfService:
    return 4;
  case EVSEStatus.reserved:
    return 5;
  case EVSEStatus.unavailable:
    return 6;
  default:
    throw StateError("Invalid enum value $value for EVSEStatus enum.");
  }
}

EVSEStatus sdkSearchEvsestatusFromFfi(int handle) {
  switch (handle) {
  case 0:
    return EVSEStatus.available;
  case 1:
    return EVSEStatus.occupied;
  case 2:
    return EVSEStatus.offline;
  case 3:
    return EVSEStatus.other;
  case 4:
    return EVSEStatus.outOfService;
  case 5:
    return EVSEStatus.reserved;
  case 6:
    return EVSEStatus.unavailable;
  default:
    throw StateError("Invalid numeric value $handle for EVSEStatus enum.");
  }
}

void sdkSearchEvsestatusReleaseFfiHandle(int handle) {}

final _sdkSearchEvsestatusCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_search_EVSEStatus_create_handle_nullable'));
final _sdkSearchEvsestatusReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEStatus_release_handle_nullable'));
final _sdkSearchEvsestatusGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEStatus_get_value_nullable'));

Pointer<Void> sdkSearchEvsestatusToFfiNullable(EVSEStatus? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkSearchEvsestatusToFfi(value);
  final result = _sdkSearchEvsestatusCreateHandleNullable(_handle);
  sdkSearchEvsestatusReleaseFfiHandle(_handle);
  return result;
}

EVSEStatus? sdkSearchEvsestatusFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkSearchEvsestatusGetValueNullable(handle);
  final result = sdkSearchEvsestatusFromFfi(_handle);
  sdkSearchEvsestatusReleaseFfiHandle(_handle);
  return result;
}

void sdkSearchEvsestatusReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkSearchEvsestatusReleaseHandleNullable(handle);

// End of EVSEStatus "private" section.


