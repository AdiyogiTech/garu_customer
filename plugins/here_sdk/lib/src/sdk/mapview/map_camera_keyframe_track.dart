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
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/animation/anchor2_d_keyframe.dart';
import 'package:here_sdk/src/sdk/animation/easing.dart';
import 'package:here_sdk/src/sdk/animation/geo_coordinates_keyframe.dart';
import 'package:here_sdk/src/sdk/animation/geo_orientation_keyframe.dart';
import 'package:here_sdk/src/sdk/animation/keyframe_interpolation_mode.dart';
import 'package:here_sdk/src/sdk/animation/point2_d_keyframe.dart';
import 'package:here_sdk/src/sdk/animation/scalar_keyframe.dart';
import 'package:meta/meta.dart';

/// Stores keyframes for interpolation of a camera property using a specific easing function
/// and interpolation mode.
///
/// Can only hold keyframes of a single type.
abstract class MapCameraKeyframeTrack {


  /// Returns [List<ScalarKeyframe>?]. a copy of the scalar keyframes or nothing if this is not a scalar keyframe track.
  ///
  List<ScalarKeyframe>? getScalarKeyframes();

  /// Returns [List<Point2DKeyframe>?]. a copy of the point 2d keyframes or nothing if this is not a point 2d keyframe track.
  ///
  List<Point2DKeyframe>? getPoint2DKeyframes();

  /// Returns [List<Anchor2DKeyframe>?]. a copy of the anchor 2d keyframes or nothing if this is not an anchor 2d keyframe track.
  ///
  List<Anchor2DKeyframe>? getAnchor2DKeyframes();

  /// Returns [List<GeoCoordinatesKeyframe>?]. a copy of the geo coordinates keyframes or nothing if this is not a geo coordinates keyframe track.
  ///
  List<GeoCoordinatesKeyframe>? getGeoCoordinatesKeyframes();

  /// Returns [List<GeoOrientationKeyframe>?]. a copy of the geo orientation keyframes or nothing if this is not a geo orientation keyframe track.
  ///
  List<GeoOrientationKeyframe>? getGeoOrientationKeyframes();
  /// Creates a map camera look-at distance keyframe track.
  ///
  /// It enables animations of the distance
  /// from the map camera to the target point that the camera looks at in meters. The values will
  /// be clamped according to the minimum and maximum zoom levels set for the map camera.
  ///
  /// [keyframes] The list of keyframes that specify how the camera property is changed.
  /// Keyframe time offsets are considered to be relative to the previous keyframe
  /// in the list or relative to the start of the animation if the current keyframe
  /// is first in the list.
  /// Time offset of the first keyframe in the list should be 0, otherwise an error occurs
  /// and creation of the keyframe track will fail.
  ///
  /// [easing] The easing to apply during keyframe interpolation.
  ///
  /// [interpolationMode] The type of interpolation done between keyframe values.
  ///
  /// Returns [MapCameraKeyframeTrack]. A keyframe track over the distance from the map camera to its target.
  ///
  /// Throws [MapCameraKeyframeTrackInstantiationException]. Indicates an instantiation issue.
  ///
  static MapCameraKeyframeTrack lookAtDistanceWithEasing(List<ScalarKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) => $prototype.lookAtDistanceWithEasing(keyframes, easing, interpolationMode);
  /// Creates a map camera look-at target keyframe track.
  ///
  /// It enables animations over the
  /// geographical coordinates of the target point that the map camera is looking at. Setting the
  /// altitude is optional defaulting to ground level.
  ///
  /// [keyframes] The list of keyframes that specify how the camera property is changed.
  /// Keyframe time offsets are considered to be relative to the previous keyframe
  /// in the list or relative to the start of the animation if the current keyframe
  /// is first in the list.
  /// Time offset of the first keyframe in the list should be 0, otherwise an error occurs
  /// and creation of the keyframe track will fail.
  ///
  /// [easing] The easing to apply during keyframe interpolation.
  ///
  /// [interpolationMode] The type of interpolation done between keyframe values.
  ///
  /// Returns [MapCameraKeyframeTrack]. A keyframe track over the map camera target coordinates.
  ///
  /// Throws [MapCameraKeyframeTrackInstantiationException]. Indicates an instantiation issue.
  ///
  static MapCameraKeyframeTrack lookAtTargetWithEasing(List<GeoCoordinatesKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) => $prototype.lookAtTargetWithEasing(keyframes, easing, interpolationMode);
  /// Creates a map camera look-at orientation keyframe track.
  ///
  /// It enables animations over the
  /// orientation of the map camera target (bearing and tilt).
  ///
  /// [keyframes] The list of keyframes that specify how the camera property is changed.
  /// Keyframe time offsets are considered to be relative to the previous keyframe
  /// in the list or relative to the start of the animation if the current keyframe
  /// is first in the list.
  /// Time offset of the first keyframe in the list should be 0, otherwise an error occurs
  /// and creation of the keyframe track will fail.
  ///
  /// [easing] The easing to apply during keyframe interpolation.
  ///
  /// [interpolationMode] The type of interpolation done between keyframe values.
  ///
  /// Returns [MapCameraKeyframeTrack]. A keyframe track over the map camera target orientation.
  ///
  /// Throws [MapCameraKeyframeTrackInstantiationException]. Indicates an instantiation issue.
  ///
  static MapCameraKeyframeTrack lookAtOrientationWithEasing(List<GeoOrientationKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) => $prototype.lookAtOrientationWithEasing(keyframes, easing, interpolationMode);
  /// Creates a map camera principal point keyframe track.
  ///
  /// It enables animations on the pixel point
  /// where the map camera's target is placed in view coordinates. (0,0) is top left of the
  /// viewport, (viewport width, viewport height) is bottom right.
  ///
  /// [keyframes] The list of keyframes that specify how the camera property is changed.
  /// Point values must be in screen (pixel) coordinates with origin (0,0) in the top left of the viewport.
  /// Point values outside of viewport boundaries will be clamped to the viewport boundaries during animation.
  /// Keyframe time offsets are considered to be relative to the previous keyframe
  /// in the list or relative to the start of the animation if the current keyframe
  /// is first in the list.
  /// Time offset of the first keyframe in the list should be 0, otherwise an error occurs
  /// and creation of the keyframe track will fail.
  ///
  /// [easing] The easing to apply during keyframe interpolation.
  ///
  /// [interpolationMode] The type of interpolation done between keyframe values.
  ///
  /// Returns [MapCameraKeyframeTrack]. A keyframe track over the principal point.
  ///
  /// Throws [MapCameraKeyframeTrackInstantiationException]. Indicates an instantiation issue.
  ///
  static MapCameraKeyframeTrack principalPointWithEasing(List<Point2DKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) => $prototype.principalPointWithEasing(keyframes, easing, interpolationMode);
  /// Creates a map camera principal point keyframe track.
  ///
  /// It enables animations on the point
  /// where the map camera's target is placed in normalized view coordinates. (0,0) is top left of
  /// the viewport, (1, 1) is bottom right.
  ///
  /// [keyframes] The list of keyframes that specify how the camera property is changed.
  /// Point values must be in normalized screen coordinates with origin (0,0) in the top left and (1,1) in the bottom right of the viewport.
  /// Point values outside of viewport boundaries will be clamped to the viewport boundaries during animation.
  /// Keyframe time offsets are considered to be relative to the previous keyframe
  /// in the list or relative to the start of the animation if the current keyframe
  /// is first in the list.
  /// Time offset of the first keyframe in the list should be 0, otherwise an error occurs
  /// and creation of the keyframe track will fail.
  ///
  /// [easing] The easing to apply during keyframe interpolation.
  ///
  /// [interpolationMode] The type of interpolation done between keyframe values.
  ///
  /// Returns [MapCameraKeyframeTrack]. A keyframe track over the principal point.
  ///
  /// Throws [MapCameraKeyframeTrackInstantiationException]. Indicates an instantiation issue.
  ///
  static MapCameraKeyframeTrack normalizedPrincipalPointWithEasing(List<Anchor2DKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) => $prototype.normalizedPrincipalPointWithEasing(keyframes, easing, interpolationMode);
  /// Creates a map camera field-of-view keyframe track.
  ///
  /// It enables animations over the angle of
  /// the field of view captured by the map camera in degrees. Values will be clamped to a range
  /// from 1 to 150.
  ///
  /// [keyframes] The list of keyframes that specify how the camera property is changed.
  /// Keyframe time offsets are considered to be relative to the previous keyframe
  /// in the list or relative to the start of the animation if the current keyframe
  /// is first in the list.
  /// Time offset of the first keyframe in the list should be 0, otherwise an error occurs
  /// and creation of the keyframe track will fail.
  ///
  /// [easing] The easing to apply during keyframe interpolation.
  ///
  /// [interpolationMode] The type of interpolation done between keyframe values.
  ///
  /// Returns [MapCameraKeyframeTrack]. A keyframe track over the map camera field-of-view.
  ///
  /// Throws [MapCameraKeyframeTrackInstantiationException]. Indicates an instantiation issue.
  ///
  static MapCameraKeyframeTrack fieldOfViewWithEasing(List<ScalarKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) => $prototype.fieldOfViewWithEasing(keyframes, easing, interpolationMode);
  /// Interpolation mode affects the shape of the spline going through all keyframes.
  KeyframeInterpolationMode get interpolationMode;


  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = MapCameraKeyframeTrack$Impl(Pointer<Void>.fromAddress(0));
}

/// Describes a reason for failing to create a MapCameraKeyframeTrack.
enum MapCameraKeyframeTrackInstantiationErrorCode {
    /// List of keyframes is empty.
    emptyKeyframeList,
    /// Invalid keyframe duration value.
    /// This exception is thrown when the first keyframe duration in a list of keyframes is not equal to 0.
    invalidKeyframeDuration
}

// MapCameraKeyframeTrackInstantiationErrorCode "private" section, not exported.

int sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeToFfi(MapCameraKeyframeTrackInstantiationErrorCode value) {
  switch (value) {
  case MapCameraKeyframeTrackInstantiationErrorCode.emptyKeyframeList:
    return 1;
  case MapCameraKeyframeTrackInstantiationErrorCode.invalidKeyframeDuration:
    return 2;
  default:
    throw StateError("Invalid enum value $value for MapCameraKeyframeTrackInstantiationErrorCode enum.");
  }
}

MapCameraKeyframeTrackInstantiationErrorCode sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(int handle) {
  switch (handle) {
  case 1:
    return MapCameraKeyframeTrackInstantiationErrorCode.emptyKeyframeList;
  case 2:
    return MapCameraKeyframeTrackInstantiationErrorCode.invalidKeyframeDuration;
  default:
    throw StateError("Invalid numeric value $handle for MapCameraKeyframeTrackInstantiationErrorCode enum.");
  }
}

void sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(int handle) {}

final _sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_InstantiationErrorCode_create_handle_nullable'));
final _sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_InstantiationErrorCode_release_handle_nullable'));
final _sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_InstantiationErrorCode_get_value_nullable'));

Pointer<Void> sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeToFfiNullable(MapCameraKeyframeTrackInstantiationErrorCode? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeToFfi(value);
  final result = _sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeCreateHandleNullable(_handle);
  sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(_handle);
  return result;
}

MapCameraKeyframeTrackInstantiationErrorCode? sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeGetValueNullable(handle);
  final result = sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(_handle);
  sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseHandleNullable(handle);

// End of MapCameraKeyframeTrackInstantiationErrorCode "private" section.
/// Thrown when a problem occurs while trying to create [MapCameraKeyframeTrack].
class MapCameraKeyframeTrackInstantiationException implements Exception {
  final MapCameraKeyframeTrackInstantiationErrorCode error;
  MapCameraKeyframeTrackInstantiationException(this.error);
}

// MapCameraKeyframeTrack "private" section, not exported.

final _sdkMapviewMapcamerakeyframetrackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_register_finalizer'));
final _sdkMapviewMapcamerakeyframetrackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_copy_handle'));
final _sdkMapviewMapcamerakeyframetrackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_release_handle'));







final _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtDistance__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_release_handle'));
final _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtDistance__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_get_result'));
final _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtDistance__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_get_error'));
final _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtDistance__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_has_error'));


final _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtTarget__ListOf_sdk_animation_GeoCoordinatesKeyframe_Easing_KeyframeInterpolationMode_return_release_handle'));
final _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtTarget__ListOf_sdk_animation_GeoCoordinatesKeyframe_Easing_KeyframeInterpolationMode_return_get_result'));
final _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtTarget__ListOf_sdk_animation_GeoCoordinatesKeyframe_Easing_KeyframeInterpolationMode_return_get_error'));
final _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtTarget__ListOf_sdk_animation_GeoCoordinatesKeyframe_Easing_KeyframeInterpolationMode_return_has_error'));


final _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtOrientation__ListOf_sdk_animation_GeoOrientationKeyframe_Easing_KeyframeInterpolationMode_return_release_handle'));
final _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtOrientation__ListOf_sdk_animation_GeoOrientationKeyframe_Easing_KeyframeInterpolationMode_return_get_result'));
final _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtOrientation__ListOf_sdk_animation_GeoOrientationKeyframe_Easing_KeyframeInterpolationMode_return_get_error'));
final _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtOrientation__ListOf_sdk_animation_GeoOrientationKeyframe_Easing_KeyframeInterpolationMode_return_has_error'));


final _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_principalPoint__ListOf_sdk_animation_Point2DKeyframe_Easing_KeyframeInterpolationMode_return_release_handle'));
final _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_principalPoint__ListOf_sdk_animation_Point2DKeyframe_Easing_KeyframeInterpolationMode_return_get_result'));
final _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_principalPoint__ListOf_sdk_animation_Point2DKeyframe_Easing_KeyframeInterpolationMode_return_get_error'));
final _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_principalPoint__ListOf_sdk_animation_Point2DKeyframe_Easing_KeyframeInterpolationMode_return_has_error'));


final _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_normalizedPrincipalPoint__ListOf_sdk_animation_Anchor2DKeyframe_Easing_KeyframeInterpolationMode_return_release_handle'));
final _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_normalizedPrincipalPoint__ListOf_sdk_animation_Anchor2DKeyframe_Easing_KeyframeInterpolationMode_return_get_result'));
final _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_normalizedPrincipalPoint__ListOf_sdk_animation_Anchor2DKeyframe_Easing_KeyframeInterpolationMode_return_get_error'));
final _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_normalizedPrincipalPoint__ListOf_sdk_animation_Anchor2DKeyframe_Easing_KeyframeInterpolationMode_return_has_error'));


final _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_fieldOfView__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_release_handle'));
final _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_fieldOfView__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_get_result'));
final _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_fieldOfView__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_get_error'));
final _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapCameraKeyframeTrack_fieldOfView__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode_return_has_error'));


/// @nodoc
@visibleForTesting
class MapCameraKeyframeTrack$Impl extends __lib.NativeBase implements MapCameraKeyframeTrack {

  MapCameraKeyframeTrack$Impl(Pointer<Void> handle) : super(handle);

  @override
  List<ScalarKeyframe>? getScalarKeyframes() {
    final _getScalarKeyframesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_getScalarKeyframes'));
    final _handle = this.handle;
    final __resultHandle = _getScalarKeyframesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkAnimationScalarkeyframeFromFfiNullable(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkAnimationScalarkeyframeReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  List<Point2DKeyframe>? getPoint2DKeyframes() {
    final _getPoint2DKeyframesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_getPoint2DKeyframes'));
    final _handle = this.handle;
    final __resultHandle = _getPoint2DKeyframesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkAnimationPoint2dkeyframeFromFfiNullable(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkAnimationPoint2dkeyframeReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  List<Anchor2DKeyframe>? getAnchor2DKeyframes() {
    final _getAnchor2DKeyframesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_getAnchor2DKeyframes'));
    final _handle = this.handle;
    final __resultHandle = _getAnchor2DKeyframesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkAnimationAnchor2dkeyframeFromFfiNullable(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkAnimationAnchor2dkeyframeReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  List<GeoCoordinatesKeyframe>? getGeoCoordinatesKeyframes() {
    final _getGeoCoordinatesKeyframesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_getGeoCoordinatesKeyframes'));
    final _handle = this.handle;
    final __resultHandle = _getGeoCoordinatesKeyframesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkAnimationGeocoordinateskeyframeFromFfiNullable(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkAnimationGeocoordinateskeyframeReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  List<GeoOrientationKeyframe>? getGeoOrientationKeyframes() {
    final _getGeoOrientationKeyframesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_getGeoOrientationKeyframes'));
    final _handle = this.handle;
    final __resultHandle = _getGeoOrientationKeyframesFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkAnimationGeoorientationkeyframeFromFfiNullable(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkAnimationGeoorientationkeyframeReleaseFfiHandleNullable(__resultHandle);

    }

  }

  MapCameraKeyframeTrack lookAtDistanceWithEasing(List<ScalarKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) {
    final _lookAtDistanceWithEasingFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Uint32), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtDistance__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode'));
    final _keyframesHandle = harpSdkBindingslistofSdkAnimationScalarkeyframeToFfi(keyframes);
    final _easingHandle = sdkAnimationEasingToFfi(easing);
    final _interpolationModeHandle = sdkAnimationKeyframeinterpolationmodeToFfi(interpolationMode);
    final __callResultHandle = _lookAtDistanceWithEasingFfi(__lib.LibraryContext.isolateId, _keyframesHandle, _easingHandle, _interpolationModeHandle);
    harpSdkBindingslistofSdkAnimationScalarkeyframeReleaseFfiHandle(_keyframesHandle);
    sdkAnimationEasingReleaseFfiHandle(_easingHandle);
    sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(_interpolationModeHandle);
    if (_lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetError(__callResultHandle);
        _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
        try {
          throw MapCameraKeyframeTrackInstantiationException(sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetResult(__callResultHandle);
    _lookAtDistanceWithEasingsdkMapviewMapcamerakeyframetrackLookatdistanceListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
    try {
      return sdkMapviewMapcamerakeyframetrackFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(__resultHandle);

    }

  }

  MapCameraKeyframeTrack lookAtTargetWithEasing(List<GeoCoordinatesKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) {
    final _lookAtTargetWithEasingFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Uint32), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtTarget__ListOf_sdk_animation_GeoCoordinatesKeyframe_Easing_KeyframeInterpolationMode'));
    final _keyframesHandle = harpSdkBindingslistofSdkAnimationGeocoordinateskeyframeToFfi(keyframes);
    final _easingHandle = sdkAnimationEasingToFfi(easing);
    final _interpolationModeHandle = sdkAnimationKeyframeinterpolationmodeToFfi(interpolationMode);
    final __callResultHandle = _lookAtTargetWithEasingFfi(__lib.LibraryContext.isolateId, _keyframesHandle, _easingHandle, _interpolationModeHandle);
    harpSdkBindingslistofSdkAnimationGeocoordinateskeyframeReleaseFfiHandle(_keyframesHandle);
    sdkAnimationEasingReleaseFfiHandle(_easingHandle);
    sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(_interpolationModeHandle);
    if (_lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnGetError(__callResultHandle);
        _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
        try {
          throw MapCameraKeyframeTrackInstantiationException(sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnGetResult(__callResultHandle);
    _lookAtTargetWithEasingsdkMapviewMapcamerakeyframetrackLookattargetListofSdkAnimationGeocoordinateskeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
    try {
      return sdkMapviewMapcamerakeyframetrackFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(__resultHandle);

    }

  }

  MapCameraKeyframeTrack lookAtOrientationWithEasing(List<GeoOrientationKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) {
    final _lookAtOrientationWithEasingFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Uint32), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_lookAtOrientation__ListOf_sdk_animation_GeoOrientationKeyframe_Easing_KeyframeInterpolationMode'));
    final _keyframesHandle = harpSdkBindingslistofSdkAnimationGeoorientationkeyframeToFfi(keyframes);
    final _easingHandle = sdkAnimationEasingToFfi(easing);
    final _interpolationModeHandle = sdkAnimationKeyframeinterpolationmodeToFfi(interpolationMode);
    final __callResultHandle = _lookAtOrientationWithEasingFfi(__lib.LibraryContext.isolateId, _keyframesHandle, _easingHandle, _interpolationModeHandle);
    harpSdkBindingslistofSdkAnimationGeoorientationkeyframeReleaseFfiHandle(_keyframesHandle);
    sdkAnimationEasingReleaseFfiHandle(_easingHandle);
    sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(_interpolationModeHandle);
    if (_lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnGetError(__callResultHandle);
        _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
        try {
          throw MapCameraKeyframeTrackInstantiationException(sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnGetResult(__callResultHandle);
    _lookAtOrientationWithEasingsdkMapviewMapcamerakeyframetrackLookatorientationListofSdkAnimationGeoorientationkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
    try {
      return sdkMapviewMapcamerakeyframetrackFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(__resultHandle);

    }

  }

  MapCameraKeyframeTrack principalPointWithEasing(List<Point2DKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) {
    final _principalPointWithEasingFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Uint32), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_principalPoint__ListOf_sdk_animation_Point2DKeyframe_Easing_KeyframeInterpolationMode'));
    final _keyframesHandle = harpSdkBindingslistofSdkAnimationPoint2dkeyframeToFfi(keyframes);
    final _easingHandle = sdkAnimationEasingToFfi(easing);
    final _interpolationModeHandle = sdkAnimationKeyframeinterpolationmodeToFfi(interpolationMode);
    final __callResultHandle = _principalPointWithEasingFfi(__lib.LibraryContext.isolateId, _keyframesHandle, _easingHandle, _interpolationModeHandle);
    harpSdkBindingslistofSdkAnimationPoint2dkeyframeReleaseFfiHandle(_keyframesHandle);
    sdkAnimationEasingReleaseFfiHandle(_easingHandle);
    sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(_interpolationModeHandle);
    if (_principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnGetError(__callResultHandle);
        _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
        try {
          throw MapCameraKeyframeTrackInstantiationException(sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnGetResult(__callResultHandle);
    _principalPointWithEasingsdkMapviewMapcamerakeyframetrackPrincipalpointListofSdkAnimationPoint2dkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
    try {
      return sdkMapviewMapcamerakeyframetrackFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(__resultHandle);

    }

  }

  MapCameraKeyframeTrack normalizedPrincipalPointWithEasing(List<Anchor2DKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) {
    final _normalizedPrincipalPointWithEasingFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Uint32), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_normalizedPrincipalPoint__ListOf_sdk_animation_Anchor2DKeyframe_Easing_KeyframeInterpolationMode'));
    final _keyframesHandle = harpSdkBindingslistofSdkAnimationAnchor2dkeyframeToFfi(keyframes);
    final _easingHandle = sdkAnimationEasingToFfi(easing);
    final _interpolationModeHandle = sdkAnimationKeyframeinterpolationmodeToFfi(interpolationMode);
    final __callResultHandle = _normalizedPrincipalPointWithEasingFfi(__lib.LibraryContext.isolateId, _keyframesHandle, _easingHandle, _interpolationModeHandle);
    harpSdkBindingslistofSdkAnimationAnchor2dkeyframeReleaseFfiHandle(_keyframesHandle);
    sdkAnimationEasingReleaseFfiHandle(_easingHandle);
    sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(_interpolationModeHandle);
    if (_normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnGetError(__callResultHandle);
        _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
        try {
          throw MapCameraKeyframeTrackInstantiationException(sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnGetResult(__callResultHandle);
    _normalizedPrincipalPointWithEasingsdkMapviewMapcamerakeyframetrackNormalizedprincipalpointListofSdkAnimationAnchor2dkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
    try {
      return sdkMapviewMapcamerakeyframetrackFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(__resultHandle);

    }

  }

  MapCameraKeyframeTrack fieldOfViewWithEasing(List<ScalarKeyframe> keyframes, Easing easing, KeyframeInterpolationMode interpolationMode) {
    final _fieldOfViewWithEasingFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Uint32), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_fieldOfView__ListOf_sdk_animation_ScalarKeyframe_Easing_KeyframeInterpolationMode'));
    final _keyframesHandle = harpSdkBindingslistofSdkAnimationScalarkeyframeToFfi(keyframes);
    final _easingHandle = sdkAnimationEasingToFfi(easing);
    final _interpolationModeHandle = sdkAnimationKeyframeinterpolationmodeToFfi(interpolationMode);
    final __callResultHandle = _fieldOfViewWithEasingFfi(__lib.LibraryContext.isolateId, _keyframesHandle, _easingHandle, _interpolationModeHandle);
    harpSdkBindingslistofSdkAnimationScalarkeyframeReleaseFfiHandle(_keyframesHandle);
    sdkAnimationEasingReleaseFfiHandle(_easingHandle);
    sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(_interpolationModeHandle);
    if (_fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetError(__callResultHandle);
        _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
        try {
          throw MapCameraKeyframeTrackInstantiationException(sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapcamerakeyframetrackInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnGetResult(__callResultHandle);
    _fieldOfViewWithEasingsdkMapviewMapcamerakeyframetrackFieldofviewListofSdkAnimationScalarkeyframeEasingKeyframeinterpolationmodeReturnReleaseHandle(__callResultHandle);
    try {
      return sdkMapviewMapcamerakeyframetrackFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  KeyframeInterpolationMode get interpolationMode {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapCameraKeyframeTrack_interpolationMode_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkAnimationKeyframeinterpolationmodeFromFfi(__resultHandle);
    } finally {
      sdkAnimationKeyframeinterpolationmodeReleaseFfiHandle(__resultHandle);

    }

  }



}

Pointer<Void> sdkMapviewMapcamerakeyframetrackToFfi(MapCameraKeyframeTrack value) =>
  _sdkMapviewMapcamerakeyframetrackCopyHandle((value as __lib.NativeBase).handle);

MapCameraKeyframeTrack sdkMapviewMapcamerakeyframetrackFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapCameraKeyframeTrack) return instance;

  final _copiedHandle = _sdkMapviewMapcamerakeyframetrackCopyHandle(handle);
  final result = MapCameraKeyframeTrack$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapcamerakeyframetrackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapcamerakeyframetrackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapcamerakeyframetrackReleaseHandle(handle);

Pointer<Void> sdkMapviewMapcamerakeyframetrackToFfiNullable(MapCameraKeyframeTrack? value) =>
  value != null ? sdkMapviewMapcamerakeyframetrackToFfi(value) : Pointer<Void>.fromAddress(0);

MapCameraKeyframeTrack? sdkMapviewMapcamerakeyframetrackFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapcamerakeyframetrackFromFfi(handle) : null;

void sdkMapviewMapcamerakeyframetrackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapcamerakeyframetrackReleaseHandle(handle);

// End of MapCameraKeyframeTrack "private" section.


