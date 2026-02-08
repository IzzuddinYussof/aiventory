// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashboardHQDataStruct extends BaseStruct {
  DashboardHQDataStruct({
    double? totalInventory,
    int? orderCount,
    int? orderLate,
    double? expiring,
  })  : _totalInventory = totalInventory,
        _orderCount = orderCount,
        _orderLate = orderLate,
        _expiring = expiring;

  // "total_inventory" field.
  double? _totalInventory;
  double get totalInventory => _totalInventory ?? 0.0;
  set totalInventory(double? val) => _totalInventory = val;

  void incrementTotalInventory(double amount) =>
      totalInventory = totalInventory + amount;

  bool hasTotalInventory() => _totalInventory != null;

  // "order_count" field.
  int? _orderCount;
  int get orderCount => _orderCount ?? 0;
  set orderCount(int? val) => _orderCount = val;

  void incrementOrderCount(int amount) => orderCount = orderCount + amount;

  bool hasOrderCount() => _orderCount != null;

  // "order_late" field.
  int? _orderLate;
  int get orderLate => _orderLate ?? 0;
  set orderLate(int? val) => _orderLate = val;

  void incrementOrderLate(int amount) => orderLate = orderLate + amount;

  bool hasOrderLate() => _orderLate != null;

  // "expiring" field.
  double? _expiring;
  double get expiring => _expiring ?? 0.0;
  set expiring(double? val) => _expiring = val;

  void incrementExpiring(double amount) => expiring = expiring + amount;

  bool hasExpiring() => _expiring != null;

  static DashboardHQDataStruct fromMap(Map<String, dynamic> data) =>
      DashboardHQDataStruct(
        totalInventory: castToType<double>(data['total_inventory']),
        orderCount: castToType<int>(data['order_count']),
        orderLate: castToType<int>(data['order_late']),
        expiring: castToType<double>(data['expiring']),
      );

  static DashboardHQDataStruct? maybeFromMap(dynamic data) => data is Map
      ? DashboardHQDataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'total_inventory': _totalInventory,
        'order_count': _orderCount,
        'order_late': _orderLate,
        'expiring': _expiring,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'total_inventory': serializeParam(
          _totalInventory,
          ParamType.double,
        ),
        'order_count': serializeParam(
          _orderCount,
          ParamType.int,
        ),
        'order_late': serializeParam(
          _orderLate,
          ParamType.int,
        ),
        'expiring': serializeParam(
          _expiring,
          ParamType.double,
        ),
      }.withoutNulls;

  static DashboardHQDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      DashboardHQDataStruct(
        totalInventory: deserializeParam(
          data['total_inventory'],
          ParamType.double,
          false,
        ),
        orderCount: deserializeParam(
          data['order_count'],
          ParamType.int,
          false,
        ),
        orderLate: deserializeParam(
          data['order_late'],
          ParamType.int,
          false,
        ),
        expiring: deserializeParam(
          data['expiring'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DashboardHQDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DashboardHQDataStruct &&
        totalInventory == other.totalInventory &&
        orderCount == other.orderCount &&
        orderLate == other.orderLate &&
        expiring == other.expiring;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([totalInventory, orderCount, orderLate, expiring]);
}

DashboardHQDataStruct createDashboardHQDataStruct({
  double? totalInventory,
  int? orderCount,
  int? orderLate,
  double? expiring,
}) =>
    DashboardHQDataStruct(
      totalInventory: totalInventory,
      orderCount: orderCount,
      orderLate: orderLate,
      expiring: expiring,
    );
