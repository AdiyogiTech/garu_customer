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
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/sdk/routing/routing_error.dart';
import 'package:here_sdk/src/sdk/routing/traffic_on_route.dart';

/// A function which is called by the RoutingEngine after route traffic calculation has completed.
///
/// It is always called on the main thread.
/// The first argument is the error in case of a failure. It is `null` for an operation that succeeds.
/// The second argument is the calculated route traffic. It is `null` in case of an error.
///
/// [p0] The error in case of a failure. It is `null` for an operation that succeeds.
///
/// [p1] The calculated route traffic. It is `null` in case of an error.
typedef CalculateTrafficOnRouteCallback = void Function(RoutingError?, TrafficOnRoute?);

// CalculateTrafficOnRouteCallback "private" section, not exported.

final _sdkRoutingCalculatetrafficonroutecallbackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_register_finalizer'));
final _sdkRoutingCalculatetrafficonroutecallbackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_copy_handle'));
final _sdkRoutingCalculatetrafficonroutecallbackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_release_handle'));
final _sdkRoutingCalculatetrafficonroutecallbackCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_create_proxy'));

class CalculateTrafficOnRouteCallback$Impl {
  final Pointer<Void> handle;
  CalculateTrafficOnRouteCallback$Impl(this.handle);

  void call(RoutingError? p0, TrafficOnRoute? p1) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_call__RoutingError__TrafficOnRoute_'));
    final _p0Handle = sdkRoutingRoutingerrorToFfiNullable(p0);
    final _p1Handle = sdkRoutingTrafficonrouteToFfiNullable(p1);
    final _handle = this.handle;
    _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle, _p1Handle);
    sdkRoutingRoutingerrorReleaseFfiHandleNullable(_p0Handle);
    sdkRoutingTrafficonrouteReleaseFfiHandleNullable(_p1Handle);

  }

}

int _sdkRoutingCalculatetrafficonroutecallbackcallStatic(Object _obj, Pointer<Void> p0, Pointer<Void> p1) {
  
  try {
    (_obj as CalculateTrafficOnRouteCallback)(sdkRoutingRoutingerrorFromFfiNullable(p0), sdkRoutingTrafficonrouteFromFfiNullable(p1));
  } finally {
    sdkRoutingRoutingerrorReleaseFfiHandleNullable(p0);
    sdkRoutingTrafficonrouteReleaseFfiHandleNullable(p1);
  }
  return 0;
}

Pointer<Void> sdkRoutingCalculatetrafficonroutecallbackToFfi(CalculateTrafficOnRouteCallback value) =>
  _sdkRoutingCalculatetrafficonroutecallbackCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>, Pointer<Void>)>(_sdkRoutingCalculatetrafficonroutecallbackcallStatic, __lib.unknownError)
  );

CalculateTrafficOnRouteCallback sdkRoutingCalculatetrafficonroutecallbackFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkRoutingCalculatetrafficonroutecallbackCopyHandle(handle);
  final _impl = CalculateTrafficOnRouteCallback$Impl(_copiedHandle);
  final result = (RoutingError? p0, TrafficOnRoute? p1) => _impl.call(p0, p1);
  _sdkRoutingCalculatetrafficonroutecallbackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkRoutingCalculatetrafficonroutecallbackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkRoutingCalculatetrafficonroutecallbackReleaseHandle(handle);

// Nullable CalculateTrafficOnRouteCallback

final _sdkRoutingCalculatetrafficonroutecallbackCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_create_handle_nullable'));
final _sdkRoutingCalculatetrafficonroutecallbackReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_release_handle_nullable'));
final _sdkRoutingCalculatetrafficonroutecallbackGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_CalculateTrafficOnRouteCallback_get_value_nullable'));

Pointer<Void> sdkRoutingCalculatetrafficonroutecallbackToFfiNullable(CalculateTrafficOnRouteCallback? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingCalculatetrafficonroutecallbackToFfi(value);
  final result = _sdkRoutingCalculatetrafficonroutecallbackCreateHandleNullable(_handle);
  sdkRoutingCalculatetrafficonroutecallbackReleaseFfiHandle(_handle);
  return result;
}

CalculateTrafficOnRouteCallback? sdkRoutingCalculatetrafficonroutecallbackFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingCalculatetrafficonroutecallbackGetValueNullable(handle);
  final result = sdkRoutingCalculatetrafficonroutecallbackFromFfi(_handle);
  sdkRoutingCalculatetrafficonroutecallbackReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingCalculatetrafficonroutecallbackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingCalculatetrafficonroutecallbackReleaseHandleNullable(handle);

// End of CalculateTrafficOnRouteCallback "private" section.


