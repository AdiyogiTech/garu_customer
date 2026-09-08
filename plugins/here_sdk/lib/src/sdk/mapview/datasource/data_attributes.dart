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

/// Data attributes collection.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class DataAttributes implements DataAttributesBase {

}


// DataAttributes "private" section, not exported.

final _sdkMapviewDatasourceDataattributesRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_DataAttributes_register_finalizer'));
final _sdkMapviewDatasourceDataattributesCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributes_copy_handle'));
final _sdkMapviewDatasourceDataattributesReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributes_release_handle'));
final _sdkMapviewDatasourceDataattributesGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributes_get_type_id'));


class DataAttributes$Impl extends __lib.NativeBase implements DataAttributes {

  DataAttributes$Impl(Pointer<Void> handle) : super(handle);

  @override
  List<String> getAttributeNames() {
    final _getAttributeNamesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributes_getAttributeNames'));
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
    final _getValueTypeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getValueType__String'));
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
    final _getAsStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getAsString__String'));
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
    final _getStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getString__String'));
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
    final _getInt64Ffi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getInt64__String'));
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
    final _getFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getFloat__String'));
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
    final _getDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getDouble__String'));
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
    final _getBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getBoolean__String'));
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
    final _getValueFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributes_getValue__String'));
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

Pointer<Void> sdkMapviewDatasourceDataattributesToFfi(DataAttributes value) =>
  _sdkMapviewDatasourceDataattributesCopyHandle((value as __lib.NativeBase).handle);

DataAttributes sdkMapviewDatasourceDataattributesFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is DataAttributes) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceDataattributesGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceDataattributesCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : DataAttributes$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceDataattributesRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceDataattributesReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceDataattributesToFfiNullable(DataAttributes? value) =>
  value != null ? sdkMapviewDatasourceDataattributesToFfi(value) : Pointer<Void>.fromAddress(0);

DataAttributes? sdkMapviewDatasourceDataattributesFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceDataattributesFromFfi(handle) : null;

void sdkMapviewDatasourceDataattributesReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesReleaseHandle(handle);

// End of DataAttributes "private" section.


