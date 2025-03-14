// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// request body test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert';
import 'dart:typed_data';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i6;
import 'package:dynamite_runtime/built_value.dart' as _i5;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;
import 'package:uri/uri.dart' as _i4;

part 'request_body.openapi.g.dart';

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(super.baseURL, {super.httpClient});

  /// Creates a new [$Client] from another [client].
  $Client.fromClient(_i1.DynamiteClient client)
      : super(client.baseURL, httpClient: client.httpClient, authentications: client.authentications);

  /// Builds a serializer to parse the response of [$post_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $post_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [post] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [body]
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [post] for a method executing this request and parsing the response.
  ///  * [$post_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $post_Request({int? body, String? $body}) {
    final _parameters = <String, Object?>{};
    final __body = _$jsonSerializers.serialize(body, specifiedType: const FullType(int));
    _parameters['body'] = __body;

    final _path = _i4.UriTemplate('/{?body*}').expand(_parameters);
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('post', _uri);
    _request.headers['Content-Type'] = 'application/octet-stream';
    _request.bodyBytes = $body != null ? utf8.encode($body) : Uint8List(0);
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [body]
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$post_Request] for the request send by this method.
  ///  * [$post_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> post({int? body, String? $body}) async {
    final _request = $post_Request(body: body, $body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $post_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$getObject_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $getObject_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [getObject] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [getObject] for a method executing this request and parsing the response.
  ///  * [$getObject_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $getObject_Request({GetObjectRequestApplicationJson? $body}) {
    const _path = '/object';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Content-Type'] = 'application/json';
    _request.body = $body != null
        ? json.encode(
            _$jsonSerializers.serialize($body, specifiedType: const FullType(GetObjectRequestApplicationJson)),
          )
        : json.encode(
            _$jsonSerializers.serialize(
              GetObjectRequestApplicationJson(),
              specifiedType: const FullType(GetObjectRequestApplicationJson),
            ),
          );
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$getObject_Request] for the request send by this method.
  ///  * [$getObject_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> getObject({GetObjectRequestApplicationJson? $body}) async {
    final _request = $getObject_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $getObject_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$putObject_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $putObject_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [putObject] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [putObject] for a method executing this request and parsing the response.
  ///  * [$putObject_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $putObject_Request({PutObjectRequestApplicationJson? $body}) {
    const _path = '/object';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('put', _uri);
    _request.headers['Content-Type'] = 'application/json';
    _request.body = $body != null
        ? json.encode(
            _$jsonSerializers.serialize($body, specifiedType: const FullType(PutObjectRequestApplicationJson)),
          )
        : json.encode(
            _$jsonSerializers.serialize(
              PutObjectRequestApplicationJson(),
              specifiedType: const FullType(PutObjectRequestApplicationJson),
            ),
          );
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$putObject_Request] for the request send by this method.
  ///  * [$putObject_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> putObject({PutObjectRequestApplicationJson? $body}) async {
    final _request = $putObject_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $putObject_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$postObject_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $postObject_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [postObject] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [postObject] for a method executing this request and parsing the response.
  ///  * [$postObject_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $postObject_Request({required PostObjectRequestApplicationJson $body}) {
    const _path = '/object';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('post', _uri);
    _request.headers['Content-Type'] = 'application/json';
    _request.body = json.encode(
      _$jsonSerializers.serialize($body, specifiedType: const FullType(PostObjectRequestApplicationJson)),
    );
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$postObject_Request] for the request send by this method.
  ///  * [$postObject_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> postObject({required PostObjectRequestApplicationJson $body}) async {
    final _request = $postObject_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $postObject_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$deleteObject_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $deleteObject_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [deleteObject] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [deleteObject] for a method executing this request and parsing the response.
  ///  * [$deleteObject_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $deleteObject_Request({DeleteObjectRequestApplicationJson? $body}) {
    const _path = '/object';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('delete', _uri);
    _request.headers['Content-Type'] = 'application/json';
    _request.body = $body != null
        ? json.encode(
            _$jsonSerializers.serialize($body, specifiedType: const FullType(DeleteObjectRequestApplicationJson)),
          )
        : json.encode(const {'test': '123'});
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$deleteObject_Request] for the request send by this method.
  ///  * [$deleteObject_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> deleteObject({DeleteObjectRequestApplicationJson? $body}) async {
    final _request = $deleteObject_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $deleteObject_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$getBinary_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $getBinary_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [getBinary] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [getBinary] for a method executing this request and parsing the response.
  ///  * [$getBinary_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $getBinary_Request({Uint8List? $body}) {
    const _path = '/binary';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Content-Type'] = 'application/octet-stream';
    _request.bodyBytes = $body ?? Uint8List(0);
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$getBinary_Request] for the request send by this method.
  ///  * [$getBinary_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> getBinary({Uint8List? $body}) async {
    final _request = $getBinary_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $getBinary_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$putBinary_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $putBinary_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [putBinary] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [putBinary] for a method executing this request and parsing the response.
  ///  * [$putBinary_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $putBinary_Request({Uint8List? $body}) {
    const _path = '/binary';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('put', _uri);
    _request.headers['Content-Type'] = 'application/octet-stream';
    _request.bodyBytes = $body ?? const [116, 101, 115, 116];
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$putBinary_Request] for the request send by this method.
  ///  * [$putBinary_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> putBinary({Uint8List? $body}) async {
    final _request = $putBinary_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $putBinary_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }

  /// Builds a serializer to parse the response of [$postBinary_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<void, void> $postBinary_Serializer() =>
      _i1.DynamiteSerializer(bodyType: null, headersType: null, serializers: _$jsonSerializers);

  /// Returns a `DynamiteRequest` backing the [postBinary] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [postBinary] for a method executing this request and parsing the response.
  ///  * [$postBinary_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $postBinary_Request({required Uint8List $body}) {
    const _path = '/binary';
    final _uri = Uri.parse('$baseURL$_path');
    final _request = _i3.Request('post', _uri);
    _request.headers['Content-Type'] = 'application/octet-stream';
    _request.bodyBytes = $body;
    return _request;
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * default
  ///
  /// See:
  ///  * [$postBinary_Request] for the request send by this method.
  ///  * [$postBinary_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<void, void>> postBinary({required Uint8List $body}) async {
    final _request = $postBinary_Request($body: $body);
    final _streamedResponse = await httpClient.send(_request);
    final _response = await _i3.Response.fromStream(_streamedResponse);

    final _serializer = $postBinary_Serializer();
    return _i1.ResponseConverter<void, void>(_serializer).convert(_response);
  }
}

@BuiltValue(instantiable: false)
sealed class $GetObjectRequestApplicationJsonInterface {
  String? get test;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$GetObjectRequestApplicationJsonInterfaceBuilder].
  $GetObjectRequestApplicationJsonInterface rebuild(
    void Function($GetObjectRequestApplicationJsonInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$GetObjectRequestApplicationJsonInterfaceBuilder].
  $GetObjectRequestApplicationJsonInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($GetObjectRequestApplicationJsonInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($GetObjectRequestApplicationJsonInterfaceBuilder b) {}
}

abstract class GetObjectRequestApplicationJson
    implements
        $GetObjectRequestApplicationJsonInterface,
        Built<GetObjectRequestApplicationJson, GetObjectRequestApplicationJsonBuilder> {
  /// Creates a new GetObjectRequestApplicationJson object using the builder pattern.
  factory GetObjectRequestApplicationJson([void Function(GetObjectRequestApplicationJsonBuilder)? b]) =
      _$GetObjectRequestApplicationJson;

  const GetObjectRequestApplicationJson._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory GetObjectRequestApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for GetObjectRequestApplicationJson.
  static Serializer<GetObjectRequestApplicationJson> get serializer => _$getObjectRequestApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetObjectRequestApplicationJsonBuilder b) {
    $GetObjectRequestApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(GetObjectRequestApplicationJsonBuilder b) {
    $GetObjectRequestApplicationJsonInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $PutObjectRequestApplicationJsonInterface {
  static final _$test = _$jsonSerializers.deserialize('123', specifiedType: const FullType(String))! as String;

  String get test;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$PutObjectRequestApplicationJsonInterfaceBuilder].
  $PutObjectRequestApplicationJsonInterface rebuild(
    void Function($PutObjectRequestApplicationJsonInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$PutObjectRequestApplicationJsonInterfaceBuilder].
  $PutObjectRequestApplicationJsonInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($PutObjectRequestApplicationJsonInterfaceBuilder b) {
    b.test = _$test;
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($PutObjectRequestApplicationJsonInterfaceBuilder b) {}
}

abstract class PutObjectRequestApplicationJson
    implements
        $PutObjectRequestApplicationJsonInterface,
        Built<PutObjectRequestApplicationJson, PutObjectRequestApplicationJsonBuilder> {
  /// Creates a new PutObjectRequestApplicationJson object using the builder pattern.
  factory PutObjectRequestApplicationJson([void Function(PutObjectRequestApplicationJsonBuilder)? b]) =
      _$PutObjectRequestApplicationJson;

  const PutObjectRequestApplicationJson._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory PutObjectRequestApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for PutObjectRequestApplicationJson.
  static Serializer<PutObjectRequestApplicationJson> get serializer => _$putObjectRequestApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PutObjectRequestApplicationJsonBuilder b) {
    $PutObjectRequestApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(PutObjectRequestApplicationJsonBuilder b) {
    $PutObjectRequestApplicationJsonInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $PostObjectRequestApplicationJsonInterface {
  String? get test;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$PostObjectRequestApplicationJsonInterfaceBuilder].
  $PostObjectRequestApplicationJsonInterface rebuild(
    void Function($PostObjectRequestApplicationJsonInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$PostObjectRequestApplicationJsonInterfaceBuilder].
  $PostObjectRequestApplicationJsonInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($PostObjectRequestApplicationJsonInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($PostObjectRequestApplicationJsonInterfaceBuilder b) {}
}

abstract class PostObjectRequestApplicationJson
    implements
        $PostObjectRequestApplicationJsonInterface,
        Built<PostObjectRequestApplicationJson, PostObjectRequestApplicationJsonBuilder> {
  /// Creates a new PostObjectRequestApplicationJson object using the builder pattern.
  factory PostObjectRequestApplicationJson([void Function(PostObjectRequestApplicationJsonBuilder)? b]) =
      _$PostObjectRequestApplicationJson;

  const PostObjectRequestApplicationJson._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory PostObjectRequestApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for PostObjectRequestApplicationJson.
  static Serializer<PostObjectRequestApplicationJson> get serializer => _$postObjectRequestApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostObjectRequestApplicationJsonBuilder b) {
    $PostObjectRequestApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(PostObjectRequestApplicationJsonBuilder b) {
    $PostObjectRequestApplicationJsonInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $DeleteObjectRequestApplicationJsonInterface {
  String? get test;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$DeleteObjectRequestApplicationJsonInterfaceBuilder].
  $DeleteObjectRequestApplicationJsonInterface rebuild(
    void Function($DeleteObjectRequestApplicationJsonInterfaceBuilder) updates,
  );

  /// Converts the instance to a builder [$DeleteObjectRequestApplicationJsonInterfaceBuilder].
  $DeleteObjectRequestApplicationJsonInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($DeleteObjectRequestApplicationJsonInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($DeleteObjectRequestApplicationJsonInterfaceBuilder b) {}
}

abstract class DeleteObjectRequestApplicationJson
    implements
        $DeleteObjectRequestApplicationJsonInterface,
        Built<DeleteObjectRequestApplicationJson, DeleteObjectRequestApplicationJsonBuilder> {
  /// Creates a new DeleteObjectRequestApplicationJson object using the builder pattern.
  factory DeleteObjectRequestApplicationJson([void Function(DeleteObjectRequestApplicationJsonBuilder)? b]) =
      _$DeleteObjectRequestApplicationJson;

  const DeleteObjectRequestApplicationJson._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory DeleteObjectRequestApplicationJson.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for DeleteObjectRequestApplicationJson.
  static Serializer<DeleteObjectRequestApplicationJson> get serializer =>
      _$deleteObjectRequestApplicationJsonSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteObjectRequestApplicationJsonBuilder b) {
    $DeleteObjectRequestApplicationJsonInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(DeleteObjectRequestApplicationJsonBuilder b) {
    $DeleteObjectRequestApplicationJsonInterface._validate(b);
  }
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
      ..addBuilderFactory(
        const FullType(GetObjectRequestApplicationJson),
        GetObjectRequestApplicationJsonBuilder.new,
      )
      ..add(GetObjectRequestApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PutObjectRequestApplicationJson),
        PutObjectRequestApplicationJsonBuilder.new,
      )
      ..add(PutObjectRequestApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(PostObjectRequestApplicationJson),
        PostObjectRequestApplicationJsonBuilder.new,
      )
      ..add(PostObjectRequestApplicationJson.serializer)
      ..addBuilderFactory(
        const FullType(DeleteObjectRequestApplicationJson),
        DeleteObjectRequestApplicationJsonBuilder.new,
      )
      ..add(DeleteObjectRequestApplicationJson.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i5.DynamiteDoubleSerializer())
      ..addPlugin(_i6.StandardJsonPlugin())
      ..addPlugin(const _i5.HeaderPlugin())
      ..addPlugin(const _i5.ContentStringPlugin()))
    .build();
// coverage:ignore-end
