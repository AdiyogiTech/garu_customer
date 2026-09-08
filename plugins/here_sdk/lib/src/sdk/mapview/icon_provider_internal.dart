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
import 'dart:typed_data';
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/sdk/mapview/icon_provider_asset_type.dart';
import 'package:here_sdk/src/sdk/mapview/icon_provider_error.dart';
import 'package:here_sdk/src/sdk/mapview/map_context.dart';
import 'package:here_sdk/src/sdk/mapview/map_scheme.dart';
import 'package:here_sdk/src/sdk/mapview/road_shield_icon_properties.dart';
import 'package:meta/meta.dart';

/// This provider creates icons from map content.
///
/// The caller owns the instance of this type.
/// It is recommended to reuse the same instance of IconProvider for subsequent calls to
/// create icons since some internal processed data can be cached for optimized icon-creation.
///
/// For internal use only. There are platform dependent IconProvider classes which deliver the image
/// results using the native classes like Bitmap for Android or UIImage for iOS. This class can be used
/// directly with C++.
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
/// @nodoc
abstract class IconProviderInternal {
  /// Creates an instance of IconProviderInternal.
  ///
  /// [context] MapContext to provide icons from.
  ///
  factory IconProviderInternal(MapContext context) => $prototype.create(context);

  /// Creates an image displaying a road shield according to the given parameters with the
  /// dimensions capped to a maximum of 4096 pixels.
  ///
  /// [properties] The properties which determine the kind of road shield to be created.
  ///
  /// [mapScheme] The map scheme for which the road shield should be created.
  ///
  /// [assetType] The asset type for which the road shield should be created.
  ///
  /// [widthConstraintInPixels] The maximum width of the road shield in pixels. The value is capped to a maximum of 4096 pixels.
  /// The image will be created as large as possible within the width and height constraints
  /// while maintaining the aspect ratio. If set to 0, the width will be calculated based on
  /// the heightConstraintInPixels to preserve the aspect ratio.
  ///
  /// [heightConstraintInPixels] The maximum height of the road shield in pixels. The value is capped to a maximum of 4096 pixels.
  /// The image will be created as large as possible within the width and height constraints
  /// while maintaining the aspect ratio. If set to 0, the original image-asset's height will
  /// be used.
  ///
  /// [callback] The callback which is used to return the created image or an error code.
  ///
  void createRoadShieldIcon(RoadShieldIconProperties properties, MapScheme mapScheme, IconProviderAssetType assetType, int widthConstraintInPixels, int heightConstraintInPixels, IconProviderInternalCreateIconCallback callback);
  /// Creates an image displaying a vehicle restriction shield according to the given parameters with the
  /// dimensions capped to a maximum of 4096 pixels.
  ///
  /// [attributes] The attributes which determine the kind of vehicle restriction shield to be created.
  ///
  /// [mapScheme] The map scheme for which the vehicle restriction icon should be created.
  ///
  /// [assetType] The asset type for which the vehicle restriction icon should be created.
  ///
  /// [widthConstraintInPixels] The maximum width of the icon in pixels. The value is capped to a maximum of 4096 pixels.
  /// The image will be created as large as possible within the width and height constraints
  /// while maintaining the aspect ratio. If set to 0, the width will be calculated based on
  /// the heightConstraintInPixels to preserve the aspect ratio.
  ///
  /// [heightConstraintInPixels] The maximum height of the icon in pixels. The value is capped to a maximum of 4096 pixels.
  /// The image will be created as large as possible within the width and height constraints
  /// while maintaining the aspect ratio. If set to 0, the original image-asset's height will
  /// be used.
  ///
  /// [callback] The callback which is used to return the created image or an error code.
  ///
  void createVehicleRestrictionIcon(IconProviderInternalVehicleRestrictionIconAttributes attributes, MapScheme mapScheme, IconProviderAssetType assetType, int widthConstraintInPixels, int heightConstraintInPixels, IconProviderInternalCreateIconCallback callback);

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = IconProviderInternal$Impl(Pointer<Void>.fromAddress(0));
}

/// Contains the information required to create a vehicle restriction image.
/// @nodoc

class IconProviderInternalVehicleRestrictionIconAttributes {
  /// Category of the restriction. Can have one of the following values:
  /// "general_truck_restriction", "access_restriction", "haz_mat_permit", "haz_mat_restriction", "trailer_restriction"
  String restrictionCategory;

  /// The type of vehicle restriction. Only needed if restriction category is "access_restriction" or "haz_mat_restriction".
  /// It can have the following values:
  /// - A dimension restriction: "HEIGHT", "LENGTH", "KINGPIN_TO_REAR_AXLE_LENGTH"
  /// - A weight restriction: "WEIGHT", "WPAN_TWO_AXLES", "WPAN_TWO_OR_MORE_AXLES", ...
  /// - A weight per axle (group) restriction: "WEIGHT_PER_AXLE", "WPAG_SINGLE_AXLE", "WPAG_TANDEM_AXLE", "WPAG_TRIPLE_AXLE", ...
  /// - A axle group restriction: "AXLES_AMOUNT", "SINGLE_AXLE", "TANDEM_AXLE", "TRIPLE_AXLE", ...
  /// - A hazardous material restriction/ tunnel category: "EXPLOSIVES", "GAS","TUNNEL_CATEGORY_B1000C", ...
  ///   Compare [hazardous materials](https://www.here.com/docs/bundle/map-content-schema-data-specification/page/topics_schema/hazardousmaterialtype.html)
  String restrictionType;

  /// Country code in ISO 3166-1 alpha-2 format. Can be empty.
  String countryCode;

  /// The localized text of the vehicle restriction. Can be empty for example
  /// when the category is general truck restriction.
  String localizedText;

  /// Specifies if restriction is time dependant. If so, resulting icon will be overlaid with a clock icon.
  bool isTimeDependant;

  /// Specifies if restriction is active.
  bool isActive;

  IconProviderInternalVehicleRestrictionIconAttributes(this.restrictionCategory, this.restrictionType, this.countryCode, this.localizedText, this.isTimeDependant, this.isActive);
}


// IconProviderInternalVehicleRestrictionIconAttributes "private" section, not exported.

final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Uint8, Uint8),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, int, int)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_create_handle'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_release_handle'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldrestrictionCategory = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_field_restrictionCategory'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldrestrictionType = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_field_restrictionType'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldcountryCode = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_field_countryCode'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldlocalizedText = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_field_localizedText'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldisTimeDependant = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_field_isTimeDependant'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldisActive = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_field_isActive'));



Pointer<Void> sdkMapviewIconproviderinternalVehiclerestrictioniconattributesToFfi(IconProviderInternalVehicleRestrictionIconAttributes value) {
  final _restrictionCategoryHandle = stringToFfi(value.restrictionCategory);
  final _restrictionTypeHandle = stringToFfi(value.restrictionType);
  final _countryCodeHandle = stringToFfi(value.countryCode);
  final _localizedTextHandle = stringToFfi(value.localizedText);
  final _isTimeDependantHandle = booleanToFfi(value.isTimeDependant);
  final _isActiveHandle = booleanToFfi(value.isActive);
  final _result = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesCreateHandle(_restrictionCategoryHandle, _restrictionTypeHandle, _countryCodeHandle, _localizedTextHandle, _isTimeDependantHandle, _isActiveHandle);
  stringReleaseFfiHandle(_restrictionCategoryHandle);
  stringReleaseFfiHandle(_restrictionTypeHandle);
  stringReleaseFfiHandle(_countryCodeHandle);
  stringReleaseFfiHandle(_localizedTextHandle);
  booleanReleaseFfiHandle(_isTimeDependantHandle);
  booleanReleaseFfiHandle(_isActiveHandle);
  return _result;
}

IconProviderInternalVehicleRestrictionIconAttributes sdkMapviewIconproviderinternalVehiclerestrictioniconattributesFromFfi(Pointer<Void> handle) {
  final _restrictionCategoryHandle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldrestrictionCategory(handle);
  final _restrictionTypeHandle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldrestrictionType(handle);
  final _countryCodeHandle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldcountryCode(handle);
  final _localizedTextHandle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldlocalizedText(handle);
  final _isTimeDependantHandle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldisTimeDependant(handle);
  final _isActiveHandle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetFieldisActive(handle);
  try {
    return IconProviderInternalVehicleRestrictionIconAttributes(
      stringFromFfi(_restrictionCategoryHandle), 
      stringFromFfi(_restrictionTypeHandle), 
      stringFromFfi(_countryCodeHandle), 
      stringFromFfi(_localizedTextHandle), 
      booleanFromFfi(_isTimeDependantHandle), 
      booleanFromFfi(_isActiveHandle)
    );
  } finally {
    stringReleaseFfiHandle(_restrictionCategoryHandle);
    stringReleaseFfiHandle(_restrictionTypeHandle);
    stringReleaseFfiHandle(_countryCodeHandle);
    stringReleaseFfiHandle(_localizedTextHandle);
    booleanReleaseFfiHandle(_isTimeDependantHandle);
    booleanReleaseFfiHandle(_isActiveHandle);
  }
}

void sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseFfiHandle(Pointer<Void> handle) => _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseHandle(handle);

// Nullable IconProviderInternalVehicleRestrictionIconAttributes

final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_create_handle_nullable'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_release_handle_nullable'));
final _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_VehicleRestrictionIconAttributes_get_value_nullable'));

Pointer<Void> sdkMapviewIconproviderinternalVehiclerestrictioniconattributesToFfiNullable(IconProviderInternalVehicleRestrictionIconAttributes? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewIconproviderinternalVehiclerestrictioniconattributesToFfi(value);
  final result = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesCreateHandleNullable(_handle);
  sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseFfiHandle(_handle);
  return result;
}

IconProviderInternalVehicleRestrictionIconAttributes? sdkMapviewIconproviderinternalVehiclerestrictioniconattributesFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesGetValueNullable(handle);
  final result = sdkMapviewIconproviderinternalVehiclerestrictioniconattributesFromFfi(_handle);
  sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseHandleNullable(handle);

// End of IconProviderInternalVehicleRestrictionIconAttributes "private" section.
/// @nodoc
/// Callback to return the created icon or error code.
///
/// [p0] The created icon in PNG format.
///
/// [p1] A description of the icon.
///
/// [p2] The cause for the failure of icon creation.
typedef IconProviderInternalCreateIconCallback = void Function(Uint8List?, String?, IconProviderError?);

// IconProviderInternalCreateIconCallback "private" section, not exported.

final _sdkMapviewIconproviderinternalCreateiconcallbackRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_register_finalizer'));
final _sdkMapviewIconproviderinternalCreateiconcallbackCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_copy_handle'));
final _sdkMapviewIconproviderinternalCreateiconcallbackReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_release_handle'));
final _sdkMapviewIconproviderinternalCreateiconcallbackCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_create_proxy'));

class IconProviderInternalCreateIconCallback$Impl {
  final Pointer<Void> handle;
  IconProviderInternalCreateIconCallback$Impl(this.handle);

  void call(Uint8List? p0, String? p1, IconProviderError? p2) {
    final _callFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_call__Blob__String__IconProviderError_'));
    final _p0Handle = blobToFfiNullable(p0);
    final _p1Handle = stringToFfiNullable(p1);
    final _p2Handle = sdkMapviewIconprovidererrorToFfiNullable(p2);
    final _handle = this.handle;
    _callFfi(_handle, __lib.LibraryContext.isolateId, _p0Handle, _p1Handle, _p2Handle);
    blobReleaseFfiHandleNullable(_p0Handle);
    stringReleaseFfiHandleNullable(_p1Handle);
    sdkMapviewIconprovidererrorReleaseFfiHandleNullable(_p2Handle);

  }

}

int _sdkMapviewIconproviderinternalCreateiconcallbackcallStatic(Object _obj, Pointer<Void> p0, Pointer<Void> p1, Pointer<Void> p2) {
  
  try {
    (_obj as IconProviderInternalCreateIconCallback)(blobFromFfiNullable(p0), stringFromFfiNullable(p1), sdkMapviewIconprovidererrorFromFfiNullable(p2));
  } finally {
    blobReleaseFfiHandleNullable(p0);
    stringReleaseFfiHandleNullable(p1);
    sdkMapviewIconprovidererrorReleaseFfiHandleNullable(p2);
  }
  return 0;
}

Pointer<Void> sdkMapviewIconproviderinternalCreateiconcallbackToFfi(IconProviderInternalCreateIconCallback value) =>
  _sdkMapviewIconproviderinternalCreateiconcallbackCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Int64 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>)>(_sdkMapviewIconproviderinternalCreateiconcallbackcallStatic, __lib.unknownError)
  );

IconProviderInternalCreateIconCallback sdkMapviewIconproviderinternalCreateiconcallbackFromFfi(Pointer<Void> handle) {
  final _copiedHandle = _sdkMapviewIconproviderinternalCreateiconcallbackCopyHandle(handle);
  final _impl = IconProviderInternalCreateIconCallback$Impl(_copiedHandle);
  final result = (Uint8List? p0, String? p1, IconProviderError? p2) => _impl.call(p0, p1, p2);
  _sdkMapviewIconproviderinternalCreateiconcallbackRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewIconproviderinternalCreateiconcallbackReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewIconproviderinternalCreateiconcallbackReleaseHandle(handle);

// Nullable IconProviderInternalCreateIconCallback

final _sdkMapviewIconproviderinternalCreateiconcallbackCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_create_handle_nullable'));
final _sdkMapviewIconproviderinternalCreateiconcallbackReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_release_handle_nullable'));
final _sdkMapviewIconproviderinternalCreateiconcallbackGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_CreateIconCallback_get_value_nullable'));

Pointer<Void> sdkMapviewIconproviderinternalCreateiconcallbackToFfiNullable(IconProviderInternalCreateIconCallback? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewIconproviderinternalCreateiconcallbackToFfi(value);
  final result = _sdkMapviewIconproviderinternalCreateiconcallbackCreateHandleNullable(_handle);
  sdkMapviewIconproviderinternalCreateiconcallbackReleaseFfiHandle(_handle);
  return result;
}

IconProviderInternalCreateIconCallback? sdkMapviewIconproviderinternalCreateiconcallbackFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewIconproviderinternalCreateiconcallbackGetValueNullable(handle);
  final result = sdkMapviewIconproviderinternalCreateiconcallbackFromFfi(_handle);
  sdkMapviewIconproviderinternalCreateiconcallbackReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewIconproviderinternalCreateiconcallbackReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewIconproviderinternalCreateiconcallbackReleaseHandleNullable(handle);

// End of IconProviderInternalCreateIconCallback "private" section.

// IconProviderInternal "private" section, not exported.

final _sdkMapviewIconproviderinternalRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_IconProviderInternal_register_finalizer'));
final _sdkMapviewIconproviderinternalCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_copy_handle'));
final _sdkMapviewIconproviderinternalReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_IconProviderInternal_release_handle'));





/// @nodoc
@visibleForTesting
class IconProviderInternal$Impl extends __lib.NativeBase implements IconProviderInternal {

  IconProviderInternal$Impl(Pointer<Void> handle) : super(handle);


  IconProviderInternal create(MapContext context) {
    final _result_handle = _create(context);
    final _result = IconProviderInternal$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewIconproviderinternalRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create(MapContext context) {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_mapview_IconProviderInternal_create__MapContext'));
    final _contextHandle = sdkMapviewMapcontextToFfi(context);
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId, _contextHandle);
    sdkMapviewMapcontextReleaseFfiHandle(_contextHandle);
    return __resultHandle;
  }

  @override
  void createRoadShieldIcon(RoadShieldIconProperties properties, MapScheme mapScheme, IconProviderAssetType assetType, int widthConstraintInPixels, int heightConstraintInPixels, IconProviderInternalCreateIconCallback callback) {
    final _createRoadShieldIconFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Uint32, Uint32, Uint32, Uint32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, int, int, int, int, Pointer<Void>)>('here_sdk_sdk_mapview_IconProviderInternal_createRoadShieldIcon__RoadShieldIconProperties_MapScheme_IconProviderAssetType_UInt_UInt_CreateIconCallback'));
    final _propertiesHandle = sdkMapviewRoadshieldiconpropertiesToFfi(properties);
    final _mapSchemeHandle = sdkMapviewMapschemeToFfi(mapScheme);
    final _assetTypeHandle = sdkMapviewIconproviderassettypeToFfi(assetType);
    final _widthConstraintInPixelsHandle = (widthConstraintInPixels);
    final _heightConstraintInPixelsHandle = (heightConstraintInPixels);
    final _callbackHandle = sdkMapviewIconproviderinternalCreateiconcallbackToFfi(callback);
    final _handle = this.handle;
    _createRoadShieldIconFfi(_handle, __lib.LibraryContext.isolateId, _propertiesHandle, _mapSchemeHandle, _assetTypeHandle, _widthConstraintInPixelsHandle, _heightConstraintInPixelsHandle, _callbackHandle);
    sdkMapviewRoadshieldiconpropertiesReleaseFfiHandle(_propertiesHandle);
    sdkMapviewMapschemeReleaseFfiHandle(_mapSchemeHandle);
    sdkMapviewIconproviderassettypeReleaseFfiHandle(_assetTypeHandle);


    sdkMapviewIconproviderinternalCreateiconcallbackReleaseFfiHandle(_callbackHandle);

  }

  @override
  void createVehicleRestrictionIcon(IconProviderInternalVehicleRestrictionIconAttributes attributes, MapScheme mapScheme, IconProviderAssetType assetType, int widthConstraintInPixels, int heightConstraintInPixels, IconProviderInternalCreateIconCallback callback) {
    final _createVehicleRestrictionIconFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Void Function(Pointer<Void>, Int32, Pointer<Void>, Uint32, Uint32, Uint32, Uint32, Pointer<Void>), void Function(Pointer<Void>, int, Pointer<Void>, int, int, int, int, Pointer<Void>)>('here_sdk_sdk_mapview_IconProviderInternal_createVehicleRestrictionIcon__VehicleRestrictionIconAttributes_MapScheme_IconProviderAssetType_UInt_UInt_CreateIconCallback'));
    final _attributesHandle = sdkMapviewIconproviderinternalVehiclerestrictioniconattributesToFfi(attributes);
    final _mapSchemeHandle = sdkMapviewMapschemeToFfi(mapScheme);
    final _assetTypeHandle = sdkMapviewIconproviderassettypeToFfi(assetType);
    final _widthConstraintInPixelsHandle = (widthConstraintInPixels);
    final _heightConstraintInPixelsHandle = (heightConstraintInPixels);
    final _callbackHandle = sdkMapviewIconproviderinternalCreateiconcallbackToFfi(callback);
    final _handle = this.handle;
    _createVehicleRestrictionIconFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle, _mapSchemeHandle, _assetTypeHandle, _widthConstraintInPixelsHandle, _heightConstraintInPixelsHandle, _callbackHandle);
    sdkMapviewIconproviderinternalVehiclerestrictioniconattributesReleaseFfiHandle(_attributesHandle);
    sdkMapviewMapschemeReleaseFfiHandle(_mapSchemeHandle);
    sdkMapviewIconproviderassettypeReleaseFfiHandle(_assetTypeHandle);


    sdkMapviewIconproviderinternalCreateiconcallbackReleaseFfiHandle(_callbackHandle);

  }


}

Pointer<Void> sdkMapviewIconproviderinternalToFfi(IconProviderInternal value) =>
  _sdkMapviewIconproviderinternalCopyHandle((value as __lib.NativeBase).handle);

IconProviderInternal sdkMapviewIconproviderinternalFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is IconProviderInternal) return instance;

  final _copiedHandle = _sdkMapviewIconproviderinternalCopyHandle(handle);
  final result = IconProviderInternal$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewIconproviderinternalRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewIconproviderinternalReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewIconproviderinternalReleaseHandle(handle);

Pointer<Void> sdkMapviewIconproviderinternalToFfiNullable(IconProviderInternal? value) =>
  value != null ? sdkMapviewIconproviderinternalToFfi(value) : Pointer<Void>.fromAddress(0);

IconProviderInternal? sdkMapviewIconproviderinternalFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewIconproviderinternalFromFfi(handle) : null;

void sdkMapviewIconproviderinternalReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewIconproviderinternalReleaseHandle(handle);

// End of IconProviderInternal "private" section.


