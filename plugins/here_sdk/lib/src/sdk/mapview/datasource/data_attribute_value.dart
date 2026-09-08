// Copyright (c) 2019-2024 HERE Global B.V. and its affiliate(s).
// All rights reserved.
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
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:meta/meta.dart';

/// Encapsulates a data attribute value.
///
/// Supports basic types and arrays of basic types.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class DataAttributeValue {
  /// Creates a string data attribute value.
  ///
  /// [value] Attribute value.
  ///
  factory DataAttributeValue.withString(String value) => $prototype.withString(value);
  /// Creates a 64-bit integer data attribute value.
  ///
  /// [value] Attribute value.
  ///
  factory DataAttributeValue.withInt64(int value) => $prototype.withInt64(value);
  /// Creates a single precision floating decimal data attribute value.
  ///
  /// [value] Attribute value.
  ///
  factory DataAttributeValue.withFloat(double value) => $prototype.withFloat(value);
  /// Creates a double precision floating decimal data attribute value.
  ///
  /// [value] Attribute value.
  ///
  factory DataAttributeValue.withDouble(double value) => $prototype.withDouble(value);
  /// Creates a boolean data attribute value.
  ///
  /// [value] Attribute value.
  ///
  factory DataAttributeValue.withBoolean(bool value) => $prototype.withBoolean(value);
  /// Creates an aggregated data attribute value.
  ///
  /// [value] Attribute value.
  ///
  factory DataAttributeValue.withArray(List<DataAttributeValue> value) => $prototype.withArray(value);

  /// Returns the type of the value.
  ///
  /// Returns [DataAttributeValueValueType]. The type of the value.
  ///
  DataAttributeValueValueType getType();
  /// Gets the string value or null if the type doesn't match.
  ///
  /// Returns [String?]. Attribute value.
  ///
  String? getString();
  /// Gets 64-bits integer value or null if the type doesn't match.
  ///
  /// Returns [int?]. Attribute value.
  ///
  int? getInt64();
  /// Gets the single precision floating decimal value or null if the type doesn't match.
  ///
  /// Returns [double?]. Attribute value.
  ///
  double? getFloat();
  /// Gets the double precision floating decimal value or null if the type doesn't match.
  ///
  /// Returns [double?]. Attribute value.
  ///
  double? getDouble();
  /// Gets the boolean value or null if the type doesn't match.
  ///
  /// Returns [bool?]. Attribute value.
  ///
  bool? getBoolean();
  /// Gets the array value or null if the type doesn't match.
  ///
  /// Returns [List<DataAttributeValue>?]. Attribute value.
  ///
  List<DataAttributeValue>? getArray();
  /// Returns a string representation of the contained value.
  ///
  /// Returns [String]. Attribute value.
  ///
  String getAsString();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = DataAttributeValue$Impl(Pointer<Void>.fromAddress(0));
}

/// Supported types of the data attribute values.
enum DataAttributeValueValueType {
    /// Value of string type.
    string,
    /// Value of 64-bit integer type.
    int64,
    /// Value of single precision float type.
    float,
    /// Value of double precision float type.
    double,
    /// Value of boolean type.
    boolean,
    /// Value of array type.
    array
}

// DataAttributeValueValueType "private" section, not exported.

int sdkMapviewDatasourceDataattributevalueValuetypeToFfi(DataAttributeValueValueType value) {
  switch (value) {
  case DataAttributeValueValueType.string:
    return 0;
  case DataAttributeValueValueType.int64:
    return 1;
  case DataAttributeValueValueType.float:
    return 2;
  case DataAttributeValueValueType.double:
    return 3;
  case DataAttributeValueValueType.boolean:
    return 4;
  case DataAttributeValueValueType.array:
    return 5;
  default:
    throw StateError("Invalid enum value $value for DataAttributeValueValueType enum.");
  }
}

DataAttributeValueValueType sdkMapviewDatasourceDataattributevalueValuetypeFromFfi(int handle) {
  switch (handle) {
  case 0:
    return DataAttributeValueValueType.string;
  case 1:
    return DataAttributeValueValueType.int64;
  case 2:
    return DataAttributeValueValueType.float;
  case 3:
    return DataAttributeValueValueType.double;
  case 4:
    return DataAttributeValueValueType.boolean;
  case 5:
    return DataAttributeValueValueType.array;
  default:
    throw StateError("Invalid numeric value $handle for DataAttributeValueValueType enum.");
  }
}

void sdkMapviewDatasourceDataattributevalueValuetypeReleaseFfiHandle(int handle) {}

final _sdkMapviewDatasourceDataattributevalueValuetypeCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_datasource_DataAttributeValue_ValueType_create_handle_nullable'));
final _sdkMapviewDatasourceDataattributevalueValuetypeReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributeValue_ValueType_release_handle_nullable'));
final _sdkMapviewDatasourceDataattributevalueValuetypeGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributeValue_ValueType_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourceDataattributevalueValuetypeToFfiNullable(DataAttributeValueValueType? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourceDataattributevalueValuetypeToFfi(value);
  final result = _sdkMapviewDatasourceDataattributevalueValuetypeCreateHandleNullable(_handle);
  sdkMapviewDatasourceDataattributevalueValuetypeReleaseFfiHandle(_handle);
  return result;
}

DataAttributeValueValueType? sdkMapviewDatasourceDataattributevalueValuetypeFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourceDataattributevalueValuetypeGetValueNullable(handle);
  final result = sdkMapviewDatasourceDataattributevalueValuetypeFromFfi(_handle);
  sdkMapviewDatasourceDataattributevalueValuetypeReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourceDataattributevalueValuetypeReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributevalueValuetypeReleaseHandleNullable(handle);

// End of DataAttributeValueValueType "private" section.

// DataAttributeValue "private" section, not exported.

final _sdkMapviewDatasourceDataattributevalueRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_DataAttributeValue_register_finalizer'));
final _sdkMapviewDatasourceDataattributevalueCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributeValue_copy_handle'));
final _sdkMapviewDatasourceDataattributevalueReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributeValue_release_handle'));
















/// @nodoc
@visibleForTesting
class DataAttributeValue$Impl extends __lib.NativeBase implements DataAttributeValue {

  DataAttributeValue$Impl(Pointer<Void> handle) : super(handle);


  DataAttributeValue withString(String value) {
    final _result_handle = _withString(value);
    final _result = DataAttributeValue$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  DataAttributeValue withInt64(int value) {
    final _result_handle = _withInt64(value);
    final _result = DataAttributeValue$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  DataAttributeValue withFloat(double value) {
    final _result_handle = _withFloat(value);
    final _result = DataAttributeValue$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  DataAttributeValue withDouble(double value) {
    final _result_handle = _withDouble(value);
    final _result = DataAttributeValue$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  DataAttributeValue withBoolean(bool value) {
    final _result_handle = _withBoolean(value);
    final _result = DataAttributeValue$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  DataAttributeValue withArray(List<DataAttributeValue> value) {
    final _result_handle = _withArray(value);
    final _result = DataAttributeValue$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _withString(String value) {
    final _withStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_make__String'));
    final _valueHandle = stringToFfi(value);
    final __resultHandle = _withStringFfi(__lib.LibraryContext.isolateId, _valueHandle);
    stringReleaseFfiHandle(_valueHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withInt64(int value) {
    final _withInt64Ffi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Int64), Pointer<Void> Function(int, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_make__Long'));
    final _valueHandle = (value);
    final __resultHandle = _withInt64Ffi(__lib.LibraryContext.isolateId, _valueHandle);

    return __resultHandle;
  }

  static Pointer<Void> _withFloat(double value) {
    final _withFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Float), Pointer<Void> Function(int, double)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_make__Float'));
    final _valueHandle = (value);
    final __resultHandle = _withFloatFfi(__lib.LibraryContext.isolateId, _valueHandle);

    return __resultHandle;
  }

  static Pointer<Void> _withDouble(double value) {
    final _withDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Double), Pointer<Void> Function(int, double)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_make__Double'));
    final _valueHandle = (value);
    final __resultHandle = _withDoubleFfi(__lib.LibraryContext.isolateId, _valueHandle);

    return __resultHandle;
  }

  static Pointer<Void> _withBoolean(bool value) {
    final _withBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Uint8), Pointer<Void> Function(int, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_make__Boolean'));
    final _valueHandle = booleanToFfi(value);
    final __resultHandle = _withBooleanFfi(__lib.LibraryContext.isolateId, _valueHandle);
    booleanReleaseFfiHandle(_valueHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withArray(List<DataAttributeValue> value) {
    final _withArrayFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_make__ListOf_sdk_mapview_datasource_DataAttributeValue'));
    final _valueHandle = harpSdkBindingslistofSdkMapviewDatasourceDataattributevalueToFfi(value);
    final __resultHandle = _withArrayFfi(__lib.LibraryContext.isolateId, _valueHandle);
    harpSdkBindingslistofSdkMapviewDatasourceDataattributevalueReleaseFfiHandle(_valueHandle);
    return __resultHandle;
  }

  @override
  DataAttributeValueValueType getType() {
    final _getTypeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getType'));
    final _handle = this.handle;
    final __resultHandle = _getTypeFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceDataattributevalueValuetypeFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributevalueValuetypeReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  String? getString() {
    final _getStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getString'));
    final _handle = this.handle;
    final __resultHandle = _getStringFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfiNullable(__resultHandle);
    } finally {
      stringReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  int? getInt64() {
    final _getInt64Ffi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getInt64'));
    final _handle = this.handle;
    final __resultHandle = _getInt64Ffi(_handle, __lib.LibraryContext.isolateId);
    try {
      return longFromFfiNullable(__resultHandle);
    } finally {
      longReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  double? getFloat() {
    final _getFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getFloat'));
    final _handle = this.handle;
    final __resultHandle = _getFloatFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return floatFromFfiNullable(__resultHandle);
    } finally {
      floatReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  double? getDouble() {
    final _getDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getDouble'));
    final _handle = this.handle;
    final __resultHandle = _getDoubleFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return doubleFromFfiNullable(__resultHandle);
    } finally {
      doubleReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  bool? getBoolean() {
    final _getBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getBoolean'));
    final _handle = this.handle;
    final __resultHandle = _getBooleanFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return booleanFromFfiNullable(__resultHandle);
    } finally {
      booleanReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  List<DataAttributeValue>? getArray() {
    final _getArrayFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getArray'));
    final _handle = this.handle;
    final __resultHandle = _getArrayFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkMapviewDatasourceDataattributevalueFromFfiNullable(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkMapviewDatasourceDataattributevalueReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  String getAsString() {
    final _getAsStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributeValue_getAsString'));
    final _handle = this.handle;
    final __resultHandle = _getAsStringFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfi(__resultHandle);
    } finally {
      stringReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourceDataattributevalueToFfi(DataAttributeValue value) =>
  _sdkMapviewDatasourceDataattributevalueCopyHandle((value as __lib.NativeBase).handle);

DataAttributeValue sdkMapviewDatasourceDataattributevalueFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is DataAttributeValue) return instance;

  final _copiedHandle = _sdkMapviewDatasourceDataattributevalueCopyHandle(handle);
  final result = DataAttributeValue$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceDataattributevalueRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceDataattributevalueReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributevalueReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceDataattributevalueToFfiNullable(DataAttributeValue? value) =>
  value != null ? sdkMapviewDatasourceDataattributevalueToFfi(value) : Pointer<Void>.fromAddress(0);

DataAttributeValue? sdkMapviewDatasourceDataattributevalueFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceDataattributevalueFromFfi(handle) : null;

void sdkMapviewDatasourceDataattributevalueReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributevalueReleaseHandle(handle);

// End of DataAttributeValue "private" section.


