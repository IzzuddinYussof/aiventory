// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UpdatesStruct extends BaseStruct {
  UpdatesStruct({
    String? name,
    int? timestamp,
    String? branch,
  })  : _name = name,
        _timestamp = timestamp,
        _branch = branch;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "timestamp" field.
  int? _timestamp;
  int get timestamp => _timestamp ?? 0;
  set timestamp(int? val) => _timestamp = val;

  void incrementTimestamp(int amount) => timestamp = timestamp + amount;

  bool hasTimestamp() => _timestamp != null;

  // "branch" field.
  String? _branch;
  String get branch => _branch ?? '';
  set branch(String? val) => _branch = val;

  bool hasBranch() => _branch != null;

  static UpdatesStruct fromMap(Map<String, dynamic> data) => UpdatesStruct(
        name: data['name'] as String?,
        timestamp: castToType<int>(data['timestamp']),
        branch: data['branch'] as String?,
      );

  static UpdatesStruct? maybeFromMap(dynamic data) =>
      data is Map ? UpdatesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'timestamp': _timestamp,
        'branch': _branch,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.int,
        ),
        'branch': serializeParam(
          _branch,
          ParamType.String,
        ),
      }.withoutNulls;

  static UpdatesStruct fromSerializableMap(Map<String, dynamic> data) =>
      UpdatesStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.int,
          false,
        ),
        branch: deserializeParam(
          data['branch'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UpdatesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UpdatesStruct &&
        name == other.name &&
        timestamp == other.timestamp &&
        branch == other.branch;
  }

  @override
  int get hashCode => const ListEquality().hash([name, timestamp, branch]);
}

UpdatesStruct createUpdatesStruct({
  String? name,
  int? timestamp,
  String? branch,
}) =>
    UpdatesStruct(
      name: name,
      timestamp: timestamp,
      branch: branch,
    );
