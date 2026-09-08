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

/// Represents a geodetic polygon with custom attributes.
///
/// Can be created using a [PolygonDataBuilder].
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonData {

}


// PolygonData "private" section, not exported.

final _sdkMapviewDatasourcePolygondataRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonData_register_finalizer'));
final _sdkMapviewDatasourcePolygondataCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonData_copy_handle'));
final _sdkMapviewDatasourcePolygondataReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonData_release_handle'));


class PolygonData$Impl extends __lib.NativeBase implements PolygonData {

  PolygonData$Impl(Pointer<Void> handle) : super(handle);


}

Pointer<Void> sdkMapviewDatasourcePolygondataToFfi(PolygonData value) =>
  _sdkMapviewDatasourcePolygondataCopyHandle((value as __lib.NativeBase).handle);

PolygonData sdkMapviewDatasourcePolygondataFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonData) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePolygondataCopyHandle(handle);
  final result = PolygonData$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygondataRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygondataReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondataReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygondataToFfiNullable(PolygonData? value) =>
  value != null ? sdkMapviewDatasourcePolygondataToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonData? sdkMapviewDatasourcePolygondataFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygondataFromFfi(handle) : null;

void sdkMapviewDatasourcePolygondataReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondataReleaseHandle(handle);

// End of PolygonData "private" section.


