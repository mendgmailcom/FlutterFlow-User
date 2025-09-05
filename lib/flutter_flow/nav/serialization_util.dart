import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

import '../../flutter_flow/lat_lng.dart';
import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.intType:
        data = param.toString();
      case ParamType.doubleType:
        data = param.toString();
      case ParamType.stringType:
        data = param;
      case ParamType.boolType:
        data = param ? 'true' : 'false';
      case ParamType.dateTimeType:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.dateTimeRangeType:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.latLngType:
        data = (param as LatLng).serialize();
      case ParamType.colorType:
        data = (param as Color).toCssString();
      case ParamType.ffPlaceType:
        data = placeToString(param as FFPlace);
      case ParamType.ffUploadedFileType:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.jsonType:
        data = json.encode(param);

      // No default case needed as all ParamType values are covered
    }
    return data;
  } catch (e) {
    // Error serializing parameter: $e
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  intType,
  doubleType,
  stringType,
  boolType,
  dateTimeType,
  dateTimeRangeType,
  latLngType,
  colorType,
  ffPlaceType,
  ffUploadedFileType,
  jsonType,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList,
) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((p) => deserializeParam<T>(p, paramType, false))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.intType:
        return int.tryParse(param);
      case ParamType.doubleType:
        return double.tryParse(param);
      case ParamType.stringType:
        return param;
      case ParamType.boolType:
        return param == 'true';
      case ParamType.dateTimeType:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.dateTimeRangeType:
        return dateTimeRangeFromString(param);
      case ParamType.latLngType:
        return latLngFromString(param);
      case ParamType.colorType:
        return fromCssColor(param);
      case ParamType.ffPlaceType:
        return placeFromString(param);
      case ParamType.ffUploadedFileType:
        return uploadedFileFromString(param);
      case ParamType.jsonType:
        return json.decode(param);

      // No default case needed as all ParamType values are covered
    }
  } catch (e) {
    // Error deserializing parameter: $e
    return null;
  }
}
