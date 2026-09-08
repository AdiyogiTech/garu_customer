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

/// Indicates the option of localized text usage.
enum LocalizedTextPreference {
    /// Information is not included in the notification.
    useNever,
    /// Information is included in the notification, if available.
    useAlways,
    /// Information is included in the notification, if available and its language code is compatible with the voice
    /// package language. For example, in case the voice package language is German and the localized text information
    /// is in Italian, the information is then excluded from the notification.
    /// More examples:
    /// | Voice package language | Information language | Included |
    /// | en-GB                  | en                   | yes      |
    /// | en-GB                  | de                   | no       |
    /// | pt-BR                  | pt                   | yes      |
    /// | pt-PT                  | pt                   | yes      |
    useIfLanguageIsCompatible
}

// LocalizedTextPreference "private" section, not exported.

int sdkRoutingLocalizedtextpreferenceToFfi(LocalizedTextPreference value) {
  switch (value) {
  case LocalizedTextPreference.useNever:
    return 0;
  case LocalizedTextPreference.useAlways:
    return 1;
  case LocalizedTextPreference.useIfLanguageIsCompatible:
    return 2;
  default:
    throw StateError("Invalid enum value $value for LocalizedTextPreference enum.");
  }
}

LocalizedTextPreference sdkRoutingLocalizedtextpreferenceFromFfi(int handle) {
  switch (handle) {
  case 0:
    return LocalizedTextPreference.useNever;
  case 1:
    return LocalizedTextPreference.useAlways;
  case 2:
    return LocalizedTextPreference.useIfLanguageIsCompatible;
  default:
    throw StateError("Invalid numeric value $handle for LocalizedTextPreference enum.");
  }
}

void sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(int handle) {}

final _sdkRoutingLocalizedtextpreferenceCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_routing_LocalizedTextPreference_create_handle_nullable'));
final _sdkRoutingLocalizedtextpreferenceReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_LocalizedTextPreference_release_handle_nullable'));
final _sdkRoutingLocalizedtextpreferenceGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_LocalizedTextPreference_get_value_nullable'));

Pointer<Void> sdkRoutingLocalizedtextpreferenceToFfiNullable(LocalizedTextPreference? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingLocalizedtextpreferenceToFfi(value);
  final result = _sdkRoutingLocalizedtextpreferenceCreateHandleNullable(_handle);
  sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_handle);
  return result;
}

LocalizedTextPreference? sdkRoutingLocalizedtextpreferenceFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingLocalizedtextpreferenceGetValueNullable(handle);
  final result = sdkRoutingLocalizedtextpreferenceFromFfi(_handle);
  sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingLocalizedtextpreferenceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingLocalizedtextpreferenceReleaseHandleNullable(handle);

// End of LocalizedTextPreference "private" section.


