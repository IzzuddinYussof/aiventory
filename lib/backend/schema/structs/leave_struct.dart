// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LeaveStruct extends BaseStruct {
  LeaveStruct({
    double? annual,
    double? sick,
    double? hospitalisation,
    double? marriage,
    double? compassionate,
    double? paternity,
    double? carryForward,
    double? carryPastYear,
  })  : _annual = annual,
        _sick = sick,
        _hospitalisation = hospitalisation,
        _marriage = marriage,
        _compassionate = compassionate,
        _paternity = paternity,
        _carryForward = carryForward,
        _carryPastYear = carryPastYear;

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

  // "hospitalisation" field.
  double? _hospitalisation;
  double get hospitalisation => _hospitalisation ?? 0.0;
  set hospitalisation(double? val) => _hospitalisation = val;

  void incrementHospitalisation(double amount) =>
      hospitalisation = hospitalisation + amount;

  bool hasHospitalisation() => _hospitalisation != null;

  // "marriage" field.
  double? _marriage;
  double get marriage => _marriage ?? 0.0;
  set marriage(double? val) => _marriage = val;

  void incrementMarriage(double amount) => marriage = marriage + amount;

  bool hasMarriage() => _marriage != null;

  // "compassionate" field.
  double? _compassionate;
  double get compassionate => _compassionate ?? 0.0;
  set compassionate(double? val) => _compassionate = val;

  void incrementCompassionate(double amount) =>
      compassionate = compassionate + amount;

  bool hasCompassionate() => _compassionate != null;

  // "paternity" field.
  double? _paternity;
  double get paternity => _paternity ?? 0.0;
  set paternity(double? val) => _paternity = val;

  void incrementPaternity(double amount) => paternity = paternity + amount;

  bool hasPaternity() => _paternity != null;

  // "carry_forward" field.
  double? _carryForward;
  double get carryForward => _carryForward ?? 0.0;
  set carryForward(double? val) => _carryForward = val;

  void incrementCarryForward(double amount) =>
      carryForward = carryForward + amount;

  bool hasCarryForward() => _carryForward != null;

  // "carryPastYear" field.
  double? _carryPastYear;
  double get carryPastYear => _carryPastYear ?? 0.0;
  set carryPastYear(double? val) => _carryPastYear = val;

  void incrementCarryPastYear(double amount) =>
      carryPastYear = carryPastYear + amount;

  bool hasCarryPastYear() => _carryPastYear != null;

  static LeaveStruct fromMap(Map<String, dynamic> data) => LeaveStruct(
        annual: castToType<double>(data['annual']),
        sick: castToType<double>(data['sick']),
        hospitalisation: castToType<double>(data['hospitalisation']),
        marriage: castToType<double>(data['marriage']),
        compassionate: castToType<double>(data['compassionate']),
        paternity: castToType<double>(data['paternity']),
        carryForward: castToType<double>(data['carry_forward']),
        carryPastYear: castToType<double>(data['carryPastYear']),
      );

  static LeaveStruct? maybeFromMap(dynamic data) =>
      data is Map ? LeaveStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'annual': _annual,
        'sick': _sick,
        'hospitalisation': _hospitalisation,
        'marriage': _marriage,
        'compassionate': _compassionate,
        'paternity': _paternity,
        'carry_forward': _carryForward,
        'carryPastYear': _carryPastYear,
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
        'hospitalisation': serializeParam(
          _hospitalisation,
          ParamType.double,
        ),
        'marriage': serializeParam(
          _marriage,
          ParamType.double,
        ),
        'compassionate': serializeParam(
          _compassionate,
          ParamType.double,
        ),
        'paternity': serializeParam(
          _paternity,
          ParamType.double,
        ),
        'carry_forward': serializeParam(
          _carryForward,
          ParamType.double,
        ),
        'carryPastYear': serializeParam(
          _carryPastYear,
          ParamType.double,
        ),
      }.withoutNulls;

  static LeaveStruct fromSerializableMap(Map<String, dynamic> data) =>
      LeaveStruct(
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
        hospitalisation: deserializeParam(
          data['hospitalisation'],
          ParamType.double,
          false,
        ),
        marriage: deserializeParam(
          data['marriage'],
          ParamType.double,
          false,
        ),
        compassionate: deserializeParam(
          data['compassionate'],
          ParamType.double,
          false,
        ),
        paternity: deserializeParam(
          data['paternity'],
          ParamType.double,
          false,
        ),
        carryForward: deserializeParam(
          data['carry_forward'],
          ParamType.double,
          false,
        ),
        carryPastYear: deserializeParam(
          data['carryPastYear'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'LeaveStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LeaveStruct &&
        annual == other.annual &&
        sick == other.sick &&
        hospitalisation == other.hospitalisation &&
        marriage == other.marriage &&
        compassionate == other.compassionate &&
        paternity == other.paternity &&
        carryForward == other.carryForward &&
        carryPastYear == other.carryPastYear;
  }

  @override
  int get hashCode => const ListEquality().hash([
        annual,
        sick,
        hospitalisation,
        marriage,
        compassionate,
        paternity,
        carryForward,
        carryPastYear
      ]);
}

LeaveStruct createLeaveStruct({
  double? annual,
  double? sick,
  double? hospitalisation,
  double? marriage,
  double? compassionate,
  double? paternity,
  double? carryForward,
  double? carryPastYear,
}) =>
    LeaveStruct(
      annual: annual,
      sick: sick,
      hospitalisation: hospitalisation,
      marriage: marriage,
      compassionate: compassionate,
      paternity: paternity,
      carryForward: carryForward,
      carryPastYear: carryPastYear,
    );
