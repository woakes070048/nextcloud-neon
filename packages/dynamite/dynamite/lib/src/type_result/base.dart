part of 'type_result.dart';

@immutable
class TypeResultBase extends TypeResult {
  TypeResultBase(
    super.className, {
    super.nullable,
  });

  @override
  String? get _builderFactory => null;

  @override
  String? get _serializer => null;

  @override
  String serialize(final String object) => object;

  @override
  String encode(
    final String object, {
    final bool onlyChildren = false,
    final String? mimeType,
  }) =>
      name == 'String' ? object : '$object.toString()';

  @override
  String deserialize(final String object, {final bool toBuilder = false}) => '($object as $nullableName)';

  @override
  String decode(final String object) {
    switch (name) {
      case 'String':
        return '($object as String)';
      case 'int':
        return 'int.parse($object as String)';
      case 'bool':
        return "($object as String == 'true')";
      case 'JsonObject':
        return 'JsonObject($object)';
      default:
        throw Exception('Can not decode "$name" from String');
    }
  }

  @override
  TypeResultBase get dartType {
    final String dartName;
    switch (name) {
      case 'JsonObject':
        dartName = 'dynamic';
      default:
        dartName = name;
    }

    return TypeResultBase(dartName, nullable: nullable);
  }
}
