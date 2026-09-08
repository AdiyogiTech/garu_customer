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

/// Car specifications contain vehicle related attributes.
///
/// Examples: Dimensions, weight, axle count.
/// Only the fields that are set are considered for restriction handling.

class CarSpecifications {
  /// Car weight including trailers and shipped goods in kilograms. The provided value
  /// must be greater than or equal to 0. By default, it is not set.
  /// **Note:**
  /// This parameter is limited to a maximum weight of 4250 kgs.
  int? grossWeightInKilograms;

  /// Car height in centimeters. The provided value must be in the range \[0, 5000\].
  /// By default, it is not set.
  int? heightInCentimeters;

  /// Car width in centimeters. The provided value must be in the range \[0, 5000\].
  /// By default, it is not set.
  int? widthInCentimeters;

  /// Car length in centimeters. The provided value must be in the range \[0, 30000\].
  /// By default, it is not set.
  int? lengthInCentimeters;

  /// Defines total number of axles in the vehicle. The provided value must be greater than or
  /// equal to 2. By default, it is not set.
  /// Route calculation: When not set, possible axle count restrictions will not be
  /// taken into consideration.
  /// When specifying [CarSpecifications.trailerAxleCount], then [CarSpecifications.axleCount] is required and must be greater than [CarSpecifications.trailerAxleCount].
  int? axleCount;

  /// Defines number of trailers attached to the vehicle. The provided value must be in the range
  /// \[0, 255\]. By default, it is not set.
  /// When specifying [CarSpecifications.trailerAxleCount], then [CarSpecifications.trailerCount] is required and must be greater than 0.
  /// **Note:**
  /// This parameter can only be used in conjunction with tolls and only affects toll cost calculations.
  int? trailerCount;

  /// Defines total number of axles across all the trailers attached to the vehicle.
  /// This number is included in [CarSpecifications.axleCount], hence [CarSpecifications.trailerAxleCount] must be less than [CarSpecifications.axleCount]
  /// and greater than or equal to 1. [CarSpecifications.axleCount] and [CarSpecifications.trailerCount] are required to specify [CarSpecifications.trailerAxleCount].
  /// By default, it is not set.
  /// **Note:**
  /// This parameter can only be used in conjunction with tolls and only affects toll cost calculations.
  int? trailerAxleCount;

  /// Creates a new instance.

  /// [grossWeightInKilograms] Car weight including trailers and shipped goods in kilograms. The provided value
  /// must be greater than or equal to 0. By default, it is not set.
  /// **Note:**
  /// This parameter is limited to a maximum weight of 4250 kgs.

  /// [heightInCentimeters] Car height in centimeters. The provided value must be in the range \[0, 5000\].
  /// By default, it is not set.

  /// [widthInCentimeters] Car width in centimeters. The provided value must be in the range \[0, 5000\].
  /// By default, it is not set.

  /// [lengthInCentimeters] Car length in centimeters. The provided value must be in the range \[0, 30000\].
  /// By default, it is not set.

  /// [axleCount] Defines total number of axles in the vehicle. The provided value must be greater than or
  /// equal to 2. By default, it is not set.
  /// Route calculation: When not set, possible axle count restrictions will not be
  /// taken into consideration.
  /// When specifying [CarSpecifications.trailerAxleCount], then [CarSpecifications.axleCount] is required and must be greater than [CarSpecifications.trailerAxleCount].

  /// [trailerCount] Defines number of trailers attached to the vehicle. The provided value must be in the range
  /// \[0, 255\]. By default, it is not set.
  /// When specifying [CarSpecifications.trailerAxleCount], then [CarSpecifications.trailerCount] is required and must be greater than 0.
  /// **Note:**
  /// This parameter can only be used in conjunction with tolls and only affects toll cost calculations.

  /// [trailerAxleCount] Defines total number of axles across all the trailers attached to the vehicle.
  /// This number is included in [CarSpecifications.axleCount], hence [CarSpecifications.trailerAxleCount] must be less than [CarSpecifications.axleCount]
  /// and greater than or equal to 1. [CarSpecifications.axleCount] and [CarSpecifications.trailerCount] are required to specify [CarSpecifications.trailerAxleCount].
  /// By default, it is not set.
  /// **Note:**
  /// This parameter can only be used in conjunction with tolls and only affects toll cost calculations.

  CarSpecifications([int? grossWeightInKilograms = null, int? heightInCentimeters = null, int? widthInCentimeters = null, int? lengthInCentimeters = null, int? axleCount = null, int? trailerCount = null, int? trailerAxleCount = null])
    : grossWeightInKilograms = grossWeightInKilograms, heightInCentimeters = heightInCentimeters, widthInCentimeters = widthInCentimeters, lengthInCentimeters = lengthInCentimeters, axleCount = axleCount, trailerCount = trailerCount, trailerAxleCount = trailerAxleCount;
  /// Creates a new instance.
  CarSpecifications.withDefaults()
      : grossWeightInKilograms = null, heightInCentimeters = null, widthInCentimeters = null, lengthInCentimeters = null, axleCount = null, trailerCount = null, trailerAxleCount = null;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CarSpecifications) return false;
    CarSpecifications _other = other;
    return grossWeightInKilograms == _other.grossWeightInKilograms &&
        heightInCentimeters == _other.heightInCentimeters &&
        widthInCentimeters == _other.widthInCentimeters &&
        lengthInCentimeters == _other.lengthInCentimeters &&
        axleCount == _other.axleCount &&
        trailerCount == _other.trailerCount &&
        trailerAxleCount == _other.trailerAxleCount;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + grossWeightInKilograms.hashCode;
    result = 31 * result + heightInCentimeters.hashCode;
    result = 31 * result + widthInCentimeters.hashCode;
    result = 31 * result + lengthInCentimeters.hashCode;
    result = 31 * result + axleCount.hashCode;
    result = 31 * result + trailerCount.hashCode;
    result = 31 * result + trailerAxleCount.hashCode;
    return result;
  }
}


// CarSpecifications "private" section, not exported.

final _sdkTransportCarspecificationsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_create_handle'));
final _sdkTransportCarspecificationsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_release_handle'));
final _sdkTransportCarspecificationsGetFieldgrossWeightInKilograms = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_grossWeightInKilograms'));
final _sdkTransportCarspecificationsGetFieldheightInCentimeters = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_heightInCentimeters'));
final _sdkTransportCarspecificationsGetFieldwidthInCentimeters = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_widthInCentimeters'));
final _sdkTransportCarspecificationsGetFieldlengthInCentimeters = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_lengthInCentimeters'));
final _sdkTransportCarspecificationsGetFieldaxleCount = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_axleCount'));
final _sdkTransportCarspecificationsGetFieldtrailerCount = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_trailerCount'));
final _sdkTransportCarspecificationsGetFieldtrailerAxleCount = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_field_trailerAxleCount'));



Pointer<Void> sdkTransportCarspecificationsToFfi(CarSpecifications value) {
  final _grossWeightInKilogramsHandle = intToFfiNullable(value.grossWeightInKilograms);
  final _heightInCentimetersHandle = intToFfiNullable(value.heightInCentimeters);
  final _widthInCentimetersHandle = intToFfiNullable(value.widthInCentimeters);
  final _lengthInCentimetersHandle = intToFfiNullable(value.lengthInCentimeters);
  final _axleCountHandle = intToFfiNullable(value.axleCount);
  final _trailerCountHandle = intToFfiNullable(value.trailerCount);
  final _trailerAxleCountHandle = intToFfiNullable(value.trailerAxleCount);
  final _result = _sdkTransportCarspecificationsCreateHandle(_grossWeightInKilogramsHandle, _heightInCentimetersHandle, _widthInCentimetersHandle, _lengthInCentimetersHandle, _axleCountHandle, _trailerCountHandle, _trailerAxleCountHandle);
  intReleaseFfiHandleNullable(_grossWeightInKilogramsHandle);
  intReleaseFfiHandleNullable(_heightInCentimetersHandle);
  intReleaseFfiHandleNullable(_widthInCentimetersHandle);
  intReleaseFfiHandleNullable(_lengthInCentimetersHandle);
  intReleaseFfiHandleNullable(_axleCountHandle);
  intReleaseFfiHandleNullable(_trailerCountHandle);
  intReleaseFfiHandleNullable(_trailerAxleCountHandle);
  return _result;
}

CarSpecifications sdkTransportCarspecificationsFromFfi(Pointer<Void> handle) {
  final _grossWeightInKilogramsHandle = _sdkTransportCarspecificationsGetFieldgrossWeightInKilograms(handle);
  final _heightInCentimetersHandle = _sdkTransportCarspecificationsGetFieldheightInCentimeters(handle);
  final _widthInCentimetersHandle = _sdkTransportCarspecificationsGetFieldwidthInCentimeters(handle);
  final _lengthInCentimetersHandle = _sdkTransportCarspecificationsGetFieldlengthInCentimeters(handle);
  final _axleCountHandle = _sdkTransportCarspecificationsGetFieldaxleCount(handle);
  final _trailerCountHandle = _sdkTransportCarspecificationsGetFieldtrailerCount(handle);
  final _trailerAxleCountHandle = _sdkTransportCarspecificationsGetFieldtrailerAxleCount(handle);
  try {
    return CarSpecifications(
      intFromFfiNullable(_grossWeightInKilogramsHandle), 
      intFromFfiNullable(_heightInCentimetersHandle), 
      intFromFfiNullable(_widthInCentimetersHandle), 
      intFromFfiNullable(_lengthInCentimetersHandle), 
      intFromFfiNullable(_axleCountHandle), 
      intFromFfiNullable(_trailerCountHandle), 
      intFromFfiNullable(_trailerAxleCountHandle)
    );
  } finally {
    intReleaseFfiHandleNullable(_grossWeightInKilogramsHandle);
    intReleaseFfiHandleNullable(_heightInCentimetersHandle);
    intReleaseFfiHandleNullable(_widthInCentimetersHandle);
    intReleaseFfiHandleNullable(_lengthInCentimetersHandle);
    intReleaseFfiHandleNullable(_axleCountHandle);
    intReleaseFfiHandleNullable(_trailerCountHandle);
    intReleaseFfiHandleNullable(_trailerAxleCountHandle);
  }
}

void sdkTransportCarspecificationsReleaseFfiHandle(Pointer<Void> handle) => _sdkTransportCarspecificationsReleaseHandle(handle);

// Nullable CarSpecifications

final _sdkTransportCarspecificationsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_create_handle_nullable'));
final _sdkTransportCarspecificationsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_release_handle_nullable'));
final _sdkTransportCarspecificationsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_transport_CarSpecifications_get_value_nullable'));

Pointer<Void> sdkTransportCarspecificationsToFfiNullable(CarSpecifications? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkTransportCarspecificationsToFfi(value);
  final result = _sdkTransportCarspecificationsCreateHandleNullable(_handle);
  sdkTransportCarspecificationsReleaseFfiHandle(_handle);
  return result;
}

CarSpecifications? sdkTransportCarspecificationsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkTransportCarspecificationsGetValueNullable(handle);
  final result = sdkTransportCarspecificationsFromFfi(_handle);
  sdkTransportCarspecificationsReleaseFfiHandle(_handle);
  return result;
}

void sdkTransportCarspecificationsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkTransportCarspecificationsReleaseHandleNullable(handle);

// End of CarSpecifications "private" section.


