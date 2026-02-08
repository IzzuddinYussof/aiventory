// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FullLeaveStruct extends BaseStruct {
  FullLeaveStruct({
    double? annual,
    double? sick,
    double? marriage,
    double? paternity,
    double? compassionate,
    double? hospitalisation,
  })  : _annual = annual,
        _sick = sick,
        _marriage = marriage,
        _paternity = paternity,
        _compassionate = compassionate,
        _hospitalisation = hospitalisation;

  // "annual" field.
  double? _annual;
  double get annual => _annual ?? 0.0;
  set annual(double? val) => _annual = val;

  void incrementAnnual(double amount) => annual = annual + amount;

  bool hasAnnual() => _annual != null;

  // "sick" field.
  double? _sick;
  double get sick => _sick ?? 0.0;
  set sick(double? val) => _sick = val;

  void incrementSick(double amount) => sick = sick + amount;

  bool hasSick() => _sick != null;

  // "marriage" field.
  double? _marriage;
  double get marriage => _marriage ?? 0.0;
  set marriage(double? val) => _marriage = val;

  void incrementMarriage(double amount) => marriage = marriage + amount;

  bool hasMarriage() => _marriage != null;

  // "paternity" field.
  double? _paternity;
  double get paternity => _paternity ?? 0.0;
  set paternity(double? val) => _paternity = val;

  void incrementPaternity(double amount) => paternity = paternity + amount;

  bool hasPaternity() => _paternity != null;

  // "compassionate" field.
  double? _compassionate;
  double get compassionate => _compassionate ?? 0.0;
  set compassionate(double? val) => _compassionate = val;

  void incrementCompassionate(double amount) =>
      compassionate = compassionate + amount;

  bool hasCompassionate() => _compassionate != null;

  // "hospitalisation" field.
  double? _hospitalisation;
  double get hospitalisation => _hospitalisation ?? 0.0;
  set hospitalisation(double? val) => _hospitalisation = val;

  void incrementHospitalisation(double amount) =>
      hospitalisation = hospitalisation + amount;

  bool hasHospitalisation() => _hospitalisation != null;

  static FullLeaveStruct fromMap(Map<String, dynamic> data) => FullLeaveStruct(
        annual: castToType<double>(data['annual']),
        sick: castToType<double>(data['sick']),
        marriage: castToType<double>(data['marriage']),
        paternity: castToType<double>(data['paternity']),
        compassionate: castToType<double>(data['compassionate']),
        hospitalisation: castToType<double>(data['hospitalisation']),
      );

  static FullLeaveStruct? maybeFromMap(dynamic data) => data is Map
      ? FullLeaveStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'annual': _annual,
        'sick': _sick,
        'marriage': _marriage,
        'paternity': _paternity,
        'compassionate': _compassionate,
        'hospitalisation': _hospitalisation,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'annual': serializeParam(
          _annual,
          ParamType.double,
        ),
        'sick': serializeParam(
          _sick,
          ParamType.double,
        ),
        'marriage': serializeParam(
          _marriage,
          ParamType.double,
        ),
        'paternity': serializeParam(
          _paternity,
          ParamType.double,
        ),
        'compassionate': serializeParam(
          _compassionate,
          ParamType.double,
        ),
        'hospitalisation': serializeParam(
          _hospitalisation,
          ParamType.double,
        ),
      }.withoutNulls;

  static FullLeaveStruct fromSerializableMap(Map<String, dynamic> data) =>
      FullLeaveStruct(
        annual: deserializeParam(
          data['annual'],
          ParamType.double,
          false,
        ),
        sick: deserializeParam(
          data['sick'],
          ParamType.double,
          false,
        ),
        marriage: deserializeParam(
          data['marriage'],
          ParamType.double,
          false,
        ),
        paternity: deserializeParam(
          data['paternity'],
          ParamType.double,
          false,
        ),
        compassionate: deserializeParam(
          data['compassionate'],
          ParamType.double,
          false,
        ),
        hospitalisation: deserializeParam(
          data['hospitalisation'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'FullLeaveStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FullLeaveStruct &&
        annual == other.annual &&
        sick == other.sick &&
        marriage == other.marriage &&
        paternity == other.paternity &&
        compassionate == other.compassionate &&
        hospitalisation == other.hospitalisation;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [annual, sick, marriage, paternity, compassionate, hospitalisation]);
}

FullLeaveStruct createFullLeaveStruct({
  double? annual,
  double? sick,
  double? marriage,
  double? paternity,
  double? compassionate,
  double? hospitalisation,
}) =>
    FullLeaveStruct(
      annual: annual,
      sick: sick,
      marriage: marriage,
      paternity: paternity,
      compassionate: compassionate,
      hospitalisation: hospitalisation,
    );
