// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CarousellMovementStruct extends BaseStruct {
  CarousellMovementStruct({
    int? id,
    int? createdAt,
    int? branchIdFrom,
    int? branchIdTo,
    int? inventoryCarousellId,
    int? inventoryId,
    int? userId,
    double? quantity,
    double? totalCost,
    String? name,
    String? delivery,
    String? type,
    String? status,
    String? itemName,
    String? branchFrom,
    String? branchTo,
    String? imageUrl,
    String? expiryDate,
    double? initialQuantity,
    double? unitCost,
    String? unit,
    double? availableQuantity,
    String? remark,
    bool? seller,
    bool? buyer,
  })  : _id = id,
        _createdAt = createdAt,
        _branchIdFrom = branchIdFrom,
        _branchIdTo = branchIdTo,
        _inventoryCarousellId = inventoryCarousellId,
        _inventoryId = inventoryId,
        _userId = userId,
        _quantity = quantity,
        _totalCost = totalCost,
        _name = name,
        _delivery = delivery,
        _type = type,
        _status = status,
        _itemName = itemName,
        _branchFrom = branchFrom,
        _branchTo = branchTo,
        _imageUrl = imageUrl,
        _expiryDate = expiryDate,
        _initialQuantity = initialQuantity,
        _unitCost = unitCost,
        _unit = unit,
        _availableQuantity = availableQuantity,
        _remark = remark,
        _seller = seller,
        _buyer = buyer;

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

  // "inventory_carousell_id" field.
  int? _inventoryCarousellId;
  int get inventoryCarousellId => _inventoryCarousellId ?? 0;
  set inventoryCarousellId(int? val) => _inventoryCarousellId = val;

  void incrementInventoryCarousellId(int amount) =>
      inventoryCarousellId = inventoryCarousellId + amount;

  bool hasInventoryCarousellId() => _inventoryCarousellId != null;

  // "inventory_id" field.
  int? _inventoryId;
  int get inventoryId => _inventoryId ?? 0;
  set inventoryId(int? val) => _inventoryId = val;

  void incrementInventoryId(int amount) => inventoryId = inventoryId + amount;

  bool hasInventoryId() => _inventoryId != null;

  // "user_id" field.
  int? _userId;
  int get userId => _userId ?? 0;
  set userId(int? val) => _userId = val;

  void incrementUserId(int amount) => userId = userId + amount;

  bool hasUserId() => _userId != null;

  // "quantity" field.
  double? _quantity;
  double get quantity => _quantity ?? 0.0;
  set quantity(double? val) => _quantity = val;

  void incrementQuantity(double amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "total_cost" field.
  double? _totalCost;
  double get totalCost => _totalCost ?? 0.0;
  set totalCost(double? val) => _totalCost = val;

  void incrementTotalCost(double amount) => totalCost = totalCost + amount;

  bool hasTotalCost() => _totalCost != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "delivery" field.
  String? _delivery;
  String get delivery => _delivery ?? '';
  set delivery(String? val) => _delivery = val;

  bool hasDelivery() => _delivery != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "item_name" field.
  String? _itemName;
  String get itemName => _itemName ?? '';
  set itemName(String? val) => _itemName = val;

  bool hasItemName() => _itemName != null;

  // "branch_from" field.
  String? _branchFrom;
  String get branchFrom => _branchFrom ?? '';
  set branchFrom(String? val) => _branchFrom = val;

  bool hasBranchFrom() => _branchFrom != null;

  // "branch_to" field.
  String? _branchTo;
  String get branchTo => _branchTo ?? '';
  set branchTo(String? val) => _branchTo = val;

  bool hasBranchTo() => _branchTo != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "expiry_date" field.
  String? _expiryDate;
  String get expiryDate => _expiryDate ?? '';
  set expiryDate(String? val) => _expiryDate = val;

  bool hasExpiryDate() => _expiryDate != null;

  // "initial_quantity" field.
  double? _initialQuantity;
  double get initialQuantity => _initialQuantity ?? 0.0;
  set initialQuantity(double? val) => _initialQuantity = val;

  void incrementInitialQuantity(double amount) =>
      initialQuantity = initialQuantity + amount;

  bool hasInitialQuantity() => _initialQuantity != null;

  // "unit_cost" field.
  double? _unitCost;
  double get unitCost => _unitCost ?? 0.0;
  set unitCost(double? val) => _unitCost = val;

  void incrementUnitCost(double amount) => unitCost = unitCost + amount;

  bool hasUnitCost() => _unitCost != null;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

  // "available_quantity" field.
  double? _availableQuantity;
  double get availableQuantity => _availableQuantity ?? 0.0;
  set availableQuantity(double? val) => _availableQuantity = val;

  void incrementAvailableQuantity(double amount) =>
      availableQuantity = availableQuantity + amount;

  bool hasAvailableQuantity() => _availableQuantity != null;

  // "remark" field.
  String? _remark;
  String get remark => _remark ?? '';
  set remark(String? val) => _remark = val;

  bool hasRemark() => _remark != null;

  // "seller" field.
  bool? _seller;
  bool get seller => _seller ?? false;
  set seller(bool? val) => _seller = val;

  bool hasSeller() => _seller != null;

  // "buyer" field.
  bool? _buyer;
  bool get buyer => _buyer ?? false;
  set buyer(bool? val) => _buyer = val;

  bool hasBuyer() => _buyer != null;

  static CarousellMovementStruct fromMap(Map<String, dynamic> data) =>
      CarousellMovementStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        branchIdFrom: castToType<int>(data['branch_id_from']),
        branchIdTo: castToType<int>(data['branch_id_to']),
        inventoryCarousellId: castToType<int>(data['inventory_carousell_id']),
        inventoryId: castToType<int>(data['inventory_id']),
        userId: castToType<int>(data['user_id']),
        quantity: castToType<double>(data['quantity']),
        totalCost: castToType<double>(data['total_cost']),
        name: data['name'] as String?,
        delivery: data['delivery'] as String?,
        type: data['type'] as String?,
        status: data['status'] as String?,
        itemName: data['item_name'] as String?,
        branchFrom: data['branch_from'] as String?,
        branchTo: data['branch_to'] as String?,
        imageUrl: data['image_url'] as String?,
        expiryDate: data['expiry_date'] as String?,
        initialQuantity: castToType<double>(data['initial_quantity']),
        unitCost: castToType<double>(data['unit_cost']),
        unit: data['unit'] as String?,
        availableQuantity: castToType<double>(data['available_quantity']),
        remark: data['remark'] as String?,
        seller: data['seller'] as bool?,
        buyer: data['buyer'] as bool?,
      );

  static CarousellMovementStruct? maybeFromMap(dynamic data) => data is Map
      ? CarousellMovementStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'branch_id_from': _branchIdFrom,
        'branch_id_to': _branchIdTo,
        'inventory_carousell_id': _inventoryCarousellId,
        'inventory_id': _inventoryId,
        'user_id': _userId,
        'quantity': _quantity,
        'total_cost': _totalCost,
        'name': _name,
        'delivery': _delivery,
        'type': _type,
        'status': _status,
        'item_name': _itemName,
        'branch_from': _branchFrom,
        'branch_to': _branchTo,
        'image_url': _imageUrl,
        'expiry_date': _expiryDate,
        'initial_quantity': _initialQuantity,
        'unit_cost': _unitCost,
        'unit': _unit,
        'available_quantity': _availableQuantity,
        'remark': _remark,
        'seller': _seller,
        'buyer': _buyer,
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
        'branch_id_from': serializeParam(
          _branchIdFrom,
          ParamType.int,
        ),
        'branch_id_to': serializeParam(
          _branchIdTo,
          ParamType.int,
        ),
        'inventory_carousell_id': serializeParam(
          _inventoryCarousellId,
          ParamType.int,
        ),
        'inventory_id': serializeParam(
          _inventoryId,
          ParamType.int,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.int,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.double,
        ),
        'total_cost': serializeParam(
          _totalCost,
          ParamType.double,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'delivery': serializeParam(
          _delivery,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'item_name': serializeParam(
          _itemName,
          ParamType.String,
        ),
        'branch_from': serializeParam(
          _branchFrom,
          ParamType.String,
        ),
        'branch_to': serializeParam(
          _branchTo,
          ParamType.String,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'expiry_date': serializeParam(
          _expiryDate,
          ParamType.String,
        ),
        'initial_quantity': serializeParam(
          _initialQuantity,
          ParamType.double,
        ),
        'unit_cost': serializeParam(
          _unitCost,
          ParamType.double,
        ),
        'unit': serializeParam(
          _unit,
          ParamType.String,
        ),
        'available_quantity': serializeParam(
          _availableQuantity,
          ParamType.double,
        ),
        'remark': serializeParam(
          _remark,
          ParamType.String,
        ),
        'seller': serializeParam(
          _seller,
          ParamType.bool,
        ),
        'buyer': serializeParam(
          _buyer,
          ParamType.bool,
        ),
      }.withoutNulls;

  static CarousellMovementStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CarousellMovementStruct(
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
        inventoryCarousellId: deserializeParam(
          data['inventory_carousell_id'],
          ParamType.int,
          false,
        ),
        inventoryId: deserializeParam(
          data['inventory_id'],
          ParamType.int,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.int,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.double,
          false,
        ),
        totalCost: deserializeParam(
          data['total_cost'],
          ParamType.double,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        delivery: deserializeParam(
          data['delivery'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        itemName: deserializeParam(
          data['item_name'],
          ParamType.String,
          false,
        ),
        branchFrom: deserializeParam(
          data['branch_from'],
          ParamType.String,
          false,
        ),
        branchTo: deserializeParam(
          data['branch_to'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        expiryDate: deserializeParam(
          data['expiry_date'],
          ParamType.String,
          false,
        ),
        initialQuantity: deserializeParam(
          data['initial_quantity'],
          ParamType.double,
          false,
        ),
        unitCost: deserializeParam(
          data['unit_cost'],
          ParamType.double,
          false,
        ),
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
          false,
        ),
        availableQuantity: deserializeParam(
          data['available_quantity'],
          ParamType.double,
          false,
        ),
        remark: deserializeParam(
          data['remark'],
          ParamType.String,
          false,
        ),
        seller: deserializeParam(
          data['seller'],
          ParamType.bool,
          false,
        ),
        buyer: deserializeParam(
          data['buyer'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'CarousellMovementStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CarousellMovementStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        branchIdFrom == other.branchIdFrom &&
        branchIdTo == other.branchIdTo &&
        inventoryCarousellId == other.inventoryCarousellId &&
        inventoryId == other.inventoryId &&
        userId == other.userId &&
        quantity == other.quantity &&
        totalCost == other.totalCost &&
        name == other.name &&
        delivery == other.delivery &&
        type == other.type &&
        status == other.status &&
        itemName == other.itemName &&
        branchFrom == other.branchFrom &&
        branchTo == other.branchTo &&
        imageUrl == other.imageUrl &&
        expiryDate == other.expiryDate &&
        initialQuantity == other.initialQuantity &&
        unitCost == other.unitCost &&
        unit == other.unit &&
        availableQuantity == other.availableQuantity &&
        remark == other.remark &&
        seller == other.seller &&
        buyer == other.buyer;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        branchIdFrom,
        branchIdTo,
        inventoryCarousellId,
        inventoryId,
        userId,
        quantity,
        totalCost,
        name,
        delivery,
        type,
        status,
        itemName,
        branchFrom,
        branchTo,
        imageUrl,
        expiryDate,
        initialQuantity,
        unitCost,
        unit,
        availableQuantity,
        remark,
        seller,
        buyer
      ]);
}

CarousellMovementStruct createCarousellMovementStruct({
  int? id,
  int? createdAt,
  int? branchIdFrom,
  int? branchIdTo,
  int? inventoryCarousellId,
  int? inventoryId,
  int? userId,
  double? quantity,
  double? totalCost,
  String? name,
  String? delivery,
  String? type,
  String? status,
  String? itemName,
  String? branchFrom,
  String? branchTo,
  String? imageUrl,
  String? expiryDate,
  double? initialQuantity,
  double? unitCost,
  String? unit,
  double? availableQuantity,
  String? remark,
  bool? seller,
  bool? buyer,
}) =>
    CarousellMovementStruct(
      id: id,
      createdAt: createdAt,
      branchIdFrom: branchIdFrom,
      branchIdTo: branchIdTo,
      inventoryCarousellId: inventoryCarousellId,
      inventoryId: inventoryId,
      userId: userId,
      quantity: quantity,
      totalCost: totalCost,
      name: name,
      delivery: delivery,
      type: type,
      status: status,
      itemName: itemName,
      branchFrom: branchFrom,
      branchTo: branchTo,
      imageUrl: imageUrl,
      expiryDate: expiryDate,
      initialQuantity: initialQuantity,
      unitCost: unitCost,
      unit: unit,
      availableQuantity: availableQuantity,
      remark: remark,
      seller: seller,
      buyer: buyer,
    );
