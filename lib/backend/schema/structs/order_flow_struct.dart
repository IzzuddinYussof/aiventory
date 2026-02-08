// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderFlowStruct extends BaseStruct {
  OrderFlowStruct({
    String? name,
    DateTime? date,
    String? remark,
    String? type,
  })  : _name = name,
        _date = date,
        _remark = remark,
        _type = type;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  // "remark" field.
  String? _remark;
  String get remark => _remark ?? '';
  set remark(String? val) => _remark = val;

  bool hasRemark() => _remark != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  static OrderFlowStruct fromMap(Map<String, dynamic> data) => OrderFlowStruct(
        name: data['name'] as String?,
        date: data['date'] as DateTime?,
        remark: data['remark'] as String?,
        type: data['type'] as String?,
      );

  static OrderFlowStruct? maybeFromMap(dynamic data) => data is Map
      ? OrderFlowStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'date': _date,
        'remark': _remark,
        'type': _type,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
        'remark': serializeParam(
          _remark,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
      }.withoutNulls;

  static OrderFlowStruct fromSerializableMap(Map<String, dynamic> data) =>
      OrderFlowStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        remark: deserializeParam(
          data['remark'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OrderFlowStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OrderFlowStruct &&
        name == other.name &&
        date == other.date &&
        remark == other.remark &&
        type == other.type;
  }

  @override
  int get hashCode => const ListEquality().hash([name, date, remark, type]);
}

OrderFlowStruct createOrderFlowStruct({
  String? name,
  DateTime? date,
  String? remark,
  String? type,
}) =>
    OrderFlowStruct(
      name: name,
      date: date,
      remark: remark,
      type: type,
    );
