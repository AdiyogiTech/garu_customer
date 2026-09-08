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
import 'package:here_sdk/src/sdk/mapview/datasource/data_attribute_value.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes.dart';
import 'package:meta/meta.dart';

/// Data attributes collection builder.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class DataAttributesBuilder {
  /// Creates a data attributes builder instance.
  ///
  factory DataAttributesBuilder() => $prototype.create();

  /// Configures the builder to add the given attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  /// Returns [DataAttributesBuilder]. This data attributes builder instance.
  ///
  DataAttributesBuilder withString(String name, String value);
  /// Configures the builder to add the given attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  /// Returns [DataAttributesBuilder]. This data attributes builder instance.
  ///
  DataAttributesBuilder withLong(String name, int value);
  /// Configures the builder to add the given attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  /// Returns [DataAttributesBuilder]. This data attributes builder instance.
  ///
  DataAttributesBuilder withFloat(String name, double value);
  /// Configures the builder to add the given attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  /// Returns [DataAttributesBuilder]. This data attributes builder instance.
  ///
  DataAttributesBuilder withDouble(String name, double value);
  /// Configures the builder to add the given attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  /// Returns [DataAttributesBuilder]. This data attributes builder instance.
  ///
  DataAttributesBuilder withBoolean(String name, bool value);
  /// Configures the builder to add the given attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  /// Returns [DataAttributesBuilder]. This data attributes builder instance.
  ///
  DataAttributesBuilder withDataAttributeValue(String name, DataAttributeValue value);
  /// Builds instance of DataAttributes.
  ///
  /// Returns [DataAttributes]. Instance of the data attributes created with the given attributes.
  ///
  DataAttributes build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = DataAttributesBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// DataAttributesBuilder "private" section, not exported.

final _sdkMapviewDatasourceDataattributesbuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_register_finalizer'));
final _sdkMapviewDatasourceDataattributesbuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_copy_handle'));
final _sdkMapviewDatasourceDataattributesbuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_release_handle'));










/// @nodoc
@visibleForTesting
class DataAttributesBuilder$Impl extends __lib.NativeBase implements DataAttributesBuilder {

  DataAttributesBuilder$Impl(Pointer<Void> handle) : super(handle);


  DataAttributesBuilder create() {
    final _result_handle = _create();
    final _result = DataAttributesBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceDataattributesbuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create() {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_create'));
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId);
    return __resultHandle;
  }

  @override
  DataAttributesBuilder withString(String name, String value) {
    final _withStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_with__String_String'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = stringToFfi(value);
    final _handle = this.handle;
    final __resultHandle = _withStringFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    stringReleaseFfiHandle(_valueHandle);
    try {
      return sdkMapviewDatasourceDataattributesbuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesBuilder withLong(String name, int value) {
    final _withLongFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Int64), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_with__String_Long'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = (value);
    final _handle = this.handle;
    final __resultHandle = _withLongFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);

    try {
      return sdkMapviewDatasourceDataattributesbuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesBuilder withFloat(String name, double value) {
    final _withFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Float), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, double)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_with__String_Float'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = (value);
    final _handle = this.handle;
    final __resultHandle = _withFloatFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);

    try {
      return sdkMapviewDatasourceDataattributesbuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesBuilder withDouble(String name, double value) {
    final _withDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Double), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, double)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_with__String_Double'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = (value);
    final _handle = this.handle;
    final __resultHandle = _withDoubleFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);

    try {
      return sdkMapviewDatasourceDataattributesbuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesBuilder withBoolean(String name, bool value) {
    final _withBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Uint8), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_with__String_Boolean'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = booleanToFfi(value);
    final _handle = this.handle;
    final __resultHandle = _withBooleanFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    booleanReleaseFfiHandle(_valueHandle);
    try {
      return sdkMapviewDatasourceDataattributesbuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributesBuilder withDataAttributeValue(String name, DataAttributeValue value) {
    final _withDataAttributeValueFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_with__String_DataAttributeValue'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = sdkMapviewDatasourceDataattributevalueToFfi(value);
    final _handle = this.handle;
    final __resultHandle = _withDataAttributeValueFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    sdkMapviewDatasourceDataattributevalueReleaseFfiHandle(_valueHandle);
    try {
      return sdkMapviewDatasourceDataattributesbuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributes build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceDataattributesFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributesReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourceDataattributesbuilderToFfi(DataAttributesBuilder value) =>
  _sdkMapviewDatasourceDataattributesbuilderCopyHandle((value as __lib.NativeBase).handle);

DataAttributesBuilder sdkMapviewDatasourceDataattributesbuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is DataAttributesBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourceDataattributesbuilderCopyHandle(handle);
  final result = DataAttributesBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceDataattributesbuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesbuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceDataattributesbuilderToFfiNullable(DataAttributesBuilder? value) =>
  value != null ? sdkMapviewDatasourceDataattributesbuilderToFfi(value) : Pointer<Void>.fromAddress(0);

DataAttributesBuilder? sdkMapviewDatasourceDataattributesbuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceDataattributesbuilderFromFfi(handle) : null;

void sdkMapviewDatasourceDataattributesbuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesbuilderReleaseHandle(handle);

// End of DataAttributesBuilder "private" section.


