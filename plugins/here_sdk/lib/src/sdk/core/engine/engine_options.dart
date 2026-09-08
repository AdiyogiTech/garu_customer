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
import 'package:here_sdk/src/sdk/core/engine/authentication_mode.dart';

/// Specifies several options specific to different engines.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected behaviors.
/// Related APIs may change for new releases without a deprecation process.

class EngineOptions {
  /// Allows engines to use custom base URLs for alternative services.
  /// By default, the available endpoints use HERE backend endpoints.
  /// If unsupported base URLs are specified, the related features will become non-functional.
  /// Please contact your HERE representative to learn about possible custom base URL usage options
  String? customBaseUrl;

  /// Allows bearer authentication mode for engines. This mode adds a header
  /// ("Authorization", "Bearer $Token") to each online request made by the
  /// module the object is added to. The token can either be provided directly
  /// or retrieved via key/secret from a dedicated backend.
  AuthenticationMode? customAuthenticationMode;

  EngineOptions._(this.customBaseUrl, this.customAuthenticationMode);
  /// Creates a new instance with default values.
  EngineOptions()
      : customBaseUrl = null, customAuthenticationMode = null;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EngineOptions) return false;
    EngineOptions _other = other;
    return customBaseUrl == _other.customBaseUrl &&
        customAuthenticationMode == _other.customAuthenticationMode;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + customBaseUrl.hashCode;
    result = 31 * result + customAuthenticationMode.hashCode;
    return result;
  }
}


// EngineOptions "private" section, not exported.

final _sdkCoreEngineEngineoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_create_handle'));
final _sdkCoreEngineEngineoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_release_handle'));
final _sdkCoreEngineEngineoptionsGetFieldcustomBaseUrl = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_get_field_customBaseUrl'));
final _sdkCoreEngineEngineoptionsGetFieldcustomAuthenticationMode = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_get_field_customAuthenticationMode'));



Pointer<Void> sdkCoreEngineEngineoptionsToFfi(EngineOptions value) {
  final _customBaseUrlHandle = stringToFfiNullable(value.customBaseUrl);
  final _customAuthenticationModeHandle = sdkCoreEngineAuthenticationmodeToFfiNullable(value.customAuthenticationMode);
  final _result = _sdkCoreEngineEngineoptionsCreateHandle(_customBaseUrlHandle, _customAuthenticationModeHandle);
  stringReleaseFfiHandleNullable(_customBaseUrlHandle);
  sdkCoreEngineAuthenticationmodeReleaseFfiHandleNullable(_customAuthenticationModeHandle);
  return _result;
}

EngineOptions sdkCoreEngineEngineoptionsFromFfi(Pointer<Void> handle) {
  final _customBaseUrlHandle = _sdkCoreEngineEngineoptionsGetFieldcustomBaseUrl(handle);
  final _customAuthenticationModeHandle = _sdkCoreEngineEngineoptionsGetFieldcustomAuthenticationMode(handle);
  try {
    return EngineOptions._(
      stringFromFfiNullable(_customBaseUrlHandle), 
      sdkCoreEngineAuthenticationmodeFromFfiNullable(_customAuthenticationModeHandle)
    );
  } finally {
    stringReleaseFfiHandleNullable(_customBaseUrlHandle);
    sdkCoreEngineAuthenticationmodeReleaseFfiHandleNullable(_customAuthenticationModeHandle);
  }
}

void sdkCoreEngineEngineoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkCoreEngineEngineoptionsReleaseHandle(handle);

// Nullable EngineOptions

final _sdkCoreEngineEngineoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_create_handle_nullable'));
final _sdkCoreEngineEngineoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_release_handle_nullable'));
final _sdkCoreEngineEngineoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_EngineOptions_get_value_nullable'));

Pointer<Void> sdkCoreEngineEngineoptionsToFfiNullable(EngineOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkCoreEngineEngineoptionsToFfi(value);
  final result = _sdkCoreEngineEngineoptionsCreateHandleNullable(_handle);
  sdkCoreEngineEngineoptionsReleaseFfiHandle(_handle);
  return result;
}

EngineOptions? sdkCoreEngineEngineoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkCoreEngineEngineoptionsGetValueNullable(handle);
  final result = sdkCoreEngineEngineoptionsFromFfi(_handle);
  sdkCoreEngineEngineoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkCoreEngineEngineoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreEngineEngineoptionsReleaseHandleNullable(handle);

// End of EngineOptions "private" section.


