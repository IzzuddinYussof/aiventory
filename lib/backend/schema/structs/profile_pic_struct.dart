// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProfilePicStruct extends BaseStruct {
  ProfilePicStruct({
    String? url,
  }) : _url = url;

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  set url(String? val) => _url = val;

  bool hasUrl() => _url != null;

  static ProfilePicStruct fromMap(Map<String, dynamic> data) =>
      ProfilePicStruct(
        url: data['url'] as String?,
      );

  static ProfilePicStruct? maybeFromMap(dynamic data) => data is Map
      ? ProfilePicStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'url': _url,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'url': serializeParam(
          _url,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProfilePicStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProfilePicStruct(
        url: deserializeParam(
          data['url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProfilePicStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProfilePicStruct && url == other.url;
  }

  @override
  int get hashCode => const ListEquality().hash([url]);
}

ProfilePicStruct createProfilePicStruct({
  String? url,
}) =>
    ProfilePicStruct(
      url: url,
    );
