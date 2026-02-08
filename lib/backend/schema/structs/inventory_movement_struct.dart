// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InventoryMovementStruct extends BaseStruct {
  InventoryMovementStruct({
    int? id,
    int? createdAt,
    int? inventoryId,
    String? branch,
    String? expiryDate,
    double? quantity,
    int? lastUpdate,
    int? branchIdFrom,
    int? branchIdTo,
    String? unit,
    double? unitCost,
    double? totalCost,
    String? txType,
    String? note,
    String? doc,
    String? checksum,
    List<UpdatesStruct>? updates,
  })  : _id = id,
        _createdAt = createdAt,
        _inventoryId = inventoryId,
        _branch = branch,
        _expiryDate = expiryDate,
        _quantity = quantity,
        _lastUpdate = lastUpdate,
        _branchIdFrom = branchIdFrom,
        _branchIdTo = branchIdTo,
        _unit = unit,
        _unitCost = unitCost,
        _totalCost = totalCost,
        _txType = txType,
        _note = note,
        _doc = doc,
        _checksum = checksum,
        _updates = updates;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "created_at" field.
  int? _createdAt;
  int get createdAt => _createdAt ?? 0;
  set createdAt(int? val) => _createdAt = val;

  void incrementCreatedAt(int amount) => createdAt = createdAt + amount;

  bool hasCreatedAt() => _createdAt != null;

  // "inventory_id" field.
  int? _inventoryId;
  int get inventoryId => _inventoryId ?? 0;
  set inventoryId(int? val) => _inventoryId = val;

  void incrementInventoryId(int amount) => inventoryId = inventoryId + amount;

  bool hasInventoryId() => _inventoryId != null;

  // "branch" field.
  String? _branch;
  String get branch => _branch ?? '';
  set branch(String? val) => _branch = val;

  bool hasBranch() => _branch != null;

  // "expiry_date" field.
  String? _expiryDate;
  String get expiryDate => _expiryDate ?? '';
  set expiryDate(String? val) => _expiryDate = val;

  bool hasExpiryDate() => _expiryDate != null;

  // "quantity" field.
  double? _quantity;
  double get quantity => _quantity ?? 0.0;
  set quantity(double? val) => _quantity = val;

  void incrementQuantity(double amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "last_update" field.
  int? _lastUpdate;
  int get lastUpdate => _lastUpdate ?? 0;
  set lastUpdate(int? val) => _lastUpdate = val;

  void incrementLastUpdate(int amount) => lastUpdate = lastUpdate + amount;

  bool hasLastUpdate() => _lastUpdate != null;

  // "branch_id_from" field.
  int? _branchIdFrom;
  int get branchIdFrom => _branchIdFrom ?? 0;
  set branchIdFrom(int? val) => _branchIdFrom = val;

  void incrementBranchIdFrom(int amount) =>
      branchIdFrom = branchIdFrom + amount;

  bool hasBranchIdFrom() => _branchIdFrom != null;

  // "branch_id_to" field.
  int? _branchIdTo;
  int get branchIdTo => _branchIdTo ?? 0;
  set branchIdTo(int? val) => _branchIdTo = val;

  void incrementBranchIdTo(int amount) => branchIdTo = branchIdTo + amount;

  bool hasBranchIdTo() => _branchIdTo != null;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

  // "unit_cost" field.
  double? _unitCost;
  double get unitCost => _unitCost ?? 0.0;
  set unitCost(double? val) => _unitCost = val;

  void incrementUnitCost(double amount) => unitCost = unitCost + amount;

  bool hasUnitCost() => _unitCost != null;

  // "total_cost" field.
  double? _totalCost;
  double get totalCost => _totalCost ?? 0.0;
  set totalCost(double? val) => _totalCost = val;

  void incrementTotalCost(double amount) => totalCost = totalCost + amount;

  bool hasTotalCost() => _totalCost != null;

  // "tx_type" field.
  String? _txType;
  String get txType => _txType ?? '';
  set txType(String? val) => _txType = val;

  bool hasTxType() => _txType != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  // "doc" field.
  String? _doc;
  String get doc => _doc ?? '';
  set doc(String? val) => _doc = val;

  bool hasDoc() => _doc != null;

  // "checksum" field.
  String? _checksum;
  String get checksum => _checksum ?? '';
  set checksum(String? val) => _checksum = val;

  bool hasChecksum() => _checksum != null;

  // "updates" field.
  List<UpdatesStruct>? _updates;
  List<UpdatesStruct> get updates => _updates ?? const [];
  set updates(List<UpdatesStruct>? val) => _updates = val;

  void updateUpdates(Function(List<UpdatesStruct>) updateFn) {
    updateFn(_updates ??= []);
  }

  bool hasUpdates() => _updates != null;

  static InventoryMovementStruct fromMap(Map<String, dynamic> data) =>
      InventoryMovementStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        inventoryId: castToType<int>(data['inventory_id']),
        branch: data['branch'] as String?,
        expiryDate: data['expiry_date'] as String?,
        quantity: castToType<double>(data['quantity']),
        lastUpdate: castToType<int>(data['last_update']),
        branchIdFrom: castToType<int>(data['branch_id_from']),
        branchIdTo: castToType<int>(data['branch_id_to']),
        unit: data['unit'] as String?,
        unitCost: castToType<double>(data['unit_cost']),
        totalCost: castToType<double>(data['total_cost']),
        txType: data['tx_type'] as String?,
        note: data['note'] as String?,
        doc: data['doc'] as String?,
        checksum: data['checksum'] as String?,
        updates: getStructList(
          data['updates'],
          UpdatesStruct.fromMap,
        ),
      );

  static InventoryMovementStruct? maybeFromMap(dynamic data) => data is Map
      ? InventoryMovementStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'inventory_id': _inventoryId,
        'branch': _branch,
        'expiry_date': _expiryDate,
        'quantity': _quantity,
        'last_update': _lastUpdate,
        'branch_id_from': _branchIdFrom,
        'branch_id_to': _branchIdTo,
        'unit': _unit,
        'unit_cost': _unitCost,
        'total_cost': _totalCost,
        'tx_type': _txType,
        'note': _note,
        'doc': _doc,
        'checksum': _checksum,
        'updates': _updates?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.int,
        ),
        'inventory_id': serializeParam(
          _inventoryId,
          ParamType.int,
        ),
        'branch': serializeParam(
          _branch,
          ParamType.String,
        ),
        'expiry_date': serializeParam(
          _expiryDate,
          ParamType.String,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.double,
        ),
        'last_update': serializeParam(
          _lastUpdate,
          ParamType.int,
        ),
        'branch_id_from': serializeParam(
          _branchIdFrom,
          ParamType.int,
        ),
        'branch_id_to': serializeParam(
          _branchIdTo,
          ParamType.int,
        ),
        'unit': serializeParam(
          _unit,
          ParamType.String,
        ),
        'unit_cost': serializeParam(
          _unitCost,
          ParamType.double,
        ),
        'total_cost': serializeParam(
          _totalCost,
          ParamType.double,
        ),
        'tx_type': serializeParam(
          _txType,
          ParamType.String,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
        'doc': serializeParam(
          _doc,
          ParamType.String,
        ),
        'checksum': serializeParam(
          _checksum,
          ParamType.String,
        ),
        'updates': serializeParam(
          _updates,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static InventoryMovementStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      InventoryMovementStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.int,
          false,
        ),
        inventoryId: deserializeParam(
          data['inventory_id'],
          ParamType.int,
          false,
        ),
        branch: deserializeParam(
          data['branch'],
          ParamType.String,
          false,
        ),
        expiryDate: deserializeParam(
          data['expiry_date'],
          ParamType.String,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.double,
          false,
        ),
        lastUpdate: deserializeParam(
          data['last_update'],
          ParamType.int,
          false,
        ),
        branchIdFrom: deserializeParam(
          data['branch_id_from'],
          ParamType.int,
          false,
        ),
        branchIdTo: deserializeParam(
          data['branch_id_to'],
          ParamType.int,
          false,
        ),
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
          false,
        ),
        unitCost: deserializeParam(
          data['unit_cost'],
          ParamType.double,
          false,
        ),
        totalCost: deserializeParam(
          data['total_cost'],
          ParamType.double,
          false,
        ),
        txType: deserializeParam(
          data['tx_type'],
          ParamType.String,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
        doc: deserializeParam(
          data['doc'],
          ParamType.String,
          false,
        ),
        checksum: deserializeParam(
          data['checksum'],
          ParamType.String,
          false,
        ),
        updates: deserializeStructParam<UpdatesStruct>(
          data['updates'],
          ParamType.DataStruct,
          true,
          structBuilder: UpdatesStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'InventoryMovementStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is InventoryMovementStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        inventoryId == other.inventoryId &&
        branch == other.branch &&
        expiryDate == other.expiryDate &&
        quantity == other.quantity &&
        lastUpdate == other.lastUpdate &&
        branchIdFrom == other.branchIdFrom &&
        branchIdTo == other.branchIdTo &&
        unit == other.unit &&
        unitCost == other.unitCost &&
        totalCost == other.totalCost &&
        txType == other.txType &&
        note == other.note &&
        doc == other.doc &&
        checksum == other.checksum &&
        listEquality.equals(updates, other.updates);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        inventoryId,
        branch,
        expiryDate,
        quantity,
        lastUpdate,
        branchIdFrom,
        branchIdTo,
        unit,
        unitCost,
        totalCost,
        txType,
        note,
        doc,
        checksum,
        updates
      ]);
}

InventoryMovementStruct createInventoryMovementStruct({
  int? id,
  int? createdAt,
  int? inventoryId,
  String? branch,
  String? expiryDate,
  double? quantity,
  int? lastUpdate,
  int? branchIdFrom,
  int? branchIdTo,
  String? unit,
  double? unitCost,
  double? totalCost,
  String? txType,
  String? note,
  String? doc,
  String? checksum,
}) =>
    InventoryMovementStruct(
      id: id,
      createdAt: createdAt,
      inventoryId: inventoryId,
      branch: branch,
      expiryDate: expiryDate,
      quantity: quantity,
      lastUpdate: lastUpdate,
      branchIdFrom: branchIdFrom,
      branchIdTo: branchIdTo,
      unit: unit,
      unitCost: unitCost,
      totalCost: totalCost,
      txType: txType,
      note: note,
      doc: doc,
      checksum: checksum,
    );
