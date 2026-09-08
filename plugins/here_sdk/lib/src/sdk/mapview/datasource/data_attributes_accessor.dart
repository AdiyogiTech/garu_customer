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
import 'package:here_sdk/src/_type_repository.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attribute_value.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes_base.dart';

/// Accessor used for manipulating data attributes.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class DataAttributesAccessor implements DataAttributesBase {

  /// Adds or replaces a string attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  void addOrReplaceString(String name, String value);
  /// Adds or replaces a 64-bits integer attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  void addOrReplaceLong(String name, int value);
  /// Adds or replaces a single precision floating decimal attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  void addOrReplaceFloat(String name, double value);
  /// Adds or replaces a double precision floating decimal attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  void addOrReplaceDouble(String name, double value);
  /// Adds or replaces a boolean attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  void addOrReplaceBoolean(String name, bool value);
  /// Adds or replaces an attribute.
  ///
  /// [name] Attribute name.
  ///
  /// [value] Attribute value.
  ///
  void addOrReplace(String name, DataAttributeValue value);
  /// Removes an attribute by name.
  ///
  /// [name] Attribute name.
  ///
  void remove(String name);
  /// Removes all attributes.
  ///
  void removeAll();
}


// DataAttributesAccessor "private" section, not exported.

final _sdkMapviewDatasourceDataattributesaccessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_register_finalizer'));
final _sdkMapviewDatasourceDataattributesaccessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_copy_handle'));
final _sdkMapviewDatasourceDataattributesaccessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_release_handle'));
final _sdkMapviewDatasourceDataattributesaccessorGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_get_type_id'));










class DataAttributesAccessor$Impl extends __lib.NativeBase implements DataAttributesAccessor {

  DataAttributesAccessor$Impl(Pointer<Void> handle) : super(handle);

  @override
  void addOrReplaceString(String name, String value) {
    final _addOrReplaceStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_addOrReplace__String_String'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = stringToFfi(value);
    final _handle = this.handle;
    _addOrReplaceStringFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    stringReleaseFfiHandle(_valueHandle);

  }

  @override
  void addOrReplaceLong(String name, int value) {
    final _addOrReplaceLongFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Int64), void Function(Pointer<Void>, int, Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_addOrReplace__String_Long'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = (value);
    final _handle = this.handle;
    _addOrReplaceLongFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);


  }

  @override
  void addOrReplaceFloat(String name, double value) {
    final _addOrReplaceFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Float), void Function(Pointer<Void>, int, Pointer<Void>, double)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_addOrReplace__String_Float'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = (value);
    final _handle = this.handle;
    _addOrReplaceFloatFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);


  }

  @override
  void addOrReplaceDouble(String name, double value) {
    final _addOrReplaceDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Double), void Function(Pointer<Void>, int, Pointer<Void>, double)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_addOrReplace__String_Double'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = (value);
    final _handle = this.handle;
    _addOrReplaceDoubleFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);


  }

  @override
  void addOrReplaceBoolean(String name, bool value) {
    final _addOrReplaceBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Uint8), void Function(Pointer<Void>, int, Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_addOrReplace__String_Boolean'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = booleanToFfi(value);
    final _handle = this.handle;
    _addOrReplaceBooleanFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    booleanReleaseFfiHandle(_valueHandle);

  }

  @override
  void addOrReplace(String name, DataAttributeValue value) {
    final _addOrReplaceFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_addOrReplace__String_DataAttributeValue'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = sdkMapviewDatasourceDataattributevalueToFfi(value);
    final _handle = this.handle;
    _addOrReplaceFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    sdkMapviewDatasourceDataattributevalueReleaseFfiHandle(_valueHandle);

  }

  @override
  void remove(String name) {
    final _removeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_remove__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    _removeFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);

  }

  @override
  void removeAll() {
    final _removeAllFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_removeAll'));
    final _handle = this.handle;
    _removeAllFfi(_handle, __lib.LibraryContext.isolateId);

  }

  @override
  List<String> getAttributeNames() {
    final _getAttributeNamesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getAttributeNames'));
    final _handle = this.handle;
    final __resultHandle = _getAttributeNamesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofStringFromFfi(__resultHandle);
    } finally {
      harpSdkBindingslistofStringReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  DataAttributeValueValueType? getValueType(String name) {
    final _getValueTypeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getValueType__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getValueTypeFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return sdkMapviewDatasourceDataattributevalueValuetypeFromFfiNullable(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributevalueValuetypeReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  String? getAsString(String name) {
    final _getAsStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getAsString__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getAsStringFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return stringFromFfiNullable(__resultHandle);
    } finally {
      stringReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  String? getString(String name) {
    final _getStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getString__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getStringFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return stringFromFfiNullable(__resultHandle);
    } finally {
      stringReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  int? getInt64(String name) {
    final _getInt64Ffi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getInt64__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getInt64Ffi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return longFromFfiNullable(__resultHandle);
    } finally {
      longReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  double? getFloat(String name) {
    final _getFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getFloat__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getFloatFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return floatFromFfiNullable(__resultHandle);
    } finally {
      floatReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  double? getDouble(String name) {
    final _getDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getDouble__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getDoubleFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return doubleFromFfiNullable(__resultHandle);
    } finally {
      doubleReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  bool? getBoolean(String name) {
    final _getBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getBoolean__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getBooleanFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return booleanFromFfiNullable(__resultHandle);
    } finally {
      booleanReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  DataAttributeValue? getValue(String name) {
    final _getValueFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesAccessor_getValue__String'));
    final _nameHandle = stringToFfi(name);
    final _handle = this.handle;
    final __resultHandle = _getValueFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle);
    stringReleaseFfiHandle(_nameHandle);
    try {
      return sdkMapviewDatasourceDataattributevalueFromFfiNullable(__resultHandle);
    } finally {
      sdkMapviewDatasourceDataattributevalueReleaseFfiHandleNullable(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourceDataattributesaccessorToFfi(DataAttributesAccessor value) =>
  _sdkMapviewDatasourceDataattributesaccessorCopyHandle((value as __lib.NativeBase).handle);

DataAttributesAccessor sdkMapviewDatasourceDataattributesaccessorFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is DataAttributesAccessor) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceDataattributesaccessorGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceDataattributesaccessorCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : DataAttributesAccessor$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceDataattributesaccessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceDataattributesaccessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesaccessorReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceDataattributesaccessorToFfiNullable(DataAttributesAccessor? value) =>
  value != null ? sdkMapviewDatasourceDataattributesaccessorToFfi(value) : Pointer<Void>.fromAddress(0);

DataAttributesAccessor? sdkMapviewDatasourceDataattributesaccessorFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceDataattributesaccessorFromFfi(handle) : null;

void sdkMapviewDatasourceDataattributesaccessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesaccessorReleaseHandle(handle);

// End of DataAttributesAccessor "private" section.


