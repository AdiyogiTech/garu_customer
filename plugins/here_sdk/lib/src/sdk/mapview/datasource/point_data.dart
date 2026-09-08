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

/// Represents a geodetic point with custom attributes.
///
/// Can be created using a [PointDataBuilder].
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointData {

}


// PointData "private" section, not exported.

final _sdkMapviewDatasourcePointdataRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointData_register_finalizer'));
final _sdkMapviewDatasourcePointdataCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointData_copy_handle'));
final _sdkMapviewDatasourcePointdataReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointData_release_handle'));


class PointData$Impl extends __lib.NativeBase implements PointData {

  PointData$Impl(Pointer<Void> handle) : super(handle);


}

Pointer<Void> sdkMapviewDatasourcePointdataToFfi(PointData value) =>
  _sdkMapviewDatasourcePointdataCopyHandle((value as __lib.NativeBase).handle);

PointData sdkMapviewDatasourcePointdataFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointData) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePointdataCopyHandle(handle);
  final result = PointData$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointdataRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointdataReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdataReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointdataToFfiNullable(PointData? value) =>
  value != null ? sdkMapviewDatasourcePointdataToFfi(value) : Pointer<Void>.fromAddress(0);

PointData? sdkMapviewDatasourcePointdataFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointdataFromFfi(handle) : null;

void sdkMapviewDatasourcePointdataReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdataReleaseHandle(handle);

// End of PointData "private" section.


