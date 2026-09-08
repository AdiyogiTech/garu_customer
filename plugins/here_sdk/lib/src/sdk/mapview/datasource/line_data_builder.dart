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
import 'package:here_sdk/src/_library_context.dart' as __lib;
import 'package:here_sdk/src/_native_base.dart' as __lib;
import 'package:here_sdk/src/_token_cache.dart' as __lib;
import 'package:here_sdk/src/sdk/core/geo_polyline.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/data_attributes.dart';
import 'package:here_sdk/src/sdk/mapview/datasource/line_data.dart';
import 'package:meta/meta.dart';

/// Builder of [LineData] instances.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.
abstract class LineDataBuilder {
  /// Creates a builder instance.
  ///
  factory LineDataBuilder() => $prototype.create();

  /// Configures the builder with geometry for line to be created.
  ///
  /// [geometry] Geometry of the polyline. Each vertex defines two line segments: one
  /// with a previous vertex and one with a next vertex. First and last vertices don't have
  /// resp. previous and next vertices and thus belong to single line segments.
  /// Altitude of polyline vertices is ignored.
  ///
  /// Returns [LineDataBuilder]. The builder.
  ///
  LineDataBuilder withGeometry(GeoPolyline geometry);
  /// Configures the builder with custom attributes for line to be created.
  ///
  /// [attributes] Custom data attributes to be associated with the line.
  ///
  /// Returns [LineDataBuilder]. The builder.
  ///
  LineDataBuilder withAttributes(DataAttributes attributes);
  /// Builds an instance of [LineData] and resets the builder instance.
  ///
  /// Returns [LineData]. Instance of [LineData] created with the configured parameters.
  ///
  LineData build();

  /// @nodoc
  @visibleForTesting
  static dynamic $prototype = LineDataBuilder$Impl(Pointer<Void>.fromAddress(0));
}


// LineDataBuilder "private" section, not exported.

final _sdkMapviewDatasourceLinedatabuilderRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_mapview_datasource_LineDataBuilder_register_finalizer'));
final _sdkMapviewDatasourceLinedatabuilderCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataBuilder_copy_handle'));
final _sdkMapviewDatasourceLinedatabuilderReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_LineDataBuilder_release_handle'));






/// @nodoc
@visibleForTesting
class LineDataBuilder$Impl extends __lib.NativeBase implements LineDataBuilder {

  LineDataBuilder$Impl(Pointer<Void> handle) : super(handle);


  LineDataBuilder create() {
    final _result_handle = _create();
    final _result = LineDataBuilder$Impl(_result_handle);

    __lib.cacheInstance(_result_handle, _result);

    _sdkMapviewDatasourceLinedatabuilderRegisterFinalizer(_result_handle, __lib.LibraryContext.isolateId, _result);
    return _result;
  }

  static Pointer<Void> _create() {
    final _createFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Int32), Pointer<Void> Function(int)>('here_sdk_sdk_mapview_datasource_LineDataBuilder_create'));
    final __resultHandle = _createFfi(__lib.LibraryContext.isolateId);
    return __resultHandle;
  }

  @override
  LineDataBuilder withGeometry(GeoPolyline geometry) {
    final _withGeometryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataBuilder_withGeometry__GeoPolyline'));
    final _geometryHandle = sdkCoreGeopolylineToFfi(geometry);
    final _handle = this.handle;
    final __resultHandle = _withGeometryFfi(_handle, __lib.LibraryContext.isolateId, _geometryHandle);
    sdkCoreGeopolylineReleaseFfiHandle(_geometryHandle);
    try {
      return sdkMapviewDatasourceLinedatabuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedatabuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  LineDataBuilder withAttributes(DataAttributes attributes) {
    final _withAttributesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>)>('here_sdk_sdk_mapview_datasource_LineDataBuilder_withAttributes__DataAttributes'));
    final _attributesHandle = sdkMapviewDatasourceDataattributesToFfi(attributes);
    final _handle = this.handle;
    final __resultHandle = _withAttributesFfi(_handle, __lib.LibraryContext.isolateId, _attributesHandle);
    sdkMapviewDatasourceDataattributesReleaseFfiHandle(_attributesHandle);
    try {
      return sdkMapviewDatasourceLinedatabuilderFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedatabuilderReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  LineData build() {
    final _buildFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32), Pointer<Void> Function(Pointer<Void>, int)>('here_sdk_sdk_mapview_datasource_LineDataBuilder_build'));
    final _handle = this.handle;
    final __resultHandle = _buildFfi(_handle, __lib.LibraryContext.isolateId);
    try {
      return sdkMapviewDatasourceLinedataFromFfi(__resultHandle);
    } finally {
      sdkMapviewDatasourceLinedataReleaseFfiHandle(__resultHandle);

    }

  }


}

Pointer<Void> sdkMapviewDatasourceLinedatabuilderToFfi(LineDataBuilder value) =>
  _sdkMapviewDatasourceLinedatabuilderCopyHandle((value as __lib.NativeBase).handle);

LineDataBuilder sdkMapviewDatasourceLinedatabuilderFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is LineDataBuilder) return instance;

  final _copiedHandle = _sdkMapviewDatasourceLinedatabuilderCopyHandle(handle);
  final result = LineDataBuilder$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkMapviewDatasourceLinedatabuilderRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkMapviewDatasourceLinedatabuilderReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatabuilderReleaseHandle(handle);

Pointer<Void> sdkMapviewDatasourceLinedatabuilderToFfiNullable(LineDataBuilder? value) =>
  value != null ? sdkMapviewDatasourceLinedatabuilderToFfi(value) : Pointer<Void>.fromAddress(0);

LineDataBuilder? sdkMapviewDatasourceLinedatabuilderFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkMapviewDatasourceLinedatabuilderFromFfi(handle) : null;

void sdkMapviewDatasourceLinedatabuilderReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceLinedatabuilderReleaseHandle(handle);

// End of LineDataBuilder "private" section.


