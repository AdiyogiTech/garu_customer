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
import 'package:collection/collection.dart';
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/routing/allow_options.dart';
import 'package:here_sdk/src/sdk/routing/avoidance_options.dart';
import 'package:here_sdk/src/sdk/routing/e_v_consumption_model.dart';
import 'package:here_sdk/src/sdk/routing/max_speed_on_segment.dart';
import 'package:here_sdk/src/sdk/routing/route_options.dart';
import 'package:here_sdk/src/sdk/routing/route_text_options.dart';
import 'package:here_sdk/src/sdk/routing/toll_options.dart';
import 'package:here_sdk/src/sdk/transport/hazardous_material.dart';
import 'package:here_sdk/src/sdk/transport/truck_road_type.dart';
import 'package:here_sdk/src/sdk/transport/truck_specifications.dart';
import 'package:here_sdk/src/sdk/transport/tunnel_category.dart';

/// All the options to specify how a route for an electric truck should be calculated.

class EVTruckOptions {
  /// Specifies the common route calculation options.
  RouteOptions routeOptions;

  /// Customize textual content returned from the route calculation, such
  /// as localization, format, and unit system.
  RouteTextOptions textOptions;

  /// Options to specify restrictions for route calculations. By default
  /// no restrictions are applied.
  AvoidanceOptions avoidanceOptions;

  /// Options to specify how the tolls should be calculated,
  /// such as transponders, vehicle category, and emission type.
  TollOptions tollOptions;

  /// The options explicitly allowed by user for route calculations. By default
  /// no options are opt in.
  AllowOptions allowOptions;

  /// Specifies the number of occupants in the vehicle, including driver,
  /// can affect the vehicle's ability to use HOV/carpool restricted lanes.
  /// Shouldn't be less than 1 or greater than 255. Defaults to 1.
  ///
  /// **Note:** This parameter won't have effect if HOV and/or HOT lane usage is not allowed using [EVTruckOptions.allowOptions]
  int occupantsNumber;

  /// Segments with restriction on maximum [DynamicSpeedInfo.baseSpeedInMetersPerSecond].
  List<MaxSpeedOnSegment> maxSpeedOnSegments;

  /// Detailed truck specifications such as dimensions and weight.
  TruckSpecifications truckSpecifications;

  /// Specifies the tunnel categories to restrict certain route links.
  /// The route will pass only through tunnels of a less strict category.
  /// Refer to [TunnelCategory] for the available options.
  TunnelCategory? linkTunnelCategory;

  /// Specifies a list of hazardous materials shipped in the vehicle.
  /// Refer to [HazardousMaterial] for the available options.
  List<HazardousMaterial> hazardousMaterials;

  /// Specifies a list of avoided truck road types for vehicle.
  /// Refer to [TruckRoadType] for the available options.
  List<TruckRoadType> avoidedTruckRoadTypes;

  /// Vehicle specific parameters, which are then used to calculate energy consumption
  /// for the vehicle on a given route.
  EVConsumptionModel consumptionModel;

  /// Creates a new instance.

  /// [routeOptions] Specifies the common route calculation options.

  /// [textOptions] Customize textual content returned from the route calculation, such
  /// as localization, format, and unit system.

  /// [avoidanceOptions] Options to specify restrictions for route calculations. By default
  /// no restrictions are applied.

  /// [tollOptions] Options to specify how the tolls should be calculated,
  /// such as transponders, vehicle category, and emission type.

  /// [allowOptions] The options explicitly allowed by user for route calculations. By default
  /// no options are opt in.

  /// [occupantsNumber] Specifies the number of occupants in the vehicle, including driver,
  /// can affect the vehicle's ability to use HOV/carpool restricted lanes.
  /// Shouldn't be less than 1 or greater than 255. Defaults to 1.
  ///
  /// **Note:** This parameter won't have effect if HOV and/or HOT lane usage is not allowed using [EVTruckOptions.allowOptions]

  /// [maxSpeedOnSegments] Segments with restriction on maximum [DynamicSpeedInfo.baseSpeedInMetersPerSecond].

  /// [truckSpecifications] Detailed truck specifications such as dimensions and weight.

  /// [linkTunnelCategory] Specifies the tunnel categories to restrict certain route links.
  /// The route will pass only through tunnels of a less strict category.
  /// Refer to [TunnelCategory] for the available options.

  /// [hazardousMaterials] Specifies a list of hazardous materials shipped in the vehicle.
  /// Refer to [HazardousMaterial] for the available options.

  /// [avoidedTruckRoadTypes] Specifies a list of avoided truck road types for vehicle.
  /// Refer to [TruckRoadType] for the available options.

  /// [consumptionModel] Vehicle specific parameters, which are then used to calculate energy consumption
  /// for the vehicle on a given route.

  EVTruckOptions._(this.routeOptions, this.textOptions, this.avoidanceOptions, this.tollOptions, this.allowOptions, this.occupantsNumber, this.maxSpeedOnSegments, this.truckSpecifications, this.linkTunnelCategory, this.hazardousMaterials, this.avoidedTruckRoadTypes, this.consumptionModel);
  EVTruckOptions()
    : routeOptions = RouteOptions.withDefaults(), textOptions = RouteTextOptions(), avoidanceOptions = AvoidanceOptions(), tollOptions = TollOptions(), allowOptions = AllowOptions(), occupantsNumber = 1, maxSpeedOnSegments = [], truckSpecifications = TruckSpecifications(), linkTunnelCategory = null, hazardousMaterials = [], avoidedTruckRoadTypes = [], consumptionModel = EVConsumptionModel();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EVTruckOptions) return false;
    EVTruckOptions _other = other;
    return routeOptions == _other.routeOptions &&
        textOptions == _other.textOptions &&
        avoidanceOptions == _other.avoidanceOptions &&
        tollOptions == _other.tollOptions &&
        allowOptions == _other.allowOptions &&
        occupantsNumber == _other.occupantsNumber &&
        DeepCollectionEquality().equals(maxSpeedOnSegments, _other.maxSpeedOnSegments) &&
        truckSpecifications == _other.truckSpecifications &&
        linkTunnelCategory == _other.linkTunnelCategory &&
        DeepCollectionEquality().equals(hazardousMaterials, _other.hazardousMaterials) &&
        DeepCollectionEquality().equals(avoidedTruckRoadTypes, _other.avoidedTruckRoadTypes) &&
        consumptionModel == _other.consumptionModel;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + routeOptions.hashCode;
    result = 31 * result + textOptions.hashCode;
    result = 31 * result + avoidanceOptions.hashCode;
    result = 31 * result + tollOptions.hashCode;
    result = 31 * result + allowOptions.hashCode;
    result = 31 * result + occupantsNumber.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(maxSpeedOnSegments);
    result = 31 * result + truckSpecifications.hashCode;
    result = 31 * result + linkTunnelCategory.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(hazardousMaterials);
    result = 31 * result + DeepCollectionEquality().hash(avoidedTruckRoadTypes);
    result = 31 * result + consumptionModel.hashCode;
    return result;
  }
}


// EVTruckOptions "private" section, not exported.

final _sdkRoutingEvtruckoptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_create_handle'));
final _sdkRoutingEvtruckoptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_release_handle'));
final _sdkRoutingEvtruckoptionsGetFieldrouteOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_routeOptions'));
final _sdkRoutingEvtruckoptionsGetFieldtextOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_textOptions'));
final _sdkRoutingEvtruckoptionsGetFieldavoidanceOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_avoidanceOptions'));
final _sdkRoutingEvtruckoptionsGetFieldtollOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_tollOptions'));
final _sdkRoutingEvtruckoptionsGetFieldallowOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_allowOptions'));
final _sdkRoutingEvtruckoptionsGetFieldoccupantsNumber = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_occupantsNumber'));
final _sdkRoutingEvtruckoptionsGetFieldmaxSpeedOnSegments = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_maxSpeedOnSegments'));
final _sdkRoutingEvtruckoptionsGetFieldtruckSpecifications = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_truckSpecifications'));
final _sdkRoutingEvtruckoptionsGetFieldlinkTunnelCategory = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_linkTunnelCategory'));
final _sdkRoutingEvtruckoptionsGetFieldhazardousMaterials = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_hazardousMaterials'));
final _sdkRoutingEvtruckoptionsGetFieldavoidedTruckRoadTypes = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_avoidedTruckRoadTypes'));
final _sdkRoutingEvtruckoptionsGetFieldconsumptionModel = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_field_consumptionModel'));



Pointer<Void> sdkRoutingEvtruckoptionsToFfi(EVTruckOptions value) {
  final _routeOptionsHandle = sdkRoutingRouteoptionsToFfi(value.routeOptions);
  final _textOptionsHandle = sdkRoutingRoutetextoptionsToFfi(value.textOptions);
  final _avoidanceOptionsHandle = sdkRoutingAvoidanceoptionsToFfi(value.avoidanceOptions);
  final _tollOptionsHandle = sdkRoutingTolloptionsToFfi(value.tollOptions);
  final _allowOptionsHandle = sdkRoutingAllowoptionsToFfi(value.allowOptions);
  final _occupantsNumberHandle = (value.occupantsNumber);
  final _maxSpeedOnSegmentsHandle = heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentToFfi(value.maxSpeedOnSegments);
  final _truckSpecificationsHandle = sdkTransportTruckspecificationsToFfi(value.truckSpecifications);
  final _linkTunnelCategoryHandle = sdkTransportTunnelcategoryToFfiNullable(value.linkTunnelCategory);
  final _hazardousMaterialsHandle = heresdkRoutingCommonBindingslistofSdkTransportHazardousmaterialToFfi(value.hazardousMaterials);
  final _avoidedTruckRoadTypesHandle = heresdkRoutingCommonBindingslistofSdkTransportTruckroadtypeToFfi(value.avoidedTruckRoadTypes);
  final _consumptionModelHandle = sdkRoutingEvconsumptionmodelToFfi(value.consumptionModel);
  final _result = _sdkRoutingEvtruckoptionsCreateHandle(_routeOptionsHandle, _textOptionsHandle, _avoidanceOptionsHandle, _tollOptionsHandle, _allowOptionsHandle, _occupantsNumberHandle, _maxSpeedOnSegmentsHandle, _truckSpecificationsHandle, _linkTunnelCategoryHandle, _hazardousMaterialsHandle, _avoidedTruckRoadTypesHandle, _consumptionModelHandle);
  sdkRoutingRouteoptionsReleaseFfiHandle(_routeOptionsHandle);
  sdkRoutingRoutetextoptionsReleaseFfiHandle(_textOptionsHandle);
  sdkRoutingAvoidanceoptionsReleaseFfiHandle(_avoidanceOptionsHandle);
  sdkRoutingTolloptionsReleaseFfiHandle(_tollOptionsHandle);
  sdkRoutingAllowoptionsReleaseFfiHandle(_allowOptionsHandle);
  
  heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentReleaseFfiHandle(_maxSpeedOnSegmentsHandle);
  sdkTransportTruckspecificationsReleaseFfiHandle(_truckSpecificationsHandle);
  sdkTransportTunnelcategoryReleaseFfiHandleNullable(_linkTunnelCategoryHandle);
  heresdkRoutingCommonBindingslistofSdkTransportHazardousmaterialReleaseFfiHandle(_hazardousMaterialsHandle);
  heresdkRoutingCommonBindingslistofSdkTransportTruckroadtypeReleaseFfiHandle(_avoidedTruckRoadTypesHandle);
  sdkRoutingEvconsumptionmodelReleaseFfiHandle(_consumptionModelHandle);
  return _result;
}

EVTruckOptions sdkRoutingEvtruckoptionsFromFfi(Pointer<Void> handle) {
  final _routeOptionsHandle = _sdkRoutingEvtruckoptionsGetFieldrouteOptions(handle);
  final _textOptionsHandle = _sdkRoutingEvtruckoptionsGetFieldtextOptions(handle);
  final _avoidanceOptionsHandle = _sdkRoutingEvtruckoptionsGetFieldavoidanceOptions(handle);
  final _tollOptionsHandle = _sdkRoutingEvtruckoptionsGetFieldtollOptions(handle);
  final _allowOptionsHandle = _sdkRoutingEvtruckoptionsGetFieldallowOptions(handle);
  final _occupantsNumberHandle = _sdkRoutingEvtruckoptionsGetFieldoccupantsNumber(handle);
  final _maxSpeedOnSegmentsHandle = _sdkRoutingEvtruckoptionsGetFieldmaxSpeedOnSegments(handle);
  final _truckSpecificationsHandle = _sdkRoutingEvtruckoptionsGetFieldtruckSpecifications(handle);
  final _linkTunnelCategoryHandle = _sdkRoutingEvtruckoptionsGetFieldlinkTunnelCategory(handle);
  final _hazardousMaterialsHandle = _sdkRoutingEvtruckoptionsGetFieldhazardousMaterials(handle);
  final _avoidedTruckRoadTypesHandle = _sdkRoutingEvtruckoptionsGetFieldavoidedTruckRoadTypes(handle);
  final _consumptionModelHandle = _sdkRoutingEvtruckoptionsGetFieldconsumptionModel(handle);
  try {
    return EVTruckOptions._(
      sdkRoutingRouteoptionsFromFfi(_routeOptionsHandle), 
      sdkRoutingRoutetextoptionsFromFfi(_textOptionsHandle), 
      sdkRoutingAvoidanceoptionsFromFfi(_avoidanceOptionsHandle), 
      sdkRoutingTolloptionsFromFfi(_tollOptionsHandle), 
      sdkRoutingAllowoptionsFromFfi(_allowOptionsHandle), 
      (_occupantsNumberHandle), 
      heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentFromFfi(_maxSpeedOnSegmentsHandle), 
      sdkTransportTruckspecificationsFromFfi(_truckSpecificationsHandle), 
      sdkTransportTunnelcategoryFromFfiNullable(_linkTunnelCategoryHandle), 
      heresdkRoutingCommonBindingslistofSdkTransportHazardousmaterialFromFfi(_hazardousMaterialsHandle), 
      heresdkRoutingCommonBindingslistofSdkTransportTruckroadtypeFromFfi(_avoidedTruckRoadTypesHandle), 
      sdkRoutingEvconsumptionmodelFromFfi(_consumptionModelHandle)
    );
  } finally {
    sdkRoutingRouteoptionsReleaseFfiHandle(_routeOptionsHandle);
    sdkRoutingRoutetextoptionsReleaseFfiHandle(_textOptionsHandle);
    sdkRoutingAvoidanceoptionsReleaseFfiHandle(_avoidanceOptionsHandle);
    sdkRoutingTolloptionsReleaseFfiHandle(_tollOptionsHandle);
    sdkRoutingAllowoptionsReleaseFfiHandle(_allowOptionsHandle);
    
    heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentReleaseFfiHandle(_maxSpeedOnSegmentsHandle);
    sdkTransportTruckspecificationsReleaseFfiHandle(_truckSpecificationsHandle);
    sdkTransportTunnelcategoryReleaseFfiHandleNullable(_linkTunnelCategoryHandle);
    heresdkRoutingCommonBindingslistofSdkTransportHazardousmaterialReleaseFfiHandle(_hazardousMaterialsHandle);
    heresdkRoutingCommonBindingslistofSdkTransportTruckroadtypeReleaseFfiHandle(_avoidedTruckRoadTypesHandle);
    sdkRoutingEvconsumptionmodelReleaseFfiHandle(_consumptionModelHandle);
  }
}

void sdkRoutingEvtruckoptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingEvtruckoptionsReleaseHandle(handle);

// Nullable EVTruckOptions

final _sdkRoutingEvtruckoptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_create_handle_nullable'));
final _sdkRoutingEvtruckoptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_release_handle_nullable'));
final _sdkRoutingEvtruckoptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVTruckOptions_get_value_nullable'));

Pointer<Void> sdkRoutingEvtruckoptionsToFfiNullable(EVTruckOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingEvtruckoptionsToFfi(value);
  final result = _sdkRoutingEvtruckoptionsCreateHandleNullable(_handle);
  sdkRoutingEvtruckoptionsReleaseFfiHandle(_handle);
  return result;
}

EVTruckOptions? sdkRoutingEvtruckoptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingEvtruckoptionsGetValueNullable(handle);
  final result = sdkRoutingEvtruckoptionsFromFfi(_handle);
  sdkRoutingEvtruckoptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingEvtruckoptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingEvtruckoptionsReleaseHandleNullable(handle);

// End of EVTruckOptions "private" section.


