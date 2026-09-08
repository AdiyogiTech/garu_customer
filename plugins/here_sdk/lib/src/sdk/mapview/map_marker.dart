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
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/animation/animation_listener.dart';
import 'package:here_sdk/src/sdk/animation/map_marker_animation.dart';
import 'package:here_sdk/src/sdk/core/anchor2_d.dart';
import 'package:here_sdk/src/sdk/core/color.dart';
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/core/metadata.dart';
import 'package:here_sdk/src/sdk/mapview/map_image.dart';
import 'package:here_sdk/src/sdk/mapview/map_measure_range.dart';
import 'package:meta/meta.dart';

/// `MapMarker` is used to draw images on the map, for example to mark a specific location.
///
/// By default, the marker is centered on the given geographic coordinates.
/// Markers keep their size regardless of the current zoom level of the map view.
///
/// The image to be displayed is represented by [MapImage] object. For performance reasons,
/// it is highly recommended to reuse a single instance of the image when creating multiple
/// identical markers.
///
/// To display the map marker, it needs to be added to the scene using [MapScene.addMapMarker].
/// To stop displaying it, remove it from the scene using [MapScene.removeMapMarker].
///
/// The display of a map marker is only guaranteed in case its origin is within the viewport.
/// At the moment, this is a known limitation that mostly affects map markers which are visually
/// large and cover a sizeable part of the viewport.
///
/// **Note:**
/// Due to technical limitations using the MapMarkers API to add a very large number of markers
/// (several thousands, especially 10000+) is not recommended. Adding this many markers will have a
/// negative impact on the performance leading to stuttering of the app and lower frame rates.
/// To work around this limitation the following approach can be used:
/// Register to map camera updates using [MapCamera.addListener]. Query the bounding box of the
/// camera viewport using [MapCamera.boundingBox] (it may be extended)
/// and then use the method [GeoBox.containsGeoCoordinates] in combination with
/// [MapCameraState.distanceToTargetInMeters] to determine which MapMarkers are actually visible
/// to the user in the current camera viewport and thus need to be added to the map.
abstract class MapMarker {
  /// Creates an instance of a marker at given coordinates, represented by specified image.
  ///
  /// The altitude component of the coordinates is ignored.
  ///
  /// [coordinates] The marker's geographical coordinates.
  ///
  /// [image] The image to draw on the map.
  ///
  factory MapMarker(GeoCoordinates coordinates, MapImage image) => $prototype.$init(coordinates, image);
  /// Creates a `MapMarker` instance at given coordinates with specified image and text and a default text style.
  ///
  /// The altitude component of the coordinates is ignored.
  ///
  /// [coordinates] The marker's geographical coordinates.
  ///
  /// [image] The image to draw on the map.
  ///
  /// [text] The text to draw on the map.
  ///
  factory MapMarker.withImageAndText(GeoCoordinates coordinates, MapImage image, String text) => $prototype.withImageAndText(coordinates, image, text);
  /// Creates an instance of a marker at given coordinates, represented by specified image,
  /// with anchor point specifying how the image is positioned relative to the marker's coordinates.
  ///
  /// The anchor is a way of specifying position offset relative to image's dimensions on the screen.
  /// For example, (0, 0) places the top-left corner of the image at the marker's coordinates.
  /// (1, 1) would place the bottom-right corner of the image at the marker's coordinates.
  /// (0.5, 0.5) which is the default value would center the image at the marker's coordinates.
  /// Values outside the 0..1 range are also allowed, for example (0.5, 2) would display the image
  /// centered horizontally with its bottom edge above the marker's coordinates at the distance
  /// in pixels that is equal to the height of the image.
  ///
  /// [coordinates] The marker's geographical coordinates.
  ///
  /// [image] The image to draw on the map.
  ///
  /// [anchor] The anchor point for the marker image which specifies the position offset relative
  /// to the marker's coordinates.
  ///
  factory MapMarker.withAnchor(GeoCoordinates coordinates, MapImage image, Anchor2D anchor) => $prototype.withAnchor(coordinates, image, anchor);

  /// Starts animation of this map marker according to provided [MapMarkerAnimation].
  ///
  /// The `MapMarkerAnimation` may be shared between multiple instances of `MapMarker`.
  ///
  /// Starting animation on one map marker does not influence any ongoing animations on other map markers.
  /// Any ongoing animation of this marker instance will get cancelled.
  ///
  /// [animation] The animation to start, may be used for multiple different map markers.
  ///
  /// [animationListener] The  listener to receive notifications about animation start, completion or cancellation.
  ///
  void startAnimation(MapMarkerAnimation animation, AnimationListener? animationListener);
  /// Cancels single ongoing animation.
  ///
  /// Does nothing if animation was not started for this map marker.
  ///
  /// Does not cancel other animations if the same [MapMarkerAnimation] object was applied to multiple `MapMarker`s.
  ///
  /// [animation] The animation to cancel.
  ///
  void cancelAnimation(MapMarkerAnimation animation);
  /// The point on the map where the map marker is drawn.
  /// Gets the point on the map where the marker is drawn.
  GeoCoordinates get coordinates;
  /// The point on the map where the map marker is drawn.
  /// Sets the point on the map where the marker is drawn.
  /// The altitude component of the coordinates is ignored.
  ///
  /// The altitude component of the coordinates is ignored.
  set coordinates(GeoCoordinates value);

  /// The Metadata instance attached to this marker, see [Metadata].
  /// This will be `null` if nothing has been attached before.
  /// Gets the Metadata instance attached to this marker.
  /// This will be `null` if nothing has been attached before.
  Metadata? get metadata;
  /// The Metadata instance attached to this marker, see [Metadata].
  /// This will be `null` if nothing has been attached before.
  /// Sets the Metadata instance attached to this marker.
  set metadata(Metadata? value);

  /// Determines whether or not the marker can overlap other markers.
  /// Returns `true` if the marker allows overlap with other markers, `false` otherwise.
  /// Defaults to `true`.
  bool get isOverlapAllowed;
  /// Determines whether or not the marker can overlap other markers.
  /// Sets whether the marker is allowed to overlap with other markers.
  ///
  /// If `false`, it will disappear the moment it overlaps another marker that has
  /// a higher visibility priority. A marker that allows overlap will always be drawn.
  /// Among markers that don't allow overlap, the one with the highest draw order has
  /// priority. Marker that is hidden due to overlapping with other markers is not pickable.
  set isOverlapAllowed(bool value);

  /// The draw order of this marker relative to other markers.
  /// Gets draw order of this marker relative to other markers. The default value is 0.
  int get drawOrder;
  /// The draw order of this marker relative to other markers.
  /// Sets draw order of this marker relative to other markers.
  ///
  /// Markers with higher draw order value are drawn on top of markers with lower draw order.
  /// In case multiple markers have the same draw order value
  /// then the order in which they were added to the scene matters. Last added marker is drawn on top.
  ///
  /// Allowed range is \[0, 1023\]. Values outside this range will be clamped. The default value is 0.
  set drawOrder(int value);

  /// Image representing the marker on the screen.
  /// Gets currently used map image.
  MapImage get image;
  /// Image representing the marker on the screen.
  /// Sets map image used to represent the marker on screen.
  set image(MapImage value);

  /// The anchor point for the marker image which specifies the position offset relative
  /// to the marker's coordinates.
  /// Gets current anchor point for the marker image.
  Anchor2D get anchor;
  /// The anchor point for the marker image which specifies the position offset relative
  /// to the marker's coordinates.
  /// Sets anchor point of the marker image which specifies the position offset relative
  /// to the marker's coordinates.
  ///
  /// For example, (0, 0) places the top-left corner of the image at the marker's coordinates.
  /// (1, 1) would place the bottom-right corner of the image at the marker's coordinates.
  /// (0.5, 0.5) which is the default value would center the image at the marker's coordinates.
  /// Values outside the 0..1 range are also allowed, for example (0.5, 2) would display the image
  /// centered horizontally with its bottom edge above the marker's coordinates at the distance
  /// in pixels that is equal to the height of the image.
  set anchor(Anchor2D value);

  /// Opacity, the factor applied to the alpha channel of the marker image.
  /// Gets the current opacity of the marker image. Value is in the range of \[0.0, 1.0\].
  /// Default value is 1.0.
  double get opacity;
  /// Opacity, the factor applied to the alpha channel of the marker image.
  /// Sets the opacity of the marker image.
  ///
  /// Provided value is clamped to the range of \[0.0, 1.0\]. Default value is 1.0,
  /// which means marker is displayed with the default opacity of the image.
  ///
  /// Markers with opacity value set to 0.0 are still on the map and are considered for picking.
  set opacity(double value);

  /// Duration of a fade-in effect on marker addition to a scene or a fade-out effect on marker removal from a scene.
  /// Gets the current duration of a fade-in effect on marker addition to a scene or a fade-out effect on marker removal from a scene.
  Duration get fadeDuration;
  /// Duration of a fade-in effect on marker addition to a scene or a fade-out effect on marker removal from a scene.
  /// Sets duration of a fade-in effect on marker addition to a scene or a fade-out effect on marker removal from a scene.
  ///
  /// Provided value is clamped in range \[0.0, 10.0\] seconds. Default value is 0 seconds which means the effect is disabled
  /// and marker is added/removed immediately without any animation.
  /// Fade-in effect is also applied when marker leaves and then re-enters screen area.
  ///
  /// Change to this property is made asynchronously and is not guaranteed
  /// to take effect on the next rendered frame. In particular, changing fade duration and removing
  /// the marker immediately after may result in the new value being ignored for this removal.
  set fadeDuration(Duration value);

  /// The text to be drawn on the map along with the image of the `MapMarker`.
  /// Gets the text drawn on the map by the `MapMarker`.
  String get text;
  /// The text to be drawn on the map along with the image of the `MapMarker`.
  /// Sets the text to be drawn on the map by the `MapMarker`.
  set text(String value);

  /// The `TextStyle` applied to the text of the `MapMarker`.
  /// Gets a copy of the `TextStyle` currently in use by the `MapMarker`.
  MapMarkerTextStyle get textStyle;
  /// The `TextStyle` applied to the text of the `MapMarker`.
  /// Sets the `TextStyle` to be used by the `MapMarker`.
  set textStyle(MapMarkerTextStyle value);

  /// The list of visibility ranges. The map marker is visible only inside these map measure ranges.
  /// Gets the list of visibility ranges. The map marker is visible only inside these map measure
  /// ranges. When empty (the default), the map marker is visible without map measure restrictions.
  List<MapMeasureRange> get visibilityRanges;
  /// The list of visibility ranges. The map marker is visible only inside these map measure ranges.
  /// Sets visibility ranges for this map marker.
  ///
  /// A range is half open - \[minimumZoomLevel, maximumZoomLevel), the given maximum value is not contained in the range.
  /// The map marker is visible only inside these map measure ranges.
  ///
  /// When empty (the default), the map marker is visible without map measure restrictions.
  /// Only `MapMeasureRange`(s) of [MapMeasureKind.zoomLevel] type are supported.
  /// `MapMeasureRange`(s) of other unsupported types will be ignored.
  set visibilityRanges(List<MapMeasureRange> value);


  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = MapMarker$Impl(Pointer<Void>.fromAddress(0));
}

/// Styling options for the text of a [MapMarker].
abstract class MapMarkerTextStyle {
  /// Creates a default set of styling options for the text of a [MapMarker] that consists of
  /// the following values:
  ///
  /// - Text size: 18 pixels
  /// - Text color: opaque white
  /// - Text outline size: 0 pixels
  /// - Text outline color: opaque black
  /// - Text placement: [MapMarkerTextStylePlacement.bottom]
  ///
  /// Once the resulting `TextStyle` is applied to a `MapMarker`, its text will be centered over its
  /// image.
  ///
  /// The font will be 18 pixels wide, colored opaque white and will have no visible outline.
  ///
  factory MapMarkerTextStyle() => $prototype.$init();
  /// Creates a set of styling options for the text of a [MapMarker].
  ///
  /// List of placements is used to specify allowed placement of text relative to the icon.
  /// When marker overlapping is allowed as set by [MapMarker.isOverlapAllowed]
  /// (allowed by default), only first placement element is considered.
  /// Otherwise the placement value is chosen so that the text does not overlap
  /// with other `MapMarker` instances.
  ///
  /// Placement values are prioritized according
  /// to the order in which they appear in the list. Lists with duplicate entries
  /// as well as empty lists are not supported.
  ///
  /// [textSize] The size of the text in pixels.
  /// Only positive values are supported.
  ///
  /// [textColor] The text color.
  ///
  /// [textOutlineSize] The size of the text outline in pixels.
  /// Only non-negative values are supported.
  ///
  /// [textOutlineColor] The color of the text outline.
  ///
  /// [placements] List of allowed placements of the text relative to the icon of a [MapMarker].
  ///
  /// Throws [MapMarkerTextStyleInstantiationException]. In case of invalid input parameters.
  ///
  factory MapMarkerTextStyle.make(double textSize, ui.Color textColor, double textOutlineSize, ui.Color textOutlineColor, List<MapMarkerTextStylePlacement> placements) => $prototype.make(textSize, textColor, textOutlineSize, textOutlineColor, placements);

  /// The text size in pixels.
  /// Gets the text size in pixels.
  double get textSize;

  /// The text color.
  /// Gets the text color.
  ui.Color get textColor;

  /// The text outline size in pixels.
  /// Gets the text outline size in pixels.
  double get textOutlineSize;

  /// The text outline color.
  /// Gets the text outline color.
  ui.Color get textOutlineColor;

  /// List of possible text placements relative to the icon of a [MapMarker].
  /// Gets the possible text placements relative to the icon of a [MapMarker].
  List<MapMarkerTextStylePlacement> get placements;


  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = MapMarkerTextStyle$Impl(Pointer<Void>.fromAddress(0));
}

/// Describes a reason for failing to create a [MapMarkerTextStyle].
enum MapMarkerTextStyleInstantiationErrorCode {
    /// Instantiation parameters contain unsupported non positive text size.
    nonPositiveTextSize,
    /// Instantiation parameters contain unsupported negative text outline size.
    negativeTextOutlineSize,
    /// Instantiation parameters contain unsupported empty list without any [MapMarkerTextStylePlacement] entries.
    emptyTextPlacementList,
    /// Instantiation parameters contain unsupported list with duplicate [MapMarkerTextStylePlacement] entries.
    duplicateTextPlacementValues
}

// MapMarkerTextStyleInstantiationErrorCode "private" section, not exported.

int sdkMapviewMapmarkerTextstyleInstantiationerrorcodeToFfi(MapMarkerTextStyleInstantiationErrorCode value) {
  switch (value) {
  case MapMarkerTextStyleInstantiationErrorCode.nonPositiveTextSize:
    return 1;
  case MapMarkerTextStyleInstantiationErrorCode.negativeTextOutlineSize:
    return 2;
  case MapMarkerTextStyleInstantiationErrorCode.emptyTextPlacementList:
    return 3;
  case MapMarkerTextStyleInstantiationErrorCode.duplicateTextPlacementValues:
    return 4;
  default:
    throw StateError("Invalid enum value $value for MapMarkerTextStyleInstantiationErrorCode enum.");
  }
}

MapMarkerTextStyleInstantiationErrorCode sdkMapviewMapmarkerTextstyleInstantiationerrorcodeFromFfi(int handle) {
  switch (handle) {
  case 1:
    return MapMarkerTextStyleInstantiationErrorCode.nonPositiveTextSize;
  case 2:
    return MapMarkerTextStyleInstantiationErrorCode.negativeTextOutlineSize;
  case 3:
    return MapMarkerTextStyleInstantiationErrorCode.emptyTextPlacementList;
  case 4:
    return MapMarkerTextStyleInstantiationErrorCode.duplicateTextPlacementValues;
  default:
    throw StateError("Invalid numeric value $handle for MapMarkerTextStyleInstantiationErrorCode enum.");
  }
}

void sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseFfiHandle(int handle) {}

final _sdkMapviewMapmarkerTextstyleInstantiationerrorcodeCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_InstantiationErrorCode_create_handle_nullable'));
final _sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_InstantiationErrorCode_release_handle_nullable'));
final _sdkMapviewMapmarkerTextstyleInstantiationerrorcodeGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_InstantiationErrorCode_get_value_nullable'));

Pointer<Void> sdkMapviewMapmarkerTextstyleInstantiationerrorcodeToFfiNullable(MapMarkerTextStyleInstantiationErrorCode? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapmarkerTextstyleInstantiationerrorcodeToFfi(value);
  final result = _sdkMapviewMapmarkerTextstyleInstantiationerrorcodeCreateHandleNullable(_handle);
  sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseFfiHandle(_handle);
  return result;
}

MapMarkerTextStyleInstantiationErrorCode? sdkMapviewMapmarkerTextstyleInstantiationerrorcodeFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapmarkerTextstyleInstantiationerrorcodeGetValueNullable(handle);
  final result = sdkMapviewMapmarkerTextstyleInstantiationerrorcodeFromFfi(_handle);
  sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseHandleNullable(handle);

// End of MapMarkerTextStyleInstantiationErrorCode "private" section.
/// Represents text placement with respect to the icon of a [MapMarker].
enum MapMarkerTextStylePlacement {
    /// Text placed centered over the image.
    center,
    /// Text placed over the top edge of the image's bounding rectangle.
    top,
    /// Text placed at the top right corner of the image's bounding rectangle.
    topRight,
    /// Text placed next to the right edge of the image's bounding rectangle.
    right,
    /// Text placed at the bottom right corner of the image's bounding rectangle.
    bottomRight,
    /// Text placed below the bottom edge of the image's bounding rectangle.
    bottom,
    /// Text placed at the bottom left corner of the image's bounding rectangle.
    bottomLeft,
    /// Text placed next to the left edge of the image's bounding rectangle.
    left,
    /// Text placed at the top left corner of the image's bounding rectangle.
    topLeft
}

// MapMarkerTextStylePlacement "private" section, not exported.

int sdkMapviewMapmarkerTextstylePlacementToFfi(MapMarkerTextStylePlacement value) {
  switch (value) {
  case MapMarkerTextStylePlacement.center:
    return 0;
  case MapMarkerTextStylePlacement.top:
    return 1;
  case MapMarkerTextStylePlacement.topRight:
    return 2;
  case MapMarkerTextStylePlacement.right:
    return 3;
  case MapMarkerTextStylePlacement.bottomRight:
    return 4;
  case MapMarkerTextStylePlacement.bottom:
    return 5;
  case MapMarkerTextStylePlacement.bottomLeft:
    return 6;
  case MapMarkerTextStylePlacement.left:
    return 7;
  case MapMarkerTextStylePlacement.topLeft:
    return 8;
  default:
    throw StateError("Invalid enum value $value for MapMarkerTextStylePlacement enum.");
  }
}

MapMarkerTextStylePlacement sdkMapviewMapmarkerTextstylePlacementFromFfi(int handle) {
  switch (handle) {
  case 0:
    return MapMarkerTextStylePlacement.center;
  case 1:
    return MapMarkerTextStylePlacement.top;
  case 2:
    return MapMarkerTextStylePlacement.topRight;
  case 3:
    return MapMarkerTextStylePlacement.right;
  case 4:
    return MapMarkerTextStylePlacement.bottomRight;
  case 5:
    return MapMarkerTextStylePlacement.bottom;
  case 6:
    return MapMarkerTextStylePlacement.bottomLeft;
  case 7:
    return MapMarkerTextStylePlacement.left;
  case 8:
    return MapMarkerTextStylePlacement.topLeft;
  default:
    throw StateError("Invalid numeric value $handle for MapMarkerTextStylePlacement enum.");
  }
}

void sdkMapviewMapmarkerTextstylePlacementReleaseFfiHandle(int handle) {}

final _sdkMapviewMapmarkerTextstylePlacementCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_Placement_create_handle_nullable'));
final _sdkMapviewMapmarkerTextstylePlacementReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_Placement_release_handle_nullable'));
final _sdkMapviewMapmarkerTextstylePlacementGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_Placement_get_value_nullable'));

Pointer<Void> sdkMapviewMapmarkerTextstylePlacementToFfiNullable(MapMarkerTextStylePlacement? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewMapmarkerTextstylePlacementToFfi(value);
  final result = _sdkMapviewMapmarkerTextstylePlacementCreateHandleNullable(_handle);
  sdkMapviewMapmarkerTextstylePlacementReleaseFfiHandle(_handle);
  return result;
}

MapMarkerTextStylePlacement? sdkMapviewMapmarkerTextstylePlacementFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewMapmarkerTextstylePlacementGetValueNullable(handle);
  final result = sdkMapviewMapmarkerTextstylePlacementFromFfi(_handle);
  sdkMapviewMapmarkerTextstylePlacementReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewMapmarkerTextstylePlacementReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapmarkerTextstylePlacementReleaseHandleNullable(handle);

// End of MapMarkerTextStylePlacement "private" section.
/// Thrown when a problem occurs while trying to create a [MapMarkerTextStyle] instance.
class MapMarkerTextStyleInstantiationException implements Exception {
  final MapMarkerTextStyleInstantiationErrorCode error;
  MapMarkerTextStyleInstantiationException(this.error);
}

// MapMarkerTextStyle "private" section, not exported.

final _sdkMapviewMapmarkerTextstyleRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_register_finalizer'));
final _sdkMapviewMapmarkerTextstyleCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_copy_handle'));
final _sdkMapviewMapmarkerTextstyleReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_release_handle'));



final _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_make__Double_Color_Double_Color_ListOf_sdk_mapview_MapMarker_TextStyle_Placement_return_release_handle'));
final _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_make__Double_Color_Double_Color_ListOf_sdk_mapview_MapMarker_TextStyle_Placement_return_get_result'));
final _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_make__Double_Color_Double_Color_ListOf_sdk_mapview_MapMarker_TextStyle_Placement_return_get_error'));
final _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_TextStyle_make__Double_Color_Double_Color_ListOf_sdk_mapview_MapMarker_TextStyle_Placement_return_has_error'));


/// @nodoc
@visibleForTesting
class MapMarkerTextStyle$Impl extends __lib.NativeBase implements MapMarkerTextStyle {

  MapMarkerTextStyle$Impl(Pointer<Void> handle) : super(handle);


  MapMarkerTextStyle $init() {
    final _result_handle = _$init();
    final _result = MapMarkerTextStyle$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewMapmarkerTextstyleRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  MapMarkerTextStyle make(double textSize, ui.Color textColor, double textOutlineSize, ui.Color textOutlineColor, List<MapMarkerTextStylePlacement> placements) {
    final _result_handle = _make(textSize, textColor, textOutlineSize, textOutlineColor, placements);
    final _result = MapMarkerTextStyle$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewMapmarkerTextstyleRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _$init() {
    final _$initFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_mapview_MapMarker_TextStyle_make'));
    final __resultHandle = _$initFfi(__lib.LibraryContext.isolateId);
    return __resultHandle;
  }

  static Pointer<Void> _make(double textSize, ui.Color textColor, double textOutlineSize, ui.Color textOutlineColor, List<MapMarkerTextStylePlacement> placements) {
    final _makeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Double, Pointer<Void>, Double, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, double, Pointer<Void>, double, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_TextStyle_make__Double_Color_Double_Color_ListOf_sdk_mapview_MapMarker_TextStyle_Placement'));
    final _textSizeHandle = (textSize);
    final _textColorHandle = sdkCoreColorToFfi(textColor);
    final _textOutlineSizeHandle = (textOutlineSize);
    final _textOutlineColorHandle = sdkCoreColorToFfi(textOutlineColor);
    final _placementsHandle = harpSdkBindingslistofSdkMapviewMapmarkerTextstylePlacementToFfi(placements);
    final __callResultHandle = _makeFfi(__lib.LibraryContext.isolateId, _textSizeHandle, _textColorHandle, _textOutlineSizeHandle, _textOutlineColorHandle, _placementsHandle);

    sdkCoreColorReleaseFfiHandle(_textColorHandle);

    sdkCoreColorReleaseFfiHandle(_textOutlineColorHandle);
    harpSdkBindingslistofSdkMapviewMapmarkerTextstylePlacementReleaseFfiHandle(_placementsHandle);
    if (_makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnGetError(__callResultHandle);
        _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnReleaseHandle(__callResultHandle);
        try {
          throw MapMarkerTextStyleInstantiationException(sdkMapviewMapmarkerTextstyleInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkMapviewMapmarkerTextstyleInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnGetResult(__callResultHandle);
    _makesdkMapviewMapmarkerTextstyleMakeDoubleColorDoubleColorListofSdkMapviewMapmarkerTextstylePlacementReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  @override
  double get textSize {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Double Function(Pointer<Void>, Int32), double Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_TextStyle_textSize_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }


  @override
  ui.Color get textColor {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_TextStyle_textColor_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreColorFromFfi(__resultHandle);
    } finally {
      sdkCoreColorReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  double get textOutlineSize {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Double Function(Pointer<Void>, Int32), double Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_TextStyle_textOutlineSize_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }


  @override
  ui.Color get textOutlineColor {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_TextStyle_textOutlineColor_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreColorFromFfi(__resultHandle);
    } finally {
      sdkCoreColorReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  List<MapMarkerTextStylePlacement> get placements {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_TextStyle_placements_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkMapviewMapmarkerTextstylePlacementFromFfi(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkMapviewMapmarkerTextstylePlacementReleaseFfiHandle(__resultHandle);

    }

  }



}

Pointer<Void> sdkMapviewMapmarkerTextstyleToFfi(MapMarkerTextStyle value) =>
  _sdkMapviewMapmarkerTextstyleCopyHandle((value as __lib.NativeBase).handle);

MapMarkerTextStyle sdkMapviewMapmarkerTextstyleFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapMarkerTextStyle) return instance;

  final _copiedHandle = _sdkMapviewMapmarkerTextstyleCopyHandle(handle);
  final result = MapMarkerTextStyle$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapmarkerTextstyleRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapmarkerTextstyleReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapmarkerTextstyleReleaseHandle(handle);

Pointer<Void> sdkMapviewMapmarkerTextstyleToFfiNullable(MapMarkerTextStyle? value) =>
  value != null ? sdkMapviewMapmarkerTextstyleToFfi(value) : Pointer<Void>.fromAddress(0);

MapMarkerTextStyle? sdkMapviewMapmarkerTextstyleFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapmarkerTextstyleFromFfi(handle) : null;

void sdkMapviewMapmarkerTextstyleReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapmarkerTextstyleReleaseHandle(handle);

// End of MapMarkerTextStyle "private" section.

// MapMarker "private" section, not exported.

final _sdkMapviewMapmarkerRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_MapMarker_register_finalizer'));
final _sdkMapviewMapmarkerCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_copy_handle'));
final _sdkMapviewMapmarkerReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_MapMarker_release_handle'));







/// @nodoc
@visibleForTesting
class MapMarker$Impl extends __lib.NativeBase implements MapMarker {

  MapMarker$Impl(Pointer<Void> handle) : super(handle);


  MapMarker $init(GeoCoordinates coordinates, MapImage image) {
    final _result_handle = _$init(coordinates, image);
    final _result = MapMarker$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewMapmarkerRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  MapMarker withImageAndText(GeoCoordinates coordinates, MapImage image, String text) {
    final _result_handle = _withImageAndText(coordinates, image, text);
    final _result = MapMarker$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewMapmarkerRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  MapMarker withAnchor(GeoCoordinates coordinates, MapImage image, Anchor2D anchor) {
    final _result_handle = _withAnchor(coordinates, image, anchor);
    final _result = MapMarker$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewMapmarkerRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _$init(GeoCoordinates coordinates, MapImage image) {
    final _$initFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_make__GeoCoordinates_MapImage'));
    final _coordinatesHandle = sdkCoreGeocoordinatesToFfi(coordinates);
    final _imageHandle = sdkMapviewMapimageToFfi(image);
    final __resultHandle = _$initFfi(__lib.LibraryContext.isolateId, _coordinatesHandle, _imageHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_coordinatesHandle);
    sdkMapviewMapimageReleaseFfiHandle(_imageHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withImageAndText(GeoCoordinates coordinates, MapImage image, String text) {
    final _withImageAndTextFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_make__GeoCoordinates_MapImage_String'));
    final _coordinatesHandle = sdkCoreGeocoordinatesToFfi(coordinates);
    final _imageHandle = sdkMapviewMapimageToFfi(image);
    final _textHandle = stringToFfi(text);
    final __resultHandle = _withImageAndTextFfi(__lib.LibraryContext.isolateId, _coordinatesHandle, _imageHandle, _textHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_coordinatesHandle);
    sdkMapviewMapimageReleaseFfiHandle(_imageHandle);
    stringReleaseFfiHandle(_textHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withAnchor(GeoCoordinates coordinates, MapImage image, Anchor2D anchor) {
    final _withAnchorFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_make__GeoCoordinates_MapImage_Anchor2D'));
    final _coordinatesHandle = sdkCoreGeocoordinatesToFfi(coordinates);
    final _imageHandle = sdkMapviewMapimageToFfi(image);
    final _anchorHandle = sdkCoreAnchor2dToFfi(anchor);
    final __resultHandle = _withAnchorFfi(__lib.LibraryContext.isolateId, _coordinatesHandle, _imageHandle, _anchorHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_coordinatesHandle);
    sdkMapviewMapimageReleaseFfiHandle(_imageHandle);
    sdkCoreAnchor2dReleaseFfiHandle(_anchorHandle);
    return __resultHandle;
  }

  @override
  void startAnimation(MapMarkerAnimation animation, AnimationListener? animationListener) {
    final _startAnimationFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_startAnimation__MapMarkerAnimation_AnimationListener_'));
    final _animationHandle = sdkAnimationMapmarkeranimationToFfi(animation);
    final _animationListenerHandle = sdkAnimationAnimationlistenerToFfiNullable(animationListener);
    final _handle = this.handle;
    _startAnimationFfi(_handle, __lib.LibraryContext.isolateId, _animationHandle, _animationListenerHandle);
    sdkAnimationMapmarkeranimationReleaseFfiHandle(_animationHandle);
    sdkAnimationAnimationlistenerReleaseFfiHandleNullable(_animationListenerHandle);

  }

  @override
  void cancelAnimation(MapMarkerAnimation animation) {
    final _cancelAnimationFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_cancelAnimation__MapMarkerAnimation'));
    final _animationHandle = sdkAnimationMapmarkeranimationToFfi(animation);
    final _handle = this.handle;
    _cancelAnimationFfi(_handle, __lib.LibraryContext.isolateId, _animationHandle);
    sdkAnimationMapmarkeranimationReleaseFfiHandle(_animationHandle);

  }

  @override
  GeoCoordinates get coordinates {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_coordinates_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreGeocoordinatesFromFfi(__resultHandle);
    } finally {
      sdkCoreGeocoordinatesReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set coordinates(GeoCoordinates value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_coordinates_set__GeoCoordinates'));
    final _valueHandle = sdkCoreGeocoordinatesToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_valueHandle);

  }


  @override
  Metadata? get metadata {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_metadata_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreMetadataFromFfiNullable(__resultHandle);
    } finally {
      sdkCoreMetadataReleaseFfiHandleNullable(__resultHandle);

    }

  }

  @override
  set metadata(Metadata? value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_metadata_set__Metadata_'));
    final _valueHandle = sdkCoreMetadataToFfiNullable(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    sdkCoreMetadataReleaseFfiHandleNullable(_valueHandle);

  }


  @override
  bool get isOverlapAllowed {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint8 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_isOverlapAllowed_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return booleanFromFfi(__resultHandle);
    } finally {
      booleanReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set isOverlapAllowed(bool value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Uint8), void Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapMarker_isOverlapAllowed_set__Boolean'));
    final _valueHandle = booleanToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    booleanReleaseFfiHandle(_valueHandle);

  }


  @override
  int get drawOrder {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Int32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_drawOrder_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }

  @override
  set drawOrder(int value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Int32), void Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapMarker_drawOrder_set__Int'));
    final _valueHandle = (value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);


  }


  @override
  MapImage get image {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_image_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewMapimageFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapimageReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set image(MapImage value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_image_set__MapImage'));
    final _valueHandle = sdkMapviewMapimageToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    sdkMapviewMapimageReleaseFfiHandle(_valueHandle);

  }


  @override
  Anchor2D get anchor {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_anchor_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkCoreAnchor2dFromFfi(__resultHandle);
    } finally {
      sdkCoreAnchor2dReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set anchor(Anchor2D value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_anchor_set__Anchor2D'));
    final _valueHandle = sdkCoreAnchor2dToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    sdkCoreAnchor2dReleaseFfiHandle(_valueHandle);

  }


  @override
  double get opacity {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Double Function(Pointer<Void>, Int32), double Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_opacity_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }

  @override
  set opacity(double value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Double), void Function(Pointer<Void>, int, double)>('here_sdk_sdk_mapview_MapMarker_opacity_set__Double'));
    final _valueHandle = (value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);


  }


  @override
  Duration get fadeDuration {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint64 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_fadeDuration_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return durationFromFfi(__resultHandle);
    } finally {
      durationReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set fadeDuration(Duration value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Uint64), void Function(Pointer<Void>, int, int)>('here_sdk_sdk_mapview_MapMarker_fadeDuration_set__Duration'));
    final _valueHandle = durationToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    durationReleaseFfiHandle(_valueHandle);

  }


  @override
  String get text {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_text_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfi(__resultHandle);
    } finally {
      stringReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set text(String value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_text_set__String'));
    final _valueHandle = stringToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    stringReleaseFfiHandle(_valueHandle);

  }


  @override
  MapMarkerTextStyle get textStyle {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_textStyle_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewMapmarkerTextstyleFromFfi(__resultHandle);
    } finally {
      sdkMapviewMapmarkerTextstyleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set textStyle(MapMarkerTextStyle value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_textStyle_set__TextStyle'));
    final _valueHandle = sdkMapviewMapmarkerTextstyleToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    sdkMapviewMapmarkerTextstyleReleaseFfiHandle(_valueHandle);

  }


  @override
  List<MapMeasureRange> get visibilityRanges {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_MapMarker_visibilityRanges_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return harpSdkBindingslistofSdkMapviewMapmeasurerangeFromFfi(__resultHandle);
    } finally {
      harpSdkBindingslistofSdkMapviewMapmeasurerangeReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  set visibilityRanges(List<MapMeasureRange> value) {
    final _setFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_MapMarker_visibilityRanges_set__ListOf_sdk_mapview_MapMeasureRange'));
    final _valueHandle = harpSdkBindingslistofSdkMapviewMapmeasurerangeToFfi(value);
    final _handle = this.handle;
    _setFfi(_handle, __lib.LibraryContext.isolateId, _valueHandle);
    harpSdkBindingslistofSdkMapviewMapmeasurerangeReleaseFfiHandle(_valueHandle);

  }



}

Pointer<Void> sdkMapviewMapmarkerToFfi(MapMarker value) =>
  _sdkMapviewMapmarkerCopyHandle((value as __lib.NativeBase).handle);

MapMarker sdkMapviewMapmarkerFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is MapMarker) return instance;

  final _copiedHandle = _sdkMapviewMapmarkerCopyHandle(handle);
  final result = MapMarker$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewMapmarkerRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewMapmarkerReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewMapmarkerReleaseHandle(handle);

Pointer<Void> sdkMapviewMapmarkerToFfiNullable(MapMarker? value) =>
  value != null ? sdkMapviewMapmarkerToFfi(value) : Pointer<Void>.fromAddress(0);

MapMarker? sdkMapviewMapmarkerFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewMapmarkerFromFfi(handle) : null;

void sdkMapviewMapmarkerReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewMapmarkerReleaseHandle(handle);

// End of MapMarker "private" section.


