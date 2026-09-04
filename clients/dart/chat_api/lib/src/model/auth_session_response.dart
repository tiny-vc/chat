//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/im_connection_response.dart';
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_session_response.g.dart';

/// AuthSessionResponse
///
/// Properties:
/// * [accessToken] 
/// * [refreshToken] 
/// * [user] 
/// * [im] 
@BuiltValue()
abstract class AuthSessionResponse implements Built<AuthSessionResponse, AuthSessionResponseBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  @BuiltValueField(wireName: r'im')
  ImConnectionResponse get im;

  AuthSessionResponse._();

  factory AuthSessionResponse([void updates(AuthSessionResponseBuilder b)]) = _$AuthSessionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthSessionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthSessionResponse> get serializer => _$AuthSessionResponseSerializer();
}

class _$AuthSessionResponseSerializer implements PrimitiveSerializer<AuthSessionResponse> {
  @override
  final Iterable<Type> types = const [AuthSessionResponse, _$AuthSessionResponse];

  @override
  final String wireName = r'AuthSessionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
    yield r'im';
    yield serializers.serialize(
      object.im,
      specifiedType: const FullType(ImConnectionResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthSessionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        case r'im':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImConnectionResponse),
          ) as ImConnectionResponse;
          result.im.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthSessionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthSessionResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

