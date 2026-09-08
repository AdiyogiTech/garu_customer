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
import 'package:collection/collection.dart';
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';

/// The option to specify how the tolls should be calculated.

class TollOptions {
  /// Specifies for which systems the user has valid transponders.
  /// Note: currently, the only valid value is "all"
  List<String> transponders;

  /// Defines special toll vehicle types. Usual types like car or truck
  /// are determined from transport mode.
  TollOptionsVehicleCategory? vehicleCategory;

  /// Defines the emission type as defined by the toll operator.
  /// The emission types defined are based on the emission standards.
  TollOptionsEmissionType? emissionType;

  /// Defines the CO2 class as defined by the toll operator.
  /// CO2 class is used with emission type.
  /// Allowed values for CO2 class are 1, 2, 3, 4, or 5.
  int? co2Class;

  /// Creates a new instance.

  /// [transponders] Specifies for which systems the user has valid transponders.
  /// Note: currently, the only valid value is "all"

  /// [vehicleCategory] Defines special toll vehicle types. Usual types like car or truck
  /// are determined from transport mode.

  /// [emissionType] Defines the emission type as defined by the toll operator.
  /// The emission types defined are based on the emission standards.

  /// [co2Class] Defines the CO2 class as defined by the toll operator.
  /// CO2 class is used with emission type.
  /// Allowed values for CO2 class are 1, 2, 3, 4, or 5.

  TollOptions._(this.transponders, this.vehicleCategory, this.emissionType, this.co2Class);
  TollOptions()
    : transponders = [], vehicleCategory = null, emissionType = null, co2Class = null;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TollOptions) return false;
    TollOptions _other = other;
    return DeepCollectionEquality().equals(transponders, _other.transponders) &&
        vehicleCategory == _other.vehicleCategory &&
        emissionType == _other.emissionType &&
        co2Class == _other.co2Class;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + DeepCollectionEquality().hash(transponders);
    result = 31 * result + vehicleCategory.hashCode;
    result = 31 * result + emissionType.hashCode;
    result = 31 * result + co2Class.hashCode;
    return result;
  }
}

/// Supported options of vehicle category
enum TollOptionsVehicleCategory {
    /// Commercial buses with a seating capacity of 16-25 passengers
    /// or small bus that is used to transport a maximum of 15 passengers.
    minibus
}

// TollOptionsVehicleCategory "private" section, not exported.

int sdkRoutingTolloptionsVehiclecategoryToFfi(TollOptionsVehicleCategory value) {
  switch (value) {
  case TollOptionsVehicleCategory.minibus:
    return 0;
  default:
    throw StateError("Invalid enum value $value for TollOptionsVehicleCategory enum.");
  }
}

TollOptionsVehicleCategory sdkRoutingTolloptionsVehiclecategoryFromFfi(int handle) {
  switch (handle) {
  case 0:
    return TollOptionsVehicleCategory.minibus;
  default:
    throw StateError("Invalid numeric value $handle for TollOptionsVehicleCategory enum.");
  }
}

void sdkRoutingTolloptionsVehiclecategoryReleaseFfiHandle(int handle) {}

final _sdkRoutingTolloptionsVehiclecategoryCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_routing_TollOptions_VehicleCategory_create_handle_nullable'));
final _sdkRoutingTolloptionsVehiclecategoryReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_VehicleCategory_release_handle_nullable'));
final _sdkRoutingTolloptionsVehiclecategoryGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_VehicleCategory_get_value_nullable'));

Pointer<Void> sdkRoutingTolloptionsVehiclecategoryToFfiNullable(TollOptionsVehicleCategory? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTolloptionsVehiclecategoryToFfi(value);
  final result = _sdkRoutingTolloptionsVehiclecategoryCreateHandleNullable(_handle);
  sdkRoutingTolloptionsVehiclecategoryReleaseFfiHandle(_handle);
  return result;
}

TollOptionsVehicleCategory? sdkRoutingTolloptionsVehiclecategoryFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTolloptionsVehiclecategoryGetValueNullable(handle);
  final result = sdkRoutingTolloptionsVehiclecategoryFromFfi(_handle);
  sdkRoutingTolloptionsVehiclecategoryReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTolloptionsVehiclecategoryReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTolloptionsVehiclecategoryReleaseHandleNullable(handle);

// End of TollOptionsVehicleCategory "private" section.
/// Supported options of emission type
enum TollOptionsEmissionType {
    /// toll emission type; euro1
    euro1,
    /// toll emission type; euro2
    euro2,
    /// toll emission type; euro3
    euro3,
    /// toll emission type; euro4
    euro4,
    /// toll emission type; euro5
    euro5,
    /// toll emission type; euro6
    euro6,
    /// toll emission type; euroEev
    euroEev
}

// TollOptionsEmissionType "private" section, not exported.

int sdkRoutingTolloptionsEmissiontypeToFfi(TollOptionsEmissionType value) {
  switch (value) {
  case TollOptionsEmissionType.euro1:
    return 0;
  case TollOptionsEmissionType.euro2:
    return 1;
  case TollOptionsEmissionType.euro3:
    return 2;
  case TollOptionsEmissionType.euro4:
    return 3;
  case TollOptionsEmissionType.euro5:
    return 4;
  case TollOptionsEmissionType.euro6:
    return 5;
  case TollOptionsEmissionType.euroEev:
    return 6;
  default:
    throw StateError("Invalid enum value $value for TollOptionsEmissionType enum.");
  }
}

TollOptionsEmissionType sdkRoutingTolloptionsEmissiontypeFromFfi(int handle) {
  switch (handle) {
  case 0:
    return TollOptionsEmissionType.euro1;
  case 1:
    return TollOptionsEmissionType.euro2;
  case 2:
    return TollOptionsEmissionType.euro3;
  case 3:
    return TollOptionsEmissionType.euro4;
  case 4:
    return TollOptionsEmissionType.euro5;
  case 5:
    return TollOptionsEmissionType.euro6;
  case 6:
    return TollOptionsEmissionType.euroEev;
  default:
    throw StateError("Invalid numeric value $handle for TollOptionsEmissionType enum.");
  }
}

void sdkRoutingTolloptionsEmissiontypeReleaseFfiHandle(int handle) {}

final _sdkRoutingTolloptionsEmissiontypeCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_routing_TollOptions_EmissionType_create_handle_nullable'));
final _sdkRoutingTolloptionsEmissiontypeReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_EmissionType_release_handle_nullable'));
final _sdkRoutingTolloptionsEmissiontypeGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_EmissionType_get_value_nullable'));

Pointer<Void> sdkRoutingTolloptionsEmissiontypeToFfiNullable(TollOptionsEmissionType? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTolloptionsEmissiontypeToFfi(value);
  final result = _sdkRoutingTolloptionsEmissiontypeCreateHandleNullable(_handle);
  sdkRoutingTolloptionsEmissiontypeReleaseFfiHandle(_handle);
  return result;
}

TollOptionsEmissionType? sdkRoutingTolloptionsEmissiontypeFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTolloptionsEmissiontypeGetValueNullable(handle);
  final result = sdkRoutingTolloptionsEmissiontypeFromFfi(_handle);
  sdkRoutingTolloptionsEmissiontypeReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTolloptionsEmissiontypeReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTolloptionsEmissiontypeReleaseHandleNullable(handle);

// End of TollOptionsEmissionType "private" section.

// TollOptions "private" section, not exported.

final _sdkRoutingTolloptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_create_handle'));
final _sdkRoutingTolloptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_release_handle'));
final _sdkRoutingTolloptionsGetFieldtransponders = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_get_field_transponders'));
final _sdkRoutingTolloptionsGetFieldvehicleCategory = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_get_field_vehicleCategory'));
final _sdkRoutingTolloptionsGetFieldemissionType = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_get_field_emissionType'));
final _sdkRoutingTolloptionsGetFieldco2Class = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_get_field_co2Class'));



Pointer<Void> sdkRoutingTolloptionsToFfi(TollOptions value) {
  final _transpondersHandle = heresdkRoutingCommonBindingslistofStringToFfi(value.transponders);
  final _vehicleCategoryHandle = sdkRoutingTolloptionsVehiclecategoryToFfiNullable(value.vehicleCategory);
  final _emissionTypeHandle = sdkRoutingTolloptionsEmissiontypeToFfiNullable(value.emissionType);
  final _co2ClassHandle = intToFfiNullable(value.co2Class);
  final _result = _sdkRoutingTolloptionsCreateHandle(_transpondersHandle, _vehicleCategoryHandle, _emissionTypeHandle, _co2ClassHandle);
  heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_transpondersHandle);
  sdkRoutingTolloptionsVehiclecategoryReleaseFfiHandleNullable(_vehicleCategoryHandle);
  sdkRoutingTolloptionsEmissiontypeReleaseFfiHandleNullable(_emissionTypeHandle);
  intReleaseFfiHandleNullable(_co2ClassHandle);
  return _result;
}

TollOptions sdkRoutingTolloptionsFromFfi(Pointer<Void> handle) {
  final _transpondersHandle = _sdkRoutingTolloptionsGetFieldtransponders(handle);
  final _vehicleCategoryHandle = _sdkRoutingTolloptionsGetFieldvehicleCategory(handle);
  final _emissionTypeHandle = _sdkRoutingTolloptionsGetFieldemissionType(handle);
  final _co2ClassHandle = _sdkRoutingTolloptionsGetFieldco2Class(handle);
  try {
    return TollOptions._(
      heresdkRoutingCommonBindingslistofStringFromFfi(_transpondersHandle), 
      sdkRoutingTolloptionsVehiclecategoryFromFfiNullable(_vehicleCategoryHandle), 
      sdkRoutingTolloptionsEmissiontypeFromFfiNullable(_emissionTypeHandle), 
      intFromFfiNullable(_co2ClassHandle)
    );
  } finally {
    heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_transpondersHandle);
    sdkRoutingTolloptionsVehiclecategoryReleaseFfiHandleNullable(_vehicleCategoryHandle);
    sdkRoutingTolloptionsEmissiontypeReleaseFfiHandleNullable(_emissionTypeHandle);
    intReleaseFfiHandleNullable(_co2ClassHandle);
  }
}

void sdkRoutingTolloptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingTolloptionsReleaseHandle(handle);

// Nullable TollOptions

final _sdkRoutingTolloptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_create_handle_nullable'));
final _sdkRoutingTolloptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_release_handle_nullable'));
final _sdkRoutingTolloptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TollOptions_get_value_nullable'));

Pointer<Void> sdkRoutingTolloptionsToFfiNullable(TollOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTolloptionsToFfi(value);
  final result = _sdkRoutingTolloptionsCreateHandleNullable(_handle);
  sdkRoutingTolloptionsReleaseFfiHandle(_handle);
  return result;
}

TollOptions? sdkRoutingTolloptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTolloptionsGetValueNullable(handle);
  final result = sdkRoutingTolloptionsFromFfi(_handle);
  sdkRoutingTolloptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTolloptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTolloptionsReleaseHandleNullable(handle);

// End of TollOptions "private" section.


