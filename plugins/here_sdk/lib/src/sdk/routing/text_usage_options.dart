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
import 'package:here_sdk/src/sdk/routing/localized_text_preference.dart';

/// Specify whether the text should be used when generating notification.

class TextUsageOptions {
  /// An option whether street name should be used when generating notification.
  /// Defaults to [LocalizedTextPreference.useAlways].
  LocalizedTextPreference streetName;

  /// An option whether road number should be used when generating notification.
  /// Defaults to [LocalizedTextPreference.useAlways].
  LocalizedTextPreference roadNumber;

  /// An option whether signpost direction should be used when generating notification.
  /// Defaults to [LocalizedTextPreference.useAlways].
  LocalizedTextPreference signpostDirection;

  /// Creates a new instance.

  /// [streetName] An option whether street name should be used when generating notification.
  /// Defaults to [LocalizedTextPreference.useAlways].

  /// [roadNumber] An option whether road number should be used when generating notification.
  /// Defaults to [LocalizedTextPreference.useAlways].

  /// [signpostDirection] An option whether signpost direction should be used when generating notification.
  /// Defaults to [LocalizedTextPreference.useAlways].

  TextUsageOptions._(this.streetName, this.roadNumber, this.signpostDirection);
  TextUsageOptions()
    : streetName = LocalizedTextPreference.useAlways, roadNumber = LocalizedTextPreference.useAlways, signpostDirection = LocalizedTextPreference.useAlways;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TextUsageOptions) return false;
    TextUsageOptions _other = other;
    return streetName == _other.streetName &&
        roadNumber == _other.roadNumber &&
        signpostDirection == _other.signpostDirection;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + streetName.hashCode;
    result = 31 * result + roadNumber.hashCode;
    result = 31 * result + signpostDirection.hashCode;
    return result;
  }
}


// TextUsageOptions "private" section, not exported.

final _sdkRoutingTextusageoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32, Uint32, Uint32),
    Pointer<Void> Function(int, int, int)
  >('here_sdk_sdk_routing_TextUsageOptions_create_handle'));
final _sdkRoutingTextusageoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_release_handle'));
final _sdkRoutingTextusageoptionsGetFieldstreetName = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_get_field_streetName'));
final _sdkRoutingTextusageoptionsGetFieldroadNumber = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_get_field_roadNumber'));
final _sdkRoutingTextusageoptionsGetFieldsignpostDirection = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_get_field_signpostDirection'));



Pointer<Void> sdkRoutingTextusageoptionsToFfi(TextUsageOptions value) {
  final _streetNameHandle = sdkRoutingLocalizedtextpreferenceToFfi(value.streetName);
  final _roadNumberHandle = sdkRoutingLocalizedtextpreferenceToFfi(value.roadNumber);
  final _signpostDirectionHandle = sdkRoutingLocalizedtextpreferenceToFfi(value.signpostDirection);
  final _result = _sdkRoutingTextusageoptionsCreateHandle(_streetNameHandle, _roadNumberHandle, _signpostDirectionHandle);
  sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_streetNameHandle);
  sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_roadNumberHandle);
  sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_signpostDirectionHandle);
  return _result;
}

TextUsageOptions sdkRoutingTextusageoptionsFromFfi(Pointer<Void> handle) {
  final _streetNameHandle = _sdkRoutingTextusageoptionsGetFieldstreetName(handle);
  final _roadNumberHandle = _sdkRoutingTextusageoptionsGetFieldroadNumber(handle);
  final _signpostDirectionHandle = _sdkRoutingTextusageoptionsGetFieldsignpostDirection(handle);
  try {
    return TextUsageOptions._(
      sdkRoutingLocalizedtextpreferenceFromFfi(_streetNameHandle), 
      sdkRoutingLocalizedtextpreferenceFromFfi(_roadNumberHandle), 
      sdkRoutingLocalizedtextpreferenceFromFfi(_signpostDirectionHandle)
    );
  } finally {
    sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_streetNameHandle);
    sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_roadNumberHandle);
    sdkRoutingLocalizedtextpreferenceReleaseFfiHandle(_signpostDirectionHandle);
  }
}

void sdkRoutingTextusageoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingTextusageoptionsReleaseHandle(handle);

// Nullable TextUsageOptions

final _sdkRoutingTextusageoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_create_handle_nullable'));
final _sdkRoutingTextusageoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_release_handle_nullable'));
final _sdkRoutingTextusageoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TextUsageOptions_get_value_nullable'));

Pointer<Void> sdkRoutingTextusageoptionsToFfiNullable(TextUsageOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTextusageoptionsToFfi(value);
  final result = _sdkRoutingTextusageoptionsCreateHandleNullable(_handle);
  sdkRoutingTextusageoptionsReleaseFfiHandle(_handle);
  return result;
}

TextUsageOptions? sdkRoutingTextusageoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTextusageoptionsGetValueNullable(handle);
  final result = sdkRoutingTextusageoptionsFromFfi(_handle);
  sdkRoutingTextusageoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTextusageoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTextusageoptionsReleaseHandleNullable(handle);

// End of TextUsageOptions "private" section.


