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

/// MapContext is the rendering engine and the context in which virtual geographic maps get rendered.
///
/// It runs the render loop or offers the means for the user to run a custom one.
///
/// Data sources, assets and virtual maps can be attached to the context. A virtual map can only
/// render data from sources attached to the same context.
///
/// The graphics backend to be used by the engine can be choosen by the user or a platform suitable
/// one can be automatically selected internally. Only one graphics backend can be active and once
/// selected it cannot be changed.
abstract class MapContext {

  /// Frees a system resource held by the [MapContext] and all entities attached to it, like [HereMapControllerCore].
  ///
  /// This function is intended for use when a system resource availability becomes low.
  /// For example, some memory can be freed when the application transitions to the background state.
  ///
  /// [type] Type of resource to be freed.
  ///
  /// [severity] Severity of the request.
  ///
  void freeResource(MapContextResourceType type, MapContextFreeResourceSeverity severity);
}

/// Types of system resources used by [MapContext] or any of the entities attached to it, like [HereMapControllerCore].
enum MapContextResourceType {
    /// Memory including CPU and GPU RAM.
    memory
}

// MapContextResourceType "private" section, not exported.

int sdkMapviewMapcontextResourcetypeToFfi(MapContextResourceType value) {
  switch (value) {
  case MapContextResourceType.memory:
    return 0;
  default:
    throw StateError("Invalid enum value $value for MapContextResourceType enum.");
  }
}

MapContextResourceType sdkMapviewMapcontextResourcetypeFromFfi(int handle) {
  switch (handle) {
  case 0:
    return MapContextResourceType.memory;
  default:
    throw StateError("Invalid numeric value $handle for MapContextResourceType enum.");
  }
}

void sdkMapviewMapcontextResourcetypeReleaseFfiHandle(int handle) {}

final _sdkMapviewMapcontextResourcetypeCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapContext_ResourceType_create_handle_nullable'));
final _sdkMapviewMapcontextResourcetypeReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapContext_ResourceType_release_handle_nullable'));
final _sdkMapviewMapcontextResourcetypeGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapContext_ResourceType_get_value_nullable'));

Pointer<Void> sdkMapviewMapcontextResourcetypeToFfiNullable(MapContextResourceType? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapcontextResourcetypeToFfi(value);
  final result = _sdkMapviewMapcontextResourcetypeCreateHandleNullable(_handle);
  sdkMapviewMapcontextResourcetypeReleaseFfiHandle(_handle);
  return result;
}

MapContextResourceType? sdkMapviewMapcontextResourcetypeFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapcontextResourcetypeGetValueNullable(handle);
  final result = sdkMapviewMapcontextResourcetypeFromFfi(_handle);
  sdkMapviewMapcontextResourcetypeReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapcontextResourcetypeReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapcontextResourcetypeReleaseHandleNullable(handle);

// End of MapContextResourceType "private" section.
/// The severity of a free resource request.
enum MapContextFreeResourceSeverity {
    /// Moderate severity: some resource should be released.
    moderate,
    /// Critical severity: resource should be released as much as possible.
    critical
}

// MapContextFreeResourceSeverity "private" section, not exported.

int sdkMapviewMapcontextFreeresourceseverityToFfi(MapContextFreeResourceSeverity value) {
  switch (value) {
  case MapContextFreeResourceSeverity.moderate:
    return 0;
  case MapContextFreeResourceSeverity.critical:
    return 1;
  default:
    throw StateError("Invalid enum value $value for MapContextFreeResourceSeverity enum.");
  }
}

MapContextFreeResourceSeverity sdkMapviewMapcontextFreeresourceseverityFromFfi(int handle) {
  switch (handle) {
  case 0:
    return MapContextFreeResourceSeverity.moderate;
  case 1:
    return MapContextFreeResourceSeverity.critical;
  default:
    throw StateError("Invalid numeric value $handle for MapContextFreeResourceSeverity enum.");
  }
}

void sdkMapviewMapcontextFreeresourceseverityReleaseFfiHandle(int handle) {}

final _sdkMapviewMapcontextFreeresourceseverityCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapContext_FreeResourceSeverity_create_handle_nullable'));
final _sdkMapviewMapcontextFreeresourceseverityReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapContext_FreeResourceSeverity_release_handle_nullable'));
final _sdkMapviewMapcontextFreeresourceseverityGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapContext_FreeResourceSeverity_get_value_nullable'));

Pointer<Void> sdkMapviewMapcontextFreeresourceseverityToFfiNullable(MapContextFreeResourceSeverity? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapcontextFreeresourceseverityToFfi(value);
  final result = _sdkMapviewMapcontextFreeresourceseverityCreateHandleNullable(_handle);
  sdkMapviewMapcontextFreeresourceseverityReleaseFfiHandle(_handle);
  return result;
}

MapContextFreeResourceSeverity? sdkMapviewMapcontextFreeresourceseverityFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapcontextFreeresourceseverityGetValueNullable(handle);
  final result = sdkMapviewMapcontextFreeresourceseverityFromFfi(_handle);
  sdkMapviewMapcontextFreeresourceseverityReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapcontextFreeresourceseverityReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapcontextFreeresourceseverityReleaseHandleNullable(handle);

// End of MapContextFreeResourceSeverity "private" section.

// MapContext "private" section, not exported.

final _sdkMapviewMapcontextRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapContext_register_finalizer'));
final _sdkMapviewMapcontextCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapContext_copy_handle'));
final _sdkMapviewMapcontextReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapContext_release_handle'));



class MapContext$Impl extends __lib.NativeBase implements MapContext {

  MapContext$Impl(Pointer<Void> handle) : super(handle);

  @override
  void freeResource(MapContextResourceType type, MapContextFreeResourceSeverity severity) {
    final _freeResourceFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Uint32, Uint32), void Function(Pointer<Void>, int, int, int)>('here_sdk_sdk_mapview_MapContext_freeResource__ResourceType_FreeResourceSeverity'));
    final _typeHandle = sdkMapviewMapcontextResourcetypeToFfi(type);
    final _severityHandle = sdkMapviewMapcontextFreeresourceseverityToFfi(severity);
    final _handle = this.handle;
    _freeResourceFfi(_handle, __lib.LibraryContext.isolateId, _typeHandle, _severityHandle);
    sdkMapviewMapcontextResourcetypeReleaseFfiHandle(_typeHandle);
    sdkMapviewMapcontextFreeresourceseverityReleaseFfiHandle(_severityHandle);

  }


}

Pointer<Void> sdkMapviewMapcontextToFfi(MapContext value) =>
  _sdkMapviewMapcontextCopyHandle((value as __lib.NativeBase).handle);

MapContext sdkMapviewMapcontextFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapContext) return instance;

  final _copiedHandle = _sdkMapviewMapcontextCopyHandle(handle);
  final result = MapContext$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapcontextRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapcontextReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapcontextReleaseHandle(handle);

Pointer<Void> sdkMapviewMapcontextToFfiNullable(MapContext? value) =>
  value != null ? sdkMapviewMapcontextToFfi(value) : Pointer<Void>.fromAddress(0);

MapContext? sdkMapviewMapcontextFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapcontextFromFfi(handle) : null;

void sdkMapviewMapcontextReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapcontextReleaseHandle(handle);

// End of MapContext "private" section.


