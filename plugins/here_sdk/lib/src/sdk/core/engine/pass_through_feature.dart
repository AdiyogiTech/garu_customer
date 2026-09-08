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

/// Represents features that are allowed to consume online data when the HERE SDK's offline mode
/// is activated via [SDKNativeEngine.isOfflineMode] and/or
/// [SDKOptions.offlineMode].
///
/// Note: This is a beta release of this feature,
/// so there could be a few bugs and unexpected behaviors.
/// Related APIs may change for new releases without a deprecation process.
enum PassThroughFeature {
    /// When set, then the `TrafficEngine` is not blocked from initiating online connections to search for
    /// traffic data such as incidents.
    trafficData,
    /// When set, then the corresponding `MapFeature` will not be blocked and online connections can be
    /// initiated by the HERE SDK to retrieve traffic flow data.
    trafficTilesFlow,
    /// When set, then the corresponding `MapFeature` will not be blocked and online connections can be
    /// initiated by the HERE SDK to retrieve traffic incident data.
    trafficTilesIncidents,
    /// When set, online routing can be performed by the HERE SDK, allowing the retrieval of up-to-date
    /// routing information from online services even when offline mode is enabled.
    onlineRouting
}

// PassThroughFeature "private" section, not exported.

int sdkCoreEnginePassthroughfeatureToFfi(PassThroughFeature value) {
  switch (value) {
  case PassThroughFeature.trafficData:
    return 0;
  case PassThroughFeature.trafficTilesFlow:
    return 1;
  case PassThroughFeature.trafficTilesIncidents:
    return 2;
  case PassThroughFeature.onlineRouting:
    return 3;
  default:
    throw StateError("Invalid enum value $value for PassThroughFeature enum.");
  }
}

PassThroughFeature sdkCoreEnginePassthroughfeatureFromFfi(int handle) {
  switch (handle) {
  case 0:
    return PassThroughFeature.trafficData;
  case 1:
    return PassThroughFeature.trafficTilesFlow;
  case 2:
    return PassThroughFeature.trafficTilesIncidents;
  case 3:
    return PassThroughFeature.onlineRouting;
  default:
    throw StateError("Invalid numeric value $handle for PassThroughFeature enum.");
  }
}

void sdkCoreEnginePassthroughfeatureReleaseFfiHandle(int handle) {}

final _sdkCoreEnginePassthroughfeatureCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_core_engine_PassThroughFeature_create_handle_nullable'));
final _sdkCoreEnginePassthroughfeatureReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_PassThroughFeature_release_handle_nullable'));
final _sdkCoreEnginePassthroughfeatureGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_PassThroughFeature_get_value_nullable'));

Pointer<Void> sdkCoreEnginePassthroughfeatureToFfiNullable(PassThroughFeature? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkCoreEnginePassthroughfeatureToFfi(value);
  final result = _sdkCoreEnginePassthroughfeatureCreateHandleNullable(_handle);
  sdkCoreEnginePassthroughfeatureReleaseFfiHandle(_handle);
  return result;
}

PassThroughFeature? sdkCoreEnginePassthroughfeatureFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkCoreEnginePassthroughfeatureGetValueNullable(handle);
  final result = sdkCoreEnginePassthroughfeatureFromFfi(_handle);
  sdkCoreEnginePassthroughfeatureReleaseFfiHandle(_handle);
  return result;
}

void sdkCoreEnginePassthroughfeatureReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreEnginePassthroughfeatureReleaseHandleNullable(handle);

// End of PassThroughFeature "private" section.


