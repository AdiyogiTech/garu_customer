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
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/engine/s_d_k_native_engine.dart';
import 'package:here_sdk/src/sdk/core/errors/instantiation_error_code.dart';
import 'package:here_sdk/src/sdk/core/errors/instantiation_exception.dart';
import 'package:here_sdk/src/sdk/core/threading/task_handle.dart';
import 'package:here_sdk/src/sdk/routing/calculate_isoline_callback.dart';
import 'package:here_sdk/src/sdk/routing/isoline_options.dart';
import 'package:here_sdk/src/sdk/routing/routing_connection_settings.dart';
import 'package:here_sdk/src/sdk/routing/routing_error.dart';
import 'package:here_sdk/src/sdk/routing/waypoint.dart';
import 'package:meta/meta.dart';

/// Use the IsolineRoutingEngine to calculate a reachable area from a center point.
///
/// The calculation is done asynchronously and requires an
/// online connection.
abstract class IsolineRoutingEngine {
  /// Creates a new instance of this class.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory IsolineRoutingEngine() => $prototype.$init();
  /// Creates a new instance of RoutingEngine.
  ///
  /// [connectionSettings] Settings for the route calculation.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory IsolineRoutingEngine.withConnectionSettings(RoutingConnectionSettings connectionSettings) => $prototype.withConnectionSettings(connectionSettings);
  /// Creates a new instance of RoutingEngine.
  ///
  /// [sdkEngine] An SDKEngine instance.
  ///
  /// [connectionSettings] Settings for the route calculation.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory IsolineRoutingEngine.withSdkEngineAndConnectionSettings(SDKNativeEngine sdkEngine, RoutingConnectionSettings connectionSettings) => $prototype.withSdkEngineAndConnectionSettings(sdkEngine, connectionSettings);
  /// Creates a new instance of IsolineRoutingEngine.
  ///
  /// [sdkEngine] An SDKEngine instance.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory IsolineRoutingEngine.withSdkEngine(SDKNativeEngine sdkEngine) => $prototype.withSdkEngine(sdkEngine);

  /// Asynchronously calculates isolines to indicate the reachable area from a center point.
  ///
  /// This finds all destinations that can be reached in a specific amount of time,
  /// a maximum travel distance, or even the charge level available in an electric vehicle.
  /// The result is a polygon area where each point is reachable within the provided limit.
  ///
  /// [center] Center point from which isolines are calculated.
  /// At minimum, the waypoint must contain the coordinates as point of origin.
  ///
  /// [isolineOptions] Options for isoline calculation.
  ///
  /// [callback] Callback object that will be invoked after isoline calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle calculateIsoline(Waypoint center, IsolineOptions isolineOptions, CalculateIsolineCallback callback);
  /// Sets a custom option for routing backend queries.
  ///
  /// The custom option is applied to all the queries that `IsolineRoutingEngine` performs.
  /// For a complete list of available parameter names and their valid values, refer to
  /// [HERE Routing API v8](https://www.here.com/docs/bundle/batch-api-developer-guide/page/topics/constructing-request.html).
  /// **Note:** It's easy to set a wrong option that makes queries invalid,
  /// so make sure you read and understand the backend documentation.
  ///
  /// [name] An option name. If the engine already has an option with the same name, the option will be overwritten. The option name must be a non-empty string.
  /// The option name should't duplicate option names that SDK creates by itself for usage in the query,
  /// otherwise the query will callback with the error `RoutingError.INTERNAL_ERROR`.
  ///
  /// [value] An option value. If the value is `null`, the option will be removed. The option value must be a non-empty string.
  ///
  /// Returns [RoutingError?]. An optional error of setting the option.
  ///
  /// It's `null` if the option has been set successfully.
  /// It's `RoutingError.INVALID_PARAMETER` if the input name and/or value haven't passed internal validation.
  ///
  RoutingError? setCustomOption(String name, String? value);

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = IsolineRoutingEngine$Impl(Pointer<Void>.fromAddress(0));
}


// IsolineRoutingEngine "private" section, not exported.

final _sdkRoutingIsolineroutingengineRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_register_finalizer'));
final _sdkRoutingIsolineroutingengineCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_copy_handle'));
final _sdkRoutingIsolineroutingengineReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_release_handle'));


final _$initsdkRoutingIsolineroutingengineMakeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make_return_release_handle'));
final _$initsdkRoutingIsolineroutingengineMakeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make_return_get_result'));
final _$initsdkRoutingIsolineroutingengineMakeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make_return_get_error'));
final _$initsdkRoutingIsolineroutingengineMakeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make_return_has_error'));


final _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__RoutingConnectionSettings_return_release_handle'));
final _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__RoutingConnectionSettings_return_get_result'));
final _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__RoutingConnectionSettings_return_get_error'));
final _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__RoutingConnectionSettings_return_has_error'));


final _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_release_handle'));
final _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_get_result'));
final _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_get_error'));
final _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_has_error'));


final _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_return_release_handle'));
final _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_return_get_result'));
final _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_return_get_error'));
final _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_return_has_error'));




/// @nodoc
@visibleForTesting
class IsolineRoutingEngine$Impl extends __lib.NativeBase implements IsolineRoutingEngine {

  IsolineRoutingEngine$Impl(Pointer<Void> handle) : super(handle);


  IsolineRoutingEngine $init() {
    final _result_handle = _$init();
    final _result = IsolineRoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingIsolineroutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  IsolineRoutingEngine withConnectionSettings(RoutingConnectionSettings connectionSettings) {
    final _result_handle = _withConnectionSettings(connectionSettings);
    final _result = IsolineRoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingIsolineroutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  IsolineRoutingEngine withSdkEngineAndConnectionSettings(SDKNativeEngine sdkEngine, RoutingConnectionSettings connectionSettings) {
    final _result_handle = _withSdkEngineAndConnectionSettings(sdkEngine, connectionSettings);
    final _result = IsolineRoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingIsolineroutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  IsolineRoutingEngine withSdkEngine(SDKNativeEngine sdkEngine) {
    final _result_handle = _withSdkEngine(sdkEngine);
    final _result = IsolineRoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingIsolineroutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _$init() {
    final _$initFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_routing_IsolineRoutingEngine_make'));
    final __callResultHandle = _$initFfi(__lib.LibraryContext.isolateId);
    if (_$initsdkRoutingIsolineroutingengineMakeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _$initsdkRoutingIsolineroutingengineMakeReturnGetError(__callResultHandle);
        _$initsdkRoutingIsolineroutingengineMakeReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _$initsdkRoutingIsolineroutingengineMakeReturnGetResult(__callResultHandle);
    _$initsdkRoutingIsolineroutingengineMakeReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withConnectionSettings(RoutingConnectionSettings connectionSettings) {
    final _withConnectionSettingsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_routing_IsolineRoutingEngine_make__RoutingConnectionSettings'));
    final _connectionSettingsHandle = sdkRoutingRoutingconnectionsettingsToFfi(connectionSettings);
    final __callResultHandle = _withConnectionSettingsFfi(__lib.LibraryContext.isolateId, _connectionSettingsHandle);
    sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(_connectionSettingsHandle);
    if (_withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnGetError(__callResultHandle);
        _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnGetResult(__callResultHandle);
    _withConnectionSettingssdkRoutingIsolineroutingengineMakeRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withSdkEngineAndConnectionSettings(SDKNativeEngine sdkEngine, RoutingConnectionSettings connectionSettings) {
    final _withSdkEngineAndConnectionSettingsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings'));
    final _sdkEngineHandle = sdkCoreEngineSdknativeengineToFfi(sdkEngine);
    final _connectionSettingsHandle = sdkRoutingRoutingconnectionsettingsToFfi(connectionSettings);
    final __callResultHandle = _withSdkEngineAndConnectionSettingsFfi(__lib.LibraryContext.isolateId, _sdkEngineHandle, _connectionSettingsHandle);
    sdkCoreEngineSdknativeengineReleaseFfiHandle(_sdkEngineHandle);
    sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(_connectionSettingsHandle);
    if (_withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetError(__callResultHandle);
        _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetResult(__callResultHandle);
    _withSdkEngineAndConnectionSettingssdkRoutingIsolineroutingengineMakeSdknativeengineRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withSdkEngine(SDKNativeEngine sdkEngine) {
    final _withSdkEngineFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_routing_IsolineRoutingEngine_make__SDKNativeEngine'));
    final _sdkEngineHandle = sdkCoreEngineSdknativeengineToFfi(sdkEngine);
    final __callResultHandle = _withSdkEngineFfi(__lib.LibraryContext.isolateId, _sdkEngineHandle);
    sdkCoreEngineSdknativeengineReleaseFfiHandle(_sdkEngineHandle);
    if (_withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnGetError(__callResultHandle);
        _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnGetResult(__callResultHandle);
    _withSdkEnginesdkRoutingIsolineroutingengineMakeSdknativeengineReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  @override
  TaskHandle calculateIsoline(Waypoint center, IsolineOptions isolineOptions, CalculateIsolineCallback callback) {
    final _calculateIsolineFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_IsolineRoutingEngine_calculateIsoline__Waypoint_IsolineOptions_CalculateIsolineCallback'));
    final _centerHandle = sdkRoutingWaypointToFfi(center);
    final _isolineOptionsHandle = sdkRoutingIsolineoptionsToFfi(isolineOptions);
    final _callbackHandle = sdkRoutingCalculateisolinecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateIsolineFfi(_handle, __lib.LibraryContext.isolateId, _centerHandle, _isolineOptionsHandle, _callbackHandle);
    sdkRoutingWaypointReleaseFfiHandle(_centerHandle);
    sdkRoutingIsolineoptionsReleaseFfiHandle(_isolineOptionsHandle);
    sdkRoutingCalculateisolinecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  RoutingError? setCustomOption(String name, String? value) {
    final _setCustomOptionFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_IsolineRoutingEngine_setCustomOption__String_String_'));
    final _nameHandle = stringToFfi(name);
    final _valueHandle = stringToFfiNullable(value);
    final _handle = this.handle;
    final __resultHandle = _setCustomOptionFfi(_handle, __lib.LibraryContext.isolateId, _nameHandle, _valueHandle);
    stringReleaseFfiHandle(_nameHandle);
    stringReleaseFfiHandleNullable(_valueHandle);
    try {
      return sdkRoutingRoutingerrorFromFfiNullable(__resultHandle);
    } finally {
      sdkRoutingRoutingerrorReleaseFfiHandleNullable(__resultHandle);

    }

  }


}

Pointer<Void> sdkRoutingIsolineroutingengineToFfi(IsolineRoutingEngine value) =>
  _sdkRoutingIsolineroutingengineCopyHandle((value as __lib.NativeBase).handle);

IsolineRoutingEngine sdkRoutingIsolineroutingengineFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is IsolineRoutingEngine) return instance;

  final _copiedHandle = _sdkRoutingIsolineroutingengineCopyHandle(handle);
  final result = IsolineRoutingEngine$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkRoutingIsolineroutingengineRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkRoutingIsolineroutingengineReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkRoutingIsolineroutingengineReleaseHandle(handle);

Pointer<Void> sdkRoutingIsolineroutingengineToFfiNullable(IsolineRoutingEngine? value) =>
  value != null ? sdkRoutingIsolineroutingengineToFfi(value) : Pointer<Void>.fromAddress(0);

IsolineRoutingEngine? sdkRoutingIsolineroutingengineFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkRoutingIsolineroutingengineFromFfi(handle) : null;

void sdkRoutingIsolineroutingengineReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingIsolineroutingengineReleaseHandle(handle);

// End of IsolineRoutingEngine "private" section.


