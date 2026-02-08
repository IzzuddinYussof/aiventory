// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CarousellStruct extends BaseStruct {
  CarousellStruct({
    int? id,
    int? createdAt,
    int? inventoryId,
    String? branch,
    int? branchId,
    String? imageUrl,
    String? expiryDate,
    double? initialQuantity,
    double? unitCost,
    double? totalCost,
    String? unit,
    double? availableQuantity,
    double? soldQuantity,
    String? itemName,
    String? category,
    String? supplier,
    bool? expiry,
    String? quantityMajor,
    String? quantityMinor,
    String? barcode,
    String? remark,
    String? type,
  })  : _id = id,
        _createdAt = createdAt,
        _inventoryId = inventoryId,
        _branch = branch,
        _branchId = branchId,
        _imageUrl = imageUrl,
        _expiryDate = expiryDate,
        _initialQuantity = initialQuantity,
        _unitCost = unitCost,
        _totalCost = totalCost,
        _unit = unit,
        _availableQuantity = availableQuantity,
        _soldQuantity = soldQuantity,
        _itemName = itemName,
        _category = category,
        _supplier = supplier,
        _expiry = expiry,
        _quantityMajor = quantityMajor,
        _quantityMinor = quantityMinor,
        _barcode = barcode,
        _remark = remark,
        _type = type;

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

  // "branch_id" field.
  int? _branchId;
  int get branchId => _branchId ?? 0;
  set branchId(int? val) => _branchId = val;

  void incrementBranchId(int amount) => branchId = branchId + amount;

  bool hasBranchId() => _branchId != null;

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

  // "total_cost" field.
  double? _totalCost;
  double get totalCost => _totalCost ?? 0.0;
  set totalCost(double? val) => _totalCost = val;

  void incrementTotalCost(double amount) => totalCost = totalCost + amount;

  bool hasTotalCost() => _totalCost != null;

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

  // "sold_quantity" field.
  double? _soldQuantity;
  double get soldQuantity => _soldQuantity ?? 0.0;
  set soldQuantity(double? val) => _soldQuantity = val;

  void incrementSoldQuantity(double amount) =>
      soldQuantity = soldQuantity + amount;

  bool hasSoldQuantity() => _soldQuantity != null;

  // "item_name" field.
  String? _itemName;
  String get itemName => _itemName ?? '';
  set itemName(String? val) => _itemName = val;

  bool hasItemName() => _itemName != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "supplier" field.
  String? _supplier;
  String get supplier => _supplier ?? '';
  set supplier(String? val) => _supplier = val;

  bool hasSupplier() => _supplier != null;

  // "expiry" field.
  bool? _expiry;
  bool get expiry => _expiry ?? false;
  set expiry(bool? val) => _expiry = val;

  bool hasExpiry() => _expiry != null;

  // "quantity_major" field.
  String? _quantityMajor;
  String get quantityMajor => _quantityMajor ?? '';
  set quantityMajor(String? val) => _quantityMajor = val;

  bool hasQuantityMajor() => _quantityMajor != null;

  // "quantity_minor" field.
  String? _quantityMinor;
  String get quantityMinor => _quantityMinor ?? '';
  set quantityMinor(String? val) => _quantityMinor = val;

  bool hasQuantityMinor() => _quantityMinor != null;

  // "barcode" field.
  String? _barcode;
  String get barcode => _barcode ?? '';
  set barcode(String? val) => _barcode = val;

  bool hasBarcode() => _barcode != null;

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

  static CarousellStruct fromMap(Map<String, dynamic> data) => CarousellStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        inventoryId: castToType<int>(data['inventory_id']),
        branch: data['branch'] as String?,
        branchId: castToType<int>(data['branch_id']),
        imageUrl: data['image_url'] as String?,
        expiryDate: data['expiry_date'] as String?,
        initialQuantity: castToType<double>(data['initial_quantity']),
        unitCost: castToType<double>(data['unit_cost']),
        totalCost: castToType<double>(data['total_cost']),
        unit: data['unit'] as String?,
        availableQuantity: castToType<double>(data['available_quantity']),
        soldQuantity: castToType<double>(data['sold_quantity']),
        itemName: data['item_name'] as String?,
        category: data['category'] as String?,
        supplier: data['supplier'] as String?,
        expiry: data['expiry'] as bool?,
        quantityMajor: data['quantity_major'] as String?,
        quantityMinor: data['quantity_minor'] as String?,
        barcode: data['barcode'] as String?,
        remark: data['remark'] as String?,
        type: data['type'] as String?,
      );

  static CarousellStruct? maybeFromMap(dynamic data) => data is Map
      ? CarousellStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'inventory_id': _inventoryId,
        'branch': _branch,
        'branch_id': _branchId,
        'image_url': _imageUrl,
        'expiry_date': _expiryDate,
        'initial_quantity': _initialQuantity,
        'unit_cost': _unitCost,
        'total_cost': _totalCost,
        'unit': _unit,
        'available_quantity': _availableQuantity,
        'sold_quantity': _soldQuantity,
        'item_name': _itemName,
        'category': _category,
        'supplier': _supplier,
        'expiry': _expiry,
        'quantity_major': _quantityMajor,
        'quantity_minor': _quantityMinor,
        'barcode': _barcode,
        'remark': _remark,
        'type': _type,
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
        'branch_id': serializeParam(
          _branchId,
          ParamType.int,
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
        'total_cost': serializeParam(
          _totalCost,
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
        'sold_quantity': serializeParam(
          _soldQuantity,
          ParamType.double,
        ),
        'item_name': serializeParam(
          _itemName,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'supplier': serializeParam(
          _supplier,
          ParamType.String,
        ),
        'expiry': serializeParam(
          _expiry,
          ParamType.bool,
        ),
        'quantity_major': serializeParam(
          _quantityMajor,
          ParamType.String,
        ),
        'quantity_minor': serializeParam(
          _quantityMinor,
          ParamType.String,
        ),
        'barcode': serializeParam(
          _barcode,
          ParamType.String,
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

  static CarousellStruct fromSerializableMap(Map<String, dynamic> data) =>
      CarousellStruct(
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
        branchId: deserializeParam(
          data['branch_id'],
          ParamType.int,
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
        totalCost: deserializeParam(
          data['total_cost'],
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
        soldQuantity: deserializeParam(
          data['sold_quantity'],
          ParamType.double,
          false,
        ),
        itemName: deserializeParam(
          data['item_name'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        supplier: deserializeParam(
          data['supplier'],
          ParamType.String,
          false,
        ),
        expiry: deserializeParam(
          data['expiry'],
          ParamType.bool,
          false,
        ),
        quantityMajor: deserializeParam(
          data['quantity_major'],
          ParamType.String,
          false,
        ),
        quantityMinor: deserializeParam(
          data['quantity_minor'],
          ParamType.String,
          false,
        ),
        barcode: deserializeParam(
          data['barcode'],
          ParamType.String,
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
  String toString() => 'CarousellStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CarousellStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        inventoryId == other.inventoryId &&
        branch == other.branch &&
        branchId == other.branchId &&
        imageUrl == other.imageUrl &&
        expiryDate == other.expiryDate &&
        initialQuantity == other.initialQuantity &&
        unitCost == other.unitCost &&
        totalCost == other.totalCost &&
        unit == other.unit &&
        availableQuantity == other.availableQuantity &&
        soldQuantity == other.soldQuantity &&
        itemName == other.itemName &&
        category == other.category &&
        supplier == other.supplier &&
        expiry == other.expiry &&
        quantityMajor == other.quantityMajor &&
        quantityMinor == other.quantityMinor &&
        barcode == other.barcode &&
        remark == other.remark &&
        type == other.type;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        inventoryId,
        branch,
        branchId,
        imageUrl,
        expiryDate,
        initialQuantity,
        unitCost,
        totalCost,
        unit,
        availableQuantity,
        soldQuantity,
        itemName,
        category,
        supplier,
        expiry,
        quantityMajor,
        quantityMinor,
        barcode,
        remark,
        type
      ]);
}

CarousellStruct createCarousellStruct({
  int? id,
  int? createdAt,
  int? inventoryId,
  String? branch,
  int? branchId,
  String? imageUrl,
  String? expiryDate,
  double? initialQuantity,
  double? unitCost,
  double? totalCost,
  String? unit,
  double? availableQuantity,
  double? soldQuantity,
  String? itemName,
  String? category,
  String? supplier,
  bool? expiry,
  String? quantityMajor,
  String? quantityMinor,
  String? barcode,
  String? remark,
  String? type,
}) =>
    CarousellStruct(
      id: id,
      createdAt: createdAt,
      inventoryId: inventoryId,
      branch: branch,
      branchId: branchId,
      imageUrl: imageUrl,
      expiryDate: expiryDate,
      initialQuantity: initialQuantity,
      unitCost: unitCost,
      totalCost: totalCost,
      unit: unit,
      availableQuantity: availableQuantity,
      soldQuantity: soldQuantity,
      itemName: itemName,
      category: category,
      supplier: supplier,
      expiry: expiry,
      quantityMajor: quantityMajor,
      quantityMinor: quantityMinor,
      barcode: barcode,
      remark: remark,
      type: type,
    );
