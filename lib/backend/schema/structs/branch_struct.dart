// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BranchStruct extends BaseStruct {
  BranchStruct({
    int? id,
    String? label,
    String? region,
    int? chair,
  })  : _id = id,
        _label = label,
        _region = region,
        _chair = chair;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "Region" field.
  String? _region;
  String get region => _region ?? '';
  set region(String? val) => _region = val;

  bool hasRegion() => _region != null;

  // "chair" field.
  int? _chair;
  int get chair => _chair ?? 0;
  set chair(int? val) => _chair = val;

  void incrementChair(int amount) => chair = chair + amount;

  bool hasChair() => _chair != null;

  static BranchStruct fromMap(Map<String, dynamic> data) => BranchStruct(
        id: castToType<int>(data['id']),
        label: data['label'] as String?,
        region: data['Region'] as String?,
        chair: castToType<int>(data['chair']),
      );

  static BranchStruct? maybeFromMap(dynamic data) =>
      data is Map ? BranchStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'label': _label,
        'Region': _region,
        'chair': _chair,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'Region': serializeParam(
          _region,
          ParamType.String,
        ),
        'chair': serializeParam(
          _chair,
          ParamType.int,
        ),
      }.withoutNulls;

  static BranchStruct fromSerializableMap(Map<String, dynamic> data) =>
      BranchStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        region: deserializeParam(
          data['Region'],
          ParamType.String,
          false,
        ),
        chair: deserializeParam(
          data['chair'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'BranchStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BranchStruct &&
        id == other.id &&
        label == other.label &&
        region == other.region &&
        chair == other.chair;
  }

  @override
  int get hashCode => const ListEquality().hash([id, label, region, chair]);
}

BranchStruct createBranchStruct({
  int? id,
  String? label,
  String? region,
  int? chair,
}) =>
    BranchStruct(
      id: id,
      label: label,
      region: region,
      chair: chair,
    );
