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

/// Represents various errors that could occur from a traffic queries.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected behaviors.
/// Related APIs may change for new releases without a deprecation process.
enum TrafficQueryError {
    /// Failed to retrieve result since the server has returned an error or invalid result
    /// that couldn't be processed correctly.
    failedToRetrieveResult,
    /// Incident query/flow operation is not authenticated. Check your credentials.
    authenticationFailed,
    /// The provided credentials don't give access to the requested resource.
    forbidden,
    /// Server unreachable.
    serverUnreachable,
    /// The request timed out.
    timedOut,
    /// The device has no internet connection.
    offline,
    /// Network request error.
    httpError,
    /// Invalid "in" parameter: wrong type, missing or invalid "in".
    invalidIn,
    /// Invalid geometry: bounding box, circle, or corridor.
    invalidGeometry,
    /// Invalid incident ID, type, earliestStartTime or latestEndTime.
    invalidIncident,
    /// Incident ID is not found in the system.
    incidentIdNotFound,
    /// One or several filter options are invalid.
    invalidFilterOptions,
    /// One or more input parameters in the query is not valid.
    invalidParameter,
    /// Internal error.
    internalError,
    /// Operation cancelled.
    operationCancelled,
    /// Proxy is not authenticated. Check your proxy credentials.
    proxyAuthenticationFailed,
    /// Proxy server unreachable. Error indicates a problem with a proxy server's accessibility or connectivity.
    proxyServerUnreachable,
    /// Bad request. Error indicates server could not understand or process the request made by the client because
    /// the request itself was malformed or incorrect.
    badRequest,
    /// Server has received an excessive number of requests from client within a specific timeframe
    /// and client should slow down or wait before sending more requests.
    tooManyRequests
}

// TrafficQueryError "private" section, not exported.

int sdkTrafficTrafficqueryerrorToFfi(TrafficQueryError value) {
  switch (value) {
  case TrafficQueryError.failedToRetrieveResult:
    return 0;
  case TrafficQueryError.authenticationFailed:
    return 1;
  case TrafficQueryError.forbidden:
    return 2;
  case TrafficQueryError.serverUnreachable:
    return 3;
  case TrafficQueryError.timedOut:
    return 4;
  case TrafficQueryError.offline:
    return 5;
  case TrafficQueryError.httpError:
    return 6;
  case TrafficQueryError.invalidIn:
    return 7;
  case TrafficQueryError.invalidGeometry:
    return 8;
  case TrafficQueryError.invalidIncident:
    return 9;
  case TrafficQueryError.incidentIdNotFound:
    return 10;
  case TrafficQueryError.invalidFilterOptions:
    return 11;
  case TrafficQueryError.invalidParameter:
    return 12;
  case TrafficQueryError.internalError:
    return 13;
  case TrafficQueryError.operationCancelled:
    return 14;
  case TrafficQueryError.proxyAuthenticationFailed:
    return 15;
  case TrafficQueryError.proxyServerUnreachable:
    return 16;
  case TrafficQueryError.badRequest:
    return 17;
  case TrafficQueryError.tooManyRequests:
    return 18;
  default:
    throw StateError("Invalid enum value $value for TrafficQueryError enum.");
  }
}

TrafficQueryError sdkTrafficTrafficqueryerrorFromFfi(int handle) {
  switch (handle) {
  case 0:
    return TrafficQueryError.failedToRetrieveResult;
  case 1:
    return TrafficQueryError.authenticationFailed;
  case 2:
    return TrafficQueryError.forbidden;
  case 3:
    return TrafficQueryError.serverUnreachable;
  case 4:
    return TrafficQueryError.timedOut;
  case 5:
    return TrafficQueryError.offline;
  case 6:
    return TrafficQueryError.httpError;
  case 7:
    return TrafficQueryError.invalidIn;
  case 8:
    return TrafficQueryError.invalidGeometry;
  case 9:
    return TrafficQueryError.invalidIncident;
  case 10:
    return TrafficQueryError.incidentIdNotFound;
  case 11:
    return TrafficQueryError.invalidFilterOptions;
  case 12:
    return TrafficQueryError.invalidParameter;
  case 13:
    return TrafficQueryError.internalError;
  case 14:
    return TrafficQueryError.operationCancelled;
  case 15:
    return TrafficQueryError.proxyAuthenticationFailed;
  case 16:
    return TrafficQueryError.proxyServerUnreachable;
  case 17:
    return TrafficQueryError.badRequest;
  case 18:
    return TrafficQueryError.tooManyRequests;
  default:
    throw StateError("Invalid numeric value $handle for TrafficQueryError enum.");
  }
}

void sdkTrafficTrafficqueryerrorReleaseFfiHandle(int handle) {}

final _sdkTrafficTrafficqueryerrorCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint32),
    Pointer<Void> Function(int)
  >('here_sdk_sdk_traffic_TrafficQueryError_create_handle_nullable'));
final _sdkTrafficTrafficqueryerrorReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_traffic_TrafficQueryError_release_handle_nullable'));
final _sdkTrafficTrafficqueryerrorGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_traffic_TrafficQueryError_get_value_nullable'));

Pointer<Void> sdkTrafficTrafficqueryerrorToFfiNullable(TrafficQueryError? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkTrafficTrafficqueryerrorToFfi(value);
  final result = _sdkTrafficTrafficqueryerrorCreateHandleNullable(_handle);
  sdkTrafficTrafficqueryerrorReleaseFfiHandle(_handle);
  return result;
}

TrafficQueryError? sdkTrafficTrafficqueryerrorFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkTrafficTrafficqueryerrorGetValueNullable(handle);
  final result = sdkTrafficTrafficqueryerrorFromFfi(_handle);
  sdkTrafficTrafficqueryerrorReleaseFfiHandle(_handle);
  return result;
}

void sdkTrafficTrafficqueryerrorReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkTrafficTrafficqueryerrorReleaseHandleNullable(handle);

// End of TrafficQueryError "private" section.


