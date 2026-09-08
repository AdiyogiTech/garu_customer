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
import 'package:here_sdk/src/builtin_types__conversion.dart';

/// Defines the settings for the retry logic when connecting to the HERE routing backend.
///
/// When a timeout is triggered,
/// the next connection attempt starts with a increased timeout.
/// new_timeout = initial_timeout + increment * retry_count

class RoutingConnectionSettings {
  /// Defines the initial time out for connection to the backend.
  /// By default, the initial connection timeout is 5 seconds.
  Duration initialConnectionTimeout;

  /// Defines the increase of the timeout for the transfer of data.
  /// By default, the initial connection increment per timeout 10 seconds.
  Duration connectionTimeoutRetryIncrease;

  /// Defines the initial time out for data transfer from the backend.
  /// By default, the initial transfer timeout is 10 seconds.
  Duration initialTransferTimeout;

  /// Defines the increase of the timeout for the connection.
  /// By default, the initial transfer increment per timeout is 2 seconds.
  Duration transferTimeoutRetryIncrease;

  /// Defines the max amount of retries before the route request failes with connection related error codes.
  /// By default, the max amount of retries is 3.
  int maxRetryCount;

  /// Creates a new instance.

  /// [initialConnectionTimeout] Defines the initial time out for connection to the backend.
  /// By default, the initial connection timeout is 5 seconds.

  /// [connectionTimeoutRetryIncrease] Defines the increase of the timeout for the transfer of data.
  /// By default, the initial connection increment per timeout 10 seconds.

  /// [initialTransferTimeout] Defines the initial time out for data transfer from the backend.
  /// By default, the initial transfer timeout is 10 seconds.

  /// [transferTimeoutRetryIncrease] Defines the increase of the timeout for the connection.
  /// By default, the initial transfer increment per timeout is 2 seconds.

  /// [maxRetryCount] Defines the max amount of retries before the route request failes with connection related error codes.
  /// By default, the max amount of retries is 3.

  RoutingConnectionSettings._(this.initialConnectionTimeout, this.connectionTimeoutRetryIncrease, this.initialTransferTimeout, this.transferTimeoutRetryIncrease, this.maxRetryCount);
  RoutingConnectionSettings()
    : initialConnectionTimeout = const Duration(seconds: 5), connectionTimeoutRetryIncrease = const Duration(seconds: 10), initialTransferTimeout = const Duration(seconds: 10), transferTimeoutRetryIncrease = const Duration(seconds: 2), maxRetryCount = 3;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoutingConnectionSettings) return false;
    RoutingConnectionSettings _other = other;
    return initialConnectionTimeout == _other.initialConnectionTimeout &&
        connectionTimeoutRetryIncrease == _other.connectionTimeoutRetryIncrease &&
        initialTransferTimeout == _other.initialTransferTimeout &&
        transferTimeoutRetryIncrease == _other.transferTimeoutRetryIncrease &&
        maxRetryCount == _other.maxRetryCount;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + initialConnectionTimeout.hashCode;
    result = 31 * result + connectionTimeoutRetryIncrease.hashCode;
    result = 31 * result + initialTransferTimeout.hashCode;
    result = 31 * result + transferTimeoutRetryIncrease.hashCode;
    result = 31 * result + maxRetryCount.hashCode;
    return result;
  }
}


// RoutingConnectionSettings "private" section, not exported.

final _sdkRoutingRoutingconnectionsettingsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Uint64, Uint64, Uint64, Int32),
    Pointer<Void> Function(int, int, int, int, int)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_create_handle'));
final _sdkRoutingRoutingconnectionsettingsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_release_handle'));
final _sdkRoutingRoutingconnectionsettingsGetFieldinitialConnectionTimeout = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_get_field_initialConnectionTimeout'));
final _sdkRoutingRoutingconnectionsettingsGetFieldconnectionTimeoutRetryIncrease = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_get_field_connectionTimeoutRetryIncrease'));
final _sdkRoutingRoutingconnectionsettingsGetFieldinitialTransferTimeout = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_get_field_initialTransferTimeout'));
final _sdkRoutingRoutingconnectionsettingsGetFieldtransferTimeoutRetryIncrease = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_get_field_transferTimeoutRetryIncrease'));
final _sdkRoutingRoutingconnectionsettingsGetFieldmaxRetryCount = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_get_field_maxRetryCount'));



Pointer<Void> sdkRoutingRoutingconnectionsettingsToFfi(RoutingConnectionSettings value) {
  final _initialConnectionTimeoutHandle = durationToFfi(value.initialConnectionTimeout);
  final _connectionTimeoutRetryIncreaseHandle = durationToFfi(value.connectionTimeoutRetryIncrease);
  final _initialTransferTimeoutHandle = durationToFfi(value.initialTransferTimeout);
  final _transferTimeoutRetryIncreaseHandle = durationToFfi(value.transferTimeoutRetryIncrease);
  final _maxRetryCountHandle = (value.maxRetryCount);
  final _result = _sdkRoutingRoutingconnectionsettingsCreateHandle(_initialConnectionTimeoutHandle, _connectionTimeoutRetryIncreaseHandle, _initialTransferTimeoutHandle, _transferTimeoutRetryIncreaseHandle, _maxRetryCountHandle);
  durationReleaseFfiHandle(_initialConnectionTimeoutHandle);
  durationReleaseFfiHandle(_connectionTimeoutRetryIncreaseHandle);
  durationReleaseFfiHandle(_initialTransferTimeoutHandle);
  durationReleaseFfiHandle(_transferTimeoutRetryIncreaseHandle);
  
  return _result;
}

RoutingConnectionSettings sdkRoutingRoutingconnectionsettingsFromFfi(Pointer<Void> handle) {
  final _initialConnectionTimeoutHandle = _sdkRoutingRoutingconnectionsettingsGetFieldinitialConnectionTimeout(handle);
  final _connectionTimeoutRetryIncreaseHandle = _sdkRoutingRoutingconnectionsettingsGetFieldconnectionTimeoutRetryIncrease(handle);
  final _initialTransferTimeoutHandle = _sdkRoutingRoutingconnectionsettingsGetFieldinitialTransferTimeout(handle);
  final _transferTimeoutRetryIncreaseHandle = _sdkRoutingRoutingconnectionsettingsGetFieldtransferTimeoutRetryIncrease(handle);
  final _maxRetryCountHandle = _sdkRoutingRoutingconnectionsettingsGetFieldmaxRetryCount(handle);
  try {
    return RoutingConnectionSettings._(
      durationFromFfi(_initialConnectionTimeoutHandle), 
      durationFromFfi(_connectionTimeoutRetryIncreaseHandle), 
      durationFromFfi(_initialTransferTimeoutHandle), 
      durationFromFfi(_transferTimeoutRetryIncreaseHandle), 
      (_maxRetryCountHandle)
    );
  } finally {
    durationReleaseFfiHandle(_initialConnectionTimeoutHandle);
    durationReleaseFfiHandle(_connectionTimeoutRetryIncreaseHandle);
    durationReleaseFfiHandle(_initialTransferTimeoutHandle);
    durationReleaseFfiHandle(_transferTimeoutRetryIncreaseHandle);
    
  }
}

void sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingRoutingconnectionsettingsReleaseHandle(handle);

// Nullable RoutingConnectionSettings

final _sdkRoutingRoutingconnectionsettingsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_create_handle_nullable'));
final _sdkRoutingRoutingconnectionsettingsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_release_handle_nullable'));
final _sdkRoutingRoutingconnectionsettingsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingConnectionSettings_get_value_nullable'));

Pointer<Void> sdkRoutingRoutingconnectionsettingsToFfiNullable(RoutingConnectionSettings? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingRoutingconnectionsettingsToFfi(value);
  final result = _sdkRoutingRoutingconnectionsettingsCreateHandleNullable(_handle);
  sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(_handle);
  return result;
}

RoutingConnectionSettings? sdkRoutingRoutingconnectionsettingsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingRoutingconnectionsettingsGetValueNullable(handle);
  final result = sdkRoutingRoutingconnectionsettingsFromFfi(_handle);
  sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingRoutingconnectionsettingsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingRoutingconnectionsettingsReleaseHandleNullable(handle);

// End of RoutingConnectionSettings "private" section.


