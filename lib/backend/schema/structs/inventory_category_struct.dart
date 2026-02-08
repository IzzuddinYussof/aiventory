// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InventoryCategoryStruct extends BaseStruct {
  InventoryCategoryStruct({
    int? id,
    int? createdAt,
    String? category,
  })  : _id = id,
        _createdAt = createdAt,
        _category = category;

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

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  static InventoryCategoryStruct fromMap(Map<String, dynamic> data) =>
      InventoryCategoryStruct(
        id: castToType<int>(data['id']),
        createdAt: castToType<int>(data['created_at']),
        category: data['category'] as String?,
      );

  static InventoryCategoryStruct? maybeFromMap(dynamic data) => data is Map
      ? InventoryCategoryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'created_at': _createdAt,
        'category': _category,
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
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
      }.withoutNulls;

  static InventoryCategoryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      InventoryCategoryStruct(
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
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'InventoryCategoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is InventoryCategoryStruct &&
        id == other.id &&
        createdAt == other.createdAt &&
        category == other.category;
  }

  @override
  int get hashCode => const ListEquality().hash([id, createdAt, category]);
}

InventoryCategoryStruct createInventoryCategoryStruct({
  int? id,
  int? createdAt,
  String? category,
}) =>
    InventoryCategoryStruct(
      id: id,
      createdAt: createdAt,
      category: category,
    );
