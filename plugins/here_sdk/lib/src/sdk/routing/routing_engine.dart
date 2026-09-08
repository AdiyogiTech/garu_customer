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
import 'package:here_sdk/src/generic_types__conversion.dart';
import 'package:here_sdk/src/sdk/core/engine/s_d_k_native_engine.dart';
import 'package:here_sdk/src/sdk/core/errors/instantiation_error_code.dart';
import 'package:here_sdk/src/sdk/core/errors/instantiation_exception.dart';
import 'package:here_sdk/src/sdk/core/location_impl.dart' as location_impl;
import 'package:here_sdk/src/sdk/core/threading/task_handle.dart';
import 'package:here_sdk/src/sdk/routing/bicycle_options.dart';
import 'package:here_sdk/src/sdk/routing/bus_options.dart';
import 'package:here_sdk/src/sdk/routing/calculate_route_callback.dart';
import 'package:here_sdk/src/sdk/routing/calculate_traffic_on_route_callback.dart';
import 'package:here_sdk/src/sdk/routing/car_options.dart';
import 'package:here_sdk/src/sdk/routing/e_v_car_options.dart';
import 'package:here_sdk/src/sdk/routing/e_v_truck_options.dart';
import 'package:here_sdk/src/sdk/routing/pedestrian_options.dart';
import 'package:here_sdk/src/sdk/routing/private_bus_options.dart';
import 'package:here_sdk/src/sdk/routing/refresh_route_options.dart';
import 'package:here_sdk/src/sdk/routing/route.dart';
import 'package:here_sdk/src/sdk/routing/route_handle.dart';
import 'package:here_sdk/src/sdk/routing/route_stop.dart';
import 'package:here_sdk/src/sdk/routing/routing_connection_settings.dart';
import 'package:here_sdk/src/sdk/routing/routing_error.dart';
import 'package:here_sdk/src/sdk/routing/routing_interface.dart';
import 'package:here_sdk/src/sdk/routing/scooter_options.dart';
import 'package:here_sdk/src/sdk/routing/taxi_options.dart';
import 'package:here_sdk/src/sdk/routing/truck_options.dart';
import 'package:here_sdk/src/sdk/routing/waypoint.dart';
import 'package:meta/meta.dart';

/// Use the RoutingEngine to calculate a route from A to B with
/// a number of waypoints in between.
///
/// Route calculation is done asynchronously and requires an
/// online connection. The resulting route contains various
/// information such as the polyline, route length in meters,
/// estimated time to traverse along the route and maneuver data.
///
/// **Note:** The engine does not support an unlimited number of waypoints.
/// The limit is defined by the HERE backend services and may change. For now,
/// the maximum number of waypoints should be below 200. This value may change
/// and it is not guaranteed to be stable. If you need to support very large lists
/// of waypoints, consider to import a route (see `importRoute()` method) or use
/// the `OfflineRoutingEngine` which supports an unlimited number of waypoints.
/// The `OfflineRoutingEngine` is only available for editions such as the
/// _Navigate Edition_.
abstract class RoutingEngine implements RoutingInterface {
  /// Creates a new instance of this class.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory RoutingEngine() => $prototype.$init();
  /// Creates a new instance of RoutingEngine.
  ///
  /// [sdkEngine] An SDKEngine instance.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory RoutingEngine.withSdkEngine(SDKNativeEngine sdkEngine) => $prototype.withSdkEngine(sdkEngine);
  /// Creates a new instance of RoutingEngine.
  ///
  /// [connectionSettings] Settings for the route calculation.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory RoutingEngine.withConnectionSettings(RoutingConnectionSettings connectionSettings) => $prototype.withConnectionSettings(connectionSettings);
  /// Creates a new instance of RoutingEngine.
  ///
  /// [sdkEngine] An SDKEngine instance.
  ///
  /// [connectionSettings] Settings for the route calculation.
  ///
  /// Throws [InstantiationException]. Indicates what went wrong when the instantiation was attempted.
  ///
  factory RoutingEngine.withSdkEngineAndConnectionSettings(SDKNativeEngine sdkEngine, RoutingConnectionSettings connectionSettings) => $prototype.withSdkEngineAndConnectionSettings(sdkEngine, connectionSettings);

  /// Asynchronously refreshes a route from the [RouteHandle] provided, i.e.
  ///
  /// refreshes a previously
  /// calculated route, with a new starting point and the specified [RefreshRouteOptions].
  ///
  /// An application may use this to update several options on-the-fly. It is not meant to re-calculate a route after
  /// a route deviation was detected, as in such cases the new starting point would lie too far away from the original
  /// route.
  ///
  /// [routeHandle] The route handle holding the route to be refreshed.
  ///
  /// [startingPoint] Updates the starting point of the route. It should be of type [WaypointType.stopover]. Otherwise,
  /// an [RoutingError.invalidParameter] error is generated. Moreover, it should be very close to the
  /// original route specified with the [RouteHandle]. Since the new starting point is expected to be
  /// along the original route, the original route geometry is used to reach the remaining waypoints. The new route
  /// will not include the [Waypoint] items that lie behind the new starting point (i.e. the path that
  /// was already travelled). Plus, [Route.lengthInMeters] and [Route.duration]
  /// values are from the new starting point to the destination. If the new waypoint is too far off the original
  /// route, the route refresh may fail and an [RoutingError.couldNotMatchOrigin] error is triggered.
  /// In that case, an application may decide to calculate a new route from scratch.
  ///
  /// [refreshRouteOptions] Options to refresh the route.
  ///
  /// [callback] Callback object that will be invoked after refreshing the route.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle refreshRoute(RouteHandle routeHandle, Waypoint startingPoint, RefreshRouteOptions refreshRouteOptions, CalculateRouteCallback callback);
  /// Asynchronously refreshes a route from the [RouteHandle] provided, i.e.
  ///
  /// refreshes a previously
  /// calculated route, with a new starting point and the specified [RefreshRouteOptions].
  ///
  /// An application may use this to update several options on-the-fly. It is not meant to re-calculate a route after
  /// a route deviation was detected, as in such cases the new starting point would lie too far away from the original
  /// route.
  ///
  /// [routeHandle] The route handle holding the route to be refreshed.
  ///
  /// [startingPoint] Updates the starting point of the route. It should be of type [WaypointType.stopover]. Otherwise,
  /// an [RoutingError.invalidParameter] error is generated. Moreover, it should be very close to the
  /// original route specified with the [RouteHandle]. Since the new starting point is expected to be
  /// along the original route, the original route geometry is used to reach the remaining waypoints. The new route
  /// will not include the [Waypoint] items that lie behind the new starting point (i.e. the path that
  /// was already travelled). Plus, [Route.lengthInMeters] and [Route.duration]
  /// values are from the new starting point to the destination. If the new waypoint is too far off the original
  /// route, the route refresh may fail and an [RoutingError.couldNotMatchOrigin] error is triggered.
  /// In that case, an application may decide to calculate a new route from scratch.
  ///
  /// [lastTraveledSectionIndex] Indicates the index of the last traveled route section. Traveled part of the route won't be reused.
  ///
  /// [traveledDistanceOnLastSectionInMeters] Offset in meter to the last visited position on the route section defined by the last traveled section index.
  ///
  /// [refreshRouteOptions] Options to refresh the route.
  ///
  /// [callback] Callback object that will be invoked after refreshing the route.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle refreshRouteWithTraveledDistance(RouteHandle routeHandle, Waypoint? startingPoint, int? lastTraveledSectionIndex, int? traveledDistanceOnLastSectionInMeters, RefreshRouteOptions refreshRouteOptions, CalculateRouteCallback callback);
  /// Asynchronously recreates a route from the [RouteHandle] provided, i.e.
  ///
  /// refreshes a previously
  /// calculated route, with the specified [RefreshRouteOptions].
  ///
  /// A route handle can be invalid when the map data changes that is used by the HERE backend to recreate the route. This happens regularly.
  /// Therefore, the route handle is not meant to be persisted for a longer time. Instead, a possible use case can be to plan a route with another HERE service.
  /// For example, a HERE REST API that allows to calculate a route on a desktop. Then this route can be transferred via the handle to a mobile device for further use with the HERE SDK.
  ///
  /// [routeHandle] The route handle holding the route to be refreshed.
  ///
  /// [refreshRouteOptions] Options to import the route from handle.
  ///
  /// [callback] Callback object that will be invoked after refreshing the route.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importRouteFromHandle(RouteHandle routeHandle, RefreshRouteOptions refreshRouteOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a car route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [carOptions] Options specific for car route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importCarRoute(List<location_impl.Location> locations, CarOptions carOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a pedestrian route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [pedestrianOptions] Options specific for pedestrian route calculation, along with
  /// common route options. Note that [OptimizationMode.shortest]
  /// is not supported for pedestrians and converted to
  /// [OptimizationMode.fastest] automatically.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importPedestrianRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, PedestrianOptions pedestrianOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a bicycle route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [bicycleOptions] Options specific for bicycle route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importBicycleRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, BicycleOptions bicycleOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a scooter route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [scooterOptions] Options specific for scooter route calculation, along with
  /// common route options. Note that [OptimizationMode.shortest]
  /// is not supported for scooters and converted to
  /// [OptimizationMode.fastest] automatically.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importScooterRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, ScooterOptions scooterOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a pedestrian route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [pedestrianOptions] Options specific for pedestrian route calculation, along with
  /// common route options. Note that [OptimizationMode.shortest]
  /// is not supported for pedestrians and converted to
  /// [OptimizationMode.fastest] automatically.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importPedestrianRoute(List<location_impl.Location> locations, PedestrianOptions pedestrianOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a bicycle route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [bicycleOptions] Options specific for bicycle route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importBicycleRoute(List<location_impl.Location> locations, BicycleOptions bicycleOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a scooter route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [scooterOptions] Options specific for scooter route calculation, along with
  /// common route options. Note that [OptimizationMode.shortest]
  /// is not supported for scooters and converted to
  /// [OptimizationMode.fastest] automatically.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importScooterRoute(List<location_impl.Location> locations, ScooterOptions scooterOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a truck route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [truckOptions] Options specific for truck route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importTruckRoute(List<location_impl.Location> locations, TruckOptions truckOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a taxi route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// **Note:** This is a beta release of this feature, so there could be a few bugs and unexpected behaviors.
  /// Related APIs may change for new releases without a deprecation process.
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [taxiOptions] Options specific for taxi route calculation, along with
  /// common route options. Note that [OptimizationMode.shortest]
  /// is not supported for taxis and converted to
  /// [OptimizationMode.fastest] automatically.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importTaxiRoute(List<location_impl.Location> locations, TaxiOptions taxiOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a bus route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [busOptions] Options specific for bus route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importBusRoute(List<location_impl.Location> locations, BusOptions busOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a private bus route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or anyway geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [privateBusOptions] Options specific for private bus route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importPrivateBusRoute(List<location_impl.Location> locations, PrivateBusOptions privateBusOptions, CalculateRouteCallback callback);
  /// Asynchronously creates an electric car route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [evCarOptions] Options specific for an electric car route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importEVCarRoute(List<location_impl.Location> locations, EVCarOptions evCarOptions, CalculateRouteCallback callback);
  /// Asynchronously creates an electric truck route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [evTruckOptions] Options specific for an electric truck route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importEVTruckRoute(List<location_impl.Location> locations, EVTruckOptions evTruckOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a car route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [carOptions] Options specific for car route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importCarRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, CarOptions carOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a truck route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [truckOptions] Options specific for truck route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importTruckRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, TruckOptions truckOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a taxi route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// **Note:** This is a beta release of this feature, so there could be a few bugs and unexpected behaviors.
  /// Related APIs may change for new releases without a deprecation process.
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [taxiOptions] Options specific for taxi route calculation, along with
  /// common route options. Note that [OptimizationMode.shortest]
  /// is not supported for taxis and converted to
  /// [OptimizationMode.fastest] automatically.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importTaxiRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, TaxiOptions taxiOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a bus route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [busOptions] Options specific for bus route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importBusRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, BusOptions busOptions, CalculateRouteCallback callback);
  /// Asynchronously creates a private bus route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or anyway geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [privateBusOptions] Options specific for private bus route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importPrivateBusRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, PrivateBusOptions privateBusOptions, CalculateRouteCallback callback);
  /// Asynchronously creates an electric car route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [evCarOptions] Options specific for an electric car route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importEVCarRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, EVCarOptions evCarOptions, CalculateRouteCallback callback);
  /// Asynchronously creates an electric truck route from a sequence of geographic coordinates very close to each other.
  ///
  /// The route shape will
  /// be kept as close as possible to the one provided. For best results please use 1Hz GPS data,
  /// or geographic coordinates that have a spacing of a few meters one from the other. For example, such a list of geographic coordinates can
  /// be extracted from a GPX trace or a route object from a 3rd party library. Very sparse data may be rejected by the service with an error.
  ///
  /// **Note:** Any restrictions applied to a transport type or provided options will be
  /// discarded and reported as violations in [Section.sectionNotices] .
  ///
  /// [locations] The list of locations used to calculate the route. Note that only the [Location.coordinates] of a location are used to import the route.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the location list
  /// size is not in the range \[2,50000\].
  ///
  /// [routeStops] The list of RouteStop's which contains index of location from locations list used for route stop and duration in seconds spent on stop.
  ///
  /// An [RoutingError.invalidParameter] error is generated when the route stops list
  /// size is not in the range \[1,locations.size()-2\], any of location_index is < 1 or location_indexes are not unique.
  ///
  /// [evTruckOptions] Options specific for an electric truck route calculation, along with
  /// common route options.
  ///
  /// [callback] Callback object that will be invoked after route calculation.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle importEVTruckRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, EVTruckOptions evTruckOptions, CalculateRouteCallback callback);
  /// Asynchronously calculates the traffic along a route starting from the index of the last
  /// traveled route section and an offset, in meters, from the last visited position on the
  /// section.
  ///
  /// [route] A [Route] calculated using the online routing engine. Its
  /// [RouteHandle] and the original route calculation options will be used to
  /// compute the traffic on the route. The original route remains untouched.
  ///
  /// [lastTraveledSectionIndex] Indicates the index of the last traveled route section. Traveled part of the route won't
  /// be reused.
  ///
  /// [traveledDistanceOnLastSectionInMeters] Offset, in meters, to the last visited position on the route section defined by the last
  /// traveled section index.
  ///
  /// [callback] Callback object that will be invoked after route traffic has been calculated.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle calculateTrafficOnRoute(Route route, int lastTraveledSectionIndex, int traveledDistanceOnLastSectionInMeters, CalculateTrafficOnRouteCallback callback);
  /// Asynchronously calculates the traffic along an EV car route starting from the index of the
  /// last traveled route section and an offset in meters from the last visited position on the
  /// section.
  ///
  /// The field [TrafficOnSpan.consumptionInKilowattHours] will contain the power consumption
  /// in kilowatt-hours (kWh) necessary to traverse the span, and
  /// [RoutePlace.chargeInKilowattHours], inside [TrafficOnSection.departurePlace] and
  /// [TrafficOnSection.arrivalPlace], the estimated battery charge in kilowatt-hours (kWh) when
  /// leaving/arriving to a section.
  /// **Note:** Only EV cars are supported.
  ///
  /// [route] A [Route] calculated using the online routing engine. Its
  /// [RouteHandle] and the original route calculation options, along with EV
  /// related information like [BatterySpecifications], will be used to
  /// compute the traffic on the route. The original route remains untouched.
  ///
  /// [lastTraveledSectionIndex] Indicates the index of the last traveled route section. Traveled part of the route won't
  /// be reused.
  ///
  /// [traveledDistanceOnLastSectionInMeters] Offset, in meters, to the last visited position on the route section defined by the last
  /// traveled section index.
  ///
  /// [currentChargeInKilowattHours] Charge level of the vehicle's battery at the current location (in kWh).
  /// It must be non-negative and less than or equal to the value of
  /// [BatterySpecifications.totalCapacityInKilowattHours],
  /// otherwise the [BatterySpecifications] instance is considered invalid.
  /// Sets [BatterySpecifications.initialChargeInKilowattHours] to the given value.
  ///
  /// [callback] Callback object that will be invoked after route traffic has been calculated.
  /// It is always invoked on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle calculateTrafficOnRouteWithCurrentCharge(Route route, int lastTraveledSectionIndex, int traveledDistanceOnLastSectionInMeters, double currentChargeInKilowattHours, CalculateTrafficOnRouteCallback callback);
  /// Sets a custom option for routing backend queries.
  ///
  /// The custom option is applied to all the queries that `RoutingEngine` performs.
  /// For a complete list of available parameter names and their valid values, refer to
  /// [HERE Routing API v8](https://www.here.com/docs/bundle/routing-api-v8-api-reference/page/index.html).
  /// **Note:** It's easy to set a wrong option that makes queries invalid,
  /// so make sure you read and understand the backend documentation.
  ///
  /// [name] An option name. If the engine already has an option with the same name, the option will be overwritten. The option name must be a non-empty string.
  /// The option name should't duplicate option names that SDK creates by itself for usage in the query,
  /// otherwise the routing calculation will callback with the error `RoutingError.INVALID_PARAMETER`.
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
  static dynamic $prototype = RoutingEngine$Impl(Pointer<Void>.fromAddress(0));
}


// RoutingEngine "private" section, not exported.

final _sdkRoutingRoutingengineRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_routing_RoutingEngine_register_finalizer'));
final _sdkRoutingRoutingengineCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_copy_handle'));
final _sdkRoutingRoutingengineReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_release_handle'));
final _sdkRoutingRoutingengineGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_get_type_id'));


final _$initsdkRoutingRoutingengineMakeReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make_return_release_handle'));
final _$initsdkRoutingRoutingengineMakeReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make_return_get_result'));
final _$initsdkRoutingRoutingengineMakeReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make_return_get_error'));
final _$initsdkRoutingRoutingengineMakeReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make_return_has_error'));


final _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_return_release_handle'));
final _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_return_get_result'));
final _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_return_get_error'));
final _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_return_has_error'));


final _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__RoutingConnectionSettings_return_release_handle'));
final _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__RoutingConnectionSettings_return_get_result'));
final _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__RoutingConnectionSettings_return_get_error'));
final _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__RoutingConnectionSettings_return_has_error'));


final _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_release_handle'));
final _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetResult = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_get_result'));
final _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_get_error'));
final _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnHasError = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings_return_has_error'));




























/// @nodoc
@visibleForTesting
class RoutingEngine$Impl extends __lib.NativeBase implements RoutingEngine {

  RoutingEngine$Impl(Pointer<Void> handle) : super(handle);


  RoutingEngine $init() {
    final _result_handle = _$init();
    final _result = RoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingRoutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  RoutingEngine withSdkEngine(SDKNativeEngine sdkEngine) {
    final _result_handle = _withSdkEngine(sdkEngine);
    final _result = RoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingRoutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  RoutingEngine withConnectionSettings(RoutingConnectionSettings connectionSettings) {
    final _result_handle = _withConnectionSettings(connectionSettings);
    final _result = RoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingRoutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }


  RoutingEngine withSdkEngineAndConnectionSettings(SDKNativeEngine sdkEngine, RoutingConnectionSettings connectionSettings) {
    final _result_handle = _withSdkEngineAndConnectionSettings(sdkEngine, connectionSettings);
    final _result = RoutingEngine$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkRoutingRoutingengineRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _$init() {
    final _$initFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_routing_RoutingEngine_make'));
    final __callResultHandle = _$initFfi(__lib.LibraryContext.isolateId);
    if (_$initsdkRoutingRoutingengineMakeReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _$initsdkRoutingRoutingengineMakeReturnGetError(__callResultHandle);
        _$initsdkRoutingRoutingengineMakeReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _$initsdkRoutingRoutingengineMakeReturnGetResult(__callResultHandle);
    _$initsdkRoutingRoutingengineMakeReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withSdkEngine(SDKNativeEngine sdkEngine) {
    final _withSdkEngineFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine'));
    final _sdkEngineHandle = sdkCoreEngineSdknativeengineToFfi(sdkEngine);
    final __callResultHandle = _withSdkEngineFfi(__lib.LibraryContext.isolateId, _sdkEngineHandle);
    sdkCoreEngineSdknativeengineReleaseFfiHandle(_sdkEngineHandle);
    if (_withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnGetError(__callResultHandle);
        _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnGetResult(__callResultHandle);
    _withSdkEnginesdkRoutingRoutingengineMakeSdknativeengineReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withConnectionSettings(RoutingConnectionSettings connectionSettings) {
    final _withConnectionSettingsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_make__RoutingConnectionSettings'));
    final _connectionSettingsHandle = sdkRoutingRoutingconnectionsettingsToFfi(connectionSettings);
    final __callResultHandle = _withConnectionSettingsFfi(__lib.LibraryContext.isolateId, _connectionSettingsHandle);
    sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(_connectionSettingsHandle);
    if (_withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnGetError(__callResultHandle);
        _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnGetResult(__callResultHandle);
    _withConnectionSettingssdkRoutingRoutingengineMakeRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  static Pointer<Void> _withSdkEngineAndConnectionSettings(SDKNativeEngine sdkEngine, RoutingConnectionSettings connectionSettings) {
    final _withSdkEngineAndConnectionSettingsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_make__SDKNativeEngine_RoutingConnectionSettings'));
    final _sdkEngineHandle = sdkCoreEngineSdknativeengineToFfi(sdkEngine);
    final _connectionSettingsHandle = sdkRoutingRoutingconnectionsettingsToFfi(connectionSettings);
    final __callResultHandle = _withSdkEngineAndConnectionSettingsFfi(__lib.LibraryContext.isolateId, _sdkEngineHandle, _connectionSettingsHandle);
    sdkCoreEngineSdknativeengineReleaseFfiHandle(_sdkEngineHandle);
    sdkRoutingRoutingconnectionsettingsReleaseFfiHandle(_connectionSettingsHandle);
    if (_withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnHasError(__callResultHandle) != 0) {
        final __errorHandle = _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetError(__callResultHandle);
        _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
        try {
          throw InstantiationException(sdkCoreErrorsInstantiationerrorcodeFromFfi(__errorHandle));
        } finally {
          sdkCoreErrorsInstantiationerrorcodeReleaseFfiHandle(__errorHandle);
        }
    }
    final __resultHandle = _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnGetResult(__callResultHandle);
    _withSdkEngineAndConnectionSettingssdkRoutingRoutingengineMakeSdknativeengineRoutingconnectionsettingsReturnReleaseHandle(__callResultHandle);
    return __resultHandle;
  }

  @override
  TaskHandle refreshRoute(RouteHandle routeHandle, Waypoint startingPoint, RefreshRouteOptions refreshRouteOptions, CalculateRouteCallback callback) {
    final _refreshRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_refreshRoute__RouteHandle_Waypoint_RefreshRouteOptions_CalculateRouteCallback'));
    final _routeHandleHandle = sdkRoutingRoutehandleToFfi(routeHandle);
    final _startingPointHandle = sdkRoutingWaypointToFfi(startingPoint);
    final _refreshRouteOptionsHandle = sdkRoutingRefreshrouteoptionsToFfi(refreshRouteOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _refreshRouteFfi(_handle, __lib.LibraryContext.isolateId, _routeHandleHandle, _startingPointHandle, _refreshRouteOptionsHandle, _callbackHandle);
    sdkRoutingRoutehandleReleaseFfiHandle(_routeHandleHandle);
    sdkRoutingWaypointReleaseFfiHandle(_startingPointHandle);
    sdkRoutingRefreshrouteoptionsReleaseFfiHandle(_refreshRouteOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle refreshRouteWithTraveledDistance(RouteHandle routeHandle, Waypoint? startingPoint, int? lastTraveledSectionIndex, int? traveledDistanceOnLastSectionInMeters, RefreshRouteOptions refreshRouteOptions, CalculateRouteCallback callback) {
    final _refreshRouteWithTraveledDistanceFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_refreshRoute__RouteHandle_Waypoint__Int__Int__RefreshRouteOptions_CalculateRouteCallback'));
    final _routeHandleHandle = sdkRoutingRoutehandleToFfi(routeHandle);
    final _startingPointHandle = sdkRoutingWaypointToFfiNullable(startingPoint);
    final _lastTraveledSectionIndexHandle = intToFfiNullable(lastTraveledSectionIndex);
    final _traveledDistanceOnLastSectionInMetersHandle = intToFfiNullable(traveledDistanceOnLastSectionInMeters);
    final _refreshRouteOptionsHandle = sdkRoutingRefreshrouteoptionsToFfi(refreshRouteOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _refreshRouteWithTraveledDistanceFfi(_handle, __lib.LibraryContext.isolateId, _routeHandleHandle, _startingPointHandle, _lastTraveledSectionIndexHandle, _traveledDistanceOnLastSectionInMetersHandle, _refreshRouteOptionsHandle, _callbackHandle);
    sdkRoutingRoutehandleReleaseFfiHandle(_routeHandleHandle);
    sdkRoutingWaypointReleaseFfiHandleNullable(_startingPointHandle);
    intReleaseFfiHandleNullable(_lastTraveledSectionIndexHandle);
    intReleaseFfiHandleNullable(_traveledDistanceOnLastSectionInMetersHandle);
    sdkRoutingRefreshrouteoptionsReleaseFfiHandle(_refreshRouteOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importRouteFromHandle(RouteHandle routeHandle, RefreshRouteOptions refreshRouteOptions, CalculateRouteCallback callback) {
    final _importRouteFromHandleFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__RouteHandle_RefreshRouteOptions_CalculateRouteCallback'));
    final _routeHandleHandle = sdkRoutingRoutehandleToFfi(routeHandle);
    final _refreshRouteOptionsHandle = sdkRoutingRefreshrouteoptionsToFfi(refreshRouteOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importRouteFromHandleFfi(_handle, __lib.LibraryContext.isolateId, _routeHandleHandle, _refreshRouteOptionsHandle, _callbackHandle);
    sdkRoutingRoutehandleReleaseFfiHandle(_routeHandleHandle);
    sdkRoutingRefreshrouteoptionsReleaseFfiHandle(_refreshRouteOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importCarRoute(List<location_impl.Location> locations, CarOptions carOptions, CalculateRouteCallback callback) {
    final _importCarRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_CarOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _carOptionsHandle = sdkRoutingCaroptionsToFfi(carOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importCarRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _carOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingCaroptionsReleaseFfiHandle(_carOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importPedestrianRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, PedestrianOptions pedestrianOptions, CalculateRouteCallback callback) {
    final _importPedestrianRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_PedestrianOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _pedestrianOptionsHandle = sdkRoutingPedestrianoptionsToFfi(pedestrianOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importPedestrianRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _pedestrianOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingPedestrianoptionsReleaseFfiHandle(_pedestrianOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importBicycleRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, BicycleOptions bicycleOptions, CalculateRouteCallback callback) {
    final _importBicycleRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_BicycleOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _bicycleOptionsHandle = sdkRoutingBicycleoptionsToFfi(bicycleOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importBicycleRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _bicycleOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingBicycleoptionsReleaseFfiHandle(_bicycleOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importScooterRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, ScooterOptions scooterOptions, CalculateRouteCallback callback) {
    final _importScooterRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_ScooterOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _scooterOptionsHandle = sdkRoutingScooteroptionsToFfi(scooterOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importScooterRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _scooterOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingScooteroptionsReleaseFfiHandle(_scooterOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importPedestrianRoute(List<location_impl.Location> locations, PedestrianOptions pedestrianOptions, CalculateRouteCallback callback) {
    final _importPedestrianRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_PedestrianOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _pedestrianOptionsHandle = sdkRoutingPedestrianoptionsToFfi(pedestrianOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importPedestrianRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _pedestrianOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingPedestrianoptionsReleaseFfiHandle(_pedestrianOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importBicycleRoute(List<location_impl.Location> locations, BicycleOptions bicycleOptions, CalculateRouteCallback callback) {
    final _importBicycleRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_BicycleOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _bicycleOptionsHandle = sdkRoutingBicycleoptionsToFfi(bicycleOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importBicycleRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _bicycleOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingBicycleoptionsReleaseFfiHandle(_bicycleOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importScooterRoute(List<location_impl.Location> locations, ScooterOptions scooterOptions, CalculateRouteCallback callback) {
    final _importScooterRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ScooterOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _scooterOptionsHandle = sdkRoutingScooteroptionsToFfi(scooterOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importScooterRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _scooterOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingScooteroptionsReleaseFfiHandle(_scooterOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importTruckRoute(List<location_impl.Location> locations, TruckOptions truckOptions, CalculateRouteCallback callback) {
    final _importTruckRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_TruckOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _truckOptionsHandle = sdkRoutingTruckoptionsToFfi(truckOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importTruckRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _truckOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingTruckoptionsReleaseFfiHandle(_truckOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importTaxiRoute(List<location_impl.Location> locations, TaxiOptions taxiOptions, CalculateRouteCallback callback) {
    final _importTaxiRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_TaxiOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _taxiOptionsHandle = sdkRoutingTaxioptionsToFfi(taxiOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importTaxiRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _taxiOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingTaxioptionsReleaseFfiHandle(_taxiOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importBusRoute(List<location_impl.Location> locations, BusOptions busOptions, CalculateRouteCallback callback) {
    final _importBusRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_BusOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _busOptionsHandle = sdkRoutingBusoptionsToFfi(busOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importBusRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _busOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingBusoptionsReleaseFfiHandle(_busOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importPrivateBusRoute(List<location_impl.Location> locations, PrivateBusOptions privateBusOptions, CalculateRouteCallback callback) {
    final _importPrivateBusRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_PrivateBusOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _privateBusOptionsHandle = sdkRoutingPrivatebusoptionsToFfi(privateBusOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importPrivateBusRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _privateBusOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingPrivatebusoptionsReleaseFfiHandle(_privateBusOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importEVCarRoute(List<location_impl.Location> locations, EVCarOptions evCarOptions, CalculateRouteCallback callback) {
    final _importEVCarRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_EVCarOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _evCarOptionsHandle = sdkRoutingEvcaroptionsToFfi(evCarOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importEVCarRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _evCarOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingEvcaroptionsReleaseFfiHandle(_evCarOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importEVTruckRoute(List<location_impl.Location> locations, EVTruckOptions evTruckOptions, CalculateRouteCallback callback) {
    final _importEVTruckRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_EVTruckOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _evTruckOptionsHandle = sdkRoutingEvtruckoptionsToFfi(evTruckOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importEVTruckRouteFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _evTruckOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    sdkRoutingEvtruckoptionsReleaseFfiHandle(_evTruckOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importCarRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, CarOptions carOptions, CalculateRouteCallback callback) {
    final _importCarRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_CarOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _carOptionsHandle = sdkRoutingCaroptionsToFfi(carOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importCarRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _carOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingCaroptionsReleaseFfiHandle(_carOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importTruckRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, TruckOptions truckOptions, CalculateRouteCallback callback) {
    final _importTruckRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_TruckOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _truckOptionsHandle = sdkRoutingTruckoptionsToFfi(truckOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importTruckRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _truckOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingTruckoptionsReleaseFfiHandle(_truckOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importTaxiRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, TaxiOptions taxiOptions, CalculateRouteCallback callback) {
    final _importTaxiRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_TaxiOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _taxiOptionsHandle = sdkRoutingTaxioptionsToFfi(taxiOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importTaxiRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _taxiOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingTaxioptionsReleaseFfiHandle(_taxiOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importBusRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, BusOptions busOptions, CalculateRouteCallback callback) {
    final _importBusRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_BusOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _busOptionsHandle = sdkRoutingBusoptionsToFfi(busOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importBusRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _busOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingBusoptionsReleaseFfiHandle(_busOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importPrivateBusRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, PrivateBusOptions privateBusOptions, CalculateRouteCallback callback) {
    final _importPrivateBusRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_PrivateBusOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _privateBusOptionsHandle = sdkRoutingPrivatebusoptionsToFfi(privateBusOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importPrivateBusRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _privateBusOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingPrivatebusoptionsReleaseFfiHandle(_privateBusOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importEVCarRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, EVCarOptions evCarOptions, CalculateRouteCallback callback) {
    final _importEVCarRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_EVCarOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _evCarOptionsHandle = sdkRoutingEvcaroptionsToFfi(evCarOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importEVCarRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _evCarOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingEvcaroptionsReleaseFfiHandle(_evCarOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle importEVTruckRouteWithStops(List<location_impl.Location> locations, List<RouteStop> routeStops, EVTruckOptions evTruckOptions, CalculateRouteCallback callback) {
    final _importEVTruckRouteWithStopsFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_importRoute__ListOf_sdk_core_Location_ListOf_sdk_routing_RouteStop_EVTruckOptions_CalculateRouteCallback'));
    final _locationsHandle = heresdkRoutingBindingslistofSdkCoreLocationToFfi(locations);
    final _routeStopsHandle = heresdkRoutingBindingslistofSdkRoutingRoutestopToFfi(routeStops);
    final _evTruckOptionsHandle = sdkRoutingEvtruckoptionsToFfi(evTruckOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _importEVTruckRouteWithStopsFfi(_handle, __lib.LibraryContext.isolateId, _locationsHandle, _routeStopsHandle, _evTruckOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkCoreLocationReleaseFfiHandle(_locationsHandle);
    heresdkRoutingBindingslistofSdkRoutingRoutestopReleaseFfiHandle(_routeStopsHandle);
    sdkRoutingEvtruckoptionsReleaseFfiHandle(_evTruckOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateTrafficOnRoute(Route route, int lastTraveledSectionIndex, int traveledDistanceOnLastSectionInMeters, CalculateTrafficOnRouteCallback callback) {
    final _calculateTrafficOnRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Int32, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, int, int, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateTrafficOnRoute__Route_Int_Int_CalculateTrafficOnRouteCallback'));
    final _routeHandle = sdkRoutingRouteToFfi(route);
    final _lastTraveledSectionIndexHandle = (lastTraveledSectionIndex);
    final _traveledDistanceOnLastSectionInMetersHandle = (traveledDistanceOnLastSectionInMeters);
    final _callbackHandle = sdkRoutingCalculatetrafficonroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateTrafficOnRouteFfi(_handle, __lib.LibraryContext.isolateId, _routeHandle, _lastTraveledSectionIndexHandle, _traveledDistanceOnLastSectionInMetersHandle, _callbackHandle);
    sdkRoutingRouteReleaseFfiHandle(_routeHandle);


    sdkRoutingCalculatetrafficonroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateTrafficOnRouteWithCurrentCharge(Route route, int lastTraveledSectionIndex, int traveledDistanceOnLastSectionInMeters, double currentChargeInKilowattHours, CalculateTrafficOnRouteCallback callback) {
    final _calculateTrafficOnRouteWithCurrentChargeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Int32, Int32, Double, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, int, int, double, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateTrafficOnRoute__Route_Int_Int_Double_CalculateTrafficOnRouteCallback'));
    final _routeHandle = sdkRoutingRouteToFfi(route);
    final _lastTraveledSectionIndexHandle = (lastTraveledSectionIndex);
    final _traveledDistanceOnLastSectionInMetersHandle = (traveledDistanceOnLastSectionInMeters);
    final _currentChargeInKilowattHoursHandle = (currentChargeInKilowattHours);
    final _callbackHandle = sdkRoutingCalculatetrafficonroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateTrafficOnRouteWithCurrentChargeFfi(_handle, __lib.LibraryContext.isolateId, _routeHandle, _lastTraveledSectionIndexHandle, _traveledDistanceOnLastSectionInMetersHandle, _currentChargeInKilowattHoursHandle, _callbackHandle);
    sdkRoutingRouteReleaseFfiHandle(_routeHandle);



    sdkRoutingCalculatetrafficonroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  RoutingError? setCustomOption(String name, String? value) {
    final _setCustomOptionFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_setCustomOption__String_String_'));
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

  @override
  TaskHandle calculateCarRoute(List<Waypoint> waypoints, CarOptions carOptions, CalculateRouteCallback callback) {
    final _calculateCarRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_CarOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _carOptionsHandle = sdkRoutingCaroptionsToFfi(carOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateCarRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _carOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingCaroptionsReleaseFfiHandle(_carOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculatePedestrianRoute(List<Waypoint> waypoints, PedestrianOptions pedestrianOptions, CalculateRouteCallback callback) {
    final _calculatePedestrianRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_PedestrianOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _pedestrianOptionsHandle = sdkRoutingPedestrianoptionsToFfi(pedestrianOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculatePedestrianRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _pedestrianOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingPedestrianoptionsReleaseFfiHandle(_pedestrianOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateTruckRoute(List<Waypoint> waypoints, TruckOptions truckOptions, CalculateRouteCallback callback) {
    final _calculateTruckRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_TruckOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _truckOptionsHandle = sdkRoutingTruckoptionsToFfi(truckOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateTruckRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _truckOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingTruckoptionsReleaseFfiHandle(_truckOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateScooterRoute(List<Waypoint> waypoints, ScooterOptions scooterOptions, CalculateRouteCallback callback) {
    final _calculateScooterRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_ScooterOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _scooterOptionsHandle = sdkRoutingScooteroptionsToFfi(scooterOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateScooterRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _scooterOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingScooteroptionsReleaseFfiHandle(_scooterOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateBicycleRoute(List<Waypoint> waypoints, BicycleOptions bicycleOptions, CalculateRouteCallback callback) {
    final _calculateBicycleRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_BicycleOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _bicycleOptionsHandle = sdkRoutingBicycleoptionsToFfi(bicycleOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateBicycleRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _bicycleOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingBicycleoptionsReleaseFfiHandle(_bicycleOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateTaxiRoute(List<Waypoint> waypoints, TaxiOptions taxiOptions, CalculateRouteCallback callback) {
    final _calculateTaxiRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_TaxiOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _taxiOptionsHandle = sdkRoutingTaxioptionsToFfi(taxiOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateTaxiRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _taxiOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingTaxioptionsReleaseFfiHandle(_taxiOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateEVCarRoute(List<Waypoint> waypoints, EVCarOptions evCarOptions, CalculateRouteCallback callback) {
    final _calculateEVCarRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_EVCarOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _evCarOptionsHandle = sdkRoutingEvcaroptionsToFfi(evCarOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateEVCarRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _evCarOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingEvcaroptionsReleaseFfiHandle(_evCarOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateEVTruckRoute(List<Waypoint> waypoints, EVTruckOptions evTruckOptions, CalculateRouteCallback callback) {
    final _calculateEVTruckRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_EVTruckOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _evTruckOptionsHandle = sdkRoutingEvtruckoptionsToFfi(evTruckOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateEVTruckRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _evTruckOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingEvtruckoptionsReleaseFfiHandle(_evTruckOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculateBusRoute(List<Waypoint> waypoints, BusOptions busOptions, CalculateRouteCallback callback) {
    final _calculateBusRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_BusOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _busOptionsHandle = sdkRoutingBusoptionsToFfi(busOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculateBusRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _busOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingBusoptionsReleaseFfiHandle(_busOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle calculatePrivateBusRoute(List<Waypoint> waypoints, PrivateBusOptions privateBusOptions, CalculateRouteCallback callback) {
    final _calculatePrivateBusRouteFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_calculateRoute__ListOf_sdk_routing_Waypoint_PrivateBusOptions_CalculateRouteCallback'));
    final _waypointsHandle = heresdkRoutingBindingslistofSdkRoutingWaypointToFfi(waypoints);
    final _privateBusOptionsHandle = sdkRoutingPrivatebusoptionsToFfi(privateBusOptions);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _calculatePrivateBusRouteFfi(_handle, __lib.LibraryContext.isolateId, _waypointsHandle, _privateBusOptionsHandle, _callbackHandle);
    heresdkRoutingBindingslistofSdkRoutingWaypointReleaseFfiHandle(_waypointsHandle);
    sdkRoutingPrivatebusoptionsReleaseFfiHandle(_privateBusOptionsHandle);
    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle returnToRouteWithTraveledDistance(Route route, Waypoint startingPoint, int lastTraveledSectionIndex, int traveledDistanceOnLastSectionInMeters, CalculateRouteCallback callback) {
    final _returnToRouteWithTraveledDistanceFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Int32, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, int, int, Pointer<Void>)>('here_sdk_sdk_routing_RoutingEngine_returnToRoute__Route_Waypoint_Int_Int_CalculateRouteCallback'));
    final _routeHandle = sdkRoutingRouteToFfi(route);
    final _startingPointHandle = sdkRoutingWaypointToFfi(startingPoint);
    final _lastTraveledSectionIndexHandle = (lastTraveledSectionIndex);
    final _traveledDistanceOnLastSectionInMetersHandle = (traveledDistanceOnLastSectionInMeters);
    final _callbackHandle = sdkRoutingCalculateroutecallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _returnToRouteWithTraveledDistanceFfi(_handle, __lib.LibraryContext.isolateId, _routeHandle, _startingPointHandle, _lastTraveledSectionIndexHandle, _traveledDistanceOnLastSectionInMetersHandle, _callbackHandle);
    sdkRoutingRouteReleaseFfiHandle(_routeHandle);
    sdkRoutingWaypointReleaseFfiHandle(_startingPointHandle);


    sdkRoutingCalculateroutecallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkRoutingRoutingengineToFfi(RoutingEngine value) =>
  _sdkRoutingRoutingengineCopyHandle((value as __lib.NativeBase).handle);

RoutingEngine sdkRoutingRoutingengineFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is RoutingEngine) return instance;

  final _typeIdHandle = _sdkRoutingRoutingengineGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkRoutingRoutingengineCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : RoutingEngine$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkRoutingRoutingengineRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkRoutingRoutingengineReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkRoutingRoutingengineReleaseHandle(handle);

Pointer<Void> sdkRoutingRoutingengineToFfiNullable(RoutingEngine? value) =>
  value != null ? sdkRoutingRoutingengineToFfi(value) : Pointer<Void>.fromAddress(0);

RoutingEngine? sdkRoutingRoutingengineFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkRoutingRoutingengineFromFfi(handle) : null;

void sdkRoutingRoutingengineReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingRoutingengineReleaseHandle(handle);

// End of RoutingEngine "private" section.


