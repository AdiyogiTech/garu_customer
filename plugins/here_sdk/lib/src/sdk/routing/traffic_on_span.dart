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

/// Traffic information of a span along a route.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behaviors. Related APIs may change for new releases without a deprecation process.

class TrafficOnSpan {
  /// Index over [TrafficOnSection.geometry] where this span starts.
  int trafficSectionPolylineOffset;

  /// Length of the traffic span, in meters.
  double lengthInMeters;

  /// The time duration necessary to traverse the traffic span. This duration takes also into
  /// consideration the delays caused by the traffic.
  Duration duration;

  /// The estimated extra time in seconds spent due to traffic delays along this traffic span.
  /// Negative values indicate that the traffic span can be traversed faster than usual.
  Duration trafficDelay;

  /// The speed, in meters per second, without taking traffic into consideration.
  double baseSpeedInMetersPerSecond;

  /// The speed, in meters per second, considering traffic.
  double trafficSpeedInMetersPerSecond;

  /// The traffic jam factor shows the traffic condition in a numeric way. It is a
  /// value in the range \[0.0, 10.0\]. A large jamFactor value means more traffic jam
  /// in general. Specifically, 0.0 means free traffic and 10.0 means stationary traffic.
  double jamFactor;

  /// The indices of traffic incidents from the field [TrafficOnSection.trafficIncidents].
  List<int> incidentIndices;

  /// The power consumption in kilowatt-hours (kWh) necessary to traverse the span.
  double? consumptionInKilowattHours;

  /// Creates a new instance.

  /// [trafficSectionPolylineOffset] Index over [TrafficOnSection.geometry] where this span starts.

  /// [lengthInMeters] Length of the traffic span, in meters.

  /// [duration] The time duration necessary to traverse the traffic span. This duration takes also into
  /// consideration the delays caused by the traffic.

  /// [trafficDelay] The estimated extra time in seconds spent due to traffic delays along this traffic span.
  /// Negative values indicate that the traffic span can be traversed faster than usual.

  /// [baseSpeedInMetersPerSecond] The speed, in meters per second, without taking traffic into consideration.

  /// [trafficSpeedInMetersPerSecond] The speed, in meters per second, considering traffic.

  /// [jamFactor] The traffic jam factor shows the traffic condition in a numeric way. It is a
  /// value in the range \[0.0, 10.0\]. A large jamFactor value means more traffic jam
  /// in general. Specifically, 0.0 means free traffic and 10.0 means stationary traffic.

  /// [incidentIndices] The indices of traffic incidents from the field [TrafficOnSection.trafficIncidents].

  /// [consumptionInKilowattHours] The power consumption in kilowatt-hours (kWh) necessary to traverse the span.

  TrafficOnSpan._(this.trafficSectionPolylineOffset, this.lengthInMeters, this.duration, this.trafficDelay, this.baseSpeedInMetersPerSecond, this.trafficSpeedInMetersPerSecond, this.jamFactor, this.incidentIndices, this.consumptionInKilowattHours);
  TrafficOnSpan()
    : trafficSectionPolylineOffset = 0, lengthInMeters = 0.0, duration = const Duration(seconds: 0), trafficDelay = const Duration(seconds: 0), baseSpeedInMetersPerSecond = 0.0, trafficSpeedInMetersPerSecond = 0.0, jamFactor = 0.0, incidentIndices = [], consumptionInKilowattHours = null;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TrafficOnSpan) return false;
    TrafficOnSpan _other = other;
    return trafficSectionPolylineOffset == _other.trafficSectionPolylineOffset &&
        lengthInMeters == _other.lengthInMeters &&
        duration == _other.duration &&
        trafficDelay == _other.trafficDelay &&
        baseSpeedInMetersPerSecond == _other.baseSpeedInMetersPerSecond &&
        trafficSpeedInMetersPerSecond == _other.trafficSpeedInMetersPerSecond &&
        jamFactor == _other.jamFactor &&
        DeepCollectionEquality().equals(incidentIndices, _other.incidentIndices) &&
        consumptionInKilowattHours == _other.consumptionInKilowattHours;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + trafficSectionPolylineOffset.hashCode;
    result = 31 * result + lengthInMeters.hashCode;
    result = 31 * result + duration.hashCode;
    result = 31 * result + trafficDelay.hashCode;
    result = 31 * result + baseSpeedInMetersPerSecond.hashCode;
    result = 31 * result + trafficSpeedInMetersPerSecond.hashCode;
    result = 31 * result + jamFactor.hashCode;
    result = 31 * result + DeepCollectionEquality().hash(incidentIndices);
    result = 31 * result + consumptionInKilowattHours.hashCode;
    return result;
  }
}


// TrafficOnSpan "private" section, not exported.

final _sdkRoutingTrafficonspanCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Int32, Double, Uint64, Uint64, Double, Double, Double, Pointer<Void>, Pointer<Void>),
    Pointer<Void> Function(int, double, int, int, double, double, double, Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_create_handle'));
final _sdkRoutingTrafficonspanReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_release_handle'));
final _sdkRoutingTrafficonspanGetFieldtrafficSectionPolylineOffset = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_trafficSectionPolylineOffset'));
final _sdkRoutingTrafficonspanGetFieldlengthInMeters = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_lengthInMeters'));
final _sdkRoutingTrafficonspanGetFieldduration = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_duration'));
final _sdkRoutingTrafficonspanGetFieldtrafficDelay = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint64 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_trafficDelay'));
final _sdkRoutingTrafficonspanGetFieldbaseSpeedInMetersPerSecond = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_baseSpeedInMetersPerSecond'));
final _sdkRoutingTrafficonspanGetFieldtrafficSpeedInMetersPerSecond = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_trafficSpeedInMetersPerSecond'));
final _sdkRoutingTrafficonspanGetFieldjamFactor = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Double Function(Pointer<Void>),
    double Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_jamFactor'));
final _sdkRoutingTrafficonspanGetFieldincidentIndices = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_incidentIndices'));
final _sdkRoutingTrafficonspanGetFieldconsumptionInKilowattHours = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_field_consumptionInKilowattHours'));



Pointer<Void> sdkRoutingTrafficonspanToFfi(TrafficOnSpan value) {
  final _trafficSectionPolylineOffsetHandle = (value.trafficSectionPolylineOffset);
  final _lengthInMetersHandle = (value.lengthInMeters);
  final _durationHandle = durationToFfi(value.duration);
  final _trafficDelayHandle = durationToFfi(value.trafficDelay);
  final _baseSpeedInMetersPerSecondHandle = (value.baseSpeedInMetersPerSecond);
  final _trafficSpeedInMetersPerSecondHandle = (value.trafficSpeedInMetersPerSecond);
  final _jamFactorHandle = (value.jamFactor);
  final _incidentIndicesHandle = heresdkRoutingCommonBindingslistofIntToFfi(value.incidentIndices);
  final _consumptionInKilowattHoursHandle = doubleToFfiNullable(value.consumptionInKilowattHours);
  final _result = _sdkRoutingTrafficonspanCreateHandle(_trafficSectionPolylineOffsetHandle, _lengthInMetersHandle, _durationHandle, _trafficDelayHandle, _baseSpeedInMetersPerSecondHandle, _trafficSpeedInMetersPerSecondHandle, _jamFactorHandle, _incidentIndicesHandle, _consumptionInKilowattHoursHandle);
  
  
  durationReleaseFfiHandle(_durationHandle);
  durationReleaseFfiHandle(_trafficDelayHandle);
  
  
  
  heresdkRoutingCommonBindingslistofIntReleaseFfiHandle(_incidentIndicesHandle);
  doubleReleaseFfiHandleNullable(_consumptionInKilowattHoursHandle);
  return _result;
}

TrafficOnSpan sdkRoutingTrafficonspanFromFfi(Pointer<Void> handle) {
  final _trafficSectionPolylineOffsetHandle = _sdkRoutingTrafficonspanGetFieldtrafficSectionPolylineOffset(handle);
  final _lengthInMetersHandle = _sdkRoutingTrafficonspanGetFieldlengthInMeters(handle);
  final _durationHandle = _sdkRoutingTrafficonspanGetFieldduration(handle);
  final _trafficDelayHandle = _sdkRoutingTrafficonspanGetFieldtrafficDelay(handle);
  final _baseSpeedInMetersPerSecondHandle = _sdkRoutingTrafficonspanGetFieldbaseSpeedInMetersPerSecond(handle);
  final _trafficSpeedInMetersPerSecondHandle = _sdkRoutingTrafficonspanGetFieldtrafficSpeedInMetersPerSecond(handle);
  final _jamFactorHandle = _sdkRoutingTrafficonspanGetFieldjamFactor(handle);
  final _incidentIndicesHandle = _sdkRoutingTrafficonspanGetFieldincidentIndices(handle);
  final _consumptionInKilowattHoursHandle = _sdkRoutingTrafficonspanGetFieldconsumptionInKilowattHours(handle);
  try {
    return TrafficOnSpan._(
      (_trafficSectionPolylineOffsetHandle), 
      (_lengthInMetersHandle), 
      durationFromFfi(_durationHandle), 
      durationFromFfi(_trafficDelayHandle), 
      (_baseSpeedInMetersPerSecondHandle), 
      (_trafficSpeedInMetersPerSecondHandle), 
      (_jamFactorHandle), 
      heresdkRoutingCommonBindingslistofIntFromFfi(_incidentIndicesHandle), 
      doubleFromFfiNullable(_consumptionInKilowattHoursHandle)
    );
  } finally {
    
    
    durationReleaseFfiHandle(_durationHandle);
    durationReleaseFfiHandle(_trafficDelayHandle);
    
    
    
    heresdkRoutingCommonBindingslistofIntReleaseFfiHandle(_incidentIndicesHandle);
    doubleReleaseFfiHandleNullable(_consumptionInKilowattHoursHandle);
  }
}

void sdkRoutingTrafficonspanReleaseFfiHandle(Pointer<Void> handle) => _sdkRoutingTrafficonspanReleaseHandle(handle);

// Nullable TrafficOnSpan

final _sdkRoutingTrafficonspanCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_create_handle_nullable'));
final _sdkRoutingTrafficonspanReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_release_handle_nullable'));
final _sdkRoutingTrafficonspanGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_routing_TrafficOnSpan_get_value_nullable'));

Pointer<Void> sdkRoutingTrafficonspanToFfiNullable(TrafficOnSpan? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkRoutingTrafficonspanToFfi(value);
  final result = _sdkRoutingTrafficonspanCreateHandleNullable(_handle);
  sdkRoutingTrafficonspanReleaseFfiHandle(_handle);
  return result;
}

TrafficOnSpan? sdkRoutingTrafficonspanFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkRoutingTrafficonspanGetValueNullable(handle);
  final result = sdkRoutingTrafficonspanFromFfi(_handle);
  sdkRoutingTrafficonspanReleaseFfiHandle(_handle);
  return result;
}

void sdkRoutingTrafficonspanReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkRoutingTrafficonspanReleaseHandleNullable(handle);

// End of TrafficOnSpan "private" section.


