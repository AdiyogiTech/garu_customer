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

/// Interface for a collection of data attributes.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class DataAttributesBase {
  /// Interface for a collection of data attributes.
  ///
  /// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
  /// behavior. Related APIs may change for new releases without a deprecation process.

  factory DataAttributesBase(
    List<String> Function() getAttributeNamesLambda,
    DataAttributeValueValueType? Function(String) getValueTypeLambda,
    String? Function(String) getAsStringLambda,
    String? Function(String) getStringLambda,
    int? Function(String) getInt64Lambda,
    double? Function(String) getFloatLambda,
    double? Function(String) getDoubleLambda,
    bool? Function(String) getBooleanLambda,
    DataAttributeValue? Function(String) getValueLambda,

  ) => DataAttributesBase$Lambdas(
    getAttributeNamesLambda,
    getValueTypeLambda,
    getAsStringLambda,
    getStringLambda,
    getInt64Lambda,
    getFloatLambda,
    getDoubleLambda,
    getBooleanLambda,
    getValueLambda,

  );

  /// Returns a list of attribute names.
  ///
  /// Returns [List<String>]. The list of attribute names.
  ///
  List<String> getAttributeNames();
  /// Returns the value type of an attribute or null if it is not contained.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [DataAttributeValueValueType?]. Attribute value type or null if it is not contained.
  ///
  DataAttributeValueValueType? getValueType(String name);
  /// Gets the value of an attribute as a string or null if it is not contained.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [String?]. Attribute value.
  ///
  String? getAsString(String name);
  /// Gets the value of a string attribute or null if it is not contained or the type doesn't match.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [String?]. Attribute value.
  ///
  String? getString(String name);
  /// Gets the value of a 64-bits integer attribute or null if it is not contained or the type doesn't match.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [int?]. Attribute value.
  ///
  int? getInt64(String name);
  /// Gets the value of a single precision floating decimal attribute or null if it is not contained or the type doesn't match.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [double?]. Attribute value.
  ///
  double? getFloat(String name);
  /// Gets the value of a double precision floating decimal attribute or null if it is not contained or the type doesn't match.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [double?]. Attribute value.
  ///
  double? getDouble(String name);
  /// Gets the value of a boolean attribute or null if it is not contained or the type doesn't match.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [bool?]. Attribute value.
  ///
  bool? getBoolean(String name);
  /// Gets the DataAttributeValue or null if it is not contained.
  ///
  /// [name] Attribute name.
  ///
  /// Returns [DataAttributeValue?]. Attribute value.
  ///
  DataAttributeValue? getValue(String name);
}


// DataAttributesBase "private" section, not exported.

final _sdkMapviewDatasourceDataattributesbaseRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBase_register_finalizer'));
final _sdkMapviewDatasourceDataattributesbaseCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBase_copy_handle'));
final _sdkMapviewDatasourceDataattributesbaseReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBase_release_handle'));
final _sdkMapviewDatasourceDataattributesbaseCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBase_create_proxy'));
final _sdkMapviewDatasourceDataattributesbaseGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_DataAttributesBase_get_type_id'));










class DataAttributesBase$Lambdas implements DataAttributesBase {
  List<String> Function() getAttributeNamesLambda;
  DataAttributeValueValueType? Function(String) getValueTypeLambda;
  String? Function(String) getAsStringLambda;
  String? Function(String) getStringLambda;
  int? Function(String) getInt64Lambda;
  double? Function(String) getFloatLambda;
  double? Function(String) getDoubleLambda;
  bool? Function(String) getBooleanLambda;
  DataAttributeValue? Function(String) getValueLambda;

  DataAttributesBase$Lambdas(
    this.getAttributeNamesLambda,
    this.getValueTypeLambda,
    this.getAsStringLambda,
    this.getStringLambda,
    this.getInt64Lambda,
    this.getFloatLambda,
    this.getDoubleLambda,
    this.getBooleanLambda,
    this.getValueLambda,

  );

  @override
  List<String> getAttributeNames() =>
    getAttributeNamesLambda();
  @override
  DataAttributeValueValueType? getValueType(String name) =>
    getValueTypeLambda(name);
  @override
  String? getAsString(String name) =>
    getAsStringLambda(name);
  @override
  String? getString(String name) =>
    getStringLambda(name);
  @override
  int? getInt64(String name) =>
    getInt64Lambda(name);
  @override
  double? getFloat(String name) =>
    getFloatLambda(name);
  @override
  double? getDouble(String name) =>
    getDoubleLambda(name);
  @override
  bool? getBoolean(String name) =>
    getBooleanLambda(name);
  @override
  DataAttributeValue? getValue(String name) =>
    getValueLambda(name);
}

class DataAttributesBase$Impl extends __lib.NativeBase implements DataAttributesBase {

  DataAttributesBase$Impl(Pointer<Void> handle) : super(handle);

  @override
  List<String> getAttributeNames() {
    final _getAttributeNamesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getAttributeNames'));
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
    final _getValueTypeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getValueType__String'));
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
    final _getAsStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getAsString__String'));
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
    final _getStringFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getString__String'));
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
    final _getInt64Ffi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getInt64__String'));
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
    final _getFloatFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getFloat__String'));
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
    final _getDoubleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getDouble__String'));
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
    final _getBooleanFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getBoolean__String'));
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
    final _getValueFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_DataAttributesBase_getValue__String'));
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

int _sdkMapviewDatasourceDataattributesbasegetAttributeNamesStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  List<String>? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getAttributeNames();
    _result.value = harpSdkBindingslistofStringToFfi(_resultObject);
  } finally {
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetValueTypeStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  DataAttributeValueValueType? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getValueType(stringFromFfi(name));
    _result.value = sdkMapviewDatasourceDataattributevalueValuetypeToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetAsStringStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  String? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getAsString(stringFromFfi(name));
    _result.value = stringToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetStringStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  String? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getString(stringFromFfi(name));
    _result.value = stringToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetInt64Static(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  int? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getInt64(stringFromFfi(name));
    _result.value = longToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetFloatStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  double? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getFloat(stringFromFfi(name));
    _result.value = floatToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetDoubleStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  double? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getDouble(stringFromFfi(name));
    _result.value = doubleToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetBooleanStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  bool? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getBoolean(stringFromFfi(name));
    _result.value = booleanToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}
int _sdkMapviewDatasourceDataattributesbasegetValueStatic(Object _obj, Pointer<Void> name, Pointer<Pointer<Void>> _result) {
  DataAttributeValue? _resultObject;
  try {
    _resultObject = (_obj as DataAttributesBase).getValue(stringFromFfi(name));
    _result.value = sdkMapviewDatasourceDataattributevalueToFfiNullable(_resultObject);
  } finally {
    stringReleaseFfiHandle(name);
  }
  return 0;
}


Pointer<Void> sdkMapviewDatasourceDataattributesbaseToFfi(DataAttributesBase value) {
  if (value is __lib.NativeBase) return _sdkMapviewDatasourceDataattributesbaseCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewDatasourceDataattributesbaseCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetAttributeNamesStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetValueTypeStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetAsStringStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetStringStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetInt64Static, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetFloatStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetDoubleStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetBooleanStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewDatasourceDataattributesbasegetValueStatic, __lib.unknownError)
  );

  return result;
}

DataAttributesBase sdkMapviewDatasourceDataattributesbaseFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is DataAttributesBase) return instance;

  final _typeIdHandle = _sdkMapviewDatasourceDataattributesbaseGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewDatasourceDataattributesbaseCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : DataAttributesBase$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceDataattributesbaseRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceDataattributesbaseReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesbaseReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceDataattributesbaseToFfiNullable(DataAttributesBase? value) =>
  value != null ? sdkMapviewDatasourceDataattributesbaseToFfi(value) : Pointer<Void>.fromAddress(0);

DataAttributesBase? sdkMapviewDatasourceDataattributesbaseFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceDataattributesbaseFromFfi(handle) : null;

void sdkMapviewDatasourceDataattributesbaseReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceDataattributesbaseReleaseHandle(handle);

// End of DataAttributesBase "private" section.


