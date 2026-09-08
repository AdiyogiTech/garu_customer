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

/// Key of a data source tile.
///
/// Note: This is a beta release of this feature, so there could be a few bugs and unexpected
/// behavior. Related APIs may change for new releases without a deprecation process.

class TileKey {
  /// X coordinate of the tile. This ranges from 0 to 2^level − 1.
  int x;

  /// Y coordinate of the tile. This ranges from 0 to 2^level − 1.
  int y;

  /// Level of the tile. Supported range \[0, 31\].
  int level;

  /// Creates a new instance.
  /// [x] X coordinate of the tile. This ranges from 0 to 2^level − 1.
  /// [y] Y coordinate of the tile. This ranges from 0 to 2^level − 1.
  /// [level] Level of the tile. Supported range \[0, 31\].
  TileKey(this.x, this.y, this.level);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TileKey) return false;
    TileKey _other = other;
    return x == _other.x &&
        y == _other.y &&
        level == _other.level;
  }

  @override
  int get hashCode {
    int result = 7;
    result = 31 * result + x.hashCode;
    result = 31 * result + y.hashCode;
    result = 31 * result + level.hashCode;
    return result;
  }
}


// TileKey "private" section, not exported.

final _sdkMapviewDatasourceTilekeyCreateHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Int32, Int32, Int32),
    Pointer<Void> Function(int, int, int)
  >('here_sdk_sdk_mapview_datasource_TileKey_create_handle'));
final _sdkMapviewDatasourceTilekeyReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_release_handle'));
final _sdkMapviewDatasourceTilekeyGetFieldx = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_get_field_x'));
final _sdkMapviewDatasourceTilekeyGetFieldy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_get_field_y'));
final _sdkMapviewDatasourceTilekeyGetFieldlevel = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Int32 Function(Pointer<Void>),
    int Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_get_field_level'));



Pointer<Void> sdkMapviewDatasourceTilekeyToFfi(TileKey value) {
  final _xHandle = (value.x);
  final _yHandle = (value.y);
  final _levelHandle = (value.level);
  final _result = _sdkMapviewDatasourceTilekeyCreateHandle(_xHandle, _yHandle, _levelHandle);
  
  
  
  return _result;
}

TileKey sdkMapviewDatasourceTilekeyFromFfi(Pointer<Void> handle) {
  final _xHandle = _sdkMapviewDatasourceTilekeyGetFieldx(handle);
  final _yHandle = _sdkMapviewDatasourceTilekeyGetFieldy(handle);
  final _levelHandle = _sdkMapviewDatasourceTilekeyGetFieldlevel(handle);
  try {
    return TileKey(
      (_xHandle), 
      (_yHandle), 
      (_levelHandle)
    );
  } finally {
    
    
    
  }
}

void sdkMapviewDatasourceTilekeyReleaseFfiHandle(Pointer<Void> handle) => _sdkMapviewDatasourceTilekeyReleaseHandle(handle);

// Nullable TileKey

final _sdkMapviewDatasourceTilekeyCreateHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_create_handle_nullable'));
final _sdkMapviewDatasourceTilekeyReleaseHandleNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_release_handle_nullable'));
final _sdkMapviewDatasourceTilekeyGetValueNullable = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_mapview_datasource_TileKey_get_value_nullable'));

Pointer<Void> sdkMapviewDatasourceTilekeyToFfiNullable(TileKey? value) {
  if (value == null) return Pointer<Void>.fromAddress(0);
  final _handle = sdkMapviewDatasourceTilekeyToFfi(value);
  final result = _sdkMapviewDatasourceTilekeyCreateHandleNullable(_handle);
  sdkMapviewDatasourceTilekeyReleaseFfiHandle(_handle);
  return result;
}

TileKey? sdkMapviewDatasourceTilekeyFromFfiNullable(Pointer<Void> handle) {
  if (handle.address == 0) return null;
  final _handle = _sdkMapviewDatasourceTilekeyGetValueNullable(handle);
  final result = sdkMapviewDatasourceTilekeyFromFfi(_handle);
  sdkMapviewDatasourceTilekeyReleaseFfiHandle(_handle);
  return result;
}

void sdkMapviewDatasourceTilekeyReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkMapviewDatasourceTilekeyReleaseHandleNullable(handle);

// End of TileKey "private" section.


