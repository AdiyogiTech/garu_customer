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
import 'package:here_sdk/src/builtin_types__conversion.dart';
import 'package:meta/meta.dart';

/// Used to indicate a time period of one or more intervals in [GDF](https://www.here.com/docs/bundle/routing-api-developer-guide-v8/page/topics/time-domain.html) specification.
///
/// For example:
/// -*(M3f21h2){M9}(M11f12h2){-M9}+(h15){h2}(h20){h2}, which represents:
/// March 2nd Sunday 02h:00m for 9 months
/// ONLY DURING November 1st Sunday 02h:00m from 9 months ago
/// BUT NOT from 15:00 to 17:00 OR 20:00 to 22:00
///
/// The operator * represents reccuring occurrence, `+` represents a logical OR operation and `-` represents exclusion meaning, BUT NOT operations.
///
/// This example string represents a time period that meets the following criteria:
/// - `M3f21h2`: M3 denotes third month of the year, i.e. March,
///   f2 stands for the second Sunday of the month (as "f" might indicate "first", "second", "third", etc.),
///   1 stands for the day of the week (1...7, Day of week, Sunday = day 1), and h2 represents the hour of the day (02:00) in 24 hour format.
/// - `{M9}`: This denotes "for 9 months", with "M9" standing for nine months. The brackets {} indicate a duration.
/// - `M11f12h2`: M11 denotes 11th month of the year, i.e. November, f1 stands for the first Monday of the month,
///   2 stands for the day of the week (1...7, Day of week, Monday = day 2), and h2 represents the hour of the day (02:00) in 24 hour format.
/// - {-M9}: This denotes "9 months ago from the current stated time", with "-M9" standing for nine months in the past.
/// - `(h15){h2}(h20){h2}`: 15:00 to 17:00 OR 20:00 to 22:00
///   The brackets {} denotes duration, and the negative sign - represents a past duration.
///
/// Note: The time period is a logical AND (&&) combination of two components or points in time and it only applies if a point in time is in both components.
///
/// For more advanced examples of `TimeRule` see [here](https://www.here.com/docs/bundle/routing-api-developer-guide-v8/page/topics/time-domain.html#time-domain-advanced-examples).
abstract class TimeRule {
  /// Creates a new instance of this class.
  ///
  /// [timeRule] The time rule as a string in ISO 14825 format.
  ///
  /// [timeZoneOffsetSeconds] The time zone offset in seconds for the location where the time rule applies.
  ///
  /// [dstSpec] Day saving time specification, as a string in ISO 14825 format, for the location where the time rule applies.
  ///
  factory TimeRule(String timeRule, int timeZoneOffsetSeconds, String dstSpec) => $prototype.make(timeRule, timeZoneOffsetSeconds, dstSpec);


  /// [dateTime] date and time that should be used for rule verification.
  ///
  /// Returns [bool]. true if the time domain rules applies to the given date and time., false - otherwise.
  ///
  bool appliesTo(DateTime dateTime);
  /// The time rule as a string in ISO 14825 format.
  /// Gets the value of time rule as a string in ISO 14825 format.
  String get timeRuleString;

  /// The time zone offset in seconds for the location where the time rule applies.
  /// Gets the value of time zone offset in seconds for the location where the time rule applies.
  int get timeZoneOffsetSeconds;

  /// Day saving time specification, as a string in ISO 14825 format, for the location where the time rule applies.
  /// Gets the value of day saving time specification, as a string in ISO 14825 format, for the location where the time rule applies.
  String get dstSpec;


  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = TimeRule$Impl(Pointer<Void>.fromAddress(0));
}


// TimeRule "private" section, not exported.

final _sdkCoreTimeruleRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_core_TimeRule_register_finalizer'));
final _sdkCoreTimeruleCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_core_TimeRule_copy_handle'));
final _sdkCoreTimeruleReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_core_TimeRule_release_handle'));
final __areEqual = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Uint8 Function(Pointer<Void>, Pointer<Void>),
    int Function(Pointer<Void>, Pointer<Void>)
  >('here_sdk_sdk_core_TimeRule_are_equal'));



/// @nodoc
@visibleForTesting
class TimeRule$Impl extends __lib.NativeBase implements TimeRule {

  TimeRule$Impl(Pointer<Void> handle) : super(handle);


  TimeRule make(String timeRule, int timeZoneOffsetSeconds, String dstSpec) {
    final _result_handle = _make(timeRule, timeZoneOffsetSeconds, dstSpec);
    final _result = TimeRule$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkCoreTimeruleRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _make(String timeRule, int timeZoneOffsetSeconds, String dstSpec) {
    final _makeFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32, Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(int, Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_core_TimeRule_make__String_Int_String'));
    final _timeRuleHandle = stringToFfi(timeRule);
    final _timeZoneOffsetSecondsHandle = (timeZoneOffsetSeconds);
    final _dstSpecHandle = stringToFfi(dstSpec);
    final __resultHandle = _makeFfi(__lib.LibraryContext.isolateId, _timeRuleHandle, _timeZoneOffsetSecondsHandle, _dstSpecHandle);
    stringReleaseFfiHandle(_timeRuleHandle);

    stringReleaseFfiHandle(_dstSpecHandle);
    return __resultHandle;
  }

  @override
  bool appliesTo(DateTime dateTime) {
    final _appliesToFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Uint8 Function(Pointer<Void>, Int32, Uint64), int Function(Pointer<Void>, int, int)>('here_sdk_sdk_core_TimeRule_appliesTo__Date'));
    final _dateTimeHandle = dateToFfi(dateTime);
    final _handle = this.handle;
    final __resultHandle = _appliesToFfi(_handle, __lib.LibraryContext.isolateId, _dateTimeHandle);
    dateReleaseFfiHandle(_dateTimeHandle);
    try {
      return booleanFromFfi(__resultHandle);
    } finally {
      booleanReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  String get timeRuleString {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_core_TimeRule_timeRuleString_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfi(__resultHandle);
    } finally {
      stringReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  int get timeZoneOffsetSeconds {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Int32 Function(Pointer<Void>, Int32), int Function(Pointer<Void>, int)>('here_sdk_sdk_core_TimeRule_timeZoneOffsetSeconds_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return (__resultHandle);
    } finally {


    }

  }


  @override
  String get dstSpec {
    final _getFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_core_TimeRule_dstSpec_get'));
    final _handle = this.handle;
    final __resultHandle = _getFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return stringFromFfi(__resultHandle);
    } finally {
      stringReleaseFfiHandle(__resultHandle);

    }

  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TimeRule$Impl) return false;
    return __areEqual(this.handle, other.handle) != 0;
  }

}

Pointer<Void> sdkCoreTimeruleToFfi(TimeRule value) =>
  _sdkCoreTimeruleCopyHandle((value as __lib.NativeBase).handle);

TimeRule sdkCoreTimeruleFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is TimeRule) return instance;

  final _copiedHandle = _sdkCoreTimeruleCopyHandle(handle);
  final result = TimeRule$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkCoreTimeruleRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkCoreTimeruleReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkCoreTimeruleReleaseHandle(handle);

Pointer<Void> sdkCoreTimeruleToFfiNullable(TimeRule? value) =>
  value != null ? sdkCoreTimeruleToFfi(value) : Pointer<Void>.fromAddress(0);

TimeRule? sdkCoreTimeruleFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkCoreTimeruleFromFfi(handle) : null;

void sdkCoreTimeruleReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkCoreTimeruleReleaseHandle(handle);

// End of TimeRule "private" section.


