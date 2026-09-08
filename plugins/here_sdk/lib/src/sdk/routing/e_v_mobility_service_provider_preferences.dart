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
import 'package:here_sdk/src/generic_types__conversion.dart';

/// Defines preference level per known E-Mobility Service Provider.
///
/// The E-Mobility Service Provider ID partner id as received from
/// https://www.here.com/docs/bundle/ev-charge-points-api-developer-guide/page/topics/resource-roamings.html
/// An alternative way to get `partnerId` is the `eMobilityServiceProviders.partnerId` as part of `HERE SDK Search`.

class EVMobilityServiceProviderPreferences {
  /// Specifies the E-Mobility Service Provider partnerId that are preferred the most.
  List<String> high;

  /// Specifies the E-Mobility Service Provider partnerId that can be used when no better provider could be found or reached.
  List<String> medium;

  /// Specifies the E-Mobility Service Provider partnerId that are preferred the least.
  List<String> low;

  /// Specifies the E-Mobility Service Provider partnerId that should never be used.
  List<String> exclude;

  /// Creates a new instance.

  /// [high] Specifies the E-Mobility Service Provider partnerId that are preferred the most.

  /// [medium] Specifies the E-Mobility Service Provider partnerId that can be used when no better provider could be found or reached.

  /// [low] Specifies the E-Mobility Service Provider partnerId that are preferred the least.

  /// [exclude] Specifies the E-Mobility Service Provider partnerId that should never be used.

  EVMobilityServiceProviderPreferences._(this.high, this.medium, this.low, this.exclude);
  EVMobilityServiceProviderPreferences()
    : high = [], medium = [], low = [], exclude = [];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EVMobilityServiceProviderPreferences) return false;
    EVMobilityServiceProviderPreferences _other = other;
    return DeepCollectionEquality().equals(high, _other.high) &&
        DeepCollectionEquality().equals(medium, _other.medium) &&
        DeepCollectionEquality().equals(low, _other.low) &&
        DeepCollectionEquality().equals(exclude, _other.exclude);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + DeepCollectionEquality().hash(high);
    result = 31 * result + DeepCollectionEquality().hash(medium);
    result = 31 * result + DeepCollectionEquality().hash(low);
    result = 31 * result + DeepCollectionEquality().hash(exclude);
    return result;
  }
}


// EVMobilityServiceProviderPreferences "private" section, not exported.

final _sdkRoutingEvmobilityserviceproviderpreferencesCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_create_handle'));
final _sdkRoutingEvmobilityserviceproviderpreferencesReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_release_handle'));
final _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldhigh = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_get_field_high'));
final _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldmedium = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_get_field_medium'));
final _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldlow = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_get_field_low'));
final _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldexclude = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_get_field_exclude'));



Pointer<Void> sdkRoutingEvmobilityserviceproviderpreferencesToFfi(EVMobilityServiceProviderPreferences value) {
  final _highHandle = heresdkRoutingCommonBindingslistofStringToFfi(value.high);
  final _mediumHandle = heresdkRoutingCommonBindingslistofStringToFfi(value.medium);
  final _lowHandle = heresdkRoutingCommonBindingslistofStringToFfi(value.low);
  final _excludeHandle = heresdkRoutingCommonBindingslistofStringToFfi(value.exclude);
  final _result = _sdkRoutingEvmobilityserviceproviderpreferencesCreateHandle(_highHandle, _mediumHandle, _lowHandle, _excludeHandle);
  heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_highHandle);
  heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_mediumHandle);
  heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_lowHandle);
  heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_excludeHandle);
  return _result;
}

EVMobilityServiceProviderPreferences sdkRoutingEvmobilityserviceproviderpreferencesFromFfi(Pointer<Void> handle) {
  final _highHandle = _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldhigh(handle);
  final _mediumHandle = _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldmedium(handle);
  final _lowHandle = _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldlow(handle);
  final _excludeHandle = _sdkRoutingEvmobilityserviceproviderpreferencesGetFieldexclude(handle);
  try {
    return EVMobilityServiceProviderPreferences._(
      heresdkRoutingCommonBindingslistofStringFromFfi(_highHandle), 
      heresdkRoutingCommonBindingslistofStringFromFfi(_mediumHandle), 
      heresdkRoutingCommonBindingslistofStringFromFfi(_lowHandle), 
      heresdkRoutingCommonBindingslistofStringFromFfi(_excludeHandle)
    );
  } finally {
    heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_highHandle);
    heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_mediumHandle);
    heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_lowHandle);
    heresdkRoutingCommonBindingslistofStringReleaseFfiHandle(_excludeHandle);
  }
}

void sdkRoutingEvmobilityserviceproviderpreferencesReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingEvmobilityserviceproviderpreferencesReleaseHandle(handle);

// Nullable EVMobilityServiceProviderPreferences

final _sdkRoutingEvmobilityserviceproviderpreferencesCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_create_handle_nullable'));
final _sdkRoutingEvmobilityserviceproviderpreferencesReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_release_handle_nullable'));
final _sdkRoutingEvmobilityserviceproviderpreferencesGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVMobilityServiceProviderPreferences_get_value_nullable'));

Pointer<Void> sdkRoutingEvmobilityserviceproviderpreferencesToFfiNullable(EVMobilityServiceProviderPreferences? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingEvmobilityserviceproviderpreferencesToFfi(value);
  final result = _sdkRoutingEvmobilityserviceproviderpreferencesCreateHandleNullable(_handle);
  sdkRoutingEvmobilityserviceproviderpreferencesReleaseFfiHandle(_handle);
  return result;
}

EVMobilityServiceProviderPreferences? sdkRoutingEvmobilityserviceproviderpreferencesFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingEvmobilityserviceproviderpreferencesGetValueNullable(handle);
  final result = sdkRoutingEvmobilityserviceproviderpreferencesFromFfi(_handle);
  sdkRoutingEvmobilityserviceproviderpreferencesReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingEvmobilityserviceproviderpreferencesReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingEvmobilityserviceproviderpreferencesReleaseHandleNullable(handle);

// End of EVMobilityServiceProviderPreferences "private" section.


