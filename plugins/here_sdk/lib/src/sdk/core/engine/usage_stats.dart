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
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:here_sdk/src/generic_types__conversion.dart';

/// A class that gathers statistics of the HERE SDK network usage for uploaded and downloaded data.
///
/// **Note:** This is a beta release of this feature, so there could be a few bugs and unexpected behaviors.
/// Related APIs may change for new releases without a deprecation process.

class UsageStats {
  /// Provides network statistics.
  List<UsageStatsNetworkStats> networkStats;

  /// Represents the HERE SDK feature associated with the gathered usage statistics.
  UsageStatsFeature feature;

  /// Creates a new instance.

  /// [networkStats] Provides network statistics.

  /// [feature] Represents the HERE SDK feature associated with the gathered usage statistics.

  UsageStats(this.networkStats, this.feature);
}

/// Represents the feature enum associated with the gathered usage stats.
enum UsageStatsFeature {
    /// Represents network traffic statistics for online usage corresponding to the
    /// [LayerConfigurationFeature.detailRendering] layer configuration.
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   Note that you can enable or disable this feature by calling:
    ///   `LayerConfiguration.enabledFeatures(..) or LayerConfiguration.implicitlyPrefetchedFeatures()`.
    detailedRendering,
    /// Represents network traffic statistics for online usage corresponding to the
    /// "ev_charging_station_rendering_premium" layer group, enabled with [LayerConfigurationFeature.ev].
    /// Note, that [LayerConfigurationFeature.ev] also enables "ev_charging_station_search_premium" layer group,
    /// which is represented with [UsageStats.Feature.EV_SEARCH].
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   As of now, this layer cannot be turned off.
    evRendering,
    /// Represents network traffic statistics for online usage corresponding to the
    /// "ev_charging_station_search_premium" layer group, enabled with [LayerConfigurationFeature.ev].
    /// Note, that [LayerConfigurationFeature.ev] also enables "ev_charging_station_rendering_premium" layer group,
    /// which is represented with [UsageStats.Feature.EV_RENDERING].
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   As of now, this layer cannot be turned off.
    evSearch,
    /// Represents network traffic statistics for online usage corresponding to the "adas", "ehorizon", "interop", "isa" OCM layers.
    /// In addition, it is also tracking the following layer configurations:
    /// - [LayerConfigurationFeature.navigation]
    /// - [LayerConfigurationFeature.junctionView3x4]
    /// - [LayerConfigurationFeature.junctionView16x9]
    /// - [LayerConfigurationFeature.junctionSign3x4]
    /// - [LayerConfigurationFeature.junctionSign3x5]
    /// - [LayerConfigurationFeature.junctionSign4x3]
    /// - [LayerConfigurationFeature.junctionSign5x3]
    /// - [LayerConfigurationFeature.junctionSign16x9]
    ///   Counted when data for the corresponding layer is requested by the application
    ///   by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    /// - Using online navigation when the requested data is not cached, prefetched, or installed before.
    ///   As of now, the above listed OCM layers cannot be turned off except for those that are exposed as layer configuration.
    navigation,
    /// Represents network traffic statistics for places search.
    /// This is legacy statistic which is now replaced by [UsageStatsFeature.searchOnline].
    places,
    /// Represents network traffic statistics for online usage corresponding to the
    /// [LayerConfigurationFeature.traffic] layer configuration.
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   Note that you can enable or disable this feature by calling:
    ///   `LayerConfiguration.enabledFeatures(..) or LayerConfiguration.implicitlyPrefetchedFeatures()`.
    rdsTraffic,
    /// Represents network traffic statistics for online usage corresponding to the
    /// [LayerConfigurationFeature.rendering] layer configuration.
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   Note that you can enable or disable this feature by calling:
    ///   `LayerConfiguration.enabledFeatures(..) or LayerConfiguration.implicitlyPrefetchedFeatures()`.
    rendering,
    /// Represents network traffic statistics for online usage corresponding to the
    /// `RoutingEngine`.
    /// Includes the following transaction counts and APIs:
    /// - **Routing Car, Bicycle, Pedestrian** with HRN `hrn:here:service::olp-here:routing-8:base` counted with the use of
    ///   `RoutingEngine with CarOptions,BicycleOptions or PedestrianOptions`.
    /// - **Routing Scooter** with HRN `hrn:here:service::olp-here:routing-8:scooter` counted with the use of `RoutingEngine with ScooterOptions`
    /// - **Routing Taxi** with HRN `hrn:here:service::olp-here:routing-8:taxi` counted with the use of `RoutingEngine with TaxiOptions`
    /// - **Routing Truck** with HRN `hrn:here:service::olp-here:routing-8:truck` counted with the use of `RoutingEngine with TruckOptions`
    /// - **Time-Aware Routing** with HRN `hrn:here:service::olp-here:routing-8:traffic` counted with the use of
    ///   `RouteOptions with arrivalTime or departureTime`
    /// - **Routing EV** with HRN `hrn:here:service::olp-here:routing-8:ev` counted with the use of `RoutingEngine with EVTRuckOptions
    ///   or EVCarOptions and evCarOptions.ensureReachability = true.`
    /// - **Route Import** with HRN `hrn:here:service::olp-here:routing-8:import` counted with the use of `RoutingEngine.importRoutes(...)`
    /// - **Toll Cost** with HRN `hrn:here:service::olp-here:routing-8:tolls` counted with the use of `RoutingEngine with RouteOptions.enableTolls`
    /// - **Routing Bus** with HRN `hrn:here:service::olp-here:routing-8:bus` counted with the use of `RoutingEngine with BusOptions`
    /// - **Isoline Routing** with HRN `hrn:here:service::olp-here:isoline-routing-8` counted with the use of `RoutingEngine with IsolineOptions`
    router,
    /// Represents network traffic statistics for online usage corresponding to the
    /// following layer configurations:
    /// - [LayerConfigurationFeature.offlineRouting]
    /// - [LayerConfigurationFeature.offlineBusRouting]
    ///   Counted when data for the corresponding layer is requested by the application
    ///   by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   Note that you can enable or disable this feature by calling:
    ///   `LayerConfiguration.enabledFeatures(..) or LayerConfiguration.implicitlyPrefetchedFeatures()`.
    routing,
    /// Represents network traffic statistics to show satellite map scheme.
    /// This includes a **Raster Tile Base** transaction count with HRN `hrn:here:service::olp-here:rendering-raster-tiles-3:base`.
    satellites,
    /// Represents network traffic statistics for online usage corresponding to the
    /// "search", "ev_charging_station_search_premium", "fueling_station_premium" OCM layers.
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   As of now, these layers cannot be turned off.
    search,
    /// Represents network traffic statistics for online usage corresponding to the `SearchEngine`.
    /// Includes the following transaction counts and APIs:
    /// - **Discover/Search** with HRN `hrn:here:service::olp-here:search-opensearch-1` counted with the use of `SearchEngine textquery search`
    /// - **Geocode & Reverse Geocode** with HRN `hrn:here:service::olp-here:geocode-7` counted with the use of `SearchEngine addressQuery &
    ///   GeoCoordinates search`
    /// - **Autosuggest** with HRN `hrn:here:service::olp-here:search-autosuggest-7` counted with the use of `SearchEngine suggest`
    searchOnline,
    /// Represents network traffic statistics for online usage corresponding to the
    /// "transit" OCM layer.
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   As of now, this layer cannot be turned off.
    transit,
    /// Represents network traffic statistics for online usage corresponding to the `TransitRoutingEngine`.
    /// This includes a **Public Transit** transaction count with HRN: `hrn:here:service::olp-here:transit-8`.
    transitRoutingEngine,
    /// Represents network traffic statistics for online usage corresponding to the
    /// calls of `TrafficEngine`. All calls to `TrafficEngine` result in transaction counts for
    /// HRN `hrn:here:service::olp-here:traffic-api-7:standard`.
    traffic,
    /// Represents network traffic statistics for traffic vector tiles.
    /// This includes a **Traffic vector tile** transaction count with HRN: `hrn:here:service::olp-here:traffic-vector-tiles-2`.
    trafficVectorTiles,
    /// Represents network traffic statistics for online usage corresponding to the
    /// [LayerConfigurationFeature.truck] layer configuration.
    /// Counted when data for the corresponding layer is requested by the application
    /// by performing one of the following actions:
    /// - Pan the map view to areas that have not been cached, prefetched or installed before.
    /// - Use `MapDownloader` to download and install a `Region`.
    /// - Prefetch map data into the map cache with the `RoutePrefetcher` for areas that
    ///   have not been cached, prefetched or installed before.
    ///   Note that you can enable or disable this feature by calling:
    ///   `LayerConfiguration.enabledFeatures(..) or LayerConfiguration.implicitlyPrefetchedFeatures()`.
    truck,
    /// Represents network traffic statistics for online usage corresponding to the vector tiles.
    /// This includes a **Vector tile** transaction count with HRN: `hrn:here:service::olp-here:rendering-vector-tiles-2`.
    /// This statistic is only counted for the _Explore_ edition when showing the map view.
    vectorTiles,
    /// Represents network traffic statistics for feature that doesn't fit into other categories.
    /// Some examples include:
    /// - Authentication
    /// - Analytics
    /// - Any feature not mapped in the existing list.
    other,
    /// Represents network traffic statistics for Here Positioning.
    /// This includes a **Network Positioning** transaction count with HRN `hrn:here:service::olp-here:positioning-2`.
    positioning
}

// UsageStatsFeature "private" section, not exported.

int sdkCoreEngineUsagestatsFeatureToFfi(UsageStatsFeature value) {
  switch (value) {
  case UsageStatsFeature.detailedRendering:
    return 0;
  case UsageStatsFeature.evRendering:
    return 1;
  case UsageStatsFeature.evSearch:
    return 2;
  case UsageStatsFeature.navigation:
    return 3;
  case UsageStatsFeature.places:
    return 4;
  case UsageStatsFeature.rdsTraffic:
    return 5;
  case UsageStatsFeature.rendering:
    return 6;
  case UsageStatsFeature.router:
    return 7;
  case UsageStatsFeature.routing:
    return 8;
  case UsageStatsFeature.satellites:
    return 9;
  case UsageStatsFeature.search:
    return 10;
  case UsageStatsFeature.searchOnline:
    return 11;
  case UsageStatsFeature.transit:
    return 12;
  case UsageStatsFeature.transitRoutingEngine:
    return 13;
  case UsageStatsFeature.traffic:
    return 14;
  case UsageStatsFeature.trafficVectorTiles:
    return 15;
  case UsageStatsFeature.truck:
    return 16;
  case UsageStatsFeature.vectorTiles:
    return 17;
  case UsageStatsFeature.other:
    return 18;
  case UsageStatsFeature.positioning:
    return 19;
  default:
    throw StateError("Invalid enum value $value for UsageStatsFeature enum.");
  }
}

UsageStatsFeature sdkCoreEngineUsagestatsFeatureFromFfi(int handle) {
  switch (handle) {
  case 0:
    return UsageStatsFeature.detailedRendering;
  case 1:
    return UsageStatsFeature.evRendering;
  case 2:
    return UsageStatsFeature.evSearch;
  case 3:
    return UsageStatsFeature.navigation;
  case 4:
    return UsageStatsFeature.places;
  case 5:
    return UsageStatsFeature.rdsTraffic;
  case 6:
    return UsageStatsFeature.rendering;
  case 7:
    return UsageStatsFeature.router;
  case 8:
    return UsageStatsFeature.routing;
  case 9:
    return UsageStatsFeature.satellites;
  case 10:
    return UsageStatsFeature.search;
  case 11:
    return UsageStatsFeature.searchOnline;
  case 12:
    return UsageStatsFeature.transit;
  case 13:
    return UsageStatsFeature.transitRoutingEngine;
  case 14:
    return UsageStatsFeature.traffic;
  case 15:
    return UsageStatsFeature.trafficVectorTiles;
  case 16:
    return UsageStatsFeature.truck;
  case 17:
    return UsageStatsFeature.vectorTiles;
  case 18:
    return UsageStatsFeature.other;
  case 19:
    return UsageStatsFeature.positioning;
  default:
    throw StateError("Invalid numeric value $handle for UsageStatsFeature enum.");
  }
}

void sdkCoreEngineUsagestatsFeatureReleaseFfiHandle(int handle) {}

final _sdkCoreEngineUsagestatsFeatureCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_core_engine_UsageStats_Feature_create_handle_nullable'));
final _sdkCoreEngineUsagestatsFeatureReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_Feature_release_handle_nullable'));
final _sdkCoreEngineUsagestatsFeatureGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_Feature_get_value_nullable'));

Pointer<Void> sdkCoreEngineUsagestatsFeatureToFfiNullable(UsageStatsFeature? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkCoreEngineUsagestatsFeatureToFfi(value);
  final result = _sdkCoreEngineUsagestatsFeatureCreateHandleNullable(_handle);
  sdkCoreEngineUsagestatsFeatureReleaseFfiHandle(_handle);
  return result;
}

UsageStatsFeature? sdkCoreEngineUsagestatsFeatureFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkCoreEngineUsagestatsFeatureGetValueNullable(handle);
  final result = sdkCoreEngineUsagestatsFeatureFromFfi(_handle);
  sdkCoreEngineUsagestatsFeatureReleaseFfiHandle(_handle);
  return result;
}

void sdkCoreEngineUsagestatsFeatureReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreEngineUsagestatsFeatureReleaseHandleNullable(handle);

// End of UsageStatsFeature "private" section.
/// Provides network statistics in bytes per method.

class UsageStatsNetworkStats {
  /// Number of bytes sent over the network.
  int sentBytes;

  /// Number of bytes received from the network.
  int receivedBytes;

  /// Name or description of the method being called.
  String methodCall;

  /// Amount of calls for particular family of methodCall.
  /// methodCall in this case is considered as base request,
  /// additional query params are ignored, all calculated as one request.
  /// e.g. https://search.hereapi.com/someparams and https://search.hereapi.com/someparams2
  /// will be considered as 1 methodCall, and requestCounter is 2.
  int requestCounter;

  /// Creates a new instance.

  /// [sentBytes] Number of bytes sent over the network.

  /// [receivedBytes] Number of bytes received from the network.

  /// [methodCall] Name or description of the method being called.

  /// [requestCounter] Amount of calls for particular family of methodCall.
  /// methodCall in this case is considered as base request,
  /// additional query params are ignored, all calculated as one request.
  /// e.g. https://search.hereapi.com/someparams and https://search.hereapi.com/someparams2
  /// will be considered as 1 methodCall, and requestCounter is 2.

  UsageStatsNetworkStats(this.sentBytes, this.receivedBytes, this.methodCall, this.requestCounter);
}


// UsageStatsNetworkStats "private" section, not exported.

final _sdkCoreEngineUsagestatsNetworkstatsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Uint64, Pointer<Void>, Uint32),
    Pointer<Void> Function(int, int, Pointer<Void>, int)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_create_handle'));
final _sdkCoreEngineUsagestatsNetworkstatsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_release_handle'));
final _sdkCoreEngineUsagestatsNetworkstatsGetFieldsentBytes = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_get_field_sentBytes'));
final _sdkCoreEngineUsagestatsNetworkstatsGetFieldreceivedBytes = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_get_field_receivedBytes'));
final _sdkCoreEngineUsagestatsNetworkstatsGetFieldmethodCall = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_get_field_methodCall'));
final _sdkCoreEngineUsagestatsNetworkstatsGetFieldrequestCounter = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_get_field_requestCounter'));



Pointer<Void> sdkCoreEngineUsagestatsNetworkstatsToFfi(UsageStatsNetworkStats value) {
  final _sentBytesHandle = (value.sentBytes);
  final _receivedBytesHandle = (value.receivedBytes);
  final _methodCallHandle = stringToFfi(value.methodCall);
  final _requestCounterHandle = (value.requestCounter);
  final _result = _sdkCoreEngineUsagestatsNetworkstatsCreateHandle(_sentBytesHandle, _receivedBytesHandle, _methodCallHandle, _requestCounterHandle);
  
  
  stringReleaseFfiHandle(_methodCallHandle);
  
  return _result;
}

UsageStatsNetworkStats sdkCoreEngineUsagestatsNetworkstatsFromFfi(Pointer<Void> handle) {
  final _sentBytesHandle = _sdkCoreEngineUsagestatsNetworkstatsGetFieldsentBytes(handle);
  final _receivedBytesHandle = _sdkCoreEngineUsagestatsNetworkstatsGetFieldreceivedBytes(handle);
  final _methodCallHandle = _sdkCoreEngineUsagestatsNetworkstatsGetFieldmethodCall(handle);
  final _requestCounterHandle = _sdkCoreEngineUsagestatsNetworkstatsGetFieldrequestCounter(handle);
  try {
    return UsageStatsNetworkStats(
      (_sentBytesHandle), 
      (_receivedBytesHandle), 
      stringFromFfi(_methodCallHandle), 
      (_requestCounterHandle)
    );
  } finally {
    
    
    stringReleaseFfiHandle(_methodCallHandle);
    
  }
}

void sdkCoreEngineUsagestatsNetworkstatsReleaseFfiHandle(Pointer<Void> handle) => _sdkCoreEngineUsagestatsNetworkstatsReleaseHandle(handle);

// Nullable UsageStatsNetworkStats

final _sdkCoreEngineUsagestatsNetworkstatsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_create_handle_nullable'));
final _sdkCoreEngineUsagestatsNetworkstatsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_release_handle_nullable'));
final _sdkCoreEngineUsagestatsNetworkstatsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_NetworkStats_get_value_nullable'));

Pointer<Void> sdkCoreEngineUsagestatsNetworkstatsToFfiNullable(UsageStatsNetworkStats? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkCoreEngineUsagestatsNetworkstatsToFfi(value);
  final result = _sdkCoreEngineUsagestatsNetworkstatsCreateHandleNullable(_handle);
  sdkCoreEngineUsagestatsNetworkstatsReleaseFfiHandle(_handle);
  return result;
}

UsageStatsNetworkStats? sdkCoreEngineUsagestatsNetworkstatsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkCoreEngineUsagestatsNetworkstatsGetValueNullable(handle);
  final result = sdkCoreEngineUsagestatsNetworkstatsFromFfi(_handle);
  sdkCoreEngineUsagestatsNetworkstatsReleaseFfiHandle(_handle);
  return result;
}

void sdkCoreEngineUsagestatsNetworkstatsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreEngineUsagestatsNetworkstatsReleaseHandleNullable(handle);

// End of UsageStatsNetworkStats "private" section.
/// Indicates the method that was used by the HERE SDK.
///
/// All method names are equal to 'networkCall.some_url' temporary.
/// This issue will be fixed with correctly introduced custom headers functionality.
/// @nodoc

class UsageStatsMethodNames {
  /// Represents a generic network call that cannot be further specified.
  static final String defaultNetworkCall = "networkCall";

  /// Represents the method name for analytics.
  static final String analytics = "analytics";

  /// Represents the method name for authentication.
  static final String authentication = "authentication";

  /// Represents the method name for calculating a route.
  static final String calculateRoute = "calculateRoute";

  /// Represents the method name for calculating a transit route.
  static final String calculateTransitRoute = "calculateTransitRoute";

  /// Represents the method name for calculating a route with traffic.
  static final String calculateRouteWithTraffic = "calculateRouteWithTraffic";

  /// Represents the method name for getting mapContent.
  static final String mapContent = "mapContent";

  /// Represents the method name for searching.
  static final String searchMethod = "search";

  /// Represents the method name for fetching traffic incidents.
  static final String trafficFetchIncidents = "fetchIncidents";

}


// UsageStatsMethodNames "private" section, not exported.

final _sdkCoreEngineUsagestatsMethodnamesCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(),
    Pointer<Void> Function()
  >('here_sdk_sdk_core_engine_UsageStats_MethodNames_create_handle'));
final _sdkCoreEngineUsagestatsMethodnamesReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_MethodNames_release_handle'));



Pointer<Void> sdkCoreEngineUsagestatsMethodnamesToFfi(UsageStatsMethodNames value) {
  final _result = _sdkCoreEngineUsagestatsMethodnamesCreateHandle();
  return _result;
}

UsageStatsMethodNames sdkCoreEngineUsagestatsMethodnamesFromFfi(Pointer<Void> handle) {
  try {
    return UsageStatsMethodNames(
    );
  } finally {
  }
}

void sdkCoreEngineUsagestatsMethodnamesReleaseFfiHandle(Pointer<Void> handle) => _sdkCoreEngineUsagestatsMethodnamesReleaseHandle(handle);

// Nullable UsageStatsMethodNames

final _sdkCoreEngineUsagestatsMethodnamesCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_MethodNames_create_handle_nullable'));
final _sdkCoreEngineUsagestatsMethodnamesReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_MethodNames_release_handle_nullable'));
final _sdkCoreEngineUsagestatsMethodnamesGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_MethodNames_get_value_nullable'));

Pointer<Void> sdkCoreEngineUsagestatsMethodnamesToFfiNullable(UsageStatsMethodNames? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkCoreEngineUsagestatsMethodnamesToFfi(value);
  final result = _sdkCoreEngineUsagestatsMethodnamesCreateHandleNullable(_handle);
  sdkCoreEngineUsagestatsMethodnamesReleaseFfiHandle(_handle);
  return result;
}

UsageStatsMethodNames? sdkCoreEngineUsagestatsMethodnamesFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkCoreEngineUsagestatsMethodnamesGetValueNullable(handle);
  final result = sdkCoreEngineUsagestatsMethodnamesFromFfi(_handle);
  sdkCoreEngineUsagestatsMethodnamesReleaseFfiHandle(_handle);
  return result;
}

void sdkCoreEngineUsagestatsMethodnamesReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreEngineUsagestatsMethodnamesReleaseHandleNullable(handle);

// End of UsageStatsMethodNames "private" section.

// UsageStats "private" section, not exported.

final _sdkCoreEngineUsagestatsCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>, Uint32),
    Pointer<Void> Function(Pointer<Void>, int)
  >('here_sdk_sdk_core_engine_UsageStats_create_handle'));
final _sdkCoreEngineUsagestatsReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_release_handle'));
final _sdkCoreEngineUsagestatsGetFieldnetworkStats = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_get_field_networkStats'));
final _sdkCoreEngineUsagestatsGetFieldfeature = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_get_field_feature'));



Pointer<Void> sdkCoreEngineUsagestatsToFfi(UsageStats value) {
  final _networkStatsHandle = heresdkCoreBindingslistofSdkCoreEngineUsagestatsNetworkstatsToFfi(value.networkStats);
  final _featureHandle = sdkCoreEngineUsagestatsFeatureToFfi(value.feature);
  final _result = _sdkCoreEngineUsagestatsCreateHandle(_networkStatsHandle, _featureHandle);
  heresdkCoreBindingslistofSdkCoreEngineUsagestatsNetworkstatsReleaseFfiHandle(_networkStatsHandle);
  sdkCoreEngineUsagestatsFeatureReleaseFfiHandle(_featureHandle);
  return _result;
}

UsageStats sdkCoreEngineUsagestatsFromFfi(Pointer<Void> handle) {
  final _networkStatsHandle = _sdkCoreEngineUsagestatsGetFieldnetworkStats(handle);
  final _featureHandle = _sdkCoreEngineUsagestatsGetFieldfeature(handle);
  try {
    return UsageStats(
      heresdkCoreBindingslistofSdkCoreEngineUsagestatsNetworkstatsFromFfi(_networkStatsHandle), 
      sdkCoreEngineUsagestatsFeatureFromFfi(_featureHandle)
    );
  } finally {
    heresdkCoreBindingslistofSdkCoreEngineUsagestatsNetworkstatsReleaseFfiHandle(_networkStatsHandle);
    sdkCoreEngineUsagestatsFeatureReleaseFfiHandle(_featureHandle);
  }
}

void sdkCoreEngineUsagestatsReleaseFfiHandle(Pointer<Void> handle) => _sdkCoreEngineUsagestatsReleaseHandle(handle);

// Nullable UsageStats

final _sdkCoreEngineUsagestatsCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_create_handle_nullable'));
final _sdkCoreEngineUsagestatsReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_release_handle_nullable'));
final _sdkCoreEngineUsagestatsGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_engine_UsageStats_get_value_nullable'));

Pointer<Void> sdkCoreEngineUsagestatsToFfiNullable(UsageStats? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkCoreEngineUsagestatsToFfi(value);
  final result = _sdkCoreEngineUsagestatsCreateHandleNullable(_handle);
  sdkCoreEngineUsagestatsReleaseFfiHandle(_handle);
  return result;
}

UsageStats? sdkCoreEngineUsagestatsFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkCoreEngineUsagestatsGetValueNullable(handle);
  final result = sdkCoreEngineUsagestatsFromFfi(_handle);
  sdkCoreEngineUsagestatsReleaseFfiHandle(_handle);
  return result;
}

void sdkCoreEngineUsagestatsReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreEngineUsagestatsReleaseHandleNullable(handle);

// End of UsageStats "private" section.


