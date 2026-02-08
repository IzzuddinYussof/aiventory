// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CancelStruct extends BaseStruct {
  CancelStruct({
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

  static CancelStruct fromMap(Map<String, dynamic> data) => CancelStruct(
        name: data['name'] as String?,
        date: castToType<int>(data['date']),
        remark: data['remark'] as String?,
      );

  static CancelStruct? maybeFromMap(dynamic data) =>
      data is Map ? CancelStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static CancelStruct fromSerializableMap(Map<String, dynamic> data) =>
      CancelStruct(
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
  String toString() => 'CancelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CancelStruct &&
        name == other.name &&
        date == other.date &&
        remark == other.remark;
  }

  @override
  int get hashCode => const ListEquality().hash([name, date, remark]);
}

CancelStruct createCancelStruct({
  String? name,
  int? date,
  String? remark,
}) =>
    CancelStruct(
      name: name,
      date: date,
      remark: remark,
    );
