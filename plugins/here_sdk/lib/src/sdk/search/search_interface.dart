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
import 'package:here_sdk/src/sdk/core/geo_coordinates.dart';
import 'package:here_sdk/src/sdk/core/language_code.dart';
import 'package:here_sdk/src/sdk/core/picked_place.dart';
import 'package:here_sdk/src/sdk/core/threading/task_handle.dart';
import 'package:here_sdk/src/sdk/search/address_query.dart';
import 'package:here_sdk/src/sdk/search/category_query.dart';
import 'package:here_sdk/src/sdk/search/place_id_query.dart';
import 'package:here_sdk/src/sdk/search/place_id_search_callback.dart';
import 'package:here_sdk/src/sdk/search/search_callback.dart';
import 'package:here_sdk/src/sdk/search/search_options.dart';
import 'package:here_sdk/src/sdk/search/suggest_callback.dart';
import 'package:here_sdk/src/sdk/search/text_query.dart';

/// Provides the abstract class for the online and offline
/// search engines.
abstract class SearchInterface {
  /// Provides the abstract class for the online and offline
  /// search engines.

  factory SearchInterface(
    TaskHandle Function(TextQuery, SearchOptions, SearchCallback) searchByTextLambda,
    TaskHandle Function(AddressQuery, SearchOptions, SearchCallback) searchByAddressLambda,
    TaskHandle Function(CategoryQuery, SearchOptions, SearchCallback) searchByCategoryLambda,
    TaskHandle Function(GeoCoordinates, SearchOptions, SearchCallback) searchByCoordinatesLambda,
    TaskHandle Function(PlaceIdQuery, LanguageCode?, PlaceIdSearchCallback) searchByPlaceIdLambda,
    TaskHandle Function(PickedPlace, LanguageCode?, PlaceIdSearchCallback) searchByPickedPlaceLambda,
    TaskHandle Function(TextQuery, SearchOptions, SuggestCallback) suggestByTextLambda,

  ) => SearchInterface$Lambdas(
    searchByTextLambda,
    searchByAddressLambda,
    searchByCategoryLambda,
    searchByCoordinatesLambda,
    searchByPlaceIdLambda,
    searchByPickedPlaceLambda,
    suggestByTextLambda,

  );

  /// Performs an asynchronous text query search for [Place] instances within a given [TextQueryArea].
  ///
  /// The returned places are sorted by relevance.
  ///
  /// [query] Desired free-form text query to search.
  ///
  /// [options] Search options.
  ///
  /// [callback] Callback which receives the result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle searchByText(TextQuery query, SearchOptions options, SearchCallback callback);
  /// Performs an asynchronous address query search for [Place] instances.
  ///
  /// This is the same type of search as forward geocoding, except that more data is returned
  /// than just the geographic coordinates of a given address. Note that an address can
  /// belong to more than one [Place] result, although all found places will
  /// share the same geographic coordinates.
  /// The returned places are sorted by relevance.
  ///
  /// [query] Desired free-form address query text to search.
  ///
  /// [options] Search options.
  ///
  /// [callback] Callback which receives the result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle searchByAddress(AddressQuery query, SearchOptions options, SearchCallback callback);
  /// Performs an asynchronous category search for [Place] instances.
  ///
  /// A list containing at least one [PlaceCategory] must be provided
  /// as part of the [SearchInterface.searchByCategory.query].
  ///
  /// [query] Query with list of desired categories.
  ///
  /// [options] Search options.
  ///
  /// [callback] Callback which receives the result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle searchByCategory(CategoryQuery query, SearchOptions options, SearchCallback callback);
  /// Performs an asynchronous search for [Place] instances based on the given
  /// geographic coordinates.
  ///
  /// This is the same search type as reverse geocoding, except that more data is returned
  /// than just the [Address] related to the given coordinates.
  /// Note that more than one [Place] can be related to the given coordinates.
  /// The returned places are sorted by relevance.
  ///
  /// [coordinates] The coordinates where to search.
  ///
  /// [options] Search options.
  ///
  /// [callback] Callback which receives result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate execution of the task.
  ///
  TaskHandle searchByCoordinates(GeoCoordinates coordinates, SearchOptions options, SearchCallback callback);
  /// Performs an asynchronous search for a [Place] based on its ID and
  /// [LanguageCode].
  ///
  /// [query] The id of place to search.
  ///
  /// [languageCode] The preferred language for the search results. When unset or unsupported language is chosen,
  /// results will be returned in their local language.
  ///
  /// [callback] Callback which receives the result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle searchByPlaceId(PlaceIdQuery query, LanguageCode? languageCode, PlaceIdSearchCallback callback);
  /// Performs an asynchronous search for a [Place] based on the content found in [PickedPlace].
  ///
  /// If [PickedPlace] data is obtained from the offline map, it may happen that the newer version
  /// that is used by the online service represented by `SearchEngine` no longer contains the
  /// related POI. In that case, [SearchError.noResultsFound] error is reported.
  /// When that happens, you may try to obtain the POI from the offline map by calling
  /// `OfflineSearchEngine.searchPickedPlace`. Note that not all editions include the
  /// `OfflineSearchEngine`.
  ///
  /// [pickedPlace] The content picked from map.
  ///
  /// [languageCode] The preferred language for the search result. When unset or unsupported language is chosen,
  /// result will be returned in the local language.
  ///
  /// [callback] Callback which receives the result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle searchByPickedPlace(PickedPlace pickedPlace, LanguageCode? languageCode, PlaceIdSearchCallback callback);
  /// Performs an asynchronous request to suggest places for text queries and
  /// returns suggestions sorted by relevance.
  ///
  /// [query] Desired text query to search.
  ///
  /// [options] Search options.
  ///
  /// [callback] Callback which receives the result on the main thread.
  ///
  /// Returns [TaskHandle]. Handle that will be used to manipulate the execution of the task.
  ///
  TaskHandle suggestByText(TextQuery query, SearchOptions options, SuggestCallback callback);
}


// SearchInterface "private" section, not exported.

final _sdkSearchSearchinterfaceRegisterFinalizer = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>, Int32, Handle),
    void Function(Pointer<Void>, int, Object)
  >('here_sdk_sdk_search_SearchInterface_register_finalizer'));
final _sdkSearchSearchinterfaceCopyHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_SearchInterface_copy_handle'));
final _sdkSearchSearchinterfaceReleaseHandle = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
  >('here_sdk_sdk_search_SearchInterface_release_handle'));
final _sdkSearchSearchinterfaceCreateProxy = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Uint64, Int32, Handle, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer),
    Pointer<Void> Function(int, int, Object, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer, Pointer)
  >('here_sdk_sdk_search_SearchInterface_create_proxy'));
final _sdkSearchSearchinterfaceGetTypeId = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<
    Pointer<Void> Function(Pointer<Void>),
    Pointer<Void> Function(Pointer<Void>)
  >('here_sdk_sdk_search_SearchInterface_get_type_id'));








class SearchInterface$Lambdas implements SearchInterface {
  TaskHandle Function(TextQuery, SearchOptions, SearchCallback) searchByTextLambda;
  TaskHandle Function(AddressQuery, SearchOptions, SearchCallback) searchByAddressLambda;
  TaskHandle Function(CategoryQuery, SearchOptions, SearchCallback) searchByCategoryLambda;
  TaskHandle Function(GeoCoordinates, SearchOptions, SearchCallback) searchByCoordinatesLambda;
  TaskHandle Function(PlaceIdQuery, LanguageCode?, PlaceIdSearchCallback) searchByPlaceIdLambda;
  TaskHandle Function(PickedPlace, LanguageCode?, PlaceIdSearchCallback) searchByPickedPlaceLambda;
  TaskHandle Function(TextQuery, SearchOptions, SuggestCallback) suggestByTextLambda;

  SearchInterface$Lambdas(
    this.searchByTextLambda,
    this.searchByAddressLambda,
    this.searchByCategoryLambda,
    this.searchByCoordinatesLambda,
    this.searchByPlaceIdLambda,
    this.searchByPickedPlaceLambda,
    this.suggestByTextLambda,

  );

  @override
  TaskHandle searchByText(TextQuery query, SearchOptions options, SearchCallback callback) =>
    searchByTextLambda(query, options, callback);
  @override
  TaskHandle searchByAddress(AddressQuery query, SearchOptions options, SearchCallback callback) =>
    searchByAddressLambda(query, options, callback);
  @override
  TaskHandle searchByCategory(CategoryQuery query, SearchOptions options, SearchCallback callback) =>
    searchByCategoryLambda(query, options, callback);
  @override
  TaskHandle searchByCoordinates(GeoCoordinates coordinates, SearchOptions options, SearchCallback callback) =>
    searchByCoordinatesLambda(coordinates, options, callback);
  @override
  TaskHandle searchByPlaceId(PlaceIdQuery query, LanguageCode? languageCode, PlaceIdSearchCallback callback) =>
    searchByPlaceIdLambda(query, languageCode, callback);
  @override
  TaskHandle searchByPickedPlace(PickedPlace pickedPlace, LanguageCode? languageCode, PlaceIdSearchCallback callback) =>
    searchByPickedPlaceLambda(pickedPlace, languageCode, callback);
  @override
  TaskHandle suggestByText(TextQuery query, SearchOptions options, SuggestCallback callback) =>
    suggestByTextLambda(query, options, callback);
}

class SearchInterface$Impl extends __lib.NativeBase implements SearchInterface {

  SearchInterface$Impl(Pointer<Void> handle) : super(handle);

  @override
  TaskHandle searchByText(TextQuery query, SearchOptions options, SearchCallback callback) {
    final _searchByTextFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_searchByText__TextQuery_SearchOptions_SearchCallback'));
    final _queryHandle = sdkSearchTextqueryToFfi(query);
    final _optionsHandle = sdkSearchSearchoptionsToFfi(options);
    final _callbackHandle = sdkSearchSearchcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _searchByTextFfi(_handle, __lib.LibraryContext.isolateId, _queryHandle, _optionsHandle, _callbackHandle);
    sdkSearchTextqueryReleaseFfiHandle(_queryHandle);
    sdkSearchSearchoptionsReleaseFfiHandle(_optionsHandle);
    sdkSearchSearchcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle searchByAddress(AddressQuery query, SearchOptions options, SearchCallback callback) {
    final _searchByAddressFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_searchByAddress__AddressQuery_SearchOptions_SearchCallback'));
    final _queryHandle = sdkSearchAddressqueryToFfi(query);
    final _optionsHandle = sdkSearchSearchoptionsToFfi(options);
    final _callbackHandle = sdkSearchSearchcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _searchByAddressFfi(_handle, __lib.LibraryContext.isolateId, _queryHandle, _optionsHandle, _callbackHandle);
    sdkSearchAddressqueryReleaseFfiHandle(_queryHandle);
    sdkSearchSearchoptionsReleaseFfiHandle(_optionsHandle);
    sdkSearchSearchcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle searchByCategory(CategoryQuery query, SearchOptions options, SearchCallback callback) {
    final _searchByCategoryFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_searchByCategory__CategoryQuery_SearchOptions_SearchCallback'));
    final _queryHandle = sdkSearchCategoryqueryToFfi(query);
    final _optionsHandle = sdkSearchSearchoptionsToFfi(options);
    final _callbackHandle = sdkSearchSearchcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _searchByCategoryFfi(_handle, __lib.LibraryContext.isolateId, _queryHandle, _optionsHandle, _callbackHandle);
    sdkSearchCategoryqueryReleaseFfiHandle(_queryHandle);
    sdkSearchSearchoptionsReleaseFfiHandle(_optionsHandle);
    sdkSearchSearchcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle searchByCoordinates(GeoCoordinates coordinates, SearchOptions options, SearchCallback callback) {
    final _searchByCoordinatesFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_searchByCoordinates__GeoCoordinates_SearchOptions_SearchCallback'));
    final _coordinatesHandle = sdkCoreGeocoordinatesToFfi(coordinates);
    final _optionsHandle = sdkSearchSearchoptionsToFfi(options);
    final _callbackHandle = sdkSearchSearchcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _searchByCoordinatesFfi(_handle, __lib.LibraryContext.isolateId, _coordinatesHandle, _optionsHandle, _callbackHandle);
    sdkCoreGeocoordinatesReleaseFfiHandle(_coordinatesHandle);
    sdkSearchSearchoptionsReleaseFfiHandle(_optionsHandle);
    sdkSearchSearchcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle searchByPlaceId(PlaceIdQuery query, LanguageCode? languageCode, PlaceIdSearchCallback callback) {
    final _searchByPlaceIdFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_searchByPlaceId__PlaceIdQuery_LanguageCode__PlaceIdSearchCallback'));
    final _queryHandle = sdkSearchPlaceidqueryToFfi(query);
    final _languageCodeHandle = sdkCoreLanguagecodeToFfiNullable(languageCode);
    final _callbackHandle = sdkSearchPlaceidsearchcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _searchByPlaceIdFfi(_handle, __lib.LibraryContext.isolateId, _queryHandle, _languageCodeHandle, _callbackHandle);
    sdkSearchPlaceidqueryReleaseFfiHandle(_queryHandle);
    sdkCoreLanguagecodeReleaseFfiHandleNullable(_languageCodeHandle);
    sdkSearchPlaceidsearchcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle searchByPickedPlace(PickedPlace pickedPlace, LanguageCode? languageCode, PlaceIdSearchCallback callback) {
    final _searchByPickedPlaceFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_searchByPickedPlace__PickedPlace_LanguageCode__PlaceIdSearchCallback'));
    final _pickedPlaceHandle = sdkCorePickedplaceToFfi(pickedPlace);
    final _languageCodeHandle = sdkCoreLanguagecodeToFfiNullable(languageCode);
    final _callbackHandle = sdkSearchPlaceidsearchcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _searchByPickedPlaceFfi(_handle, __lib.LibraryContext.isolateId, _pickedPlaceHandle, _languageCodeHandle, _callbackHandle);
    sdkCorePickedplaceReleaseFfiHandle(_pickedPlaceHandle);
    sdkCoreLanguagecodeReleaseFfiHandleNullable(_languageCodeHandle);
    sdkSearchPlaceidsearchcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }

  @override
  TaskHandle suggestByText(TextQuery query, SearchOptions options, SuggestCallback callback) {
    final _suggestByTextFfi = __lib.catchArgumentError(() => __lib.nativeLibrary.lookupFunction<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<Void>, Pointer<Void>, Pointer<Void>), Pointer<Void> Function(Pointer<Void>, int, Pointer<Void>, Pointer<Void>, Pointer<Void>)>('here_sdk_sdk_search_SearchInterface_suggestByText__TextQuery_SearchOptions_SuggestCallback'));
    final _queryHandle = sdkSearchTextqueryToFfi(query);
    final _optionsHandle = sdkSearchSearchoptionsToFfi(options);
    final _callbackHandle = sdkSearchSuggestcallbackToFfi(callback);
    final _handle = this.handle;
    final __resultHandle = _suggestByTextFfi(_handle, __lib.LibraryContext.isolateId, _queryHandle, _optionsHandle, _callbackHandle);
    sdkSearchTextqueryReleaseFfiHandle(_queryHandle);
    sdkSearchSearchoptionsReleaseFfiHandle(_optionsHandle);
    sdkSearchSuggestcallbackReleaseFfiHandle(_callbackHandle);
    try {
      return sdkCoreThreadingTaskhandleFromFfi(__resultHandle);
    } finally {
      sdkCoreThreadingTaskhandleReleaseFfiHandle(__resultHandle);

    }

  }


}

int _sdkSearchSearchinterfacesearchByTextStatic(Object _obj, Pointer<Void> query, Pointer<Void> options, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).searchByText(sdkSearchTextqueryFromFfi(query), sdkSearchSearchoptionsFromFfi(options), sdkSearchSearchcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkSearchTextqueryReleaseFfiHandle(query);
    sdkSearchSearchoptionsReleaseFfiHandle(options);
    sdkSearchSearchcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkSearchSearchinterfacesearchByAddressStatic(Object _obj, Pointer<Void> query, Pointer<Void> options, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).searchByAddress(sdkSearchAddressqueryFromFfi(query), sdkSearchSearchoptionsFromFfi(options), sdkSearchSearchcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkSearchAddressqueryReleaseFfiHandle(query);
    sdkSearchSearchoptionsReleaseFfiHandle(options);
    sdkSearchSearchcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkSearchSearchinterfacesearchByCategoryStatic(Object _obj, Pointer<Void> query, Pointer<Void> options, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).searchByCategory(sdkSearchCategoryqueryFromFfi(query), sdkSearchSearchoptionsFromFfi(options), sdkSearchSearchcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkSearchCategoryqueryReleaseFfiHandle(query);
    sdkSearchSearchoptionsReleaseFfiHandle(options);
    sdkSearchSearchcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkSearchSearchinterfacesearchByCoordinatesStatic(Object _obj, Pointer<Void> coordinates, Pointer<Void> options, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).searchByCoordinates(sdkCoreGeocoordinatesFromFfi(coordinates), sdkSearchSearchoptionsFromFfi(options), sdkSearchSearchcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkCoreGeocoordinatesReleaseFfiHandle(coordinates);
    sdkSearchSearchoptionsReleaseFfiHandle(options);
    sdkSearchSearchcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkSearchSearchinterfacesearchByPlaceIdStatic(Object _obj, Pointer<Void> query, Pointer<Void> languageCode, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).searchByPlaceId(sdkSearchPlaceidqueryFromFfi(query), sdkCoreLanguagecodeFromFfiNullable(languageCode), sdkSearchPlaceidsearchcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkSearchPlaceidqueryReleaseFfiHandle(query);
    sdkCoreLanguagecodeReleaseFfiHandleNullable(languageCode);
    sdkSearchPlaceidsearchcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkSearchSearchinterfacesearchByPickedPlaceStatic(Object _obj, Pointer<Void> pickedPlace, Pointer<Void> languageCode, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).searchByPickedPlace(sdkCorePickedplaceFromFfi(pickedPlace), sdkCoreLanguagecodeFromFfiNullable(languageCode), sdkSearchPlaceidsearchcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkCorePickedplaceReleaseFfiHandle(pickedPlace);
    sdkCoreLanguagecodeReleaseFfiHandleNullable(languageCode);
    sdkSearchPlaceidsearchcallbackReleaseFfiHandle(callback);
  }
  return 0;
}
int _sdkSearchSearchinterfacesuggestByTextStatic(Object _obj, Pointer<Void> query, Pointer<Void> options, Pointer<Void> callback, Pointer<Pointer<Void>> _result) {
  TaskHandle? _resultObject;
  try {
    _resultObject = (_obj as SearchInterface).suggestByText(sdkSearchTextqueryFromFfi(query), sdkSearchSearchoptionsFromFfi(options), sdkSearchSuggestcallbackFromFfi(callback));
    _result.value = sdkCoreThreadingTaskhandleToFfi(_resultObject);
  } finally {
    sdkSearchTextqueryReleaseFfiHandle(query);
    sdkSearchSearchoptionsReleaseFfiHandle(options);
    sdkSearchSuggestcallbackReleaseFfiHandle(callback);
  }
  return 0;
}


Pointer<Void> sdkSearchSearchinterfaceToFfi(SearchInterface value) {
  if (value is __lib.NativeBase) return _sdkSearchSearchinterfaceCopyHandle((value as __lib.NativeBase).handle);

  final result = _sdkSearchSearchinterfaceCreateProxy(
    __lib.getObjectToken(value),
    __lib.LibraryContext.isolateId,
    value,
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesearchByTextStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesearchByAddressStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesearchByCategoryStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesearchByCoordinatesStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesearchByPlaceIdStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesearchByPickedPlaceStatic, __lib.unknownError),
    Pointer.fromFunction<Uint8 Function(Handle, Pointer<Void>, Pointer<Void>, Pointer<Void>, Pointer<Pointer<Void>>)>(_sdkSearchSearchinterfacesuggestByTextStatic, __lib.unknownError)
  );

  return result;
}

SearchInterface sdkSearchSearchinterfaceFromFfi(Pointer<Void> handle) {
  if (handle.address == 0) throw StateError("Expected non-null value.");
  final instance = __lib.getCachedInstance(handle);
  if (instance != null && instance is SearchInterface) return instance;

  final _typeIdHandle = _sdkSearchSearchinterfaceGetTypeId(handle);
  final factoryConstructor = __lib.typeRepository[stringFromFfi(_typeIdHandle)];
  stringReleaseFfiHandle(_typeIdHandle);

  final _copiedHandle = _sdkSearchSearchinterfaceCopyHandle(handle);
  final result = factoryConstructor != null
    ? factoryConstructor(_copiedHandle)
    : SearchInterface$Impl(_copiedHandle);
  __lib.cacheInstance(_copiedHandle, result);
  _sdkSearchSearchinterfaceRegisterFinalizer(_copiedHandle, __lib.LibraryContext.isolateId, result);
  return result;
}

void sdkSearchSearchinterfaceReleaseFfiHandle(Pointer<Void> handle) =>
  _sdkSearchSearchinterfaceReleaseHandle(handle);

Pointer<Void> sdkSearchSearchinterfaceToFfiNullable(SearchInterface? value) =>
  value != null ? sdkSearchSearchinterfaceToFfi(value) : Pointer<Void>.fromAddress(0);

SearchInterface? sdkSearchSearchinterfaceFromFfiNullable(Pointer<Void> handle) =>
  handle.address != 0 ? sdkSearchSearchinterfaceFromFfi(handle) : null;

void sdkSearchSearchinterfaceReleaseFfiHandleNullable(Pointer<Void> handle) =>
  _sdkSearchSearchinterfaceReleaseHandle(handle);

// End of SearchInterface "private" section.


