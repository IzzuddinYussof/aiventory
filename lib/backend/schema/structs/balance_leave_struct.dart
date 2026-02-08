// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BalanceLeaveStruct extends BaseStruct {
  BalanceLeaveStruct({
    double? annual,
    double? sick,
    double? hospitalisation,
    double? marriage,
    double? paternity,
    double? compassionate,
    double? unpaidTaken,
    double? emergencyTaken,
  })  : _annual = annual,
        _sick = sick,
        _hospitalisation = hospitalisation,
        _marriage = marriage,
        _paternity = paternity,
        _compassionate = compassionate,
        _unpaidTaken = unpaidTaken,
        _emergencyTaken = emergencyTaken;

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

  // "unpaid_taken" field.
  double? _unpaidTaken;
  double get unpaidTaken => _unpaidTaken ?? 0.0;
  set unpaidTaken(double? val) => _unpaidTaken = val;

  void incrementUnpaidTaken(double amount) =>
      unpaidTaken = unpaidTaken + amount;

  bool hasUnpaidTaken() => _unpaidTaken != null;

  // "emergency_taken" field.
  double? _emergencyTaken;
  double get emergencyTaken => _emergencyTaken ?? 0.0;
  set emergencyTaken(double? val) => _emergencyTaken = val;

  void incrementEmergencyTaken(double amount) =>
      emergencyTaken = emergencyTaken + amount;

  bool hasEmergencyTaken() => _emergencyTaken != null;

  static BalanceLeaveStruct fromMap(Map<String, dynamic> data) =>
      BalanceLeaveStruct(
        annual: castToType<double>(data['annual']),
        sick: castToType<double>(data['sick']),
        hospitalisation: castToType<double>(data['hospitalisation']),
        marriage: castToType<double>(data['marriage']),
        paternity: castToType<double>(data['paternity']),
        compassionate: castToType<double>(data['compassionate']),
        unpaidTaken: castToType<double>(data['unpaid_taken']),
        emergencyTaken: castToType<double>(data['emergency_taken']),
      );

  static BalanceLeaveStruct? maybeFromMap(dynamic data) => data is Map
      ? BalanceLeaveStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'annual': _annual,
        'sick': _sick,
        'hospitalisation': _hospitalisation,
        'marriage': _marriage,
        'paternity': _paternity,
        'compassionate': _compassionate,
        'unpaid_taken': _unpaidTaken,
        'emergency_taken': _emergencyTaken,
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
        'paternity': serializeParam(
          _paternity,
          ParamType.double,
        ),
        'compassionate': serializeParam(
          _compassionate,
          ParamType.double,
        ),
        'unpaid_taken': serializeParam(
          _unpaidTaken,
          ParamType.double,
        ),
        'emergency_taken': serializeParam(
          _emergencyTaken,
          ParamType.double,
        ),
      }.withoutNulls;

  static BalanceLeaveStruct fromSerializableMap(Map<String, dynamic> data) =>
      BalanceLeaveStruct(
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
        unpaidTaken: deserializeParam(
          data['unpaid_taken'],
          ParamType.double,
          false,
        ),
        emergencyTaken: deserializeParam(
          data['emergency_taken'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'BalanceLeaveStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BalanceLeaveStruct &&
        annual == other.annual &&
        sick == other.sick &&
        hospitalisation == other.hospitalisation &&
        marriage == other.marriage &&
        paternity == other.paternity &&
        compassionate == other.compassionate &&
        unpaidTaken == other.unpaidTaken &&
        emergencyTaken == other.emergencyTaken;
  }

  @override
  int get hashCode => const ListEquality().hash([
        annual,
        sick,
        hospitalisation,
        marriage,
        paternity,
        compassionate,
        unpaidTaken,
        emergencyTaken
      ]);
}

BalanceLeaveStruct createBalanceLeaveStruct({
  double? annual,
  double? sick,
  double? hospitalisation,
  double? marriage,
  double? paternity,
  double? compassionate,
  double? unpaidTaken,
  double? emergencyTaken,
}) =>
    BalanceLeaveStruct(
      annual: annual,
      sick: sick,
      hospitalisation: hospitalisation,
      marriage: marriage,
      paternity: paternity,
      compassionate: compassionate,
      unpaidTaken: unpaidTaken,
      emergencyTaken: emergencyTaken,
    );
