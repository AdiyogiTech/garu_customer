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

/// EVSE connector.

class EVSEConnector {
  /// HERE ID of the connector.
  String? id;

  /// CPO ID of the connector.
  String? cpoId;

  /// Connector type ID. For more information on the current connector types,
  /// see [resource-type-connector-types.html](https://www.here.com/docs/bundle/ev-charge-points-api-developer-guide/page/topics/resource-type-connector-types.html).
  String? typeId;

  /// Maximum charge power of connector in kW.
  double? maxPowerInKilowatts;

  /// Creates a new instance.

  /// [id] HERE ID of the connector.

  /// [cpoId] CPO ID of the connector.

  /// [typeId] Connector type ID. For more information on the current connector types,
  /// see [resource-type-connector-types.html](https://www.here.com/docs/bundle/ev-charge-points-api-developer-guide/page/topics/resource-type-connector-types.html).

  /// [maxPowerInKilowatts] Maximum charge power of connector in kW.

  EVSEConnector._(this.id, this.cpoId, this.typeId, this.maxPowerInKilowatts);
  EVSEConnector()
    : id = null, cpoId = null, typeId = null, maxPowerInKilowatts = null;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EVSEConnector) return false;
    EVSEConnector _other = other;
    return id == _other.id &&
        cpoId == _other.cpoId &&
        typeId == _other.typeId &&
        maxPowerInKilowatts == _other.maxPowerInKilowatts;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + id.hashCode;
    result = 31 * result + cpoId.hashCode;
    result = 31 * result + typeId.hashCode;
    result = 31 * result + maxPowerInKilowatts.hashCode;
    return result;
  }
}


// EVSEConnector "private" section, not exported.

final _sdkSearchEvseconnectorCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_create_handle'));
final _sdkSearchEvseconnectorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_release_handle'));
final _sdkSearchEvseconnectorGetFieldid = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_get_field_id'));
final _sdkSearchEvseconnectorGetFieldcpoId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_get_field_cpoId'));
final _sdkSearchEvseconnectorGetFieldtypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_get_field_typeId'));
final _sdkSearchEvseconnectorGetFieldmaxPowerInKilowatts = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_get_field_maxPowerInKilowatts'));



Pointer<Void> sdkSearchEvseconnectorToFfi(EVSEConnector value) {
  final _idHandle = stringToFfiNullable(value.id);
  final _cpoIdHandle = stringToFfiNullable(value.cpoId);
  final _typeIdHandle = stringToFfiNullable(value.typeId);
  final _maxPowerInKilowattsHandle = doubleToFfiNullable(value.maxPowerInKilowatts);
  final _result = _sdkSearchEvseconnectorCreateHandle(_idHandle, _cpoIdHandle, _typeIdHandle, _maxPowerInKilowattsHandle);
  stringReleaseFfiHandleNullable(_idHandle);
  stringReleaseFfiHandleNullable(_cpoIdHandle);
  stringReleaseFfiHandleNullable(_typeIdHandle);
  doubleReleaseFfiHandleNullable(_maxPowerInKilowattsHandle);
  return _result;
}

EVSEConnector sdkSearchEvseconnectorFromFfi(Pointer<Void> handle) {
  final _idHandle = _sdkSearchEvseconnectorGetFieldid(handle);
  final _cpoIdHandle = _sdkSearchEvseconnectorGetFieldcpoId(handle);
  final _typeIdHandle = _sdkSearchEvseconnectorGetFieldtypeId(handle);
  final _maxPowerInKilowattsHandle = _sdkSearchEvseconnectorGetFieldmaxPowerInKilowatts(handle);
  try {
    return EVSEConnector._(
      stringFromFfiNullable(_idHandle), 
      stringFromFfiNullable(_cpoIdHandle), 
      stringFromFfiNullable(_typeIdHandle), 
      doubleFromFfiNullable(_maxPowerInKilowattsHandle)
    );
  } finally {
    stringReleaseFfiHandleNullable(_idHandle);
    stringReleaseFfiHandleNullable(_cpoIdHandle);
    stringReleaseFfiHandleNullable(_typeIdHandle);
    doubleReleaseFfiHandleNullable(_maxPowerInKilowattsHandle);
  }
}

void sdkSearchEvseconnectorReleaseFfiHandle(Pointer<Void> handle) => _sdkSearchEvseconnectorReleaseHandle(handle);

// Nullable EVSEConnector

final _sdkSearchEvseconnectorCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_create_handle_nullable'));
final _sdkSearchEvseconnectorReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_release_handle_nullable'));
final _sdkSearchEvseconnectorGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_EVSEConnector_get_value_nullable'));

Pointer<Void> sdkSearchEvseconnectorToFfiNullable(EVSEConnector? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkSearchEvseconnectorToFfi(value);
  final result = _sdkSearchEvseconnectorCreateHandleNullable(_handle);
  sdkSearchEvseconnectorReleaseFfiHandle(_handle);
  return result;
}

EVSEConnector? sdkSearchEvseconnectorFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkSearchEvseconnectorGetValueNullable(handle);
  final result = sdkSearchEvseconnectorFromFfi(_handle);
  sdkSearchEvseconnectorReleaseFfiHandle(_handle);
  return result;
}

void sdkSearchEvseconnectorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkSearchEvseconnectorReleaseHandleNullable(handle);

// End of EVSEConnector "private" section.


