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
import 'package:here_sdk/src/_type_repository.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/anchor2_d.dart';
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/core/point2_d.dart';
import 'package:here_sdk/src/sdk/core/rectangle2_d.dart';
import 'package:here_sdk/src/sdk/core/size2_d.dart';
import 'package:here_sdk/src/sdk/gestures/gestures.dart';
import 'package:here_sdk/src/sdk/mapview/here_map_controller_core.dart';
import 'package:here_sdk/src/sdk/mapview/map_camera.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:here_sdk/src/sdk/mapview/map_pick_result.dart';
import 'package:here_sdk/src/sdk/mapview/map_scene.dart';
import 'package:here_sdk/src/sdk/mapview/map_view_lifecycle_listener.dart';
import 'package:here_sdk/src/sdk/mapview/pick_map_content_result.dart';
import 'package:here_sdk/src/sdk/mapview/pick_map_items_result.dart';

/// Represents the available public API from  MapView.
abstract class MapViewBase {
  /// Represents the available public API from  MapView.

  factory MapViewBase(
    GeoCoordinates? Function(Point2D) viewToGeoCoordinatesLambda,
    Point2D? Function(GeoCoordinates) geoToViewCoordinatesLambda,
    void Function(Anchor2D, Point2D) setWatermarkLocationLambda,
    void Function(MapViewLifecycleListener) addLifecycleListenerLambda,
    void Function(MapViewLifecycleListener) removeLifecycleListenerLambda,
    void Function(Point2D, double, MapViewBasePickMapItemsCallback) pickMapItemsLambda,
    void Function(Rectangle2D, PickMapContentCallback) pickMapContentLambda,
    void Function(MapSceneMapPickFilter?, Rectangle2D, MapViewBaseMapPickCallback) pickLambda,
    bool Function() isValidGetLambda,
    MapCamera Function() cameraGetLambda,
    Gestures Function() gesturesGetLambda,
    MapScene Function() mapSceneGetLambda,
    MapContext Function() mapContextGetLambda,
    HereMapControllerCore Function() hereMapControllerCoreGetLambda,
    Size2D Function() viewportSizeGetLambda,
    int Function() frameRateGetLambda,
    void Function(int) frameRateSetLambda,
    double Function() pixelScaleGetLambda,
    Size2D Function() watermarkSizeGetLambda
  ) => MapViewBase$Lambdas(
    viewToGeoCoordinatesLambda,
    geoToViewCoordinatesLambda,
    setWatermarkLocationLambda,
    addLifecycleListenerLambda,
    removeLifecycleListenerLambda,
    pickMapItemsLambda,
    pickMapContentLambda,
    pickLambda,
    isValidGetLambda,
    cameraGetLambda,
    gesturesGetLambda,
    mapSceneGetLambda,
    mapContextGetLambda,
    hereMapControllerCoreGetLambda,
    viewportSizeGetLambda,
    frameRateGetLambda,
    frameRateSetLambda,
    pixelScaleGetLambda,
    watermarkSizeGetLambda
  );

  /// Converts view coordinates (in pixels) to geographical coordinates.
  ///
  /// An optional altitude component of the resulting geographical coordinate is not set.
  ///
  /// If the view coordinates specify a point above a horizon, then the result
  /// is geographical coordinates of the point on a horizon below the specified
  /// view coordinates.
  ///
  /// The fog effect is ignored for the calculation, meaning that for the view point
  /// within the area covered by the fog, the result is geographical coordinates
  /// that would be displayed at the specified point if the fog effect was
  /// not applied.
  ///
  /// If the render surface is not attached, it will return `null`.
  ///
  /// [viewCoordinates] Point inside the view to convert.
  ///
  /// Returns [GeoCoordinates?]. The geographical coordinates under specified view point or `null` if there is no render surface attached.
  ///
  GeoCoordinates? viewToGeoCoordinates(Point2D viewCoordinates);
  /// Converts geographical coordinates to view coordinates (in pixels).
  ///
  /// If specified, altitude of the input coordinates is interpreted as altitude above sea level.
  /// If not specified, the input coordinates are interpreted as being on ground elevation.
  /// The above distinction is only relevant when 3D terrain feature is enabled.
  ///
  /// The resulting view coordinates might be outside of current viewport, i.e. result might contain values
  /// less than zero or greater than view's dimensions.
  ///
  /// If the render surface is not attached, it will return `null`.
  ///
  /// [geoCoordinates] Geographical coordinates to convert.
  ///
  /// Returns [Point2D?]. The view coordinates of the specified geographical point or `null`
  /// if there is no render surface attached.
  ///
  Point2D? geoToViewCoordinates(GeoCoordinates geoCoordinates);
  /// Sets the position of the HERE logo watermark within the map view.
  ///
  /// By default, the watermark is aligned to the bottom-right corner of the view:
  /// Anchor2D(1.0, 1.0) and Point2D(-watermarkSize.width / 2, -watermarkSize.height / 2).
  /// It is recommended to change the default position only if necessary to avoid overlapping UI elements.
  /// The watermark should always be fully visible within the view.
  /// The anchor point on the watermark is its center (width/2, height/2), around which it will be placed
  /// in the map view.
  /// For map views smaller than 250 dip in both width and height, the watermark will not be shown.
  ///
  /// [anchor] Anchor point in normalized view coordinates \[0, 1\]. Map view's origin at (0, 0) indicates
  /// a top-left corner of the map view.
  /// Out of boundary anchor point values will be clamped to the \[0, 1\] range.
  ///
  /// [offset] A horizontal and vertical offset (expressed in positive/negative pixel coordinates) that
  /// allows shifting the watermark from the anchor point position in one or the other
  /// direction.
  /// For the quadrant of values expressing visible part of the map view negative offset shifts
  /// the watermark to the direction of the origin, positive - away from it.
  /// For example, the offset of (-10, 5) will shift the watermark 10px to the left and 5px to
  /// the bottom.
  /// If specified offset will result in watermark being completely or partially out-of-view
  /// the offset will be adjusted internally so that watermark is fully visible.
  /// Offset is not being scaled when the map view size changes.
  ///
  void setWatermarkLocation(Anchor2D anchor, Point2D offset);
  /// Adds a [MapViewLifecycleListener] to this map view.
  ///
  /// Adding the same object multiple times has no effect.
  ///
  /// [lifecycleListener] An object to be notified of lifecycle events.
  ///
  void addLifecycleListener(MapViewLifecycleListener lifecycleListener);
  /// Removes a [MapViewLifecycleListener] from this map view.
  ///
  /// Trying to remove an object that was not added or was removed before
  /// has no effect.
  ///
  /// [lifecycleListener] An object to stop being notified of lifecycle events.
  ///
  void removeLifecycleListener(MapViewLifecycleListener lifecycleListener);
  /// Returns all map items located inside the specified pick area.
  ///
  /// The pick area is a circle
  /// defined by a center point and radius.
  ///
  /// [centerPoint] The center point of the pick area, in map view coordinates (in pixels), relative to
  /// the map view's origin at (0, 0) which indicates the top-left corner of the map view.
  ///
  /// [radius] The radius of the pick area, in pixels.
  ///
  /// [callback] Callback to call with the result. This will be called on main thread when the operation
  /// has completed.
  ///
  @Deprecated("Will be removed in v4.22.0. Please use [MapViewBase.pick] instead.")

  void pickMapItems(Point2D centerPoint, double radius, MapViewBasePickMapItemsCallback callback);
  /// Returns all map content located inside the specified pick area.
  ///
  /// Pickable map content
  /// currently consist of:
  /// - Embedded carto POI markers that are available on the map, by default.
  /// - Traffic incidents which are visible when they are enabled using [MapScene.enableFeatures]
  ///   with [MapFeatures.trafficIncidents]. Note: Using the deprecated method
  ///   [MapScene.setLayerVisibility] together with [MapScene.enableFeatures] is not supported.
  /// - Vehicle restrictions which are only available for the _Navigate Edition_.
  ///   Vehicle restrictions are enabled using [MapScene.enableFeatures] with
  ///   `MapFeatures.VEHICLE_RESTRICTIONS`. Please note that the vehicle restriction line marking the
  ///   affected street is pickable and not the restriction icon itself. If the `viewArea` rectangle
  ///   passed in is not too small then tapping on the icon will always include the respective
  ///   vehicle restriction in the callback.
  ///
  /// Only visible POIs, traffic incidents and vehicle restrictions lines can be picked, i.e. only
  /// those categories that were not hidden by `MapScene.setPoiVisibility()` and those which aren't
  /// covered by any custom marker. The pick area is defined by a rectangle in map view coordinates
  /// in pixels, relative to the map view's origin at (0, 0) which indicates the top-left corner
  /// of the map view.
  ///
  /// Note: Map items that are added by the user can be picked with
  /// [MapViewBase.pickMapItems] instead.
  ///
  /// [viewArea] The rectangular area of the view inside which map content will be picked.
  ///
  /// [callback] Callback to call with the result. This will be called on main thread when the operation
  /// has completed.
  ///
  @Deprecated("Will be removed in v4.22.0. Please use [MapViewBase.pick] instead.")

  void pickMapContent(Rectangle2D viewArea, PickMapContentCallback callback);
  /// Returns all map content located inside the specified pick area.
  ///
  /// Content to be picked is
  /// specified by a pick content filter.
  /// The pick area is defined by a rectangle in map view coordinates
  /// in pixels, relative to the map view's origin at (0, 0) which indicates the top-left corner
  /// of the map view.
  ///
  /// [filter] Filter for the map content to be picked. When a filter is not set all of the pickable content will be picked.
  ///
  /// [viewArea] The rectangular pixel area of the view inside which map content will be picked.
  /// View area is relative to the map view's origin at (0, 0) at the top-left corner
  /// of the map view.
  ///
  /// [callback] Callback to call with the result. This will be called on a main thread when pick operation
  /// completes.
  ///
  void pick(MapSceneMapPickFilter? filter, Rectangle2D viewArea, MapViewBaseMapPickCallback callback);
  /// Indicates whether this instance is valid. It will be made invalid
  /// when the corresponding `SDKNativeEngine` is destroyed.
  /// Returns true if this instance is valid, false otherwise. It will be made
  /// invalid when the corresponding `SDKNativeEngine` is destroyed.
  bool get isValid;

  /// The camera to control the view for the map.
  /// Gets the camera to control the view for the map.
  MapCamera get camera;

  /// The gestures control object for setting up the capture of gestures.
  /// Gets the gestures control object.
  Gestures get gestures;

  /// Map scene associated with this map view.
  /// Gets the map scene associated with this map view.
  MapScene get mapScene;

  /// Map context associated with this map view.
  /// Gets the map context associated with this map view.
  MapContext get mapContext;

  /// Here Map associated with this map view.
  /// Gets the [HereMapControllerCore] associated with this map view.
  HereMapControllerCore get hereMapControllerCore;

  /// The size of this map view in physical pixels.
  /// If internally the map view's render surface is not attached yet
  /// (see: [MapViewLifecycleListener]), or after the map view has been destroyed
  /// then a `Size2D` with zero width and height is returned.
  /// Gets the size of this map view in physical pixels.
  /// If internally the map view's render surface is not attached yet
  /// (see: [MapViewLifecycleListener]), or after the map view has been destroyed
  /// then a `Size2D` with zero width and height is returned.
  Size2D get viewportSize;

  /// Maximum render frame rate in frames per second. Setting to 0 disables automatic rendering for this view. Setting negative values has no effect.
  /// The default value is 60 frames per second.
  /// Gets maximum render frame rate in frames per second.
  int get frameRate;
  /// Maximum render frame rate in frames per second. Setting to 0 disables automatic rendering for this view. Setting negative values has no effect.
  /// The default value is 60 frames per second.
  /// Sets maximum render frame rate in frames per second. Setting to 0 disables automatic rendering for this view.
  /// Setting negative values has no effect. The default value is 60 frames per second.
  set frameRate(int value);

  /// The pixel scale factor used by this MapView.
  ///
  /// It is used to support screen resolution and size independence.
  /// This value is a derivative of the device's screen pixel density and is a direct analog of
  ///
  /// devicePixelRatio from FlutterView, ViewConfiguration or MediaQueryData.
  /// It can be used to translate between physical pixels and
  ///
  /// logical pixels
  /// according to formula:
  ///
  /// logical_pixels = pixels / pixel_scale.
  ///
  /// Pixel scale is 0.0 if the map view is not initialized.
  /// Gets the pixel scale factor used by this MapView.
  /// It is used to support screen resolution and size independence.
  /// This value is a derivative of the device's screen pixel density and is a direct analog of
  ///
  /// devicePixelRatio from FlutterView, ViewConfiguration or MediaQueryData.
  /// It can be used to translate between physical pixels and
  ///
  /// logical pixels
  /// according to the formula:
  ///
  /// logical_pixels = pixels / pixel_scale.
  double get pixelScale;

  /// Provides the size of the watermark in physical pixels.
  /// Returns the watermark size in physical pixels.
  Size2D get watermarkSize;

}

/// Callback after pick map items operation has completed.
///
/// If the pick operation failed,
/// `null` will be returned.
///
/// [p0] The operation result.
@Deprecated("Will be removed in v4.22.0.")
typedef MapViewBasePickMapItemsCallback = void Function(PickMapItemsResult?);

// MapViewBasePickMapItemsCallback "private" section, not exported.

final _sdkMapviewMapviewbasePickmapitemscallbackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_register_finalizer'));
final _sdkMapviewMapviewbasePickmapitemscallbackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_copy_handle'));
final _sdkMapviewMapviewbasePickmapitemscallbackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_release_handle'));
final _sdkMapviewMapviewbasePickmapitemscallbackCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_create_proxy'));

class MapViewBasePickMapItemsCallback$Impl {
  final Pointer<Void> handle;
  MapViewBasePickMapItemsCallback$Impl(this.handle);

  void call(PickMapItemsResult? p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_call__PickMapItemsResult_'));
    final _p0Handle = sdkMapviewPickmapitemsresultToFfiNullable(p0);
    final _handle = this.handle;
    _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewPickmapitemsresultReleaseFfiHandleNullable(_p0Handle);

  }

}

int _sdkMapviewMapviewbasePickmapitemscallbackcallStatic(Object _obj, Pointer<Void> p0) {
  
  try {
    (_obj as MapViewBasePickMapItemsCallback)(sdkMapviewPickmapitemsresultFromFfiNullable(p0));
  } finally {
    sdkMapviewPickmapitemsresultReleaseFfiHandleNullable(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewMapviewbasePickmapitemscallbackToFfi(MapViewBasePickMapItemsCallback value) =>
  _sdkMapviewMapviewbasePickmapitemscallbackCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>)>(_sdkMapviewMapviewbasePickmapitemscallbackcallStatic, __lib.unknownError)
  );

MapViewBasePickMapItemsCallback sdkMapviewMapviewbasePickmapitemscallbackFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewMapviewbasePickmapitemscallbackCopyHandle(handle);
  final _impl = MapViewBasePickMapItemsCallback$Impl(_copiedHandle);
  final result = (PickMapItemsResult? p0) => _impl.call(p0);
  _sdkMapviewMapviewbasePickmapitemscallbackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapviewbasePickmapitemscallbackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapviewbasePickmapitemscallbackReleaseHandle(handle);

// Nullable MapViewBasePickMapItemsCallback

final _sdkMapviewMapviewbasePickmapitemscallbackCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_create_handle_nullable'));
final _sdkMapviewMapviewbasePickmapitemscallbackReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_release_handle_nullable'));
final _sdkMapviewMapviewbasePickmapitemscallbackGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapItemsCallback_get_value_nullable'));

Pointer<Void> sdkMapviewMapviewbasePickmapitemscallbackToFfiNullable(MapViewBasePickMapItemsCallback? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapviewbasePickmapitemscallbackToFfi(value);
  final result = _sdkMapviewMapviewbasePickmapitemscallbackCreateHandleNullable(_handle);
  sdkMapviewMapviewbasePickmapitemscallbackReleaseFfiHandle(_handle);
  return result;
}

MapViewBasePickMapItemsCallback? sdkMapviewMapviewbasePickmapitemscallbackFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapviewbasePickmapitemscallbackGetValueNullable(handle);
  final result = sdkMapviewMapviewbasePickmapitemscallbackFromFfi(_handle);
  sdkMapviewMapviewbasePickmapitemscallbackReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapviewbasePickmapitemscallbackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapviewbasePickmapitemscallbackReleaseHandleNullable(handle);

// End of MapViewBasePickMapItemsCallback "private" section.
/// Callback after pick map features operation has completed.
///
/// If the pick operation failed,
/// `null` will be returned.
///
/// [p0] The operation result.
@Deprecated("Will be removed in v4.22.0.")
typedef PickMapContentCallback = void Function(PickMapContentResult?);

// PickMapContentCallback "private" section, not exported.

final _sdkMapviewMapviewbasePickmapcontentcallbackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_register_finalizer'));
final _sdkMapviewMapviewbasePickmapcontentcallbackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_copy_handle'));
final _sdkMapviewMapviewbasePickmapcontentcallbackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_release_handle'));
final _sdkMapviewMapviewbasePickmapcontentcallbackCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_create_proxy'));

class PickMapContentCallback$Impl {
  final Pointer<Void> handle;
  PickMapContentCallback$Impl(this.handle);

  void call(PickMapContentResult? p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_call__PickMapContentResult_'));
    final _p0Handle = sdkMapviewPickmapcontentresultToFfiNullable(p0);
    final _handle = this.handle;
    _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewPickmapcontentresultReleaseFfiHandleNullable(_p0Handle);

  }

}

int _sdkMapviewMapviewbasePickmapcontentcallbackcallStatic(Object _obj, Pointer<Void> p0) {
  
  try {
    (_obj as PickMapContentCallback)(sdkMapviewPickmapcontentresultFromFfiNullable(p0));
  } finally {
    sdkMapviewPickmapcontentresultReleaseFfiHandleNullable(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewMapviewbasePickmapcontentcallbackToFfi(PickMapContentCallback value) =>
  _sdkMapviewMapviewbasePickmapcontentcallbackCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>)>(_sdkMapviewMapviewbasePickmapcontentcallbackcallStatic, __lib.unknownError)
  );

PickMapContentCallback sdkMapviewMapviewbasePickmapcontentcallbackFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewMapviewbasePickmapcontentcallbackCopyHandle(handle);
  final _impl = PickMapContentCallback$Impl(_copiedHandle);
  final result = (PickMapContentResult? p0) => _impl.call(p0);
  _sdkMapviewMapviewbasePickmapcontentcallbackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapviewbasePickmapcontentcallbackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapviewbasePickmapcontentcallbackReleaseHandle(handle);

// Nullable PickMapContentCallback

final _sdkMapviewMapviewbasePickmapcontentcallbackCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_create_handle_nullable'));
final _sdkMapviewMapviewbasePickmapcontentcallbackReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_release_handle_nullable'));
final _sdkMapviewMapviewbasePickmapcontentcallbackGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_PickMapContentCallback_get_value_nullable'));

Pointer<Void> sdkMapviewMapviewbasePickmapcontentcallbackToFfiNullable(PickMapContentCallback? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapviewbasePickmapcontentcallbackToFfi(value);
  final result = _sdkMapviewMapviewbasePickmapcontentcallbackCreateHandleNullable(_handle);
  sdkMapviewMapviewbasePickmapcontentcallbackReleaseFfiHandle(_handle);
  return result;
}

PickMapContentCallback? sdkMapviewMapviewbasePickmapcontentcallbackFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapviewbasePickmapcontentcallbackGetValueNullable(handle);
  final result = sdkMapviewMapviewbasePickmapcontentcallbackFromFfi(_handle);
  sdkMapviewMapviewbasePickmapcontentcallbackReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapviewbasePickmapcontentcallbackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapviewbasePickmapcontentcallbackReleaseHandleNullable(handle);

// End of PickMapContentCallback "private" section.
/// Callback for a pick request.
///
/// In case of an error the result is not set.
///
/// [p0] The operation result.
typedef MapViewBaseMapPickCallback = void Function(MapPickResult?);

// MapViewBaseMapPickCallback "private" section, not exported.

final _sdkMapviewMapviewbaseMappickcallbackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_register_finalizer'));
final _sdkMapviewMapviewbaseMappickcallbackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_copy_handle'));
final _sdkMapviewMapviewbaseMappickcallbackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_release_handle'));
final _sdkMapviewMapviewbaseMappickcallbackCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_create_proxy'));

class MapViewBaseMapPickCallback$Impl {
  final Pointer<Void> handle;
  MapViewBaseMapPickCallback$Impl(this.handle);

  void call(MapPickResult? p0) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_call__MapPickResult_'));
    final _p0Handle = sdkMapviewMappickresultToFfiNullable(p0);
    final _handle = this.handle;
    _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle);
    sdkMapviewMappickresultReleaseFfiHandleNullable(_p0Handle);

  }

}

int _sdkMapviewMapviewbaseMappickcallbackcallStatic(Object _obj, Pointer<Void> p0) {
  
  try {
    (_obj as MapViewBaseMapPickCallback)(sdkMapviewMappickresultFromFfiNullable(p0));
  } finally {
    sdkMapviewMappickresultReleaseFfiHandleNullable(p0);
  }
  return 0;
}

Pointer<Void> sdkMapviewMapviewbaseMappickcallbackToFfi(MapViewBaseMapPickCallback value) =>
  _sdkMapviewMapviewbaseMappickcallbackCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>)>(_sdkMapviewMapviewbaseMappickcallbackcallStatic, __lib.unknownError)
  );

MapViewBaseMapPickCallback sdkMapviewMapviewbaseMappickcallbackFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewMapviewbaseMappickcallbackCopyHandle(handle);
  final _impl = MapViewBaseMapPickCallback$Impl(_copiedHandle);
  final result = (MapPickResult? p0) => _impl.call(p0);
  _sdkMapviewMapviewbaseMappickcallbackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapviewbaseMappickcallbackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapviewbaseMappickcallbackReleaseHandle(handle);

// Nullable MapViewBaseMapPickCallback

final _sdkMapviewMapviewbaseMappickcallbackCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_create_handle_nullable'));
final _sdkMapviewMapviewbaseMappickcallbackReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_release_handle_nullable'));
final _sdkMapviewMapviewbaseMappickcallbackGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_MapPickCallback_get_value_nullable'));

Pointer<Void> sdkMapviewMapviewbaseMappickcallbackToFfiNullable(MapViewBaseMapPickCallback? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapviewbaseMappickcallbackToFfi(value);
  final result = _sdkMapviewMapviewbaseMappickcallbackCreateHandleNullable(_handle);
  sdkMapviewMapviewbaseMappickcallbackReleaseFfiHandle(_handle);
  return result;
}

MapViewBaseMapPickCallback? sdkMapviewMapviewbaseMappickcallbackFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapviewbaseMappickcallbackGetValueNullable(handle);
  final result = sdkMapviewMapviewbaseMappickcallbackFromFfi(_handle);
  sdkMapviewMapviewbaseMappickcallbackReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapviewbaseMappickcallbackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapviewbaseMappickcallbackReleaseHandleNullable(handle);

// End of MapViewBaseMapPickCallback "private" section.

// MapViewBase "private" section, not exported.

final _sdkMapviewMapviewbaseRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapViewBase_register_finalizer'));
final _sdkMapviewMapviewbaseCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_copy_handle'));
final _sdkMapviewMapviewbaseReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_release_handle'));
final _sdkMapviewMapviewbaseCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_mapview_MapViewBase_create_proxy'));
final _sdkMapviewMapviewbaseGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapViewBase_get_type_id'));









class MapViewBase$Lambdas implements MapViewBase {
  GeoCoordinates? Function(Point2D) viewToGeoCoordinatesLambda;
  Point2D? Function(GeoCoordinates) geoToViewCoordinatesLambda;
  void Function(Anchor2D, Point2D) setWatermarkLocationLambda;
  void Function(MapViewLifecycleListener) addLifecycleListenerLambda;
  void Function(MapViewLifecycleListener) removeLifecycleListenerLambda;
  void Function(Point2D, double, MapViewBasePickMapItemsCallback) pickMapItemsLambda;
  void Function(Rectangle2D, PickMapContentCallback) pickMapContentLambda;
  void Function(MapSceneMapPickFilter?, Rectangle2D, MapViewBaseMapPickCallback) pickLambda;
  bool Function() isValidGetLambda;
  MapCamera Function() cameraGetLambda;
  Gestures Function() gesturesGetLambda;
  MapScene Function() mapSceneGetLambda;
  MapContext Function() mapContextGetLambda;
  HereMapControllerCore Function() hereMapControllerCoreGetLambda;
  Size2D Function() viewportSizeGetLambda;
  int Function() frameRateGetLambda;
  void Function(int) frameRateSetLambda;
  double Function() pixelScaleGetLambda;
  Size2D Function() watermarkSizeGetLambda;

  MapViewBase$Lambdas(
    this.viewToGeoCoordinatesLambda,
    this.geoToViewCoordinatesLambda,
    this.setWatermarkLocationLambda,
    this.addLifecycleListenerLambda,
    this.removeLifecycleListenerLambda,
    this.pickMapItemsLambda,
    this.pickMapContentLambda,
    this.pickLambda,
    this.isValidGetLambda,
    this.cameraGetLambda,
    this.gesturesGetLambda,
    this.mapSceneGetLambda,
    this.mapContextGetLambda,
    this.hereMapControllerCoreGetLambda,
    this.viewportSizeGetLambda,
    this.frameRateGetLambda,
    this.frameRateSetLambda,
    this.pixelScaleGetLambda,
    this.watermarkSizeGetLambda
  );

  @override
  GeoCoordinates? viewToGeoCoordinates(Point2D viewCoordinates) =>
    viewToGeoCoordinatesLambda(viewCoordinates);
  @override
  Point2D? geoToViewCoordinates(GeoCoordinates geoCoordinates) =>
    geoToViewCoordinatesLambda(geoCoordinates);
  @override
  void setWatermarkLocation(Anchor2D anchor, Point2D offset) =>
    setWatermarkLocationLambda(anchor, offset);
  @override
  void addLifecycleListener(MapViewLifecycleListener lifecycleListener) =>
    addLifecycleListenerLambda(lifecycleListener);
  @override
  void removeLifecycleListener(MapViewLifecycleListener lifecycleListener) =>
    removeLifecycleListenerLambda(lifecycleListener);
  @override
  void pickMapItems(Point2D centerPoint, double radius, MapViewBasePickMapItemsCallback callback) =>
    pickMapItemsLambda(centerPoint, radius, callback);
  @override
  void pickMapContent(Rectangle2D viewArea, PickMapContentCallback callback) =>
    pickMapContentLambda(viewArea, callback);
  @override
  void pick(MapSceneMapPickFilter? filter, Rectangle2D viewArea, MapViewBaseMapPickCallback callback) =>
    pickLambda(filter, viewArea, callback);
  @override
  bool get isValid => isValidGetLambda();
  @override
  MapCamera get camera => cameraGetLambda();
  @override
  Gestures get gestures => gesturesGetLambda();
  @override
  MapScene get mapScene => mapSceneGetLambda();
  @override
  MapContext get mapContext => mapContextGetLambda();
  @override
  HereMapControllerCore get hereMapControllerCore => hereMapControllerCoreGetLambda();
  @override
  Size2D get viewportSize => viewportSizeGetLambda();
  @override
  int get frameRate => frameRateGetLambda();
  @override
  set frameRate(int value) => frameRateSetLambda(value);
  @override
  double get pixelScale => pixelScaleGetLambda();
  @override
  Size2D get watermarkSize => watermarkSizeGetLambda();
}

class MapViewBase$Impl extends __lib.NativeBase implements MapViewBase {

  MapViewBase$Impl(Pointer<Void> handle) : super(handle);

  @override
  GeoCoordinates? viewToGeoCoordinates(Point2D viewCoordinates) {
    final _viewToGeoCoordinatesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_viewToGeoCoordinates__Point2D'));
    final _viewCoordinatesHandle = sdkCorePoint2dToFfi(viewCoordinates);
    final _handle = this.handle;
    final __resultHandle = _viewToGeoCoordinatesFfi(_handle, __lib.LibraryContext.isolateId, _viewCoordinatesHandle);
    sdkCorePoint2dReleaseFfiHandle(_viewCoordinatesHandle);
    try {
      return sdkCoreGeocoordinatesFromFfiNullable(__resultHandle);
    } finally {
      sdkCoreGeocoordinatesReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  Point2D? geoToViewCoordinates(GeoCoordinates geoCoordinates) {
    final _geoToViewCoordinatesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_geoToViewCoordinates__GeoCoordinates'));
    final _geoCoordinatesHandle = sdkCoreGeocoordinatesToFfi(geoCoordinates);
    final _handle = this.handle;
    final __resultHandle = _geoToViewCoordinatesFfi(_handle, __lib.LibraryContext.isolateId, _geoCoordinatesHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_geoCoordinatesHandle);
    try {
      return sdkCorePoint2dFromFfiNullable(__resultHandle);
    } finally {
      sdkCorePoint2dReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  void setWatermarkLocation(Anchor2D anchor, Point2D offset) {
    final _setWatermarkLocationFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_setWatermarkLocation__Anchor2D_Point2D'));
    final _anchorHandle = sdkCoreAnchor2dToFfi(anchor);
    final _offsetHandle = sdkCorePoint2dToFfi(offset);
    final _handle = this.handle;
    _setWatermarkLocationFfi(_handle, __lib.LibraryContext.isolateId, _anchorHandle, _offsetHandle);
    sdkCoreAnchor2dReleaseFfiHandle(_anchorHandle);
    sdkCorePoint2dReleaseFfiHandle(_offsetHandle);

  }

  @override
  void addLifecycleListener(MapViewLifecycleListener lifecycleListener) {
    final _addLifecycleListenerFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_addLifecycleListener__MapViewLifecycleListener'));
    final _lifecycleListenerHandle = sdkMapviewMapviewlifecyclelistenerToFfi(lifecycleListener);
    final _handle = this.handle;
    _addLifecycleListenerFfi(_handle, __lib.LibraryContext.isolateId, _lifecycleListenerHandle);
    sdkMapviewMapviewlifecyclelistenerReleaseFfiHandle(_lifecycleListenerHandle);

  }

  @override
  void removeLifecycleListener(MapViewLifecycleListener lifecycleListener) {
    final _removeLifecycleListenerFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_removeLifecycleListener__MapViewLifecycleListener'));
    final _lifecycleListenerHandle = sdkMapviewMapviewlifecyclelistenerToFfi(lifecycleListener);
    final _handle = this.handle;
    _removeLifecycleListenerFfi(_handle, __lib.LibraryContext.isolateId, _lifecycleListenerHandle);
    sdkMapviewMapviewlifecyclelistenerReleaseFfiHandle(_lifecycleListenerHandle);

  }

  @override
  void pickMapItems(Point2D centerPoint, double radius, MapViewBasePickMapItemsCallback callback) {
    final _pickMapItemsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Double, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, double, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_pickMapItems__Point2D_Double_PickMapItemsCallback'));
    final _centerPointHandle = sdkCorePoint2dToFfi(centerPoint);
    final _radiusHandle = (radius);
    final _callbackHandle = sdkMapviewMapviewbasePickmapitemscallbackToFfi(callback);
    final _handle = this.handle;
    _pickMapItemsFfi(_handle, __lib.LibraryContext.isolateId, _centerPointHandle, _radiusHandle, _callbackHandle);
    sdkCorePoint2dReleaseFfiHandle(_centerPointHandle);

    sdkMapviewMapviewbasePickmapitemscallbackReleaseFfiHandle(_callbackHandle);

  }

  @override
  void pickMapContent(Rectangle2D viewArea, PickMapContentCallback callback) {
    final _pickMapContentFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_pickMapContent__Rectangle2D_PickMapContentCallback'));
    final _viewAreaHandle = sdkCoreRectangle2dToFfi(viewArea);
    final _callbackHandle = sdkMapviewMapviewbasePickmapcontentcallbackToFfi(callback);
    final _handle = this.handle;
    _pickMapContentFfi(_handle, __lib.LibraryContext.isolateId, _viewAreaHandle, _callbackHandle);
    sdkCoreRectangle2dReleaseFfiHandle(_viewAreaHandle);
    sdkMapviewMapviewbasePickmapcontentcallbackReleaseFfiHandle(_callbackHandle);

  }

  @override
  void pick(MapSceneMapPickFilter? filter, Rectangle2D viewArea, MapViewBaseMapPickCallback callback) {
    final _pickFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapViewBase_pick__MapPickFilter__Rectangle2D_MapPickCallback'));
    final _filterHandle = sdkMapviewMapsceneMappickfilterToFfiNullable(filter);
    final _viewAreaHandle = sdkCoreRectangle2dToFfi(viewArea);
    final _callbackHandle = sdkMapviewMapviewbaseMappickcallbackToFfi(callback);
    final _handle = this.handle;
    _pickFfi(_handle, __lib.LibraryContext.isolateId, _filterHandle, _viewAreaHandle, _callbackHandle);
    sdkMapviewMapsceneMappickfilterReleaseFfiHandleNullable(_filterHandle);
    sdkCoreRectangle2dReleaseFfiHandle(_viewAreaHandle);
    sdkMapviewMapviewbaseMappickcallbackReleaseFfiHandle(_callbackHandle);

  }

  /// Returns true if this instance is valid, false otherwise. It will be made
  /// invalid when the corresponding `SDKNativeEngine` is destroyed.
  bool get isValid {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint8 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_isValid_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return booleanFromFfi(__resultHandle);
    } finally {
      booleanReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the camera to control the view for the map.
  MapCamera get camera {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_camera_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewMapcameraFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcameraReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the gestures control object.
  Gestures get gestures {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_gestures_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkGesturesGesturesFromFfi(__resultHandle);
    } finally {
      sdkGesturesGesturesReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the map scene associated with this map view.
  MapScene get mapScene {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_mapScene_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewMapsceneFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapsceneReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the map context associated with this map view.
  MapContext get mapContext {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_mapContext_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewMapcontextFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapcontextReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the [HereMapControllerCore] associated with this map view.
  HereMapControllerCore get hereMapControllerCore {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_hereMap_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewHeremapFromFfi(__resultHandle);
    } finally {
      sdkMapviewHeremapReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets the size of this map view in physical pixels.
  /// If internally the map view's render surface is not attached yet
  /// (see: [MapViewLifecycleListener]), or after the map view has been destroyed
  /// then a `Size2D` with zero width and height is returned.
  Size2D get viewportSize {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_viewportSize_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreSize2dFromFfi(__resultHandle);
    } finally {
      sdkCoreSize2dReleaseFfiHandle(__resultHandle);

    }

  }


  /// Gets maximum render frame rate in frames per second.
  int get frameRate {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Int32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_frameRate_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }

  /// Sets maximum render frame rate in frames per second. Setting to 0 disables automatic rendering for this view.
  /// Setting negative values has no effect. The default value is 60 frames per second.
  ///
  /// [value] Maximum render frame rate in frames per second. Setting to 0 disables automatic rendering for this view. Setting negative values has no effect.
  /// The default value is 60 frames per second.
  ///
  set frameRate(int value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Int32), void Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapViewBase_frameRate_set__Int'));
    final _valueHandle = (value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);


  }


  /// Gets the pixel scale factor used by this MapView.
  /// It is used to support screen resolution and size independence.
  /// This value is a derivative of the device's screen pixel density and is a direct analog of
  ///
  /// devicePixelRatio from FlutterView, ViewConfiguration or MediaQueryData.
  /// It can be used to translate between physical pixels and
  ///
  /// logical pixels
  /// according to the formula:
  ///
  /// logical_pixels = pixels / pixel_scale.
  double get pixelScale {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Double Function(Pointer<Void>, Int32), double Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_pixelScale_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }


  /// Returns the watermark size in physical pixels.
  Size2D get watermarkSize {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapViewBase_watermarkSize_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreSize2dFromFfi(__resultHandle);
    } finally {
      sdkCoreSize2dReleaseFfiHandle(__resultHandle);

    }

  }



}

int _sdkMapviewMapviewbaseviewToGeoCoordinatesStatic(Object _obj, Pointer<Void> viewCoordinates, Pointer<Pointer<Void>> _result) {
  GeoCoordinates? _resultObject;
  try {
    _resultObject = (_obj as MapViewBase).viewToGeoCoordinates(sdkCorePoint2dFromFfi(viewCoordinates));
    _result.value = sdkCoreGeocoordinatesToFfiNullable(_resultObject);
  } finally {
    sdkCorePoint2dReleaseFfiHandle(viewCoordinates);
  }
  return 0;
}
int _sdkMapviewMapviewbasegeoToViewCoordinatesStatic(Object _obj, Pointer<Void> geoCoordinates, Pointer<Pointer<Void>> _result) {
  Point2D? _resultObject;
  try {
    _resultObject = (_obj as MapViewBase).geoToViewCoordinates(sdkCoreGeocoordinatesFromFfi(geoCoordinates));
    _result.value = sdkCorePoint2dToFfiNullable(_resultObject);
  } finally {
    sdkCoreGeocoordinatesReleaseFfiHandle(geoCoordinates);
  }
  return 0;
}
int _sdkMapviewMapviewbasesetWatermarkLocationStatic(Object _obj, Pointer<Void> anchor, Pointer<Void> offset) {

  try {
    (_obj as MapViewBase).setWatermarkLocation(sdkCoreAnchor2dFromFfi(anchor), sdkCorePoint2dFromFfi(offset));
  } finally {
    sdkCoreAnchor2dReleaseFfiHandle(anchor);
    sdkCorePoint2dReleaseFfiHandle(offset);
  }
  return 0;
}
int _sdkMapviewMapviewbaseaddLifecycleListenerStatic(Object _obj, Pointer<Void> lifecycleListener) {

  try {
    (_obj as MapViewBase).addLifecycleListener(sdkMapviewMapviewlifecyclelistenerFromFfi(lifecycleListener));
  } finally {
    sdkMapviewMapviewlifecyclelistenerReleaseFfiHandle(lifecycleListener);
  }
  return 0;
}
int _sdkMapviewMapviewbaseremoveLifecycleListenerStatic(Object _obj, Pointer<Void> lifecycleListener) {

  try {
    (_obj as MapViewBase).removeLifecycleListener(sdkMapviewMapviewlifecyclelistenerFromFfi(lifecycleListener));
  } finally {
    sdkMapviewMapviewlifecyclelistenerReleaseFfiHandle(lifecycleListener);
  }
  return 0;
}
int _sdkMapviewMapviewbasepickMapItemsStatic(Object _obj, Pointer<Void> centerPoint, double radius, Pointer<Void> callback) {

  try {
    (_obj as MapViewBase).pickMapItems(sdkCorePoint2dFromFfi(centerPoint), (radius), sdkMapviewMapviewbasePickmapitemscallbackFromFfi(callback));
  } finally {
    sdkCorePoint2dReleaseFfiHandle(centerPoint);
    
    sdkMapviewMapviewbasePickmapitemscallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkMapviewMapviewbasepickMapContentStatic(Object _obj, Pointer<Void> viewArea, Pointer<Void> callback) {

  try {
    (_obj as MapViewBase).pickMapContent(sdkCoreRectangle2dFromFfi(viewArea), sdkMapviewMapviewbasePickmapcontentcallbackFromFfi(callback));
  } finally {
    sdkCoreRectangle2dReleaseFfiHandle(viewArea);
    sdkMapviewMapviewbasePickmapcontentcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkMapviewMapviewbasepickStatic(Object _obj, Pointer<Void> filter, Pointer<Void> viewArea, Pointer<Void> callback) {

  try {
    (_obj as MapViewBase).pick(sdkMapviewMapsceneMappickfilterFromFfiNullable(filter), sdkCoreRectangle2dFromFfi(viewArea), sdkMapviewMapviewbaseMappickcallbackFromFfi(callback));
  } finally {
    sdkMapviewMapsceneMappickfilterReleaseFfiHandleNullable(filter);
    sdkCoreRectangle2dReleaseFfiHandle(viewArea);
    sdkMapviewMapviewbaseMappickcallbackReleaseFfiHandle(callback);
  }
  return 0;
}

int _sdkMapviewMapviewbaseisValidGetStatic(Object _obj, Pointer<Uint8> _result) {
  _result.value = booleanToFfi((_obj as MapViewBase).isValid);
  return 0;
}
int _sdkMapviewMapviewbasecameraGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkMapviewMapcameraToFfi((_obj as MapViewBase).camera);
  return 0;
}
int _sdkMapviewMapviewbasegesturesGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkGesturesGesturesToFfi((_obj as MapViewBase).gestures);
  return 0;
}
int _sdkMapviewMapviewbasemapSceneGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkMapviewMapsceneToFfi((_obj as MapViewBase).mapScene);
  return 0;
}
int _sdkMapviewMapviewbasemapContextGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkMapviewMapcontextToFfi((_obj as MapViewBase).mapContext);
  return 0;
}
int _sdkMapviewMapviewbasehereMapControllerCoreGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkMapviewHeremapToFfi((_obj as MapViewBase).hereMapControllerCore);
  return 0;
}
int _sdkMapviewMapviewbaseviewportSizeGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkCoreSize2dToFfi((_obj as MapViewBase).viewportSize);
  return 0;
}
int _sdkMapviewMapviewbaseframeRateGetStatic(Object _obj, Pointer<Int32> _result) {
  _result.value = ((_obj as MapViewBase).frameRate);
  return 0;
}

int _sdkMapviewMapviewbaseframeRateSetStatic(Object _obj, int _value) {
  try {
    (_obj as MapViewBase).frameRate =
      (_value);
  } finally {
    
  }
  return 0;
}
int _sdkMapviewMapviewbasepixelScaleGetStatic(Object _obj, Pointer<Double> _result) {
  _result.value = ((_obj as MapViewBase).pixelScale);
  return 0;
}
int _sdkMapviewMapviewbasewatermarkSizeGetStatic(Object _obj, Pointer<Pointer<Void>> _result) {
  _result.value = sdkCoreSize2dToFfi((_obj as MapViewBase).watermarkSize);
  return 0;
}

Pointer<Void> sdkMapviewMapviewbaseToFfi(MapViewBase value) {
  if (value is __lib.NativeBase) return _sdkMapviewMapviewbaseCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkMapviewMapviewbaseCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbaseviewToGeoCoordinatesStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasegeoToViewCoordinatesStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>)>(_sdkMapviewMapviewbasesetWatermarkLocationStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewMapviewbaseaddLifecycleListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>)>(_sdkMapviewMapviewbaseremoveLifecycleListenerStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Double, Pointer<Void>)>(_sdkMapviewMapviewbasepickMapItemsStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>)>(_sdkMapviewMapviewbasepickMapContentStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>)>(_sdkMapviewMapviewbasepickStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Uint8>)>(_sdkMapviewMapviewbaseisValidGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasecameraGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasegesturesGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasemapSceneGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasemapContextGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasehereMapControllerCoreGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbaseviewportSizeGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Int32>)>(_sdkMapviewMapviewbaseframeRateGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Int32)>(_sdkMapviewMapviewbaseframeRateSetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Double>)>(_sdkMapviewMapviewbasepixelScaleGetStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Pointer<Void>>)>(_sdkMapviewMapviewbasewatermarkSizeGetStatic, __lib.unknownError)
  );

  return result;
}

MapViewBase sdkMapviewMapviewbaseFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapViewBase) return instance;

  final _typeIdHandle = _sdkMapviewMapviewbaseGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkMapviewMapviewbaseCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : MapViewBase$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapviewbaseRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapviewbaseReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapviewbaseReleaseHandle(handle);

Pointer<Void> sdkMapviewMapviewbaseToFfiNullable(MapViewBase? value) =>
  value != null ? sdkMapviewMapviewbaseToFfi(value) : Pointer<Void>.fromAddress(0);

MapViewBase? sdkMapviewMapviewbaseFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapviewbaseFromFfi(handle) : null;

void sdkMapviewMapviewbaseReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapviewbaseReleaseHandle(handle);

// End of MapViewBase "private" section.


