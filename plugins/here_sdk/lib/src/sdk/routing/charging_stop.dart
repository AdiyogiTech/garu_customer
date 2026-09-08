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
import 'package:here_sdk/src/sdk/routing/charging_supply_type.dart';

/// The options to specify a user-planned charging stop.
///
/// **Note:**
/// In order to specify this [ChargingStop], it is also required to set
/// [sdk.routing.BatterySpecifications.total_capacity_in_kilowatt_hours], [sdk.routing.BatterySpecifications.initial_charge_in_kilowatt_hours],
/// and [BatterySpecifications.chargingCurve].
/// Without all of them, the route calculation will fail as an invalid parameter error.

class ChargingStop {
  /// The value of rated power of the connector (in kW).
  double powerInKilowatts;

  /// The value of rated current of the connector (in A).
  double currentInAmperes;

  /// The value of rated voltage of the connector (in V).
  double voltageInVolts;

  /// Supply type of the suggested connector.
  ChargingSupplyType? supplyType;

  /// The minimum duration the user expects to charge at the station,
  /// including [BatterySpecifications.chargingSetupDuration].
  /// **Note:**
  /// At least one of `min_duration` and `max_duration` is required for a user-planned charging stop.
  /// For most use cases, providing at least `min_duration` is recommended.
  Duration? minDuration;

  /// The maximum duration the user plans to charge at the station,
  /// including [BatterySpecifications.chargingSetupDuration].
  /// **Note:**
  /// At least one of `min_duration` and `max_duration` is required for a user-planned charging stop.
  /// For most use cases, providing at least `min_duration` is recommended.
  Duration? maxDuration;

  /// Creates a new instance.
  ChargingStop.withDefaults()
      : powerInKilowatts = 0.0, currentInAmperes = 0.0, voltageInVolts = 0.0, supplyType = null, minDuration = null, maxDuration = null;
  /// Creates a new instance.
  /// [powerInKilowatts] The value of rated power of the connector (in kW).
  /// [currentInAmperes] The value of rated current of the connector (in A).
  /// [voltageInVolts] The value of rated voltage of the connector (in V).
  /// [supplyType] Supply type of the suggested connector.
  /// [minDuration] The minimum duration the user expects to charge at the station,
  /// including [BatterySpecifications.chargingSetupDuration].
  /// **Note:**
  /// At least one of `min_duration` and `max_duration` is required for a user-planned charging stop.
  /// For most use cases, providing at least `min_duration` is recommended.
  /// [maxDuration] The maximum duration the user plans to charge at the station,
  /// including [BatterySpecifications.chargingSetupDuration].
  /// **Note:**
  /// At least one of `min_duration` and `max_duration` is required for a user-planned charging stop.
  /// For most use cases, providing at least `min_duration` is recommended.
  ChargingStop(this.powerInKilowatts, this.currentInAmperes, this.voltageInVolts, this.supplyType, this.minDuration, this.maxDuration);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChargingStop) return false;
    ChargingStop _other = other;
    return powerInKilowatts == _other.powerInKilowatts &&
        currentInAmperes == _other.currentInAmperes &&
        voltageInVolts == _other.voltageInVolts &&
        supplyType == _other.supplyType &&
        minDuration == _other.minDuration &&
        maxDuration == _other.maxDuration;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + powerInKilowatts.hashCode;
    result = 31 * result + currentInAmperes.hashCode;
    result = 31 * result + voltageInVolts.hashCode;
    result = 31 * result + supplyType.hashCode;
    result = 31 * result + minDuration.hashCode;
    result = 31 * result + maxDuration.hashCode;
    return result;
  }
}


// ChargingStop "private" section, not exported.

final _sdkRoutingChargingstopCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Double, Double, Double, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(double, double, double, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_create_handle'));
final _sdkRoutingChargingstopReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_release_handle'));
final _sdkRoutingChargingstopGetFieldpowerInKilowatts = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_field_powerInKilowatts'));
final _sdkRoutingChargingstopGetFieldcurrentInAmperes = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_field_currentInAmperes'));
final _sdkRoutingChargingstopGetFieldvoltageInVolts = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_field_voltageInVolts'));
final _sdkRoutingChargingstopGetFieldsupplyType = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_field_supplyType'));
final _sdkRoutingChargingstopGetFieldminDuration = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_field_minDuration'));
final _sdkRoutingChargingstopGetFieldmaxDuration = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_field_maxDuration'));



Pointer<Void> sdkRoutingChargingstopToFfi(ChargingStop value) {
  final _powerInKilowattsHandle = (value.powerInKilowatts);
  final _currentInAmperesHandle = (value.currentInAmperes);
  final _voltageInVoltsHandle = (value.voltageInVolts);
  final _supplyTypeHandle = sdkRoutingChargingsupplytypeToFfiNullable(value.supplyType);
  final _minDurationHandle = durationToFfiNullable(value.minDuration);
  final _maxDurationHandle = durationToFfiNullable(value.maxDuration);
  final _result = _sdkRoutingChargingstopCreateHandle(_powerInKilowattsHandle, _currentInAmperesHandle, _voltageInVoltsHandle, _supplyTypeHandle, _minDurationHandle, _maxDurationHandle);
  
  
  
  sdkRoutingChargingsupplytypeReleaseFfiHandleNullable(_supplyTypeHandle);
  durationReleaseFfiHandleNullable(_minDurationHandle);
  durationReleaseFfiHandleNullable(_maxDurationHandle);
  return _result;
}

ChargingStop sdkRoutingChargingstopFromFfi(Pointer<Void> handle) {
  final _powerInKilowattsHandle = _sdkRoutingChargingstopGetFieldpowerInKilowatts(handle);
  final _currentInAmperesHandle = _sdkRoutingChargingstopGetFieldcurrentInAmperes(handle);
  final _voltageInVoltsHandle = _sdkRoutingChargingstopGetFieldvoltageInVolts(handle);
  final _supplyTypeHandle = _sdkRoutingChargingstopGetFieldsupplyType(handle);
  final _minDurationHandle = _sdkRoutingChargingstopGetFieldminDuration(handle);
  final _maxDurationHandle = _sdkRoutingChargingstopGetFieldmaxDuration(handle);
  try {
    return ChargingStop(
      (_powerInKilowattsHandle), 
      (_currentInAmperesHandle), 
      (_voltageInVoltsHandle), 
      sdkRoutingChargingsupplytypeFromFfiNullable(_supplyTypeHandle), 
      durationFromFfiNullable(_minDurationHandle), 
      durationFromFfiNullable(_maxDurationHandle)
    );
  } finally {
    
    
    
    sdkRoutingChargingsupplytypeReleaseFfiHandleNullable(_supplyTypeHandle);
    durationReleaseFfiHandleNullable(_minDurationHandle);
    durationReleaseFfiHandleNullable(_maxDurationHandle);
  }
}

void sdkRoutingChargingstopReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingChargingstopReleaseHandle(handle);

// Nullable ChargingStop

final _sdkRoutingChargingstopCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_create_handle_nullable'));
final _sdkRoutingChargingstopReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_release_handle_nullable'));
final _sdkRoutingChargingstopGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_ChargingStop_get_value_nullable'));

Pointer<Void> sdkRoutingChargingstopToFfiNullable(ChargingStop? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingChargingstopToFfi(value);
  final result = _sdkRoutingChargingstopCreateHandleNullable(_handle);
  sdkRoutingChargingstopReleaseFfiHandle(_handle);
  return result;
}

ChargingStop? sdkRoutingChargingstopFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingChargingstopGetValueNullable(handle);
  final result = sdkRoutingChargingstopFromFfi(_handle);
  sdkRoutingChargingstopReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingChargingstopReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingChargingstopReleaseHandleNullable(handle);

// End of ChargingStop "private" section.


