// ignore_for_file: camel_case_types
// ignore_for_file: public_member_api_docs
import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite_runtime/content_string.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:universal_io/io.dart';

export 'package:dynamite_runtime/http_client.dart';

part 'theming.openapi.g.dart';

class ThemingResponse<T, U> extends DynamiteResponse<T, U> {
  ThemingResponse(
    super.data,
    super.headers,
  );

  @override
  String toString() => 'ThemingResponse(data: $data, headers: $headers)';
}

class ThemingApiException extends DynamiteApiException {
  ThemingApiException(
    super.statusCode,
    super.headers,
    super.body,
  );

  static Future<ThemingApiException> fromResponse(final HttpClientResponse response) async {
    final data = await response.bodyBytes;

    String body;
    try {
      body = utf8.decode(data);
    } on FormatException {
      body = 'binary';
    }

    return ThemingApiException(
      response.statusCode,
      response.responseHeaders,
      body,
    );
  }

  @override
  String toString() => 'ThemingApiException(statusCode: $statusCode, headers: $headers, body: $body)';
}

class ThemingClient extends DynamiteClient {
  ThemingClient(
    super.baseURL, {
    super.baseHeaders,
    super.userAgent,
    super.httpClient,
    super.cookieJar,
    super.authentications,
  });

  ThemingClient.fromClient(final DynamiteClient client)
      : super(
          client.baseURL,
          baseHeaders: client.baseHeaders,
          httpClient: client.httpClient,
          cookieJar: client.cookieJar,
          authentications: client.authentications,
        );

  ThemingIconClient get icon => ThemingIconClient(this);
  ThemingThemingClient get theming => ThemingThemingClient(this);
  ThemingUserThemeClient get userTheme => ThemingUserThemeClient(this);
}

class ThemingIconClient {
  ThemingIconClient(this.rootClient);

  final ThemingClient rootClient;

  /// Return a 32x32 favicon as png
  Future<Uint8List> getFavicon({final String app = 'core'}) async {
    var path = '/index.php/apps/theming/favicon/{app}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'image/x-icon',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    }
    path = path.replaceAll('{app}', Uri.encodeQueryComponent(app));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Return a 512x512 icon for touch devices
  Future<Uint8List> getTouchIcon({final String app = 'core'}) async {
    var path = '/index.php/apps/theming/icon/{app}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'image/png',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    }
    path = path.replaceAll('{app}', Uri.encodeQueryComponent(app));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Get a themed icon
  Future<Uint8List> getThemedIcon({
    required final String app,
    required final String image,
  }) async {
    var path = '/index.php/apps/theming/img/{app}/{image}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'image/svg+xml',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    }
    path = path.replaceAll('{app}', Uri.encodeQueryComponent(app));
    if (!RegExp(r'^.+$').hasMatch(image)) {
      throw Exception('Invalid value "$image" for parameter "image" with pattern "${r'^.+$'}"'); // coverage:ignore-line
    }
    path = path.replaceAll('{image}', Uri.encodeQueryComponent(image));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }
}

/// Class ThemingController
/// handle ajax requests to update the theme
class ThemingThemingClient {
  ThemingThemingClient(this.rootClient);

  final ThemingClient rootClient;

  /// Get the CSS stylesheet for a theme
  Future<String> getThemeStylesheet({
    required final String themeId,
    final int plain = 0,
    final int withCustomCss = 0,
  }) async {
    var path = '/index.php/apps/theming/theme/{themeId}.css';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'text/css',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    }
    path = path.replaceAll('{themeId}', Uri.encodeQueryComponent(themeId));
    if (plain != 0) {
      queryParameters['plain'] = plain.toString();
    }
    if (withCustomCss != 0) {
      queryParameters['withCustomCss'] = withCustomCss.toString();
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Get an image
  Future<Uint8List> getImage({
    required final String key,
    final int useSvg = 1,
  }) async {
    var path = '/index.php/apps/theming/image/{key}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': '*/*',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    }
    path = path.replaceAll('{key}', Uri.encodeQueryComponent(key));
    if (useSvg != 1) {
      queryParameters['useSvg'] = useSvg.toString();
    }
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Get the manifest for an app
  Future<ThemingThemingGetManifestResponse200ApplicationJson> getManifest({required final String app}) async {
    var path = '/index.php/apps/theming/manifest/{app}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    }
    path = path.replaceAll('{app}', Uri.encodeQueryComponent(app));
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return _jsonSerializers.deserialize(
        await response.jsonBody,
        specifiedType: const FullType(ThemingThemingGetManifestResponse200ApplicationJson),
      )! as ThemingThemingGetManifestResponse200ApplicationJson;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }
}

class ThemingUserThemeClient {
  ThemingUserThemeClient(this.rootClient);

  final ThemingClient rootClient;

  /// Get the background image
  Future<Uint8List> getBackground({final String oCSAPIRequest = 'true'}) async {
    const path = '/index.php/apps/theming/background';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': '*/*',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth'); // coverage:ignore-line
    }
    headers['OCS-APIRequest'] = oCSAPIRequest;
    final response = await rootClient.doRequest(
      'get',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Set the background
  Future<ThemingBackground> setBackground({
    required final String type,
    final String value = '',
    final String? color,
    final String oCSAPIRequest = 'true',
  }) async {
    var path = '/index.php/apps/theming/background/{type}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth'); // coverage:ignore-line
    }
    path = path.replaceAll('{type}', Uri.encodeQueryComponent(type));
    if (value != '') {
      queryParameters['value'] = value;
    }
    if (color != null) {
      queryParameters['color'] = color;
    }
    headers['OCS-APIRequest'] = oCSAPIRequest;
    final response = await rootClient.doRequest(
      'post',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return _jsonSerializers.deserialize(await response.jsonBody, specifiedType: const FullType(ThemingBackground))!
          as ThemingBackground;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Delete the background
  Future<ThemingBackground> deleteBackground({final String oCSAPIRequest = 'true'}) async {
    const path = '/index.php/apps/theming/background/custom';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth'); // coverage:ignore-line
    }
    headers['OCS-APIRequest'] = oCSAPIRequest;
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return _jsonSerializers.deserialize(await response.jsonBody, specifiedType: const FullType(ThemingBackground))!
          as ThemingBackground;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Enable theme
  Future<ThemingUserThemeEnableThemeResponse200ApplicationJson> enableTheme({
    required final String themeId,
    final String oCSAPIRequest = 'true',
  }) async {
    var path = '/ocs/v2.php/apps/theming/api/v1/theme/{themeId}/enable';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth'); // coverage:ignore-line
    }
    path = path.replaceAll('{themeId}', Uri.encodeQueryComponent(themeId));
    headers['OCS-APIRequest'] = oCSAPIRequest;
    final response = await rootClient.doRequest(
      'put',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return _jsonSerializers.deserialize(
        await response.jsonBody,
        specifiedType: const FullType(ThemingUserThemeEnableThemeResponse200ApplicationJson),
      )! as ThemingUserThemeEnableThemeResponse200ApplicationJson;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }

  /// Disable theme
  Future<ThemingUserThemeDisableThemeResponse200ApplicationJson> disableTheme({
    required final String themeId,
    final String oCSAPIRequest = 'true',
  }) async {
    var path = '/ocs/v2.php/apps/theming/api/v1/theme/{themeId}';
    final queryParameters = <String, dynamic>{};
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    Uint8List? body;
    if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'bearer').isNotEmpty) {
      headers.addAll(
        rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'bearer').headers,
      );
    } else if (rootClient.authentications.where((final a) => a.type == 'http' && a.scheme == 'basic').isNotEmpty) {
      headers
          .addAll(rootClient.authentications.singleWhere((final a) => a.type == 'http' && a.scheme == 'basic').headers);
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth'); // coverage:ignore-line
    }
    path = path.replaceAll('{themeId}', Uri.encodeQueryComponent(themeId));
    headers['OCS-APIRequest'] = oCSAPIRequest;
    final response = await rootClient.doRequest(
      'delete',
      Uri(path: path, queryParameters: queryParameters.isNotEmpty ? queryParameters : null).toString(),
      headers,
      body,
    );
    if (response.statusCode == 200) {
      return _jsonSerializers.deserialize(
        await response.jsonBody,
        specifiedType: const FullType(ThemingUserThemeDisableThemeResponse200ApplicationJson),
      )! as ThemingUserThemeDisableThemeResponse200ApplicationJson;
    }
    throw await ThemingApiException.fromResponse(response); // coverage:ignore-line
  }
}

abstract class ThemingThemingGetManifestResponse200ApplicationJson_Icons
    implements
        Built<ThemingThemingGetManifestResponse200ApplicationJson_Icons,
            ThemingThemingGetManifestResponse200ApplicationJson_IconsBuilder> {
  factory ThemingThemingGetManifestResponse200ApplicationJson_Icons([
    final void Function(ThemingThemingGetManifestResponse200ApplicationJson_IconsBuilder)? b,
  ]) = _$ThemingThemingGetManifestResponse200ApplicationJson_Icons;
  const ThemingThemingGetManifestResponse200ApplicationJson_Icons._();

  factory ThemingThemingGetManifestResponse200ApplicationJson_Icons.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  String get src;
  String get type;
  String get sizes;
  static Serializer<ThemingThemingGetManifestResponse200ApplicationJson_Icons> get serializer =>
      _$themingThemingGetManifestResponse200ApplicationJsonIconsSerializer;
}

abstract class ThemingThemingGetManifestResponse200ApplicationJson
    implements
        Built<ThemingThemingGetManifestResponse200ApplicationJson,
            ThemingThemingGetManifestResponse200ApplicationJsonBuilder> {
  factory ThemingThemingGetManifestResponse200ApplicationJson([
    final void Function(ThemingThemingGetManifestResponse200ApplicationJsonBuilder)? b,
  ]) = _$ThemingThemingGetManifestResponse200ApplicationJson;
  const ThemingThemingGetManifestResponse200ApplicationJson._();

  factory ThemingThemingGetManifestResponse200ApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  String get name;
  @BuiltValueField(wireName: 'short_name')
  String get shortName;
  @BuiltValueField(wireName: 'start_url')
  String get startUrl;
  @BuiltValueField(wireName: 'theme_color')
  String get themeColor;
  @BuiltValueField(wireName: 'background_color')
  String get backgroundColor;
  String get description;
  BuiltList<ThemingThemingGetManifestResponse200ApplicationJson_Icons> get icons;
  String get display;
  static Serializer<ThemingThemingGetManifestResponse200ApplicationJson> get serializer =>
      _$themingThemingGetManifestResponse200ApplicationJsonSerializer;
}

abstract class ThemingBackground implements Built<ThemingBackground, ThemingBackgroundBuilder> {
  factory ThemingBackground([final void Function(ThemingBackgroundBuilder)? b]) = _$ThemingBackground;
  const ThemingBackground._();

  factory ThemingBackground.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  String? get backgroundImage;
  String get backgroundColor;
  int get version;
  static Serializer<ThemingBackground> get serializer => _$themingBackgroundSerializer;
}

abstract class ThemingOCSMeta implements Built<ThemingOCSMeta, ThemingOCSMetaBuilder> {
  factory ThemingOCSMeta([final void Function(ThemingOCSMetaBuilder)? b]) = _$ThemingOCSMeta;
  const ThemingOCSMeta._();

  factory ThemingOCSMeta.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  String get status;
  int get statuscode;
  String? get message;
  String? get totalitems;
  String? get itemsperpage;
  static Serializer<ThemingOCSMeta> get serializer => _$themingOCSMetaSerializer;
}

abstract class ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs
    implements
        Built<ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs,
            ThemingUserThemeEnableThemeResponse200ApplicationJson_OcsBuilder> {
  factory ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs([
    final void Function(ThemingUserThemeEnableThemeResponse200ApplicationJson_OcsBuilder)? b,
  ]) = _$ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs;
  const ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs._();

  factory ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  ThemingOCSMeta get meta;
  JsonObject get data;
  static Serializer<ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs> get serializer =>
      _$themingUserThemeEnableThemeResponse200ApplicationJsonOcsSerializer;
}

abstract class ThemingUserThemeEnableThemeResponse200ApplicationJson
    implements
        Built<ThemingUserThemeEnableThemeResponse200ApplicationJson,
            ThemingUserThemeEnableThemeResponse200ApplicationJsonBuilder> {
  factory ThemingUserThemeEnableThemeResponse200ApplicationJson([
    final void Function(ThemingUserThemeEnableThemeResponse200ApplicationJsonBuilder)? b,
  ]) = _$ThemingUserThemeEnableThemeResponse200ApplicationJson;
  const ThemingUserThemeEnableThemeResponse200ApplicationJson._();

  factory ThemingUserThemeEnableThemeResponse200ApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs get ocs;
  static Serializer<ThemingUserThemeEnableThemeResponse200ApplicationJson> get serializer =>
      _$themingUserThemeEnableThemeResponse200ApplicationJsonSerializer;
}

abstract class ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs
    implements
        Built<ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs,
            ThemingUserThemeDisableThemeResponse200ApplicationJson_OcsBuilder> {
  factory ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs([
    final void Function(ThemingUserThemeDisableThemeResponse200ApplicationJson_OcsBuilder)? b,
  ]) = _$ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs;
  const ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs._();

  factory ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  ThemingOCSMeta get meta;
  JsonObject get data;
  static Serializer<ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs> get serializer =>
      _$themingUserThemeDisableThemeResponse200ApplicationJsonOcsSerializer;
}

abstract class ThemingUserThemeDisableThemeResponse200ApplicationJson
    implements
        Built<ThemingUserThemeDisableThemeResponse200ApplicationJson,
            ThemingUserThemeDisableThemeResponse200ApplicationJsonBuilder> {
  factory ThemingUserThemeDisableThemeResponse200ApplicationJson([
    final void Function(ThemingUserThemeDisableThemeResponse200ApplicationJsonBuilder)? b,
  ]) = _$ThemingUserThemeDisableThemeResponse200ApplicationJson;
  const ThemingUserThemeDisableThemeResponse200ApplicationJson._();

  factory ThemingUserThemeDisableThemeResponse200ApplicationJson.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs get ocs;
  static Serializer<ThemingUserThemeDisableThemeResponse200ApplicationJson> get serializer =>
      _$themingUserThemeDisableThemeResponse200ApplicationJsonSerializer;
}

abstract class ThemingPublicCapabilities_Theming
    implements Built<ThemingPublicCapabilities_Theming, ThemingPublicCapabilities_ThemingBuilder> {
  factory ThemingPublicCapabilities_Theming([final void Function(ThemingPublicCapabilities_ThemingBuilder)? b]) =
      _$ThemingPublicCapabilities_Theming;
  const ThemingPublicCapabilities_Theming._();

  factory ThemingPublicCapabilities_Theming.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  String get name;
  String get url;
  String get slogan;
  String get color;
  @BuiltValueField(wireName: 'color-text')
  String get colorText;
  @BuiltValueField(wireName: 'color-element')
  String get colorElement;
  @BuiltValueField(wireName: 'color-element-bright')
  String get colorElementBright;
  @BuiltValueField(wireName: 'color-element-dark')
  String get colorElementDark;
  String get logo;
  String get background;
  @BuiltValueField(wireName: 'background-plain')
  bool get backgroundPlain;
  @BuiltValueField(wireName: 'background-default')
  bool get backgroundDefault;
  String get logoheader;
  String get favicon;
  static Serializer<ThemingPublicCapabilities_Theming> get serializer => _$themingPublicCapabilitiesThemingSerializer;
}

abstract class ThemingPublicCapabilities implements Built<ThemingPublicCapabilities, ThemingPublicCapabilitiesBuilder> {
  factory ThemingPublicCapabilities([final void Function(ThemingPublicCapabilitiesBuilder)? b]) =
      _$ThemingPublicCapabilities;
  const ThemingPublicCapabilities._();

  factory ThemingPublicCapabilities.fromJson(final Map<String, dynamic> json) =>
      _jsonSerializers.deserializeWith(serializer, json)!;

  Map<String, dynamic> toJson() => _jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  ThemingPublicCapabilities_Theming get theming;
  static Serializer<ThemingPublicCapabilities> get serializer => _$themingPublicCapabilitiesSerializer;
}

final Serializers _serializers = (Serializers().toBuilder()
      ..addBuilderFactory(
        const FullType(ThemingThemingGetManifestResponse200ApplicationJson),
        ThemingThemingGetManifestResponse200ApplicationJson.new,
      )
      ..add(ThemingThemingGetManifestResponse200ApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ThemingThemingGetManifestResponse200ApplicationJson_Icons),
        ThemingThemingGetManifestResponse200ApplicationJson_Icons.new,
      )
      ..add(ThemingThemingGetManifestResponse200ApplicationJson_Icons.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ThemingThemingGetManifestResponse200ApplicationJson_Icons)]),
        ListBuilder<ThemingThemingGetManifestResponse200ApplicationJson_Icons>.new,
      )
      ..addBuilderFactory(const FullType(ThemingBackground), ThemingBackground.new)
      ..add(ThemingBackground.serializer)
      ..addBuilderFactory(
        const FullType(ThemingUserThemeEnableThemeResponse200ApplicationJson),
        ThemingUserThemeEnableThemeResponse200ApplicationJson.new,
      )
      ..add(ThemingUserThemeEnableThemeResponse200ApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs),
        ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs.new,
      )
      ..add(ThemingUserThemeEnableThemeResponse200ApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(ThemingOCSMeta), ThemingOCSMeta.new)
      ..add(ThemingOCSMeta.serializer)
      ..addBuilderFactory(
        const FullType(ThemingUserThemeDisableThemeResponse200ApplicationJson),
        ThemingUserThemeDisableThemeResponse200ApplicationJson.new,
      )
      ..add(ThemingUserThemeDisableThemeResponse200ApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs),
        ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs.new,
      )
      ..add(ThemingUserThemeDisableThemeResponse200ApplicationJson_Ocs.serializer)
      ..addBuilderFactory(const FullType(ThemingPublicCapabilities), ThemingPublicCapabilities.new)
      ..add(ThemingPublicCapabilities.serializer)
      ..addBuilderFactory(const FullType(ThemingPublicCapabilities_Theming), ThemingPublicCapabilities_Theming.new)
      ..add(ThemingPublicCapabilities_Theming.serializer))
    .build();

Serializers get themingSerializers => _serializers;

final Serializers _jsonSerializers = (_serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const ContentStringPlugin()))
    .build();

// coverage:ignore-start
T deserializeTheming<T>(final Object data) => _serializers.deserialize(data, specifiedType: FullType(T))! as T;

Object? serializeTheming<T>(final T data) => _serializers.serialize(data, specifiedType: FullType(T));
// coverage:ignore-end
