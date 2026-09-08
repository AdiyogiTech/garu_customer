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

/// eMSP (e-Mobility Service Provider) for which the EV station operator has EV roaming agreements.
///
/// It is only available for online search.
///
/// **Note:** Currently, this is a closed-alpha feature, so it is available only for selected
/// customers.
/// There could be a few bugs and unexpected behaviors.
/// **Note:** Participants of the closed-alpha group can get access from HERE to use this feature.
/// If the credentials are not enabled, a [SearchError.forbidden] will be propagated.

class EMobilityServiceProvider {
  /// The name of the e-Mobility Service Provider.
  /// It may change but the respective `partnerId` will remain stable.
  String? name;

  /// The unique and stable id for the e-Mobility Service Provider on the HERE platform.
  /// It can be used for filtering when searching for EV charging stations.
  String? partnerId;

  /// Creates a new instance.

  /// [name] The name of the e-Mobility Service Provider.
  /// It may change but the respective `partnerId` will remain stable.

  /// [partnerId] The unique and stable id for the e-Mobility Service Provider on the HERE platform.
  /// It can be used for filtering when searching for EV charging stations.

  EMobilityServiceProvider._(this.name, this.partnerId);
  EMobilityServiceProvider()
    : name = null, partnerId = null;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EMobilityServiceProvider) return false;
    EMobilityServiceProvider _other = other;
    return name == _other.name &&
        partnerId == _other.partnerId;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + name.hashCode;
    result = 31 * result + partnerId.hashCode;
    return result;
  }
}


// EMobilityServiceProvider "private" section, not exported.

final _sdkSearchEmobilityserviceproviderCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_create_handle'));
final _sdkSearchEmobilityserviceproviderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_release_handle'));
final _sdkSearchEmobilityserviceproviderGetFieldname = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_get_field_name'));
final _sdkSearchEmobilityserviceproviderGetFieldpartnerId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_get_field_partnerId'));



Pointer<Void> sdkSearchEmobilityserviceproviderToFfi(EMobilityServiceProvider value) {
  final _nameHandle = stringToFfiNullable(value.name);
  final _partnerIdHandle = stringToFfiNullable(value.partnerId);
  final _result = _sdkSearchEmobilityserviceproviderCreateHandle(_nameHandle, _partnerIdHandle);
  stringReleaseFfiHandleNullable(_nameHandle);
  stringReleaseFfiHandleNullable(_partnerIdHandle);
  return _result;
}

EMobilityServiceProvider sdkSearchEmobilityserviceproviderFromFfi(Pointer<Void> handle) {
  final _nameHandle = _sdkSearchEmobilityserviceproviderGetFieldname(handle);
  final _partnerIdHandle = _sdkSearchEmobilityserviceproviderGetFieldpartnerId(handle);
  try {
    return EMobilityServiceProvider._(
      stringFromFfiNullable(_nameHandle), 
      stringFromFfiNullable(_partnerIdHandle)
    );
  } finally {
    stringReleaseFfiHandleNullable(_nameHandle);
    stringReleaseFfiHandleNullable(_partnerIdHandle);
  }
}

void sdkSearchEmobilityserviceproviderReleaseFfiHandle(Pointer<Void> handle) => _sdkSearchEmobilityserviceproviderReleaseHandle(handle);

// Nullable EMobilityServiceProvider

final _sdkSearchEmobilityserviceproviderCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_create_handle_nullable'));
final _sdkSearchEmobilityserviceproviderReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_release_handle_nullable'));
final _sdkSearchEmobilityserviceproviderGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EMobilityServiceProvider_get_value_nullable'));

Pointer<Void> sdkSearchEmobilityserviceproviderToFfiNullable(EMobilityServiceProvider? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkSearchEmobilityserviceproviderToFfi(value);
  final result = _sdkSearchEmobilityserviceproviderCreateHandleNullable(_handle);
  sdkSearchEmobilityserviceproviderReleaseFfiHandle(_handle);
  return result;
}

EMobilityServiceProvider? sdkSearchEmobilityserviceproviderFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkSearchEmobilityserviceproviderGetValueNullable(handle);
  final result = sdkSearchEmobilityserviceproviderFromFfi(_handle);
  sdkSearchEmobilityserviceproviderReleaseFfiHandle(_handle);
  return result;
}

void sdkSearchEmobilityserviceproviderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkSearchEmobilityserviceproviderReleaseHandleNullable(handle);

// End of EMobilityServiceProvider "private" section.


