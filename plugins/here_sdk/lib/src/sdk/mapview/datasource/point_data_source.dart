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
import 'package:here_sdk/src/sdk/mapview/datasource/point_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/point_data_accessor.dart';

/// Point data source allows the rendering engine access to the user provided
/// geographical locations and their attributes.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PointDataSource {

  /// Adds a new point to the data source.
  ///
  /// Altitude of the point coordinates is ignored.
  ///
  /// [point] Point to be added.
  ///
  void add(PointData point);
  /// Adds new points to the data source.
  ///
  /// Altitude of the points coordinates is ignored.
  ///
  /// [points] Point positions.
  ///
  void addPoints(List<PointData> points);
  /// Removes all points from the data source.
  ///
  void removeAll();
  /// Iterates through all the points from the data source and passes them to the
  /// given processor, one by one.
  ///
  /// The processor can update the point data.
  ///
  /// The iteration stops after all points have been processed or the processor returns false
  /// from the process call.
  ///
  /// [processor] Point data processor.
  ///
  void forEach(PointDataSourcePointDataProcessor processor);
  /// Iterates through all the points from the data source and passes them to the
  /// given inspector, one by one.
  ///
  /// All points for which the inspector returns true get removed from the data source.
  /// The inspector cannot update the point data.
  ///
  /// [processor] Point data inspector.
  ///
  void removeIf(PointDataSourcePointDataProcessor processor);
  /// Frees all internally used resources.
  ///
  /// After calling this method, the object
  /// is not usable anymore.
  ///
  void destroy();
}

/// Called for each point, allowing inspection, removal or update of coordinates and attributes.
///
/// [p0] the point data accessor.
///
/// Returns value indicating the result of the processing.
typedef PointDataSourcePointDataProcessor = bool Function(PointDataAccessor);

// PointDataSourcePointDataProcessor "private" section, not exported.

final _sdkMapviewDatasourcePointdatasourcePointdataprocessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_register_finalizer'));
final _sdkMapviewDatasourcePointdatasourcePointdataprocessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_copy_handle'));
final _sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_release_handle'));
final _sdkMapviewDatasourcePointdatasourcePointdataprocessorCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_create_proxy'));

class PointDataSourcePointDataProcessor$Impl {
  final Pointer<Void> handle;
  PointDataSourcePointDataProcessor$Impl(this.handle);

  bool call(PointDataAccessor p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint8 Function(Pointer<Void>, Int32, Pointer<Void>), int Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_call__PointDataAccessor'));
    final _p0Handle = sdkMapviewDatasourcePointdataaccessorToFfi(p0);
    final _handle = this.handle;
    final __resultHandle = _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewDatasourcePointdataaccessorReleaseFfiHandle(_p0Handle);
    try {
      return booleanFromFfi(__resultHandle);
    } finally {
      booleanReleaseFfiHandle(__resultHandle);

    }

  }

}

int _sdkMapviewDatasourcePointdatasourcePointdataprocessorcallStatic(Object _obj, Pointer<Void> p0, Pointer<Uint8> _result) {
  bool? _resultObject;
  try {
    _resultObject = (_obj as PointDataSourcePointDataProcessor)(sdkMapviewDatasourcePointdataaccessorFromFfi(p0));
    _result.value = booleanToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourcePointdataaccessorReleaseFfiHandle(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewDatasourcePointdatasourcePointdataprocessorToFfi(PointDataSourcePointDataProcessor value) =>
  _sdkMapviewDatasourcePointdatasourcePointdataprocessorCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>, Pointer<Uint8>)>(_sdkMapviewDatasourcePointdatasourcePointdataprocessorcallStatic, __lib.unknownError)
  );

PointDataSourcePointDataProcessor sdkMapviewDatasourcePointdatasourcePointdataprocessorFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewDatasourcePointdatasourcePointdataprocessorCopyHandle(handle);
  final _impl = PointDataSourcePointDataProcessor$Impl(_copiedHandle);
  final result = (PointDataAccessor p0) => _impl.call(p0);
  _sdkMapviewDatasourcePointdatasourcePointdataprocessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseHandle(handle);

// Nullable PointDataSourcePointDataProcessor

final _sdkMapviewDatasourcePointdatasourcePointdataprocessorCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_create_handle_nullable'));
final _sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_release_handle_nullable'));
final _sdkMapviewDatasourcePointdatasourcePointdataprocessorGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_PointDataProcessor_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourcePointdatasourcePointdataprocessorToFfiNullable(PointDataSourcePointDataProcessor? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourcePointdatasourcePointdataprocessorToFfi(value);
  final result = _sdkMapviewDatasourcePointdatasourcePointdataprocessorCreateHandleNullable(_handle);
  sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseFfiHandle(_handle);
  return result;
}

PointDataSourcePointDataProcessor? sdkMapviewDatasourcePointdatasourcePointdataprocessorFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourcePointdatasourcePointdataprocessorGetValueNullable(handle);
  final result = sdkMapviewDatasourcePointdatasourcePointdataprocessorFromFfi(_handle);
  sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseHandleNullable(handle);

// End of PointDataSourcePointDataProcessor "private" section.

// PointDataSource "private" section, not exported.

final _sdkMapviewDatasourcePointdatasourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_register_finalizer'));
final _sdkMapviewDatasourcePointdatasourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_copy_handle'));
final _sdkMapviewDatasourcePointdatasourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PointDataSource_release_handle'));








class PointDataSource$Impl extends __lib.NativeBase implements PointDataSource {

  PointDataSource$Impl(Pointer<Void> handle) : super(handle);

  @override
  void add(PointData point) {
    final _addFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSource_add__PointData'));
    final _pointHandle = sdkMapviewDatasourcePointdataToFfi(point);
    final _handle = this.handle;
    _addFfi(_handle, __lib.LibraryContext.isolateId, _pointHandle);
    sdkMapviewDatasourcePointdataReleaseFfiHandle(_pointHandle);

  }

  @override
  void addPoints(List<PointData> points) {
    final _addPointsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSource_add__ListOf_sdk_mapview_datasource_PointData'));
    final _pointsHandle = harpSdkBindingslistofSdkMapviewDatasourcePointdataToFfi(points);
    final _handle = this.handle;
    _addPointsFfi(_handle, __lib.LibraryContext.isolateId, _pointsHandle);
    harpSdkBindingslistofSdkMapviewDatasourcePointdataReleaseFfiHandle(_pointsHandle);

  }

  @override
  void removeAll() {
    final _removeAllFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointDataSource_removeAll'));
    final _handle = this.handle;
    _removeAllFfi(_handle, __lib.LibraryContext.isolateId);

  }

  @override
  void forEach(PointDataSourcePointDataProcessor processor) {
    final _forEachFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSource_forEach__PointDataProcessor'));
    final _processorHandle = sdkMapviewDatasourcePointdatasourcePointdataprocessorToFfi(processor);
    final _handle = this.handle;
    _forEachFfi(_handle, __lib.LibraryContext.isolateId, _processorHandle);
    sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseFfiHandle(_processorHandle);

  }

  @override
  void removeIf(PointDataSourcePointDataProcessor processor) {
    final _removeIfFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PointDataSource_removeIf__PointDataProcessor'));
    final _processorHandle = sdkMapviewDatasourcePointdatasourcePointdataprocessorToFfi(processor);
    final _handle = this.handle;
    _removeIfFfi(_handle, __lib.LibraryContext.isolateId, _processorHandle);
    sdkMapviewDatasourcePointdatasourcePointdataprocessorReleaseFfiHandle(_processorHandle);

  }

  @override
  void destroy() {
    final _destroyFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PointDataSource_destroy'));
    final _handle = this.handle;
    _destroyFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewDatasourcePointdatasourceToFfi(PointDataSource value) =>
  _sdkMapviewDatasourcePointdatasourceCopyHandle((value as __lib.NativeBase).handle);

PointDataSource sdkMapviewDatasourcePointdatasourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PointDataSource) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePointdatasourceCopyHandle(handle);
  final result = PointDataSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePointdatasourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePointdatasourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatasourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePointdatasourceToFfiNullable(PointDataSource? value) =>
  value != null ? sdkMapviewDatasourcePointdatasourceToFfi(value) : Pointer<Void>.fromAddress(0);

PointDataSource? sdkMapviewDatasourcePointdatasourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePointdatasourceFromFfi(handle) : null;

void sdkMapviewDatasourcePointdatasourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePointdatasourceReleaseHandle(handle);

// End of PointDataSource "private" section.


