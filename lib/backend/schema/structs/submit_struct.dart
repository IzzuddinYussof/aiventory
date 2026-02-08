// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubmitStruct extends BaseStruct {
  SubmitStruct({
    String? name,
    int? date,
    String? remark,
  })  : _name = name,
        _date = date,
        _remark = remark;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "date" field.
  int? _date;
  int get date => _date ?? 0;
  set date(int? val) => _date = val;

  void incrementDate(int amount) => date = date + amount;

  bool hasDate() => _date != null;

  // "remark" field.
  String? _remark;
  String get remark => _remark ?? '';
  set remark(String? val) => _remark = val;

  bool hasRemark() => _remark != null;

  static SubmitStruct fromMap(Map<String, dynamic> data) => SubmitStruct(
        name: data['name'] as String?,
        date: castToType<int>(data['date']),
        remark: data['remark'] as String?,
      );

  static SubmitStruct? maybeFromMap(dynamic data) =>
      data is Map ? SubmitStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'date': _date,
        'remark': _remark,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.int,
        ),
        'remark': serializeParam(
          _remark,
          ParamType.String,
        ),
      }.withoutNulls;

  static SubmitStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubmitStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.int,
          false,
        ),
        remark: deserializeParam(
          data['remark'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SubmitStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubmitStruct &&
        name == other.name &&
        date == other.date &&
        remark == other.remark;
  }

  @override
  int get hashCode => const ListEquality().hash([name, date, remark]);
}

SubmitStruct createSubmitStruct({
  String? name,
  int? date,
  String? remark,
}) =>
    SubmitStruct(
      name: name,
      date: date,
      remark: remark,
    );
