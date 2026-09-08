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

/// The options explicitly allowed by user for route calculations.

class AllowOptions {
  /// A flag that specifies whether HOV lanes can be used in the route calculation.
  ///
  /// A HOV (High occupancy Vehicle) lane or carpool lane is reserved for carpool usage. Carpool lane requires
  /// a minimum number of passengers in order for the car to use the carpool lane.
  ///
  /// **Note:** Can be used with [CarOptions.occupantsNumber] or similar to specify the number of occupants in the vehicle
  bool allowHov;

  /// A flag that specifies whether specifies whether HOT lanes can be used in the calculation.
  ///
  /// HOT (high-occupancy toll) lanes are HOV lanes where vehicles that do not qualify as high-occupancy are allowed to pass by paying a toll.
  ///
  /// **Note:** Can be used with [CarOptions.occupantsNumber] or similar to specify the number of occupants in the vehicle
  bool allowHot;

  /// Creates a new instance.

  /// [allowHov] A flag that specifies whether HOV lanes can be used in the route calculation.
  ///
  /// A HOV (High occupancy Vehicle) lane or carpool lane is reserved for carpool usage. Carpool lane requires
  /// a minimum number of passengers in order for the car to use the carpool lane.
  ///
  /// **Note:** Can be used with [CarOptions.occupantsNumber] or similar to specify the number of occupants in the vehicle

  /// [allowHot] A flag that specifies whether specifies whether HOT lanes can be used in the calculation.
  ///
  /// HOT (high-occupancy toll) lanes are HOV lanes where vehicles that do not qualify as high-occupancy are allowed to pass by paying a toll.
  ///
  /// **Note:** Can be used with [CarOptions.occupantsNumber] or similar to specify the number of occupants in the vehicle

  AllowOptions._(this.allowHov, this.allowHot);
  AllowOptions()
    : allowHov = false, allowHot = false;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AllowOptions) return false;
    AllowOptions _other = other;
    return allowHov == _other.allowHov &&
        allowHot == _other.allowHot;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + allowHov.hashCode;
    result = 31 * result + allowHot.hashCode;
    return result;
  }
}


// AllowOptions "private" section, not exported.

final _sdkRoutingAllowoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint8, Uint8),
    Pointer<Void> Function(int, int)
  >('here_sdk_sdk_routing_AllowOptions_create_handle'));
final _sdkRoutingAllowoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AllowOptions_release_handle'));
final _sdkRoutingAllowoptionsGetFieldallowHov = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AllowOptions_get_field_allowHov'));
final _sdkRoutingAllowoptionsGetFieldallowHot = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AllowOptions_get_field_allowHot'));



Pointer<Void> sdkRoutingAllowoptionsToFfi(AllowOptions value) {
  final _allowHovHandle = booleanToFfi(value.allowHov);
  final _allowHotHandle = booleanToFfi(value.allowHot);
  final _result = _sdkRoutingAllowoptionsCreateHandle(_allowHovHandle, _allowHotHandle);
  booleanReleaseFfiHandle(_allowHovHandle);
  booleanReleaseFfiHandle(_allowHotHandle);
  return _result;
}

AllowOptions sdkRoutingAllowoptionsFromFfi(Pointer<Void> handle) {
  final _allowHovHandle = _sdkRoutingAllowoptionsGetFieldallowHov(handle);
  final _allowHotHandle = _sdkRoutingAllowoptionsGetFieldallowHot(handle);
  try {
    return AllowOptions._(
      booleanFromFfi(_allowHovHandle), 
      booleanFromFfi(_allowHotHandle)
    );
  } finally {
    booleanReleaseFfiHandle(_allowHovHandle);
    booleanReleaseFfiHandle(_allowHotHandle);
  }
}

void sdkRoutingAllowoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingAllowoptionsReleaseHandle(handle);

// Nullable AllowOptions

final _sdkRoutingAllowoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AllowOptions_create_handle_nullable'));
final _sdkRoutingAllowoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AllowOptions_release_handle_nullable'));
final _sdkRoutingAllowoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_AllowOptions_get_value_nullable'));

Pointer<Void> sdkRoutingAllowoptionsToFfiNullable(AllowOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingAllowoptionsToFfi(value);
  final result = _sdkRoutingAllowoptionsCreateHandleNullable(_handle);
  sdkRoutingAllowoptionsReleaseFfiHandle(_handle);
  return result;
}

AllowOptions? sdkRoutingAllowoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingAllowoptionsGetValueNullable(handle);
  final result = sdkRoutingAllowoptionsFromFfi(_handle);
  sdkRoutingAllowoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingAllowoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingAllowoptionsReleaseHandleNullable(handle);

// End of AllowOptions "private" section.


