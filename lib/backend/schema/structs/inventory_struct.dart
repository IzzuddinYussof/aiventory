// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InventoryStruct extends BaseStruct {
  InventoryStruct({
    int? id,
    int? createdAt,
    String? itemName,
    String? category,
    int? minQuantity,
    String? supplier,
    double? priceUnit,
    bool? expiry,
    String? quantityMajor,
    String? quantityMinor,
    int? ratio,
    String? barcode,
    ImageStruct? image,
  })  : _id = id,
        _createdAt = createdAt,
        _itemName = itemName,
        _category = category,
        _minQuantity = minQuantity,
        _supplier = supplier,
        _priceUnit = priceUnit,
        _expiry = expiry,
        _quantityMajor = quantityMajor,
        _quantityMinor = quantityMinor,
        _ratio = ratio,
        _barcode = barcode,
        _image = image;

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

  // "min_quantity" field.
  int? _minQuantity;
  int get minQuantity => _minQuantity ?? 0;
  set minQuantity(int? val) => _minQuantity = val;

  void incrementMinQuantity(int amount) => minQuantity = minQuantity + amount;

  bool hasMinQuantity() => _minQuantity != null;

  // "supplier" field.
  String? _supplier;
  String get supplier => _supplier ?? '';
  set supplier(String? val) => _supplier = val;

  bool hasSupplier() => _supplier != null;

  // "price_unit" field.
  double? _priceUnit;
  double get priceUnit => _priceUnit ?? 0.0;
  set priceUnit(double? val) => _priceUnit = val;

  void incrementPriceUnit(double amount) => priceUnit = priceUnit + amount;

  bool hasPriceUnit() => _priceUnit != null;

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

  // "ratio" field.
  int? _ratio;
  int get ratio => _ratio ?? 0;
  set ratio(int? val) => _ratio = val;

  void incrementRatio(int amount) => ratio = ratio + amount;

  bool hasRatio() => _ratio != null;

  // "barcode" field.
  String? _barcode;
  String get barcode => _barcode ?? '';
  set barcode(String? val) => _barcode = val;

  bool hasBarcode() => _barcode != null;

  // "image" field.
  ImageStruct? _image;
  ImageStruct get image => _image ?? ImageStruct();
  set image(ImageStruct? val) => _image = val;

  void updateImage(Function(ImageStruct) updateFn) {
    updateFn(_image ??= ImageStruct());
  }

  bool hasImage() => _image != null;

  static InventoryStruct fromMap(Map<String, dynamic> data) => InventoryStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        itemName: data['item_name'] as String?,
        category: data['category'] as String?,
        minQuantity: castToType<int>(data['min_quantity']),
        supplier: data['supplier'] as String?,
        priceUnit: castToType<double>(data['price_unit']),
        expiry: data['expiry'] as bool?,
        quantityMajor: data['quantity_major'] as String?,
        quantityMinor: data['quantity_minor'] as String?,
        ratio: castToType<int>(data['ratio']),
        barcode: data['barcode'] as String?,
        image: data['image'] is ImageStruct
            ? data['image']
            : ImageStruct.maybeFromMap(data['image']),
      );

  static InventoryStruct? maybeFromMap(dynamic data) => data is Map
      ? InventoryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'item_name': _itemName,
        'category': _category,
        'min_quantity': _minQuantity,
        'supplier': _supplier,
        'price_unit': _priceUnit,
        'expiry': _expiry,
        'quantity_major': _quantityMajor,
        'quantity_minor': _quantityMinor,
        'ratio': _ratio,
        'barcode': _barcode,
        'image': _image?.toMap(),
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
        'item_name': serializeParam(
          _itemName,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'min_quantity': serializeParam(
          _minQuantity,
          ParamType.int,
        ),
        'supplier': serializeParam(
          _supplier,
          ParamType.String,
        ),
        'price_unit': serializeParam(
          _priceUnit,
          ParamType.double,
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
        'ratio': serializeParam(
          _ratio,
          ParamType.int,
        ),
        'barcode': serializeParam(
          _barcode,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static InventoryStruct fromSerializableMap(Map<String, dynamic> data) =>
      InventoryStruct(
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
        minQuantity: deserializeParam(
          data['min_quantity'],
          ParamType.int,
          false,
        ),
        supplier: deserializeParam(
          data['supplier'],
          ParamType.String,
          false,
        ),
        priceUnit: deserializeParam(
          data['price_unit'],
          ParamType.double,
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
        ratio: deserializeParam(
          data['ratio'],
          ParamType.int,
          false,
        ),
        barcode: deserializeParam(
          data['barcode'],
          ParamType.String,
          false,
        ),
        image: deserializeStructParam(
          data['image'],
          ParamType.DataStruct,
          false,
          structBuilder: ImageStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'InventoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is InventoryStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        itemName == other.itemName &&
        category == other.category &&
        minQuantity == other.minQuantity &&
        supplier == other.supplier &&
        priceUnit == other.priceUnit &&
        expiry == other.expiry &&
        quantityMajor == other.quantityMajor &&
        quantityMinor == other.quantityMinor &&
        ratio == other.ratio &&
        barcode == other.barcode &&
        image == other.image;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        createdAt,
        itemName,
        category,
        minQuantity,
        supplier,
        priceUnit,
        expiry,
        quantityMajor,
        quantityMinor,
        ratio,
        barcode,
        image
      ]);
}

InventoryStruct createInventoryStruct({
  int? id,
  int? createdAt,
  String? itemName,
  String? category,
  int? minQuantity,
  String? supplier,
  double? priceUnit,
  bool? expiry,
  String? quantityMajor,
  String? quantityMinor,
  int? ratio,
  String? barcode,
  ImageStruct? image,
}) =>
    InventoryStruct(
      id: id,
      createdAt: createdAt,
      itemName: itemName,
      category: category,
      minQuantity: minQuantity,
      supplier: supplier,
      priceUnit: priceUnit,
      expiry: expiry,
      quantityMajor: quantityMajor,
      quantityMinor: quantityMinor,
      ratio: ratio,
      barcode: barcode,
      image: image ?? ImageStruct(),
    );
