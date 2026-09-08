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
import 'dart:ui' as ui;
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/color.dart';

/// Manage the lights and their attributes in a scene.
abstract class MapSceneLights {

  /// Set a new color for the light based on its category.
  ///
  /// [category] The category of light for which the color is set.
  ///
  /// [color] The Color type includes red, green, blue, and alpha components.
  /// The value of these components must be inside the range \[0, 1\].
  ///
  /// [callback] Optional callback that will receive the result of this operation.
  ///
  void setColor(MapSceneLightsCategory category, ui.Color color, MapSceneLightsAttributeSettingCallback? callback);
  /// Set a new intensity for the light based on its category.
  ///
  /// [category] The category of light for which the intensity is set.
  ///
  /// [intensity] The light intensity value must be inside the range \[0, 10\].
  /// The intensity value is clamped to this range.
  /// If the value falls outside its supported range, it will be adjusted to stay within the range.
  /// Note: When the intensity value is big,
  /// 3D objects might turn completely white because all the color channels could go over the limit of 1.0.
  ///
  /// [callback] Optional callback that will receive the result of this operation.
  ///
  void setIntensity(MapSceneLightsCategory category, double intensity, MapSceneLightsAttributeSettingCallback? callback);
  /// Set a new direction for the light based on its category.
  ///
  /// [category] The category of light for which the direction is set.
  ///
  /// [direction] The Direction contains azimuth and altitude angles in degrees.
  ///
  /// [callback] Optional callback that will receive the result of this operation.
  ///
  void setDirection(MapSceneLightsCategory category, MapSceneLightsDirection direction, MapSceneLightsAttributeSettingCallback? callback);
  /// Retrieves the current color of the light based on its category.
  ///
  /// [category] The category of light from which the color is retrieved.
  ///
  /// Returns [ui.Color?]. The current color of the light, or null if the light is missing from the loaded scene
  /// or MapScene is not intitialized.
  ///
  ui.Color? getColor(MapSceneLightsCategory category);
  /// Retrieves the current intensity of the light based on its category.
  ///
  /// [category] The category of light from which the intensity is retrieved.
  ///
  /// Returns [double?]. The current intensity of the light, or null if the light is missing from the loaded scene
  /// or MapScene is not intitialized.
  ///
  double? getIntensity(MapSceneLightsCategory category);
  /// Retrieves the current direction of the light based on its category.
  ///
  /// [category] The category of light from which the direction is retrieved.
  ///
  /// Returns [MapSceneLightsDirection?]. The current direction of the light, or null if the light is missing from the loaded scene
  /// or MapScene is not intitialized.
  ///
  MapSceneLightsDirection? getDirection(MapSceneLightsCategory category);
  /// Resets all attributes of each light to their default values based on the current map scene settings.
  ///
  void reset();
}

/// The scene uses three categories of lighting which are:
/// Main light, Back light and Rim light.
///
/// These lights are directional lights.
///
/// The properties of all lights have an impact on the shading of 3D objects, for instance, extruded buildings within the scene.
/// However, shadow casting is only affected by the direction of the main light.
///
/// Category primarily serves as an identifier type for managing the lights.
enum MapSceneLightsCategory {
    /// Main light
    main,
    /// Back light
    back,
    /// Rim light
    rim
}

// MapSceneLightsCategory "private" section, not exported.

int sdkMapviewMapscenelightsCategoryToFfi(MapSceneLightsCategory value) {
  switch (value) {
  case MapSceneLightsCategory.main:
    return 0;
  case MapSceneLightsCategory.back:
    return 1;
  case MapSceneLightsCategory.rim:
    return 2;
  default:
    throw StateError("Invalid enum value $value for MapSceneLightsCategory enum.");
  }
}

MapSceneLightsCategory sdkMapviewMapscenelightsCategoryFromFfi(int handle) {
  switch (handle) {
  case 0:
    return MapSceneLightsCategory.main;
  case 1:
    return MapSceneLightsCategory.back;
  case 2:
    return MapSceneLightsCategory.rim;
  default:
    throw StateError("Invalid numeric value $handle for MapSceneLightsCategory enum.");
  }
}

void sdkMapviewMapscenelightsCategoryReleaseFfiHandle(int handle) {}

final _sdkMapviewMapscenelightsCategoryCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapSceneLights_Category_create_handle_nullable'));
final _sdkMapviewMapscenelightsCategoryReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Category_release_handle_nullable'));
final _sdkMapviewMapscenelightsCategoryGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Category_get_value_nullable'));

Pointer<Void> sdkMapviewMapscenelightsCategoryToFfiNullable(MapSceneLightsCategory? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapscenelightsCategoryToFfi(value);
  final result = _sdkMapviewMapscenelightsCategoryCreateHandleNullable(_handle);
  sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_handle);
  return result;
}

MapSceneLightsCategory? sdkMapviewMapscenelightsCategoryFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapscenelightsCategoryGetValueNullable(handle);
  final result = sdkMapviewMapscenelightsCategoryFromFfi(_handle);
  sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapscenelightsCategoryReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsCategoryReleaseHandleNullable(handle);

// End of MapSceneLightsCategory "private" section.
/// Error enum indicating reasons for failure when setting light attributes.
enum MapSceneLightsAttributeSettingError {
    /// No lights available in the scene.
    noLights
}

// MapSceneLightsAttributeSettingError "private" section, not exported.

int sdkMapviewMapscenelightsAttributesettingerrorToFfi(MapSceneLightsAttributeSettingError value) {
  switch (value) {
  case MapSceneLightsAttributeSettingError.noLights:
    return 0;
  default:
    throw StateError("Invalid enum value $value for MapSceneLightsAttributeSettingError enum.");
  }
}

MapSceneLightsAttributeSettingError sdkMapviewMapscenelightsAttributesettingerrorFromFfi(int handle) {
  switch (handle) {
  case 0:
    return MapSceneLightsAttributeSettingError.noLights;
  default:
    throw StateError("Invalid numeric value $handle for MapSceneLightsAttributeSettingError enum.");
  }
}

void sdkMapviewMapscenelightsAttributesettingerrorReleaseFfiHandle(int handle) {}

final _sdkMapviewMapscenelightsAttributesettingerrorCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingError_create_handle_nullable'));
final _sdkMapviewMapscenelightsAttributesettingerrorReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingError_release_handle_nullable'));
final _sdkMapviewMapscenelightsAttributesettingerrorGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingError_get_value_nullable'));

Pointer<Void> sdkMapviewMapscenelightsAttributesettingerrorToFfiNullable(MapSceneLightsAttributeSettingError? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapscenelightsAttributesettingerrorToFfi(value);
  final result = _sdkMapviewMapscenelightsAttributesettingerrorCreateHandleNullable(_handle);
  sdkMapviewMapscenelightsAttributesettingerrorReleaseFfiHandle(_handle);
  return result;
}

MapSceneLightsAttributeSettingError? sdkMapviewMapscenelightsAttributesettingerrorFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapscenelightsAttributesettingerrorGetValueNullable(handle);
  final result = sdkMapviewMapscenelightsAttributesettingerrorFromFfi(_handle);
  sdkMapviewMapscenelightsAttributesettingerrorReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapscenelightsAttributesettingerrorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsAttributesettingerrorReleaseHandleNullable(handle);

// End of MapSceneLightsAttributeSettingError "private" section.
/// The direction of lights as a pair of azimuth and altitude angles.
///
/// See https://en.wikipedia.org/wiki/Horizontal_coordinate_system

class MapSceneLightsDirection {
  /// Direction azimuth value in degrees in the range \[0, 360\).
  /// The default value is 0.0.
  /// The azimuth range is half-open, meaning the maximum value is not included in the range.
  /// If the azimuth value falls outside the range, it is wrapped to stay within \[0, 360\).
  /// Specifically, values less than 0 will be increased by 360 until they fall within the range,
  /// and values greater than or equal to 360 will be reduced by 360 until they fall within the range.
  /// By convention, an azimuth of 0 degrees corresponds to North, and azimuth values increase clockwise.
  /// Thus, 90 degrees corresponds to East, 180 degrees to South, and 270 degrees to West.
  double azimuth;

  /// Direction altitude value in degrees in the range \[0, 90\].
  /// The default value is 0.0.
  /// The altitude value is clamped to this range.
  /// If the value falls outside its supported range, it will be adjusted to stay within the range.
  /// Specifically, values less than 0 will be set to 0, and values greater than 90 will be set to 90.
  /// Note: Unlike azimuth, altitude values are not wrapped around; they are clamped directly.
  /// For example, an altitude value of -10 will be adjusted to 0, and an altitude value of 100 will be adjusted to 90.
  /// When both azimuth and altitude values are provided, they are adjusted independently:
  /// For instance, (0, -10) is changed to (0, 0) rather than (180, 10).
  double altitude;

  /// Constructs a Direction with default values: azimuth = 0.0, altitude = 0.0.
  MapSceneLightsDirection.zero()
      : azimuth = 0.0, altitude = 0.0;
  /// Constructs a Direction from the values.
  /// [azimuth] Direction azimuth value in degrees in the range \[0, 360\).
  /// The default value is 0.0.
  /// The azimuth range is half-open, meaning the maximum value is not included in the range.
  /// If the azimuth value falls outside the range, it is wrapped to stay within \[0, 360\).
  /// Specifically, values less than 0 will be increased by 360 until they fall within the range,
  /// and values greater than or equal to 360 will be reduced by 360 until they fall within the range.
  /// By convention, an azimuth of 0 degrees corresponds to North, and azimuth values increase clockwise.
  /// Thus, 90 degrees corresponds to East, 180 degrees to South, and 270 degrees to West.
  /// [altitude] Direction altitude value in degrees in the range \[0, 90\].
  /// The default value is 0.0.
  /// The altitude value is clamped to this range.
  /// If the value falls outside its supported range, it will be adjusted to stay within the range.
  /// Specifically, values less than 0 will be set to 0, and values greater than 90 will be set to 90.
  /// Note: Unlike azimuth, altitude values are not wrapped around; they are clamped directly.
  /// For example, an altitude value of -10 will be adjusted to 0, and an altitude value of 100 will be adjusted to 90.
  /// When both azimuth and altitude values are provided, they are adjusted independently:
  /// For instance, (0, -10) is changed to (0, 0) rather than (180, 10).
  MapSceneLightsDirection(this.azimuth, this.altitude);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapSceneLightsDirection) return false;
    MapSceneLightsDirection _other = other;
    return azimuth == _other.azimuth &&
        altitude == _other.altitude;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + azimuth.hashCode;
    result = 31 * result + altitude.hashCode;
    return result;
  }
}


// MapSceneLightsDirection "private" section, not exported.

final _sdkMapviewMapscenelightsDirectionCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Double, Double),
    Pointer<Void> Function(double, double)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_create_handle'));
final _sdkMapviewMapscenelightsDirectionReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_release_handle'));
final _sdkMapviewMapscenelightsDirectionGetFieldazimuth = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_get_field_azimuth'));
final _sdkMapviewMapscenelightsDirectionGetFieldaltitude = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_get_field_altitude'));



Pointer<Void> sdkMapviewMapscenelightsDirectionToFfi(MapSceneLightsDirection value) {
  final _azimuthHandle = (value.azimuth);
  final _altitudeHandle = (value.altitude);
  final _result = _sdkMapviewMapscenelightsDirectionCreateHandle(_azimuthHandle, _altitudeHandle);
  
  
  return _result;
}

MapSceneLightsDirection sdkMapviewMapscenelightsDirectionFromFfi(Pointer<Void> handle) {
  final _azimuthHandle = _sdkMapviewMapscenelightsDirectionGetFieldazimuth(handle);
  final _altitudeHandle = _sdkMapviewMapscenelightsDirectionGetFieldaltitude(handle);
  try {
    return MapSceneLightsDirection(
      (_azimuthHandle), 
      (_altitudeHandle)
    );
  } finally {
    
    
  }
}

void sdkMapviewMapscenelightsDirectionReleaseFfiHandle(Pointer<Void> handle) => _sdkMapviewMapscenelightsDirectionReleaseHandle(handle);

// Nullable MapSceneLightsDirection

final _sdkMapviewMapscenelightsDirectionCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_create_handle_nullable'));
final _sdkMapviewMapscenelightsDirectionReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_release_handle_nullable'));
final _sdkMapviewMapscenelightsDirectionGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_Direction_get_value_nullable'));

Pointer<Void> sdkMapviewMapscenelightsDirectionToFfiNullable(MapSceneLightsDirection? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapscenelightsDirectionToFfi(value);
  final result = _sdkMapviewMapscenelightsDirectionCreateHandleNullable(_handle);
  sdkMapviewMapscenelightsDirectionReleaseFfiHandle(_handle);
  return result;
}

MapSceneLightsDirection? sdkMapviewMapscenelightsDirectionFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapscenelightsDirectionGetValueNullable(handle);
  final result = sdkMapviewMapscenelightsDirectionFromFfi(_handle);
  sdkMapviewMapscenelightsDirectionReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapscenelightsDirectionReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsDirectionReleaseHandleNullable(handle);

// End of MapSceneLightsDirection "private" section.
/// This callback function allows handling errors that occur during the setting of light attributes.
///
/// [p0] The cause for the failure when setting the light attributes, or null if no error occurred.
///
/// Note: The error code `NO_LIGHTS` may be returned when attempting to set light attributes in map schemes
/// that do not support lights, for instance `road.network` map scheme.
///
/// Please refer to the error code documentation for further details on error handling.
typedef MapSceneLightsAttributeSettingCallback = void Function(MapSceneLightsAttributeSettingError?);

// MapSceneLightsAttributeSettingCallback "private" section, not exported.

final _sdkMapviewMapscenelightsAttributesettingcallbackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_register_finalizer'));
final _sdkMapviewMapscenelightsAttributesettingcallbackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_copy_handle'));
final _sdkMapviewMapscenelightsAttributesettingcallbackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_release_handle'));
final _sdkMapviewMapscenelightsAttributesettingcallbackCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_create_proxy'));

class MapSceneLightsAttributeSettingCallback$Impl {
  final Pointer<Void> handle;
  MapSceneLightsAttributeSettingCallback$Impl(this.handle);

  void call(MapSceneLightsAttributeSettingError? p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_call__AttributeSettingError_'));
    final _p0Handle = sdkMapviewMapscenelightsAttributesettingerrorToFfiNullable(p0);
    final _handle = this.handle;
    _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewMapscenelightsAttributesettingerrorReleaseFfiHandleNullable(_p0Handle);

  }

}

int _sdkMapviewMapscenelightsAttributesettingcallbackcallStatic(Object _obj, Pointer<Void> p0) {
  
  try {
    (_obj as MapSceneLightsAttributeSettingCallback)(sdkMapviewMapscenelightsAttributesettingerrorFromFfiNullable(p0));
  } finally {
    sdkMapviewMapscenelightsAttributesettingerrorReleaseFfiHandleNullable(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewMapscenelightsAttributesettingcallbackToFfi(MapSceneLightsAttributeSettingCallback value) =>
  _sdkMapviewMapscenelightsAttributesettingcallbackCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>)>(_sdkMapviewMapscenelightsAttributesettingcallbackcallStatic, __lib.unknownError)
  );

MapSceneLightsAttributeSettingCallback sdkMapviewMapscenelightsAttributesettingcallbackFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewMapscenelightsAttributesettingcallbackCopyHandle(handle);
  final _impl = MapSceneLightsAttributeSettingCallback$Impl(_copiedHandle);
  final result = (MapSceneLightsAttributeSettingError? p0) => _impl.call(p0);
  _sdkMapviewMapscenelightsAttributesettingcallbackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsAttributesettingcallbackReleaseHandle(handle);

// Nullable MapSceneLightsAttributeSettingCallback

final _sdkMapviewMapscenelightsAttributesettingcallbackCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_create_handle_nullable'));
final _sdkMapviewMapscenelightsAttributesettingcallbackReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_release_handle_nullable'));
final _sdkMapviewMapscenelightsAttributesettingcallbackGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_AttributeSettingCallback_get_value_nullable'));

Pointer<Void> sdkMapviewMapscenelightsAttributesettingcallbackToFfiNullable(MapSceneLightsAttributeSettingCallback? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapscenelightsAttributesettingcallbackToFfi(value);
  final result = _sdkMapviewMapscenelightsAttributesettingcallbackCreateHandleNullable(_handle);
  sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandle(_handle);
  return result;
}

MapSceneLightsAttributeSettingCallback? sdkMapviewMapscenelightsAttributesettingcallbackFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapscenelightsAttributesettingcallbackGetValueNullable(handle);
  final result = sdkMapviewMapscenelightsAttributesettingcallbackFromFfi(_handle);
  sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsAttributesettingcallbackReleaseHandleNullable(handle);

// End of MapSceneLightsAttributeSettingCallback "private" section.

// MapSceneLights "private" section, not exported.

final _sdkMapviewMapscenelightsRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapSceneLights_register_finalizer'));
final _sdkMapviewMapscenelightsCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_copy_handle'));
final _sdkMapviewMapscenelightsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapSceneLights_release_handle'));









class MapSceneLights$Impl extends __lib.NativeBase implements MapSceneLights {

  MapSceneLights$Impl(Pointer<Void> handle) : super(handle);

  @override
  void setColor(MapSceneLightsCategory category, ui.Color color, MapSceneLightsAttributeSettingCallback? callback) {
    final _setColorFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Uint32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapSceneLights_setColor__Category_Color_AttributeSettingCallback_'));
    final _categoryHandle = sdkMapviewMapscenelightsCategoryToFfi(category);
    final _colorHandle = sdkCoreColorToFfi(color);
    final _callbackHandle = sdkMapviewMapscenelightsAttributesettingcallbackToFfiNullable(callback);
    final _handle = this.handle;
    _setColorFfi(_handle, __lib.LibraryContext.isolateId, _categoryHandle, _colorHandle, _callbackHandle);
    sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_categoryHandle);
    sdkCoreColorReleaseFfiHandle(_colorHandle);
    sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandleNullable(_callbackHandle);

  }

  @override
  void setIntensity(MapSceneLightsCategory category, double intensity, MapSceneLightsAttributeSettingCallback? callback) {
    final _setIntensityFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Uint32, Double, Pointer<Void>), void Function(Pointer<Void>, int, int, double, Pointer<Void>)>('here_sdk_sdk_mapview_MapSceneLights_setIntensity__Category_Double_AttributeSettingCallback_'));
    final _categoryHandle = sdkMapviewMapscenelightsCategoryToFfi(category);
    final _intensityHandle = (intensity);
    final _callbackHandle = sdkMapviewMapscenelightsAttributesettingcallbackToFfiNullable(callback);
    final _handle = this.handle;
    _setIntensityFfi(_handle, __lib.LibraryContext.isolateId, _categoryHandle, _intensityHandle, _callbackHandle);
    sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_categoryHandle);

    sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandleNullable(_callbackHandle);

  }

  @override
  void setDirection(MapSceneLightsCategory category, MapSceneLightsDirection direction, MapSceneLightsAttributeSettingCallback? callback) {
    final _setDirectionFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Uint32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapSceneLights_setDirection__Category_Direction_AttributeSettingCallback_'));
    final _categoryHandle = sdkMapviewMapscenelightsCategoryToFfi(category);
    final _directionHandle = sdkMapviewMapscenelightsDirectionToFfi(direction);
    final _callbackHandle = sdkMapviewMapscenelightsAttributesettingcallbackToFfiNullable(callback);
    final _handle = this.handle;
    _setDirectionFfi(_handle, __lib.LibraryContext.isolateId, _categoryHandle, _directionHandle, _callbackHandle);
    sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_categoryHandle);
    sdkMapviewMapscenelightsDirectionReleaseFfiHandle(_directionHandle);
    sdkMapviewMapscenelightsAttributesettingcallbackReleaseFfiHandleNullable(_callbackHandle);

  }

  @override
  ui.Color? getColor(MapSceneLightsCategory category) {
    final _getColorFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Uint32), Pointer<Void> Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapSceneLights_getColor__Category'));
    final _categoryHandle = sdkMapviewMapscenelightsCategoryToFfi(category);
    final _handle = this.handle;
    final __resultHandle = _getColorFfi(_handle, __lib.LibraryContext.isolateId, _categoryHandle);
    sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_categoryHandle);
    try {
      return sdkCoreColorFromFfiNullable(__resultHandle);
    } finally {
      sdkCoreColorReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  double? getIntensity(MapSceneLightsCategory category) {
    final _getIntensityFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Uint32), Pointer<Void> Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapSceneLights_getIntensity__Category'));
    final _categoryHandle = sdkMapviewMapscenelightsCategoryToFfi(category);
    final _handle = this.handle;
    final __resultHandle = _getIntensityFfi(_handle, __lib.LibraryContext.isolateId, _categoryHandle);
    sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_categoryHandle);
    try {
      return doubleFromFfiNullable(__resultHandle);
    } finally {
      doubleReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  MapSceneLightsDirection? getDirection(MapSceneLightsCategory category) {
    final _getDirectionFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Uint32), Pointer<Void> Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapSceneLights_getDirection__Category'));
    final _categoryHandle = sdkMapviewMapscenelightsCategoryToFfi(category);
    final _handle = this.handle;
    final __resultHandle = _getDirectionFfi(_handle, __lib.LibraryContext.isolateId, _categoryHandle);
    sdkMapviewMapscenelightsCategoryReleaseFfiHandle(_categoryHandle);
    try {
      return sdkMapviewMapscenelightsDirectionFromFfiNullable(__resultHandle);
    } finally {
      sdkMapviewMapscenelightsDirectionReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  void reset() {
    final _resetFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32), void Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapSceneLights_reset'));
    final _handle = this.handle;
    _resetFfi(_handle, __lib.LibraryContext.isolateId);

  }


}

Pointer<Void> sdkMapviewMapscenelightsToFfi(MapSceneLights value) =>
  _sdkMapviewMapscenelightsCopyHandle((value as __lib.NativeBase).handle);

MapSceneLights sdkMapviewMapscenelightsFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapSceneLights) return instance;

  final _copiedHandle = _sdkMapviewMapscenelightsCopyHandle(handle);
  final result = MapSceneLights$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapscenelightsRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapscenelightsReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsReleaseHandle(handle);

Pointer<Void> sdkMapviewMapscenelightsToFfiNullable(MapSceneLights? value) =>
  value != null ? sdkMapviewMapscenelightsToFfi(value) : Pointer<Void>.fromAddress(0);

MapSceneLights? sdkMapviewMapscenelightsFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapscenelightsFromFfi(handle) : null;

void sdkMapviewMapscenelightsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapscenelightsReleaseHandle(handle);

// End of MapSceneLights "private" section.


