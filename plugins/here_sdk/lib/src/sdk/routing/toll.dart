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
import 'package:here_sdk/src/sdk/routing/toll_fare.dart';

/// This struct presents all the data for a toll.
///
/// **Note:** This is a beta release of this feature, so there could be a few bugs and unexpected behaviors.
/// Related APIs may change for new releases without a deprecation process.

class Toll {
  /// The country in which the toll is to be paid in ISO-3166-1 alpha-3 format, e.g. "USA".
  String countryCode;

  /// Name of the toll system collecting the toll, e.g. "VIAPASS WALLONIA“.
  @Deprecated("Will be removed in v4.23.0. Please use [Toll.tollSystems] instead.")
  String tollSystem;

  /// Names of the multiple toll systems which are associated with the toll, e.g. \["ATLANDES“, "ASF", "COFIROUTE"\].
  /// When the toll information covers several toll roads and the toll system of the each road is different,
  /// all toll system names are listed here and the last element will be one of the exit toll booth.
  List<String> tollSystems;

  /// The list of toll fares possible for the toll which may depend on time of day, payment method, vehicle
  /// characteristics, etc. If there are multiple toll fares that the router cannot disambiguate, then the
  /// list will contain more than one toll fare. Note that this list contains at least one element, i.e. it
  /// is never empty.
  List<TollFare> fares;

  /// Creates a new instance.

  /// [countryCode] The country in which the toll is to be paid in ISO-3166-1 alpha-3 format, e.g. "USA".

  /// [tollSystem] Name of the toll system collecting the toll, e.g. "VIAPASS WALLONIA“.

  /// [tollSystems] Names of the multiple toll systems which are associated with the toll, e.g. \["ATLANDES“, "ASF", "COFIROUTE"\].
  /// When the toll information covers several toll roads and the toll system of the each road is different,
  /// all toll system names are listed here and the last element will be one of the exit toll booth.

  /// [fares] The list of toll fares possible for the toll which may depend on time of day, payment method, vehicle
  /// characteristics, etc. If there are multiple toll fares that the router cannot disambiguate, then the
  /// list will contain more than one toll fare. Note that this list contains at least one element, i.e. it
  /// is never empty.

  Toll(String countryCode, List<String> tollSystems, List<TollFare> fares, [String tollSystem = ""])
    : countryCode = countryCode, tollSystem = tollSystem, tollSystems = tollSystems, fares = fares;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Toll) return false;
    Toll _other = other;
    return countryCode == _other.countryCode &&
        tollSystem == _other.tollSystem &&
        DeepCollectionEquality().equals(tollSystems, _other.tollSystems) &&
        DeepCollectionEquality().equals(fares, _other.fares);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + countryCode.hashCode;
    result = 31 * result + tollSystem.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(tollSystems);
    result = 31 * result + DeepCollectionEquality().hash(fares);
    return result;
  }
}


// Toll "private" section, not exported.

final _sdkRoutingTollCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_create_handle'));
final _sdkRoutingTollReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_release_handle'));
final _sdkRoutingTollGetFieldcountryCode = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_get_field_countryCode'));
final _sdkRoutingTollGetFieldtollSystem = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_get_field_tollSystem'));
final _sdkRoutingTollGetFieldtollSystems = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_get_field_tollSystems'));
final _sdkRoutingTollGetFieldfares = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_get_field_fares'));



Pointer<Void> sdkRoutingTollToFfi(Toll value) {
  final _countryCodeHandle = stringToFfi(value.countryCode);
  final _tollSystemHandle = stringToFfi(value.tollSystem);
  final _tollSystemsHandle = heresdkRoutingCommonBindingslistofStringToFfi(value.tollSystems);
  final _faresHandle = heresdkRoutingCommonBindingslistofSdkRoutingTollfareToFfi(value.fares);
  final _result = _sdkRoutingTollCreateHandle(_countryCodeHandle, _tollSystemHandle, _tollSystemsHandle, _faresHandle);
  stringReleaseFfiHandle(_countryCodeHandle);
  stringReleaseFfiHandle(_tollSystemHandle);
  heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_tollSystemsHandle);
  heresdkRoutingCommonBindingslistofSdkRoutingTollfareReleaseFfiHandle(_faresHandle);
  return _result;
}

Toll sdkRoutingTollFromFfi(Pointer<Void> handle) {
  final _countryCodeHandle = _sdkRoutingTollGetFieldcountryCode(handle);
  final _tollSystemHandle = _sdkRoutingTollGetFieldtollSystem(handle);
  final _tollSystemsHandle = _sdkRoutingTollGetFieldtollSystems(handle);
  final _faresHandle = _sdkRoutingTollGetFieldfares(handle);
  try {
    return Toll(
      stringFromFfi(_countryCodeHandle), 
      heresdkRoutingCommonBindingslistofStringFromFfi(_tollSystemsHandle), 
      heresdkRoutingCommonBindingslistofSdkRoutingTollfareFromFfi(_faresHandle), 
      stringFromFfi(_tollSystemHandle)
    );
  } finally {
    stringReleaseFfiHandle(_countryCodeHandle);
    stringReleaseFfiHandle(_tollSystemHandle);
    heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_tollSystemsHandle);
    heresdkRoutingCommonBindingslistofSdkRoutingTollfareReleaseFfiHandle(_faresHandle);
  }
}

void sdkRoutingTollReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingTollReleaseHandle(handle);

// Nullable Toll

final _sdkRoutingTollCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_create_handle_nullable'));
final _sdkRoutingTollReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_release_handle_nullable'));
final _sdkRoutingTollGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_Toll_get_value_nullable'));

Pointer<Void> sdkRoutingTollToFfiNullable(Toll? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTollToFfi(value);
  final result = _sdkRoutingTollCreateHandleNullable(_handle);
  sdkRoutingTollReleaseFfiHandle(_handle);
  return result;
}

Toll? sdkRoutingTollFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTollGetValueNullable(handle);
  final result = sdkRoutingTollFromFfi(_handle);
  sdkRoutingTollReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTollReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTollReleaseHandleNullable(handle);

// End of Toll "private" section.


