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
import 'package:here_sdk/src/sdk/mapview/datasource/line_data.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/line_data_accessor.dart';

/// Polyline data source allows the rendering engine access to the user provided
/// polylines geometry and their attributes.
///
/// Polyline segments are rendered following the shortest path between their end vertices.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class LineDataSource {

  /// Adds a new line to the data source.
  ///
  /// [line] Line to add.
  ///
  void add(LineData line);
  /// Adds new lines to the data source.
  ///
  /// [lines] Lines to add.
  ///
  void addLines(List<LineData> lines);
  /// Removes all lines from the data source.
  ///
  void removeAll();
  /// Iterates through all the lines from the data source and passes them to the
  /// given processor, one by one.
  ///
  /// The processor can update the line data.
  /// The iteration stops after all lines have been processed or the processor returns false
  /// from the process call.
  ///
  /// [processor] Line processor.
  ///
  void forEach(LineDataSourceLineDataProcessor processor);
  /// Iterates through all the lines from the data source and passes them to the
  /// given inspector, one by one.
  ///
  /// All lines for which the inspector returns true get removed from the data source.
  /// The inspector cannot update the line data.
  ///
  /// [inspector] Line inspector.
  ///
  void removeIf(LineDataSourceLineDataProcessor inspector);
  /// Frees all internally used resources.
  ///
  /// After calling this method, the object
  /// is not usable anymore.
  ///
  void destroy();
}

/// Called for each line, allowing inspection, removal or update of geometry and attributes.
///
/// [p0] the line data accessor.
///
/// Returns value indicating the result of the processing.
typedef LineDataSourceLineDataProcessor = bool Function(LineDataAccessor);

// LineDataSourceLineDataProcessor "private" section, not exported.

final _sdkMapviewDatasourceLinedatasourceLinedataprocessorRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_register_finalizer'));
final _sdkMapviewDatasourceLinedatasourceLinedataprocessorCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_copy_handle'));
final _sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_release_handle'));
final _sdkMapviewDatasourceLinedatasourceLinedataprocessorCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_create_proxy'));

class LineDataSourceLineDataProcessor$Impl {
  final Pointer<Void> handle;
  LineDataSourceLineDataProcessor$Impl(this.handle);

  bool call(LineDataAccessor p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint8 Function(Pointer<Void>, Int32, Pointer<Void>), int Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_call__LineDataAccessor'));
    final _p0Handle = sdkMapviewDatasourceLinedataaccessorToFfi(p0);
    final _handle = this.handle;
    final __resultHandle = _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewDatasourceLinedataaccessorReleaseFfiHandle(_p0Handle);
    try {
      return booleanFromFfi(__resultHandle);
    } finally {
      booleanReleaseFfiHandle(__resultHandle);

    }

  }

}

int _sdkMapviewDatasourceLinedatasourceLinedataprocessorcallStatic(Object _obj, Pointer<Void> p0, Pointer<Uint8> _result) {
  bool? _resultObject;
  try {
    _resultObject = (_obj as LineDataSourceLineDataProcessor)(sdkMapviewDatasourceLinedataaccessorFromFfi(p0));
    _result.value = booleanToFfi(_resultObject);
  } finally {
    sdkMapviewDatasourceLinedataaccessorReleaseFfiHandle(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewDatasourceLinedatasourceLinedataprocessorToFfi(LineDataSourceLineDataProcessor value) =>
  _sdkMapviewDatasourceLinedatasourceLinedataprocessorCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>, Pointer<Uint8>)>(_sdkMapviewDatasourceLinedatasourceLinedataprocessorcallStatic, __lib.unknownError)
  );

LineDataSourceLineDataProcessor sdkMapviewDatasourceLinedatasourceLinedataprocessorFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewDatasourceLinedatasourceLinedataprocessorCopyHandle(handle);
  final _impl = LineDataSourceLineDataProcessor$Impl(_copiedHandle);
  final result = (LineDataAccessor p0) => _impl.call(p0);
  _sdkMapviewDatasourceLinedatasourceLinedataprocessorRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseHandle(handle);

// Nullable LineDataSourceLineDataProcessor

final _sdkMapviewDatasourceLinedatasourceLinedataprocessorCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_create_handle_nullable'));
final _sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_release_handle_nullable'));
final _sdkMapviewDatasourceLinedatasourceLinedataprocessorGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_LineDataProcessor_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourceLinedatasourceLinedataprocessorToFfiNullable(LineDataSourceLineDataProcessor? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourceLinedatasourceLinedataprocessorToFfi(value);
  final result = _sdkMapviewDatasourceLinedatasourceLinedataprocessorCreateHandleNullable(_handle);
  sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseFfiHandle(_handle);
  return result;
}

LineDataSourceLineDataProcessor? sdkMapviewDatasourceLinedatasourceLinedataprocessorFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourceLinedatasourceLinedataprocessorGetValueNullable(handle);
  final result = sdkMapviewDatasourceLinedatasourceLinedataprocessorFromFfi(_handle);
  sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseHandleNullable(handle);

// End of LineDataSourceLineDataProcessor "private" section.

// LineDataSource "private" section, not exported.

final _sdkMapviewDatasourceLinedatasourceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_register_finalizer'));
final _sdkMapviewDatasourceLinedatasourceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_copy_handle'));
final _sdkMapviewDatasourceLinedatasourceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataSource_release_handle'));








class LineDataSource$Impl extends __lib.NativeBase implements LineDataSource {

  LineDataSource$Impl(Pointer<Void> handle) : super(handle);

  @override
  void add(LineData line) {
    final _addFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSource_add__LineData'));
    final _lineHandle = sdkMapviewDatasourceLinedataToFfi(line);
    final _handle = this.handle;
    _addFfi(_handle, __lib.LibraryContext.isolateId, _lineHandle);
    sdkMapviewDatasourceLinedataReleaseFfiHandle(_lineHandle);

  }

  @override
  void addLines(List<LineData> lines) {
    final _addLinesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSource_add__ListOf_sdk_mapview_datasource_LineData'));
    final _linesHandle = harpSdkBindingslistofSdkMapviewDatasourceLinedataToFfi(lines);
    final _handle = this.handle;
    _addLinesFfi(_handle, __lib.LibraryContext.isolateId, _linesHandle);
    harpSdkBindingslistofSdkMapviewDatasourceLinedataReleaseFfiHandle(_linesHandle);

  }

  @override
  void removeAll() {
    final _removeAllFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineDataSource_removeAll'));
    final _handle = this.handle;
    _removeAllFfi(_handle, __lib.LibraryContext.isolateId);

  }

  @override
  void forEach(LineDataSourceLineDataProcessor processor) {
    final _forEachFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSource_forEach__LineDataProcessor'));
    final _processorHandle = sdkMapviewDatasourceLinedatasourceLinedataprocessorToFfi(processor);
    final _handle = this.handle;
    _forEachFfi(_handle, __lib.LibraryContext.isolateId, _processorHandle);
    sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseFfiHandle(_processorHandle);

  }

  @override
  void removeIf(LineDataSourceLineDataProcessor inspector) {
    final _removeIfFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataSource_removeIf__LineDataProcessor'));
    final _inspectorHandle = sdkMapviewDatasourceLinedatasourceLinedataprocessorToFfi(inspector);
    final _handle = this.handle;
    _removeIfFfi(_handle, __lib.LibraryContext.isolateId, _inspectorHandle);
    sdkMapviewDatasourceLinedatasourceLinedataprocessorReleaseFfiHandle(_inspectorHandle);

  }

  @override
  void destroy() {
    final _destroyFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineDataSource_destroy'));
    final _handle = this.handle;
    _destroyFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewDatasourceLinedatasourceToFfi(LineDataSource value) =>
  _sdkMapviewDatasourceLinedatasourceCopyHandle((value as __lib.NativeBase).handle);

LineDataSource sdkMapviewDatasourceLinedatasourceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineDataSource) return instance;

  final _copiedHandle = _sdkMapviewDatasourceLinedatasourceCopyHandle(handle);
  final result = LineDataSource$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinedatasourceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinedatasourceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatasourceReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinedatasourceToFfiNullable(LineDataSource? value) =>
  value != null ? sdkMapviewDatasourceLinedatasourceToFfi(value) : Pointer<Void>.fromAddress(0);

LineDataSource? sdkMapviewDatasourceLinedatasourceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinedatasourceFromFfi(handle) : null;

void sdkMapviewDatasourceLinedatasourceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatasourceReleaseHandle(handle);

// End of LineDataSource "private" section.


