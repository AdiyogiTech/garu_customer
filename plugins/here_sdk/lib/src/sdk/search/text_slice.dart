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

/// A structure that represents a slice of text with a boolean value that shows
/// whether it matches an input query.
/// @nodoc

class TextSlice {
  /// The text content.
  String text;

  /// A boolean value that indicates whether the text matches a part of an input query.
  /// If `true`, the text should be styled differently.
  bool matchesQuery;

  TextSlice._(this.text, this.matchesQuery);
  TextSlice()
    : text = "", matchesQuery = false;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TextSlice) return false;
    TextSlice _other = other;
    return text == _other.text &&
        matchesQuery == _other.matchesQuery;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + text.hashCode;
    result = 31 * result + matchesQuery.hashCode;
    return result;
  }
}


// TextSlice "private" section, not exported.

final _sdkSearchTextsliceCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Uint8),
    Pointer<Void> Function(Pointer<Void>, int)
  >('here_sdk_sdk_search_TextSlice_create_handle'));
final _sdkSearchTextsliceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_TextSlice_release_handle'));
final _sdkSearchTextsliceGetFieldtext = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_TextSlice_get_field_text'));
final _sdkSearchTextsliceGetFieldmatchesQuery = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_search_TextSlice_get_field_matchesQuery'));



Pointer<Void> sdkSearchTextsliceToFfi(TextSlice value) {
  final _textHandle = stringToFfi(value.text);
  final _matchesQueryHandle = booleanToFfi(value.matchesQuery);
  final _result = _sdkSearchTextsliceCreateHandle(_textHandle, _matchesQueryHandle);
  stringReleaseFfiHandle(_textHandle);
  booleanReleaseFfiHandle(_matchesQueryHandle);
  return _result;
}

TextSlice sdkSearchTextsliceFromFfi(Pointer<Void> handle) {
  final _textHandle = _sdkSearchTextsliceGetFieldtext(handle);
  final _matchesQueryHandle = _sdkSearchTextsliceGetFieldmatchesQuery(handle);
  try {
    return TextSlice._(
      stringFromFfi(_textHandle), 
      booleanFromFfi(_matchesQueryHandle)
    );
  } finally {
    stringReleaseFfiHandle(_textHandle);
    booleanReleaseFfiHandle(_matchesQueryHandle);
  }
}

void sdkSearchTextsliceReleaseFfiHandle(Pointer<Void> handle) => _sdkSearchTextsliceReleaseHandle(handle);

// Nullable TextSlice

final _sdkSearchTextsliceCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_TextSlice_create_handle_nullable'));
final _sdkSearchTextsliceReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_TextSlice_release_handle_nullable'));
final _sdkSearchTextsliceGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_TextSlice_get_value_nullable'));

Pointer<Void> sdkSearchTextsliceToFfiNullable(TextSlice? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkSearchTextsliceToFfi(value);
  final result = _sdkSearchTextsliceCreateHandleNullable(_handle);
  sdkSearchTextsliceReleaseFfiHandle(_handle);
  return result;
}

TextSlice? sdkSearchTextsliceFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkSearchTextsliceGetValueNullable(handle);
  final result = sdkSearchTextsliceFromFfi(_handle);
  sdkSearchTextsliceReleaseFfiHandle(_handle);
  return result;
}

void sdkSearchTextsliceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkSearchTextsliceReleaseHandleNullable(handle);

// End of TextSlice "private" section.


