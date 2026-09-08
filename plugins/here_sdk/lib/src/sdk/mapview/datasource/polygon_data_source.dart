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
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/polygon_data_accessor.dart';

/// Polygon data source allows the rendering engine access to the user provided
/// polygons geometry and their attributes.
///
/// Polygon segments are rendered following the shortest path between their end points.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class PolygonDataSource {

  /// Adds a new polygon to the data source.
  ///
  /// [polygon] Polygon to add.
  ///
  void add(PolygonData polygon);
  /// Adds new polygons to the data source.
  ///
  /// [polygons] Polygons to add.
  ///
  void addPolygons(List<PolygonData> polygons);
  /// Removes all polygons from the data source.
  ///
  void removeAll();
  /// Iterates through all the polygons from the data source and passes them to the
  /// given processor, one by one.
  ///
  /// The processor can update the polygon data.
  ///
  /// The iteration stops after all polygons have been processed or the processor returns false
  /// from the process call.
  ///
  /// [processor] Polygon processor.
  ///
  void forEach(PolygonDataSourcePolygonDataProcessor processor);
  /// Iterates through all the polygons from the data source and passes them to the
  /// given inspector, one by one.
  ///
  /// All polygons for which the inspector returns true get removed from the data source.
  /// The inspector cannot update the polygon data.
  ///
  /// [inspector] Polygon inspector.
  ///
  void removeIf(PolygonDataSourcePolygonDataProcessor inspector);
  /// Frees all internally used resources.
  ///
  /// After calling this method, the object
  /// is not usable anymore.
  ///
  void destroy();
}

/// Called for each polygon, allowing inspection, removal or update of geometry and attributes.
///
/// [p0] the polygon data accessor.
///
/// Returns value indicating the result of the processing.
typedef PolygonDataSourcePolygonDataProcessor = bool Function(PolygonDataAccessor);

// PolygonDataSourcePolygonDataProcessor "private" section, not exported.

final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_register_finalizer'));
final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_copy_handle'));
final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_release_handle'));
final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_create_proxy'));

class PolygonDataSourcePolygonDataProcessor$Impl {
  final Pointer<Void> handle;
  PolygonDataSourcePolygonDataProcessor$Impl(this.handle);

  bool call(PolygonDataAccessor p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint8 Function(Pointer<Void>, Int32, Pointer<Void>), int Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_call__PolygonDataAccessor'));
    final _p0Handle = sdkMapviewDatasourcePolygondataaccessorToFfi(p0);
    final _handle = this.handle;
    final __resultHandle = _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewDatasourcePolygondataaccessorReleaseFfiHandle(_p0Handle);
    try {
      return booleanFromFfi(__resultHandle);
    } finally {
      booleanReleaseFfiHandle(__resultHandle);

    }

  }

}

int _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorcallStatic(Object _obj, Pointer<Void> p0, Pointer<Uint8> _result) {
  bool? _resultObject;
  try {
    _resultObject = (_obj as PolygonDataSourcePolygonDataProcessor)(sdkMapviewDatasourcePolygondataaccessorFromFfi(p0));
    _result.value = booleanToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourcePolygondataaccessorReleaseFfiHandle(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewDatasourcePolygondatasourcePolygondataprocessorToFfi(PolygonDataSourcePolygonDataProcessor value) =>
  _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>, Pointer<Uint8>)>(_sdkMapviewDatasourcePolygondatasourcePolygondataprocessorcallStatic, __lib.unknownError)
  );

PolygonDataSourcePolygonDataProcessor sdkMapviewDatasourcePolygondatasourcePolygondataprocessorFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorCopyHandle(handle);
  final _impl = PolygonDataSourcePolygonDataProcessor$Impl(_copiedHandle);
  final result = (PolygonDataAccessor p0) => _impl.call(p0);
  _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseHandle(handle);

// Nullable PolygonDataSourcePolygonDataProcessor

final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_create_handle_nullable'));
final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_release_handle_nullable'));
final _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_PolygonDataProcessor_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourcePolygondatasourcePolygondataprocessorToFfiNullable(PolygonDataSourcePolygonDataProcessor? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourcePolygondatasourcePolygondataprocessorToFfi(value);
  final result = _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorCreateHandleNullable(_handle);
  sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseFfiHandle(_handle);
  return result;
}

PolygonDataSourcePolygonDataProcessor? sdkMapviewDatasourcePolygondatasourcePolygondataprocessorFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorGetValueNullable(handle);
  final result = sdkMapviewDatasourcePolygondatasourcePolygondataprocessorFromFfi(_handle);
  sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseHandleNullable(handle);

// End of PolygonDataSourcePolygonDataProcessor "private" section.

// PolygonDataSource "private" section, not exported.

final _sdkMapviewDatasourcePolygondatasourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_register_finalizer'));
final _sdkMapviewDatasourcePolygondatasourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_copy_handle'));
final _sdkMapviewDatasourcePolygondatasourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_PolygonDataSource_release_handle'));








class PolygonDataSource$Impl extends __lib.NativeBase implements PolygonDataSource {

  PolygonDataSource$Impl(Pointer<Void> handle) : super(handle);

  @override
  void add(PolygonData polygon) {
    final _addFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_add__PolygonData'));
    final _polygonHandle = sdkMapviewDatasourcePolygondataToFfi(polygon);
    final _handle = this.handle;
    _addFfi(_handle, __lib.LibraryContext.isolateId, _polygonHandle);
    sdkMapviewDatasourcePolygondataReleaseFfiHandle(_polygonHandle);

  }

  @override
  void addPolygons(List<PolygonData> polygons) {
    final _addPolygonsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_add__ListOf_sdk_mapview_datasource_PolygonData'));
    final _polygonsHandle = harpSdkBindingslistofSdkMapviewDatasourcePolygondataToFfi(polygons);
    final _handle = this.handle;
    _addPolygonsFfi(_handle, __lib.LibraryContext.isolateId, _polygonsHandle);
    harpSdkBindingslistofSdkMapviewDatasourcePolygondataReleaseFfiHandle(_polygonsHandle);

  }

  @override
  void removeAll() {
    final _removeAllFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_removeAll'));
    final _handle = this.handle;
    _removeAllFfi(_handle, __lib.LibraryContext.isolateId);

  }

  @override
  void forEach(PolygonDataSourcePolygonDataProcessor processor) {
    final _forEachFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_forEach__PolygonDataProcessor'));
    final _processorHandle = sdkMapviewDatasourcePolygondatasourcePolygondataprocessorToFfi(processor);
    final _handle = this.handle;
    _forEachFfi(_handle, __lib.LibraryContext.isolateId, _processorHandle);
    sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseFfiHandle(_processorHandle);

  }

  @override
  void removeIf(PolygonDataSourcePolygonDataProcessor inspector) {
    final _removeIfFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_removeIf__PolygonDataProcessor'));
    final _inspectorHandle = sdkMapviewDatasourcePolygondatasourcePolygondataprocessorToFfi(inspector);
    final _handle = this.handle;
    _removeIfFfi(_handle, __lib.LibraryContext.isolateId, _inspectorHandle);
    sdkMapviewDatasourcePolygondatasourcePolygondataprocessorReleaseFfiHandle(_inspectorHandle);

  }

  @override
  void destroy() {
    final _destroyFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_PolygonDataSource_destroy'));
    final _handle = this.handle;
    _destroyFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewDatasourcePolygondatasourceToFfi(PolygonDataSource value) =>
  _sdkMapviewDatasourcePolygondatasourceCopyHandle((value as __lib.NativeBase).handle);

PolygonDataSource sdkMapviewDatasourcePolygondatasourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is PolygonDataSource) return instance;

  final _copiedHandle = _sdkMapviewDatasourcePolygondatasourceCopyHandle(handle);
  final result = PolygonDataSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourcePolygondatasourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourcePolygondatasourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatasourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourcePolygondatasourceToFfiNullable(PolygonDataSource? value) =>
  value != null ? sdkMapviewDatasourcePolygondatasourceToFfi(value) : Pointer<Void>.fromAddress(0);

PolygonDataSource? sdkMapviewDatasourcePolygondatasourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourcePolygondatasourceFromFfi(handle) : null;

void sdkMapviewDatasourcePolygondatasourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourcePolygondatasourceReleaseHandle(handle);

// End of PolygonDataSource "private" section.


