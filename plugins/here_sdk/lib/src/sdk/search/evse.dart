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
import 'package:collection/collection.dart';
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/search/e_v_s_e_connector.dart';
import 'package:here_sdk/src/sdk/search/e_v_s_e_status.dart';

/// Charge Point Operator (CPO) ID uses the Electric Vehicle Supply Equipment ID (EVSE ID) for an exact identification of the charging infrastructure and charging point.
///
/// **Note:** Currently, this is a closed-alpha feature, so it is available only for selected
/// customers.
/// There could be a few bugs and unexpected behaviors.
/// **Note:** Participants of the closed-alpha group can get access from HERE to use this feature.
/// If the credentials are not enabled, a [SearchError.forbidden] will be propagated.

class Evse {
  /// HERE ID of the EVSE.
  String? id;

  /// The unique ID of an EVSE in the system of the CPO.
  /// This ID is unique in the system of the CPO but not necessarily globally unique.
  /// The format will differ between different CPOs.
  /// This ID is always provided.
  String? cpoId;

  /// Identifier in Emi3 format of the EVSE within the Charge Point Operator (CPO) platform.
  /// This id is not always present.
  /// Example of ID format: `DE*ICT*E0001897`.
  String? cpoEvseEmi3Id;

  /// EVSE status.
  EVSEStatus? status;

  /// Last update of the dynamic connector availability information.
  DateTime? lastUpdated;

  /// List of connectors of this EVSE.
  List<EVSEConnector> connectors;

  /// Creates a new instance.

  /// [id] HERE ID of the EVSE.

  /// [cpoId] The unique ID of an EVSE in the system of the CPO.
  /// This ID is unique in the system of the CPO but not necessarily globally unique.
  /// The format will differ between different CPOs.
  /// This ID is always provided.

  /// [cpoEvseEmi3Id] Identifier in Emi3 format of the EVSE within the Charge Point Operator (CPO) platform.
  /// This id is not always present.
  /// Example of ID format: `DE*ICT*E0001897`.

  /// [status] EVSE status.

  /// [lastUpdated] Last update of the dynamic connector availability information.

  /// [connectors] List of connectors of this EVSE.

  Evse._(this.id, this.cpoId, this.cpoEvseEmi3Id, this.status, this.lastUpdated, this.connectors);
  Evse()
    : id = null, cpoId = null, cpoEvseEmi3Id = null, status = null, lastUpdated = null, connectors = [];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Evse) return false;
    Evse _other = other;
    return id == _other.id &&
        cpoId == _other.cpoId &&
        cpoEvseEmi3Id == _other.cpoEvseEmi3Id &&
        status == _other.status &&
        lastUpdated == _other.lastUpdated &&
        DeepCollectionEquality().equals(connectors, _other.connectors);
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + id.hashCode;
    result = 31 * result + cpoId.hashCode;
    result = 31 * result + cpoEvseEmi3Id.hashCode;
    result = 31 * result + status.hashCode;
    result = 31 * result + lastUpdated.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(connectors);
    return result;
  }
}


// Evse "private" section, not exported.

final _sdkSearchEvseCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_search_Evse_create_handle'));
final _sdkSearchEvseReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_release_handle'));
final _sdkSearchEvseGetFieldid = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_field_id'));
final _sdkSearchEvseGetFieldcpoId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_field_cpoId'));
final _sdkSearchEvseGetFieldcpoEvseEmi3Id = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_field_cpoEvseEmi3Id'));
final _sdkSearchEvseGetFieldstatus = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_field_status'));
final _sdkSearchEvseGetFieldlastUpdated = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_field_lastUpdated'));
final _sdkSearchEvseGetFieldconnectors = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_field_connectors'));



Pointer<Void> sdkSearchEvseToFfi(Evse value) {
  final _idHandle = stringToFfiNullable(value.id);
  final _cpoIdHandle = stringToFfiNullable(value.cpoId);
  final _cpoEvseEmi3IdHandle = stringToFfiNullable(value.cpoEvseEmi3Id);
  final _statusHandle = sdkSearchEvsestatusToFfiNullable(value.status);
  final _lastUpdatedHandle = dateToFfiNullable(value.lastUpdated);
  final _connectorsHandle = heresdkSearchCommonBindingslistofSdkSearchEvseconnectorToFfi(value.connectors);
  final _result = _sdkSearchEvseCreateHandle(_idHandle, _cpoIdHandle, _cpoEvseEmi3IdHandle, _statusHandle, _lastUpdatedHandle, _connectorsHandle);
  stringReleaseFfiHandleNullable(_idHandle);
  stringReleaseFfiHandleNullable(_cpoIdHandle);
  stringReleaseFfiHandleNullable(_cpoEvseEmi3IdHandle);
  sdkSearchEvsestatusReleaseFfiHandleNullable(_statusHandle);
  dateReleaseFfiHandleNullable(_lastUpdatedHandle);
  heresdkSearchCommonBindingslistofSdkSearchEvseconnectorReleaseFfiHandle(_connectorsHandle);
  return _result;
}

Evse sdkSearchEvseFromFfi(Pointer<Void> handle) {
  final _idHandle = _sdkSearchEvseGetFieldid(handle);
  final _cpoIdHandle = _sdkSearchEvseGetFieldcpoId(handle);
  final _cpoEvseEmi3IdHandle = _sdkSearchEvseGetFieldcpoEvseEmi3Id(handle);
  final _statusHandle = _sdkSearchEvseGetFieldstatus(handle);
  final _lastUpdatedHandle = _sdkSearchEvseGetFieldlastUpdated(handle);
  final _connectorsHandle = _sdkSearchEvseGetFieldconnectors(handle);
  try {
    return Evse._(
      stringFromFfiNullable(_idHandle), 
      stringFromFfiNullable(_cpoIdHandle), 
      stringFromFfiNullable(_cpoEvseEmi3IdHandle), 
      sdkSearchEvsestatusFromFfiNullable(_statusHandle), 
      dateFromFfiNullable(_lastUpdatedHandle), 
      heresdkSearchCommonBindingslistofSdkSearchEvseconnectorFromFfi(_connectorsHandle)
    );
  } finally {
    stringReleaseFfiHandleNullable(_idHandle);
    stringReleaseFfiHandleNullable(_cpoIdHandle);
    stringReleaseFfiHandleNullable(_cpoEvseEmi3IdHandle);
    sdkSearchEvsestatusReleaseFfiHandleNullable(_statusHandle);
    dateReleaseFfiHandleNullable(_lastUpdatedHandle);
    heresdkSearchCommonBindingslistofSdkSearchEvseconnectorReleaseFfiHandle(_connectorsHandle);
  }
}

void sdkSearchEvseReleaseFfiHandle(Pointer<Void> handle) => _sdkSearchEvseReleaseHandle(handle);

// Nullable Evse

final _sdkSearchEvseCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_create_handle_nullable'));
final _sdkSearchEvseReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_release_handle_nullable'));
final _sdkSearchEvseGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_Evse_get_value_nullable'));

Pointer<Void> sdkSearchEvseToFfiNullable(Evse? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkSearchEvseToFfi(value);
  final result = _sdkSearchEvseCreateHandleNullable(_handle);
  sdkSearchEvseReleaseFfiHandle(_handle);
  return result;
}

Evse? sdkSearchEvseFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkSearchEvseGetValueNullable(handle);
  final result = sdkSearchEvseFromFfi(_handle);
  sdkSearchEvseReleaseFfiHandle(_handle);
  return result;
}

void sdkSearchEvseReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkSearchEvseReleaseHandleNullable(handle);

// End of Evse "private" section.


