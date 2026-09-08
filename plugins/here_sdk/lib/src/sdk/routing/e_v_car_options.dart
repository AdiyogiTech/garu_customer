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
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/routing/allow_options.dart';
import 'package:here_sdk/src/sdk/routing/avoidance_options.dart';
import 'package:here_sdk/src/sdk/routing/battery_specifications.dart';
import 'package:here_sdk/src/sdk/routing/e_v_consumption_model.dart';
import 'package:here_sdk/src/sdk/routing/e_v_mobility_service_provider_preferences.dart';
import 'package:here_sdk/src/sdk/routing/max_speed_on_segment.dart';
import 'package:here_sdk/src/sdk/routing/route_options.dart';
import 'package:here_sdk/src/sdk/routing/route_text_options.dart';
import 'package:here_sdk/src/sdk/routing/toll_options.dart';
import 'package:here_sdk/src/sdk/transport/car_specifications.dart';

/// All the options to specify how a route for an electric car should be calculated.
///
/// At minimum, a valid [EVConsumptionModel] must be set or the route calculation will fail.
/// <br>
/// Note: [EVCarOptions.ensureReachability] must be true to make sure that all stopovers are reachable. For this,
/// charging stations may be added to the route. If [EVCarOptions.ensureReachability] is true, you need to
/// specify the required route options and battery specifications that include the current charge level
/// of the battery ([BatterySpecifications.initialChargeInKilowattHours]).
/// See the parameter description below for more details.

class EVCarOptions {
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
  /// **Note:** This parameter won't have effect if HOV and/or HOT lane usage is not allowed using [EVCarOptions.allowOptions]
  int occupantsNumber;

  /// Segments with restriction on maximum [DynamicSpeedInfo.baseSpeedInMetersPerSecond].
  List<MaxSpeedOnSegment> maxSpeedOnSegments;

  /// Ensure that the vehicle does not run out of energy along the way.
  /// Requires valid [EVCarOptions.batterySpecifications].
  /// It also requires that
  /// [RouteOptions.optimizationMode] = [OptimizationMode.fastest],
  /// [RouteOptions.speedCapInMetersPerSecond] is not set, and
  /// [AvoidanceOptions] is empty. Otherwise, this object is considered invalid.
  /// Setting this flag enables calculation of a route optimized for electric vehicles.
  /// Charging stations may be added along the route to ensure that the vehicle does
  /// not run out of energy along the way.
  /// It is especially useful for longer routes, because after all, charging stations are much
  /// less common than petrol stations.
  /// Defaults to false.
  bool ensureReachability;

  /// Vehicle specific parameters, which are then used to calculate energy consumption
  /// for the vehicle on a given route.
  EVConsumptionModel consumptionModel;

  /// Parameters that describe the electric vehicle's battery.
  BatterySpecifications batterySpecifications;

  /// Detailed car specifications such as dimensions and weight.
  CarSpecifications carSpecifications;

  /// Defines the preferred E-Mobility Service Providers.
  /// The The E-Mobility Service Provider Partner Ids can be received from
  /// https://www.here.com/docs/bundle/ev-charge-points-api-developer-guide/page/topics/resource-roamings.html
  /// An alternative way to get `partnerId` is the `eMobilityServiceProviders.partnerId` as part of `HERE SDK Search`.
  /// Maximum number of E-Mobility Service Providers is limited to 10.
  /// By default, all providers are used.
  EVMobilityServiceProviderPreferences evMobilityServiceProviderPreferences;

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
  /// **Note:** This parameter won't have effect if HOV and/or HOT lane usage is not allowed using [EVCarOptions.allowOptions]

  /// [maxSpeedOnSegments] Segments with restriction on maximum [DynamicSpeedInfo.baseSpeedInMetersPerSecond].

  /// [ensureReachability] Ensure that the vehicle does not run out of energy along the way.
  /// Requires valid [EVCarOptions.batterySpecifications].
  /// It also requires that
  /// [RouteOptions.optimizationMode] = [OptimizationMode.fastest],
  /// [RouteOptions.speedCapInMetersPerSecond] is not set, and
  /// [AvoidanceOptions] is empty. Otherwise, this object is considered invalid.
  /// Setting this flag enables calculation of a route optimized for electric vehicles.
  /// Charging stations may be added along the route to ensure that the vehicle does
  /// not run out of energy along the way.
  /// It is especially useful for longer routes, because after all, charging stations are much
  /// less common than petrol stations.
  /// Defaults to false.

  /// [consumptionModel] Vehicle specific parameters, which are then used to calculate energy consumption
  /// for the vehicle on a given route.

  /// [batterySpecifications] Parameters that describe the electric vehicle's battery.

  /// [carSpecifications] Detailed car specifications such as dimensions and weight.

  /// [evMobilityServiceProviderPreferences] Defines the preferred E-Mobility Service Providers.
  /// The The E-Mobility Service Provider Partner Ids can be received from
  /// https://www.here.com/docs/bundle/ev-charge-points-api-developer-guide/page/topics/resource-roamings.html
  /// An alternative way to get `partnerId` is the `eMobilityServiceProviders.partnerId` as part of `HERE SDK Search`.
  /// Maximum number of E-Mobility Service Providers is limited to 10.
  /// By default, all providers are used.

  EVCarOptions._(this.routeOptions, this.textOptions, this.avoidanceOptions, this.tollOptions, this.allowOptions, this.occupantsNumber, this.maxSpeedOnSegments, this.ensureReachability, this.consumptionModel, this.batterySpecifications, this.carSpecifications, this.evMobilityServiceProviderPreferences);
  EVCarOptions()
    : routeOptions = RouteOptions.withDefaults(), textOptions = RouteTextOptions(), avoidanceOptions = AvoidanceOptions(), tollOptions = TollOptions(), allowOptions = AllowOptions(), occupantsNumber = 1, maxSpeedOnSegments = [], ensureReachability = false, consumptionModel = EVConsumptionModel(), batterySpecifications = BatterySpecifications.withDefaults(), carSpecifications = CarSpecifications(), evMobilityServiceProviderPreferences = EVMobilityServiceProviderPreferences();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EVCarOptions) return false;
    EVCarOptions _other = other;
    return routeOptions == _other.routeOptions &&
        textOptions == _other.textOptions &&
        avoidanceOptions == _other.avoidanceOptions &&
        tollOptions == _other.tollOptions &&
        allowOptions == _other.allowOptions &&
        occupantsNumber == _other.occupantsNumber &&
        DeepCollectionEquality().equals(maxSpeedOnSegments, _other.maxSpeedOnSegments) &&
        ensureReachability == _other.ensureReachability &&
        consumptionModel == _other.consumptionModel &&
        batterySpecifications == _other.batterySpecifications &&
        carSpecifications == _other.carSpecifications &&
        evMobilityServiceProviderPreferences == _other.evMobilityServiceProviderPreferences;
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
    result = 31 * result + ensureReachability.hashCode;
    result = 31 * result + consumptionModel.hashCode;
    result = 31 * result + batterySpecifications.hashCode;
    result = 31 * result + carSpecifications.hashCode;
    result = 31 * result + evMobilityServiceProviderPreferences.hashCode;
    return result;
  }
}


// EVCarOptions "private" section, not exported.

final _sdkRoutingEvcaroptionsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Int32, Pointer<Void>, Uint8, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, int, Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_create_handle'));
final _sdkRoutingEvcaroptionsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_release_handle'));
final _sdkRoutingEvcaroptionsGetFieldrouteOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_routeOptions'));
final _sdkRoutingEvcaroptionsGetFieldtextOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_textOptions'));
final _sdkRoutingEvcaroptionsGetFieldavoidanceOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_avoidanceOptions'));
final _sdkRoutingEvcaroptionsGetFieldtollOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_tollOptions'));
final _sdkRoutingEvcaroptionsGetFieldallowOptions = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_allowOptions'));
final _sdkRoutingEvcaroptionsGetFieldoccupantsNumber = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_occupantsNumber'));
final _sdkRoutingEvcaroptionsGetFieldmaxSpeedOnSegments = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_maxSpeedOnSegments'));
final _sdkRoutingEvcaroptionsGetFieldensureReachability = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_ensureReachability'));
final _sdkRoutingEvcaroptionsGetFieldconsumptionModel = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_consumptionModel'));
final _sdkRoutingEvcaroptionsGetFieldbatterySpecifications = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_batterySpecifications'));
final _sdkRoutingEvcaroptionsGetFieldcarSpecifications = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_carSpecifications'));
final _sdkRoutingEvcaroptionsGetFieldevMobilityServiceProviderPreferences = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_field_evMobilityServiceProviderPreferences'));



Pointer<Void> sdkRoutingEvcaroptionsToFfi(EVCarOptions value) {
  final _routeOptionsHandle = sdkRoutingRouteoptionsToFfi(value.routeOptions);
  final _textOptionsHandle = sdkRoutingRoutetextoptionsToFfi(value.textOptions);
  final _avoidanceOptionsHandle = sdkRoutingAvoidanceoptionsToFfi(value.avoidanceOptions);
  final _tollOptionsHandle = sdkRoutingTolloptionsToFfi(value.tollOptions);
  final _allowOptionsHandle = sdkRoutingAllowoptionsToFfi(value.allowOptions);
  final _occupantsNumberHandle = (value.occupantsNumber);
  final _maxSpeedOnSegmentsHandle = heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentToFfi(value.maxSpeedOnSegments);
  final _ensureReachabilityHandle = booleanToFfi(value.ensureReachability);
  final _consumptionModelHandle = sdkRoutingEvconsumptionmodelToFfi(value.consumptionModel);
  final _batterySpecificationsHandle = sdkRoutingBatteryspecificationsToFfi(value.batterySpecifications);
  final _carSpecificationsHandle = sdkTransportCarspecificationsToFfi(value.carSpecifications);
  final _evMobilityServiceProviderPreferencesHandle = sdkRoutingEvmobilityserviceproviderpreferencesToFfi(value.evMobilityServiceProviderPreferences);
  final _result = _sdkRoutingEvcaroptionsCreateHandle(_routeOptionsHandle, _textOptionsHandle, _avoidanceOptionsHandle, _tollOptionsHandle, _allowOptionsHandle, _occupantsNumberHandle, _maxSpeedOnSegmentsHandle, _ensureReachabilityHandle, _consumptionModelHandle, _batterySpecificationsHandle, _carSpecificationsHandle, _evMobilityServiceProviderPreferencesHandle);
  sdkRoutingRouteoptionsReleaseFfiHandle(_routeOptionsHandle);
  sdkRoutingRoutetextoptionsReleaseFfiHandle(_textOptionsHandle);
  sdkRoutingAvoidanceoptionsReleaseFfiHandle(_avoidanceOptionsHandle);
  sdkRoutingTolloptionsReleaseFfiHandle(_tollOptionsHandle);
  sdkRoutingAllowoptionsReleaseFfiHandle(_allowOptionsHandle);
  
  heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentReleaseFfiHandle(_maxSpeedOnSegmentsHandle);
  booleanReleaseFfiHandle(_ensureReachabilityHandle);
  sdkRoutingEvconsumptionmodelReleaseFfiHandle(_consumptionModelHandle);
  sdkRoutingBatteryspecificationsReleaseFfiHandle(_batterySpecificationsHandle);
  sdkTransportCarspecificationsReleaseFfiHandle(_carSpecificationsHandle);
  sdkRoutingEvmobilityserviceproviderpreferencesReleaseFfiHandle(_evMobilityServiceProviderPreferencesHandle);
  return _result;
}

EVCarOptions sdkRoutingEvcaroptionsFromFfi(Pointer<Void> handle) {
  final _routeOptionsHandle = _sdkRoutingEvcaroptionsGetFieldrouteOptions(handle);
  final _textOptionsHandle = _sdkRoutingEvcaroptionsGetFieldtextOptions(handle);
  final _avoidanceOptionsHandle = _sdkRoutingEvcaroptionsGetFieldavoidanceOptions(handle);
  final _tollOptionsHandle = _sdkRoutingEvcaroptionsGetFieldtollOptions(handle);
  final _allowOptionsHandle = _sdkRoutingEvcaroptionsGetFieldallowOptions(handle);
  final _occupantsNumberHandle = _sdkRoutingEvcaroptionsGetFieldoccupantsNumber(handle);
  final _maxSpeedOnSegmentsHandle = _sdkRoutingEvcaroptionsGetFieldmaxSpeedOnSegments(handle);
  final _ensureReachabilityHandle = _sdkRoutingEvcaroptionsGetFieldensureReachability(handle);
  final _consumptionModelHandle = _sdkRoutingEvcaroptionsGetFieldconsumptionModel(handle);
  final _batterySpecificationsHandle = _sdkRoutingEvcaroptionsGetFieldbatterySpecifications(handle);
  final _carSpecificationsHandle = _sdkRoutingEvcaroptionsGetFieldcarSpecifications(handle);
  final _evMobilityServiceProviderPreferencesHandle = _sdkRoutingEvcaroptionsGetFieldevMobilityServiceProviderPreferences(handle);
  try {
    return EVCarOptions._(
      sdkRoutingRouteoptionsFromFfi(_routeOptionsHandle), 
      sdkRoutingRoutetextoptionsFromFfi(_textOptionsHandle), 
      sdkRoutingAvoidanceoptionsFromFfi(_avoidanceOptionsHandle), 
      sdkRoutingTolloptionsFromFfi(_tollOptionsHandle), 
      sdkRoutingAllowoptionsFromFfi(_allowOptionsHandle), 
      (_occupantsNumberHandle), 
      heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentFromFfi(_maxSpeedOnSegmentsHandle), 
      booleanFromFfi(_ensureReachabilityHandle), 
      sdkRoutingEvconsumptionmodelFromFfi(_consumptionModelHandle), 
      sdkRoutingBatteryspecificationsFromFfi(_batterySpecificationsHandle), 
      sdkTransportCarspecificationsFromFfi(_carSpecificationsHandle), 
      sdkRoutingEvmobilityserviceproviderpreferencesFromFfi(_evMobilityServiceProviderPreferencesHandle)
    );
  } finally {
    sdkRoutingRouteoptionsReleaseFfiHandle(_routeOptionsHandle);
    sdkRoutingRoutetextoptionsReleaseFfiHandle(_textOptionsHandle);
    sdkRoutingAvoidanceoptionsReleaseFfiHandle(_avoidanceOptionsHandle);
    sdkRoutingTolloptionsReleaseFfiHandle(_tollOptionsHandle);
    sdkRoutingAllowoptionsReleaseFfiHandle(_allowOptionsHandle);
    
    heresdkRoutingCommonBindingslistofSdkRoutingMaxspeedonsegmentReleaseFfiHandle(_maxSpeedOnSegmentsHandle);
    booleanReleaseFfiHandle(_ensureReachabilityHandle);
    sdkRoutingEvconsumptionmodelReleaseFfiHandle(_consumptionModelHandle);
    sdkRoutingBatteryspecificationsReleaseFfiHandle(_batterySpecificationsHandle);
    sdkTransportCarspecificationsReleaseFfiHandle(_carSpecificationsHandle);
    sdkRoutingEvmobilityserviceproviderpreferencesReleaseFfiHandle(_evMobilityServiceProviderPreferencesHandle);
  }
}

void sdkRoutingEvcaroptionsReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingEvcaroptionsReleaseHandle(handle);

// Nullable EVCarOptions

final _sdkRoutingEvcaroptionsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_create_handle_nullable'));
final _sdkRoutingEvcaroptionsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_release_handle_nullable'));
final _sdkRoutingEvcaroptionsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_EVCarOptions_get_value_nullable'));

Pointer<Void> sdkRoutingEvcaroptionsToFfiNullable(EVCarOptions? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingEvcaroptionsToFfi(value);
  final result = _sdkRoutingEvcaroptionsCreateHandleNullable(_handle);
  sdkRoutingEvcaroptionsReleaseFfiHandle(_handle);
  return result;
}

EVCarOptions? sdkRoutingEvcaroptionsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingEvcaroptionsGetValueNullable(handle);
  final result = sdkRoutingEvcaroptionsFromFfi(_handle);
  sdkRoutingEvcaroptionsReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingEvcaroptionsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingEvcaroptionsReleaseHandleNullable(handle);

// End of EVCarOptions "private" section.


