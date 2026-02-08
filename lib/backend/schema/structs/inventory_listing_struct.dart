// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InventoryListingStruct extends BaseStruct {
  InventoryListingStruct({
    int? id,
    int? createdAt,
    int? branchId,
    int? inventoryId,
    int? expiryDate,
    double? quantityOnHand,
    double? quantityReserved,
    String? status,
    double? averageUnitCost,
    int? lastInventoryMovement,
    int? lastUpdated,
    String? checksum,
    InventoryStruct? inventory,
    String? unit,
  })  : _id = id,
        _createdAt = createdAt,
        _branchId = branchId,
        _inventoryId = inventoryId,
        _expiryDate = expiryDate,
        _quantityOnHand = quantityOnHand,
        _quantityReserved = quantityReserved,
        _status = status,
        _averageUnitCost = averageUnitCost,
        _lastInventoryMovement = lastInventoryMovement,
        _lastUpdated = lastUpdated,
        _checksum = checksum,
        _inventory = inventory,
        _unit = unit;

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

  // "branch_id" field.
  int? _branchId;
  int get branchId => _branchId ?? 0;
  set branchId(int? val) => _branchId = val;

  void incrementBranchId(int amount) => branchId = branchId + amount;

  bool hasBranchId() => _branchId != null;

  // "inventory_id" field.
  int? _inventoryId;
  int get inventoryId => _inventoryId ?? 0;
  set inventoryId(int? val) => _inventoryId = val;

  void incrementInventoryId(int amount) => inventoryId = inventoryId + amount;

  bool hasInventoryId() => _inventoryId != null;

  // "expiry_date" field.
  int? _expiryDate;
  int get expiryDate => _expiryDate ?? 0;
  set expiryDate(int? val) => _expiryDate = val;

  void incrementExpiryDate(int amount) => expiryDate = expiryDate + amount;

  bool hasExpiryDate() => _expiryDate != null;

  // "quantity_on_hand" field.
  double? _quantityOnHand;
  double get quantityOnHand => _quantityOnHand ?? 0.0;
  set quantityOnHand(double? val) => _quantityOnHand = val;

  void incrementQuantityOnHand(double amount) =>
      quantityOnHand = quantityOnHand + amount;

  bool hasQuantityOnHand() => _quantityOnHand != null;

  // "quantity_reserved" field.
  double? _quantityReserved;
  double get quantityReserved => _quantityReserved ?? 0.0;
  set quantityReserved(double? val) => _quantityReserved = val;

  void incrementQuantityReserved(double amount) =>
      quantityReserved = quantityReserved + amount;

  bool hasQuantityReserved() => _quantityReserved != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "average_unit_cost" field.
  double? _averageUnitCost;
  double get averageUnitCost => _averageUnitCost ?? 0.0;
  set averageUnitCost(double? val) => _averageUnitCost = val;

  void incrementAverageUnitCost(double amount) =>
      averageUnitCost = averageUnitCost + amount;

  bool hasAverageUnitCost() => _averageUnitCost != null;

  // "last_inventory_movement" field.
  int? _lastInventoryMovement;
  int get lastInventoryMovement => _lastInventoryMovement ?? 0;
  set lastInventoryMovement(int? val) => _lastInventoryMovement = val;

  void incrementLastInventoryMovement(int amount) =>
      lastInventoryMovement = lastInventoryMovement + amount;

  bool hasLastInventoryMovement() => _lastInventoryMovement != null;

  // "last_updated" field.
  int? _lastUpdated;
  int get lastUpdated => _lastUpdated ?? 0;
  set lastUpdated(int? val) => _lastUpdated = val;

  void incrementLastUpdated(int amount) => lastUpdated = lastUpdated + amount;

  bool hasLastUpdated() => _lastUpdated != null;

  // "checksum" field.
  String? _checksum;
  String get checksum => _checksum ?? '';
  set checksum(String? val) => _checksum = val;

  bool hasChecksum() => _checksum != null;

  // "inventory" field.
  InventoryStruct? _inventory;
  InventoryStruct get inventory => _inventory ?? InventoryStruct();
  set inventory(InventoryStruct? val) => _inventory = val;

  void updateInventory(Function(InventoryStruct) updateFn) {
    updateFn(_inventory ??= InventoryStruct());
  }

  bool hasInventory() => _inventory != null;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

  static InventoryListingStruct fromMap(Map<String, dynamic> data) =>
      InventoryListingStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        branchId: castToType<int>(data['branch_id']),
        inventoryId: castToType<int>(data['inventory_id']),
        expiryDate: castToType<int>(data['expiry_date']),
        quantityOnHand: castToType<double>(data['quantity_on_hand']),
        quantityReserved: castToType<double>(data['quantity_reserved']),
        status: data['status'] as String?,
        averageUnitCost: castToType<double>(data['average_unit_cost']),
        lastInventoryMovement: castToType<int>(data['last_inventory_movement']),
        lastUpdated: castToType<int>(data['last_updated']),
        checksum: data['checksum'] as String?,
        inventory: data['inventory'] is InventoryStruct
            ? data['inventory']
            : InventoryStruct.maybeFromMap(data['inventory']),
        unit: data['unit'] as String?,
      );

  static InventoryListingStruct? maybeFromMap(dynamic data) => data is Map
      ? InventoryListingStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'branch_id': _branchId,
        'inventory_id': _inventoryId,
        'expiry_date': _expiryDate,
        'quantity_on_hand': _quantityOnHand,
        'quantity_reserved': _quantityReserved,
        'status': _status,
        'average_unit_cost': _averageUnitCost,
        'last_inventory_movement': _lastInventoryMovement,
        'last_updated': _lastUpdated,
        'checksum': _checksum,
        'inventory': _inventory?.toMap(),
        'unit': _unit,
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
        'branch_id': serializeParam(
          _branchId,
          ParamType.int,
        ),
        'inventory_id': serializeParam(
          _inventoryId,
          ParamType.int,
        ),
        'expiry_date': serializeParam(
          _expiryDate,
          ParamType.int,
        ),
        'quantity_on_hand': serializeParam(
          _quantityOnHand,
          ParamType.double,
        ),
        'quantity_reserved': serializeParam(
          _quantityReserved,
          ParamType.double,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'average_unit_cost': serializeParam(
          _averageUnitCost,
          ParamType.double,
        ),
        'last_inventory_movement': serializeParam(
          _lastInventoryMovement,
          ParamType.int,
        ),
        'last_updated': serializeParam(
          _lastUpdated,
          ParamType.int,
        ),
        'checksum': serializeParam(
          _checksum,
          ParamType.String,
        ),
        'inventory': serializeParam(
          _inventory,
          ParamType.DataStruct,
        ),
        'unit': serializeParam(
          _unit,
          ParamType.String,
        ),
      }.withoutNulls;

  static InventoryListingStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      InventoryListingStruct(
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
        branchId: deserializeParam(
          data['branch_id'],
          ParamType.int,
          false,
        ),
        inventoryId: deserializeParam(
          data['inventory_id'],
          ParamType.int,
          false,
        ),
        expiryDate: deserializeParam(
          data['expiry_date'],
          ParamType.int,
          false,
        ),
        quantityOnHand: deserializeParam(
          data['quantity_on_hand'],
          ParamType.double,
          false,
        ),
        quantityReserved: deserializeParam(
          data['quantity_reserved'],
          ParamType.double,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        averageUnitCost: deserializeParam(
          data['average_unit_cost'],
          ParamType.double,
          false,
        ),
        lastInventoryMovement: deserializeParam(
          data['last_inventory_movement'],
          ParamType.int,
          false,
        ),
        lastUpdated: deserializeParam(
          data['last_updated'],
          ParamType.int,
          false,
        ),
        checksum: deserializeParam(
          data['checksum'],
          ParamType.String,
          false,
        ),
        inventory: deserializeStructParam(
          data['inventory'],
          ParamType.DataStruct,
          false,
          structBuilder: InventoryStruct.fromSerializableMap,
        ),
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'InventoryListingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is InventoryListingStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        branchId == other.branchId &&
        inventoryId == other.inventoryId &&
        expiryDate == other.expiryDate &&
        quantityOnHand == other.quantityOnHand &&
        quantityReserved == other.quantityReserved &&
        status == other.status &&
        averageUnitCost == other.averageUnitCost &&
        lastInventoryMovement == other.lastInventoryMovement &&
        lastUpdated == other.lastUpdated &&
        checksum == other.checksum &&
        inventory == other.inventory &&
        unit == other.unit;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        branchId,
        inventoryId,
        expiryDate,
        quantityOnHand,
        quantityReserved,
        status,
        averageUnitCost,
        lastInventoryMovement,
        lastUpdated,
        checksum,
        inventory,
        unit
      ]);
}

InventoryListingStruct createInventoryListingStruct({
  int? id,
  int? createdAt,
  int? branchId,
  int? inventoryId,
  int? expiryDate,
  double? quantityOnHand,
  double? quantityReserved,
  String? status,
  double? averageUnitCost,
  int? lastInventoryMovement,
  int? lastUpdated,
  String? checksum,
  InventoryStruct? inventory,
  String? unit,
}) =>
    InventoryListingStruct(
      id: id,
      createdAt: createdAt,
      branchId: branchId,
      inventoryId: inventoryId,
      expiryDate: expiryDate,
      quantityOnHand: quantityOnHand,
      quantityReserved: quantityReserved,
      status: status,
      averageUnitCost: averageUnitCost,
      lastInventoryMovement: lastInventoryMovement,
      lastUpdated: lastUpdated,
      checksum: checksum,
      inventory: inventory ?? InventoryStruct(),
      unit: unit,
    );
